import 'package:freezed_annotation/freezed_annotation.dart';

part 'cfhandle.freezed.dart';

@freezed
abstract class CFHandle with _$CFHandle {
  const factory CFHandle.initial() = _CFHandleInitial;
  const factory CFHandle.loading() = _CFHandleLoading;
  const factory CFHandle.data({required String handle}) = _CFHandleData;
  const factory CFHandle.error([String? error]) = _CFHandleError;
}
