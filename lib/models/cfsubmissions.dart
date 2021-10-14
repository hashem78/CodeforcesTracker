import 'package:code_forces_tracker/models/cfsubmission.dart';
import 'package:code_forces_tracker/remote.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cfsubmissions.freezed.dart';

@freezed
abstract class CFSubmissions with _$CFSubmissions {
  const factory CFSubmissions.initial() = _CFSubmissionsInitial;
  const factory CFSubmissions.loading() = _CFSubmissionsLoading;
  const factory CFSubmissions.data({
    required List<CFSubmission> submissions,
    required int nextFrom,
    required GetUserState getUserState,
  }) = _CFSubmissionsData;
  const factory CFSubmissions.error([String? error]) = _CFSubmissionsError;
}
