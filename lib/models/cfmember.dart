import 'package:freezed_annotation/freezed_annotation.dart';

part 'cfmember.freezed.dart';
part 'cfmember.g.dart';

@freezed
abstract class CFMember with _$CFMember {
  const factory CFMember(
    String handle,
    String? name,
  ) = _CFMember;

  factory CFMember.fromJson(Map<String, dynamic> json) =>
      _$CFMemberFromJson(json);
}
