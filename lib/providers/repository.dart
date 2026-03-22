import 'package:code_forces_tracker/api/codeforces_service.dart';
import 'package:code_forces_tracker/remote.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository.g.dart';

@Riverpod(keepAlive: true)
CodeforcesService codeforcesService(Ref ref) {
  final client = createCodeforcesClient();
  ref.onDispose(client.dispose);
  return client.getService<CodeforcesService>();
}

@riverpod
CFRepository cfRepository(Ref ref, String handle) {
  final service = ref.watch(codeforcesServiceProvider);
  return CFRepository(handle: handle, service: service);
}
