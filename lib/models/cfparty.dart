// ignore_for_file: constant_identifier_names

import 'package:code_forces_tracker/models/cfmember.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cfparty.freezed.dart';
part 'cfparty.g.dart';

enum CFParticipantType {
  CONTESTANT,
  PRACTICE,
  VIRTUAL,
  MANAGER,
  OUT_OF_COMPETITION,
}

@freezed
abstract class CFParty with _$CFParty {
  const factory CFParty(
    int? contestId,
    IList<CFMember> members,
    CFParticipantType participantType,
    int? teamId,
    String? teamName,
    bool ghost,
    int? room,
    int startTimeSeconds,
  ) = _CFParty;

  factory CFParty.fromJson(Map<String, dynamic> json) =>
      _$CFPartyFromJson(json);
}
