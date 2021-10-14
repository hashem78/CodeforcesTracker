import 'package:code_forces_tracker/notifiers/cflanguages.dart';
import 'package:code_forces_tracker/remote.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CFLanguagesNotifier extends StateNotifier<CFLanguages> {
  CFLanguagesNotifier(String handle)
      : repository = CFRepository(handle: handle),
        super(const CFLanguages.loading());

  final CFRepository repository;
  void fetchData() {
    state = const CFLanguages.loading();
    repository.getLanguages().then(
      (value) {
        state = CFLanguages.data(data: value);
      },
      onError: (err){
        throw Exception('An error occured');
      }
    );
  }
}
