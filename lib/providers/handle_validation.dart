import 'dart:async';

import 'package:code_forces_tracker/providers/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'handle_validation.g.dart';

enum HandleValidationResult { valid, invalid }

@Riverpod(keepAlive: true)
class HandleValidator extends _$HandleValidator {
  Completer<void>? _abort;

  @override
  AsyncValue<HandleValidationResult> build() => const AsyncData(HandleValidationResult.invalid);

  Future<void> validate(String handle) async {
    // Cancel any in-flight request
    _abort?.complete();
    _abort = Completer<void>();

    state = const AsyncLoading();

    try {
      final repo = ref.read(cfRepositoryProvider(handle));
      final valid = await repo.validateHandle(abortTrigger: _abort!.future);
      state = AsyncData(valid ? HandleValidationResult.valid : HandleValidationResult.invalid);
    } on Exception catch (e, st) {
      if (_abort?.isCompleted == true) return; // cancelled, ignore
      state = AsyncError(e, st);
    }
  }

  void cancel() {
    _abort?.complete();
    _abort = null;
    state = const AsyncData(HandleValidationResult.invalid);
  }
}
