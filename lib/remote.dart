import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:code_forces_tracker/models/cflanguagedata.dart';
import 'package:code_forces_tracker/models/cfverdictsdata.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

import 'package:code_forces_tracker/models/cfsubmission.dart';

enum GetUserState { filtering, normal, none }

typedef UsersStatusType = Tuple2<List<CFSubmission>, GetUserState>;

typedef StatisticsType = Tuple2<List<CFLanguageData>, List<CFVerdictsData>>;

class CFRepository {
  final String handle;

  CFRepository({
    required this.handle,
  }) : _client = http.Client();

  final http.Client _client;

  String get _userStatus =>
      'https://codeforces.com/api/user.status?handle=$handle';
  Future<UsersStatusType> getUserStatus({
    required Set<CFSubmissionVerdict> filters,
    int from = 1,
    int count = 10,
  }) async {
    try {
      final http.Response response = await _client.get(
        Uri.parse('$_userStatus&from=$from&count=$count'),
      );
      final dynamic decodedResponse = jsonDecode(response.body);
      final String status = decodedResponse['status'];

      print(from);

      if (status == 'OK' && response.statusCode == 200) {
        final List<CFSubmission> submissions = [];
        if (decodedResponse['result'].isEmpty) {
          return const UsersStatusType([], GetUserState.normal);
        }
        for (final submission in decodedResponse['result']) {
          if (submission['contestId'] != null) {
            submission['url'] =
                'https://codeforces.com/contest/${submission["contestId"]}/submission/${submission["id"]}';
          }
          final cfsubmission = CFSubmission.fromJson(submission);
          if (filters.isNotEmpty) {
            if (filters.contains(cfsubmission.verdict)) {
              submissions.add(cfsubmission);
            }
          } else {
            submissions.add(cfsubmission);
          }
        }
        if (submissions.isEmpty) {
          return const UsersStatusType([], GetUserState.filtering);
        } else {
          return UsersStatusType(
            submissions,
            GetUserState.none,
          );
        }
      } else {
        throw Exception('Failed while fetching submissions');
      }
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  Future<StatisticsType> getStatistics() async {
    final port = ReceivePort();

    final isolate = await Isolate.spawn<List>(
      _getStatistics,
      [port.sendPort, handle],
    );
    final completer = Completer<StatisticsType>();
    port.listen(
      (message) {
        if (message is StatisticsType) {
          completer.complete(message);
          port.close();
          isolate.kill();
        }
      },
    );
    return completer.future;
  }

  static Future<List<CFSubmission>> _getAllSubmissions(String handle) async {
    final url = 'https://codeforces.com/api/user.status?handle=$handle';
    final response = await http.get(Uri.parse(url));
    final decodedResponse = jsonDecode(response.body);
    final submissions = <CFSubmission>[];
    if (response.statusCode == 200 && decodedResponse['status'] == 'OK') {
      for (final submission in decodedResponse['result']) {
        submissions.add(CFSubmission.fromJson(submission));
      }
    } else {
      throw Exception(
        'An error occured while trying to get all submissions in isolate',
      );
    }
    return submissions;
  }

  static List<CFLanguageData> _getLanguagesData(
    List<CFSubmission> submissions,
  ) {
    final languages = <String, int>{};
    final languagesChartData = <CFLanguageData>[];
    for (final submission in submissions) {
      if (!languages.containsKey(submission.programmingLanguage)) {
        languages[submission.programmingLanguage] = 1;
      } else {
        languages[submission.programmingLanguage] =
            languages[submission.programmingLanguage]! + 1;
      }
    }
    final entriesList = languages.entries.toList();
    MapEntry<String, int> mx = entriesList.first;
    for (int i = 1; i < entriesList.length; ++i) {
      if (entriesList[i].value > mx.value) {
        mx = entriesList[i];
      }
    }

    for (final entry in languages.entries) {
      languagesChartData.add(
        CFLanguageData(
          entry.key,
          entry.value,
        ),
      );
    }
    return languagesChartData;
  }

  static List<CFVerdictsData> _getVerdictsData(
    List<CFSubmission> submissions,
  ) {
    final verdicts = <CFSubmissionVerdict, int>{};
    final verdictsCharData = <CFVerdictsData>[];
    for (final submission in submissions) {
      if (!verdicts.containsKey(submission.verdict) &&
          submission.verdict != null) {
        verdicts[submission.verdict!] = 1;
      } else {
        verdicts[submission.verdict!] = verdicts[submission.verdict]! + 1;
      }
    }
    final entriesList = verdicts.entries.toList();
    MapEntry<CFSubmissionVerdict, int> mx = entriesList.first;
    for (int i = 1; i < entriesList.length; ++i) {
      if (entriesList[i].value > mx.value) {
        mx = entriesList[i];
      }
    }

    for (final entry in verdicts.entries) {
      verdictsCharData.add(
        CFVerdictsData(
          entry.key,
          entry.value,
        ),
      );
    }
    return verdictsCharData;
  }

  static Future<void> _getStatistics(List message) async {
    final port = message[0] as SendPort;
    final handle = message[1] as String;
    final submissions = await _getAllSubmissions(handle);
    final languagesData = _getLanguagesData(submissions);
    final verdictsData = _getVerdictsData(submissions);

    port.send(Tuple2(languagesData, verdictsData));
  }
}
