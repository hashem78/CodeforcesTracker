import 'package:code_forces_tracker/providers/prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'handle.g.dart';

const _prefsKey = 'handle';

@Riverpod(keepAlive: true)
class HandleNotifier extends _$HandleNotifier {
  @override
  String? build() {
    final prefs = ref.read(prefsProvider);
    return prefs.getString(_prefsKey);
  }

  void set(String handle) {
    state = handle;
    ref.read(prefsProvider).setString(_prefsKey, handle);
  }

  void clear() {
    state = null;
    ref.read(prefsProvider).remove(_prefsKey);
  }
}
