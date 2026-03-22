import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:code_forces_tracker/models/cflanguagedata.dart';
import 'package:code_forces_tracker/models/cfverdictsdata.dart';
import 'package:http/http.dart' as http;

import 'package:code_forces_tracker/models/cfsubmission.dart';

enum GetUserState { filtering, normal, none }

typedef UsersStatusType = (List<CFSubmission>, GetUserState);

typedef StatisticsType = (List<CFLanguageData>, List<CFVerdictsData>);

class CFRepository {
  final String handle;

  CFRepository({required this.handle}) : _client = http.Client();

  final http.Client _client;

  static const _baseUrl = 'https://codeforces.com/api';

  /// Validates that a handle exists on Codeforces.
  /// Returns `true` if found, `false` otherwise.
  static Future<bool> validateHandle(String handle) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/user.info?handles=$handle'),
    );
    if (response.statusCode != 200) return false;
    final json = jsonDecode(response.body);
    return json['status'] == 'OK';
  }

  Future<UsersStatusType> getUserStatus({
    required Set<CFSubmissionVerdict> filters,
    int from = 1,
    int count = 10,
  }) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/user.status?handle=$handle&from=$from&count=$count'),
    );
    if (response.statusCode != 200) {
      throw Exception('API error: ${response.statusCode}');
    }
    final decodedResponse = jsonDecode(response.body);

    if (decodedResponse['status'] != 'OK') {
      throw Exception('Failed while fetching submissions');
    }

    if ((decodedResponse['result'] as List).isEmpty) {
      return (const <CFSubmission>[], GetUserState.normal);
    }

    final submissions = <CFSubmission>[];
    for (final submission in decodedResponse['result']) {
      if (submission['contestId'] != null) {
        submission['url'] =
            'https://codeforces.com/contest/${submission["contestId"]}/submission/${submission["id"]}';
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

  Future<StatisticsType> getStatistics() async {
    final port = ReceivePort();
    final isolate = await Isolate.spawn<List>(_getStatistics, [
      port.sendPort,
      handle,
    ]);
    final completer = Completer<StatisticsType>();
    port.listen((message) {
      if (message is StatisticsType) {
        completer.complete(message);
        port.close();
        isolate.kill();
      }
    });
    return completer.future;
  }

  static Future<List<CFSubmission>> _getAllSubmissions(String handle) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/user.status?handle=$handle'),
    );
    if (response.statusCode != 200) {
      throw Exception('API error: ${response.statusCode}');
    }
    final decodedResponse = jsonDecode(response.body);
    if (decodedResponse['status'] != 'OK') {
      throw Exception('Failed to fetch all submissions');
    }
    return [
      for (final submission in decodedResponse['result'])
        CFSubmission.fromJson(submission),
    ];
  }

  static List<CFLanguageData> _getLanguagesData(List<CFSubmission> submissions) {
    final counts = <String, int>{};
    for (final s in submissions) {
      counts[s.programmingLanguage] = (counts[s.programmingLanguage] ?? 0) + 1;
    }
    return [
      for (final entry in counts.entries)
        CFLanguageData(entry.key, entry.value),
    ];
  }

  static List<CFVerdictsData> _getVerdictsData(List<CFSubmission> submissions) {
    final counts = <CFSubmissionVerdict, int>{};
    for (final s in submissions) {
      if (s.verdict != null) {
        counts[s.verdict!] = (counts[s.verdict!] ?? 0) + 1;
      }
    }
    return [
      for (final entry in counts.entries)
        CFVerdictsData(entry.key, entry.value),
    ];
  }

  static Future<void> _getStatistics(List message) async {
    final port = message[0] as SendPort;
    final handle = message[1] as String;
    final submissions = await _getAllSubmissions(handle);
    port.send((_getLanguagesData(submissions), _getVerdictsData(submissions)));
  }
}
