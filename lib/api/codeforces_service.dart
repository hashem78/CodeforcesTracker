import 'dart:async';

import 'package:chopper/chopper.dart';

part 'codeforces_service.chopper.dart';

@ChopperApi()
abstract class CodeforcesService extends ChopperService {
  static CodeforcesService create([ChopperClient? client]) =>
      _$CodeforcesService(client);

  @GET(path: '/user.info')
  Future<Response> getUserInfo(
    @Query('handles') String handle, {
    @AbortTrigger() Future<void>? abortTrigger,
  });

  @GET(path: '/user.status')
  Future<Response> getUserStatus(
    @Query('handle') String handle, {
    @Query('from') int from = 1,
    @Query('count') int count = 10,
    @AbortTrigger() Future<void>? abortTrigger,
  });
}

ChopperClient createCodeforcesClient() {
  return ChopperClient(
    baseUrl: Uri.parse('https://codeforces.com/api'),
    services: [CodeforcesService.create()],
  );
}
