import 'dart:async';

import 'package:code_forces_tracker/providers/repository.dart';
import 'package:code_forces_tracker/remote.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'statistics.g.dart';

@riverpod
Future<StatisticsType> statistics(Ref ref, String handle) async {
  final repository = ref.watch(cfRepositoryProvider(handle));
  return repository.getStatistics();
}
