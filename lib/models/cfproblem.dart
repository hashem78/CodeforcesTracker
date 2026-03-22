// ignore_for_file: constant_identifier_names

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cfproblem.freezed.dart';
part 'cfproblem.g.dart';

enum CFProblemType { PROGRAMMING, QUESTION }

@freezed
abstract class CFProblem with _$CFProblem {
  const factory CFProblem(
    int? contestId,
    String? problemsetName,
    String index,
    String name,
    CFProblemType type,
    double? points,
    int? rating,
    IList<String> tags,
  ) = _CFProblem;

  factory CFProblem.fromJson(Map<String, dynamic> json) =>
      _$CFProblemFromJson(json);
}
