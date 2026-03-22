import 'package:freezed_annotation/freezed_annotation.dart';

part 'cfhandle.freezed.dart';

@freezed
class CFHandle with _$CFHandle {
  const factory CFHandle.initial() = CFHandleInitial;
  const factory CFHandle.loading() = CFHandleLoading;
  const factory CFHandle.data({required String handle}) = CFHandleData;
  const factory CFHandle.error([String? error]) = CFHandleError;
}
