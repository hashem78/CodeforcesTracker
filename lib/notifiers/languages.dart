import 'package:code_forces_tracker/remote.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'languages.g.dart';

@riverpod
Stream<StatisticsType> statistics(Ref ref, String handle) {
  final repository = CFRepository(handle: handle);
  return Stream.fromFuture(repository.getStatistics());
}
