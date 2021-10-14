// ignore_for_file: constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cfcontest.freezed.dart';
part 'cfcontest.g.dart';

enum CFContestType { CF, IOI, ICPC }
enum CFConstestPhase {
  BEFORE,
  CODING,
  PENDING_SYSTEM_TEST,
  SYSTEM_TEST,
  FINISHED,
}

@freezed
abstract class CFContest with _$CFContest {
  const factory CFContest(
    int id,
    String name,
    CFContestType type,
    CFConstestPhase phase,
    bool frozen,
    int durationSeconds,
    int? startTimeSeconds,
    int? relativeTimeSeconds,
    String? preparedBy,
    String? websiteUrl,
    String? description,
    int? difficulty,
    String? kind,
    String? icpcRegion,
    String? country,
    String? city,
    String? season,
  ) = _CFContest;

  factory CFContest.fromJson(Map<String, dynamic> json) =>
      _$CFContestFromJson(json);
}
