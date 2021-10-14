import 'package:freezed_annotation/freezed_annotation.dart';

part 'cfuser.freezed.dart';
part 'cfuser.g.dart';

@freezed
abstract class CFUser with _$CFUser {
  const factory CFUser(
    String handle,
    String email,
    String vkId,
    String? openId,
    String? firstName,
    String? lastName,
    String? country,
    String? city,
    String? organization,
    int contribution,
    String rank,
    int rating,
    String maxRank,
    int maxRating,
    int lastOnlineTimeSeconds,
    int registrationTimeSeconds	,
    int friendOfCount,
    String avatar,
    String titlePhoto,
  ) = _CFUser;

  factory CFUser.fromJson(Map<String, dynamic> json) => _$CFUserFromJson(json);
}
