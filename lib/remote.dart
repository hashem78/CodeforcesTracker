import 'dart:convert';

import 'package:code_forces_tracker/api/codeforces_service.dart';
import 'package:code_forces_tracker/models/cflanguagedata.dart';
import 'package:code_forces_tracker/models/cfverdictsdata.dart';

import 'package:code_forces_tracker/models/cfsubmission.dart';

enum GetUserState { filtering, normal, none }

typedef UsersStatusType = (List<CFSubmission>, GetUserState);

typedef StatisticsType = (List<CFLanguageData>, List<CFVerdictsData>);

class CFRepository {
  final String handle;
  final CodeforcesService _service;

  CFRepository({required this.handle, required CodeforcesService service}) : _service = service;

  Future<bool> validateHandle({Future<void>? abortTrigger}) async {
    try {
      final response = await _service.getUserInfo(handle, abortTrigger: abortTrigger);
      if (response.statusCode != 200) return false;
      final json = jsonDecode(response.bodyString);
      return json['status'] == 'OK';
    } on Exception {
      return false;
    }
  }

  Future<UsersStatusType> getUserStatus({
    required Set<CFSubmissionVerdict> filters,
    int from = 1,
    int count = 10,
    Future<void>? abortTrigger,
  }) async {
    final response = await _service.getUserStatus(handle, from: from, count: count, abortTrigger: abortTrigger);
    if (response.statusCode != 200) {
      throw Exception('API error: ${response.statusCode}');
    }
    final decodedResponse = jsonDecode(response.bodyString);

    if (decodedResponse['status'] != 'OK') {
      throw Exception('Failed while fetching submissions');
    }

    if ((decodedResponse['result'] as List).isEmpty) {
      return (const <CFSubmission>[], GetUserState.normal);
    }

    final submissions = <CFSubmission>[];
    for (final submission in decodedResponse['result']) {
      if (submission['contestId'] != null) {
        submission['url'] = 'https://codeforces.com/contest/${submission["contestId"]}/submission/${submission["id"]}';
      }
      final cfsubmission = CFSubmission.fromJson(submission);
      if (filters.isEmpty || filters.contains(cfsubmission.verdict)) {
        submissions.add(cfsubmission);
      }
    }

    if (submissions.isEmpty) {
      return (const <CFSubmission>[], GetUserState.filtering);
    }
    return (submissions, GetUserState.none);
  }

  Future<StatisticsType> getStatistics({Future<void>? abortTrigger}) async {
    final response = await _service.getUserStatus(handle, from: 1, count: 100000, abortTrigger: abortTrigger);
    if (response.statusCode != 200) {
      throw Exception('API error: ${response.statusCode}');
    }
    final decodedResponse = jsonDecode(response.bodyString);
    if (decodedResponse['status'] != 'OK') {
      throw Exception('Failed to fetch submissions');
    }

    final submissions = [for (final s in decodedResponse['result']) CFSubmission.fromJson(s)];

    final langCounts = <String, int>{};
    final verdictCounts = <CFSubmissionVerdict, int>{};

    for (final s in submissions) {
      langCounts[s.programmingLanguage] = (langCounts[s.programmingLanguage] ?? 0) + 1;
      if (s.verdict != null) {
        verdictCounts[s.verdict!] = (verdictCounts[s.verdict!] ?? 0) + 1;
      }
    }

    return (
      [for (final e in langCounts.entries) CFLanguageData(e.key, e.value)],
      [for (final e in verdictCounts.entries) CFVerdictsData(e.key, e.value)],
    );
  }
}
