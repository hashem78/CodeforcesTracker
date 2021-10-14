import 'dart:convert';

import 'package:code_forces_tracker/models/cfsubmission.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

enum GetUserState { filtering, normal, none }

typedef UsersStatusType = Tuple2<List<CFSubmission>, GetUserState>;

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
}
