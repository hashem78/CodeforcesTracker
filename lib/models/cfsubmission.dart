// ignore_for_file: constant_identifier_names

import 'package:code_forces_tracker/models/cfparty.dart';
import 'package:code_forces_tracker/models/cfproblem.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cfsubmission.freezed.dart';
part 'cfsubmission.g.dart';

enum CFSubmissionVerdict {
  FAILED,
  OK,
  PARTIAL,
  COMPILATION_ERROR,
  RUNTIME_ERROR,
  WRONG_ANSWER,
  PRESENTATION_ERROR,
  TIME_LIMIT_EXCEEDED,
  MEMORY_LIMIT_EXCEEDED,
  IDLENESS_LIMIT_EXCEEDED,
  SECURITY_VIOLATED,
  CRASHED,
  INPUT_PREPARATION_CRASHED,
  CHALLENGED,
  SKIPPED,
  TESTING,
  REJECTED
}

@freezed
abstract class CFSubmission with _$CFSubmission {
  const factory CFSubmission(
    int id,
    int? contestId,
    int creationTimeSeconds,
    int relativeTimeSeconds,
    CFProblem problem,
    CFParty author,
    String programmingLanguage,
    CFSubmissionVerdict? verdict,
    int passedTestCount,
    int timeConsumedMillis,
    int memoryConsumedBytes,
    double? points,
    String? url,
  ) = _CFSubmission;

  factory CFSubmission.fromJson(Map<String, dynamic> json) =>
      _$CFSubmissionFromJson(json);
}
