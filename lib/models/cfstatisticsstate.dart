
import 'package:code_forces_tracker/remote.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tuple/tuple.dart';
import 'package:code_forces_tracker/models/cfverdictsdata.dart';
import 'package:code_forces_tracker/models/cflanguagedata.dart';

part 'cfstatisticsstate.freezed.dart';


@freezed
class CFStatisticsState with _$CFStatisticsState {
  const factory CFStatisticsState.loading() = _CFStatisticsStateLoading;
  const factory CFStatisticsState.data({required StatisticsType data}) = _CFStatisticsStateData;
  const factory CFStatisticsState.error([String? error]) = _CFStatisticsStateError;
	
}
