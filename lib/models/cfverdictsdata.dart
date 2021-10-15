import 'package:code_forces_tracker/models/cfsubmission.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cfverdictsdata.freezed.dart';

@freezed
class CFVerdictsData with _$CFVerdictsData {
  const factory CFVerdictsData(CFSubmissionVerdict verdict, int value) =
      _CFVerdictsData;
}
