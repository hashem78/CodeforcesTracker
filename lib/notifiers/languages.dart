import 'package:code_forces_tracker/models/cfstatisticsstate.dart';
import 'package:code_forces_tracker/remote.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CFStatisticsNotifier extends StateNotifier<CFStatisticsState> {
  CFStatisticsNotifier(String handle)
      : repository = CFRepository(handle: handle),
        super(const CFStatisticsState.loading());

  final CFRepository repository;
  void fetchData() {
    state = const CFStatisticsState.loading();
    repository.getStatistics().then((value) {
      state = CFStatisticsState.data(data: value);
    }, onError: (err) {
      throw Exception('An error occured');
    });
  }
}
