// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'codeforces_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$CodeforcesService extends CodeforcesService {
  _$CodeforcesService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = CodeforcesService;

  @override
  Future<Response<dynamic>> getUserInfo(
    String handle, {
    Future<void>? abortTrigger,
  }) {
    final Uri $url = Uri.parse('/user.info');
    final Map<String, dynamic> $params = <String, dynamic>{'handles': handle};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      abortTrigger: abortTrigger,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getUserStatus(
    String handle, {
    int from = 1,
    int count = 10,
    Future<void>? abortTrigger,
  }) {
    final Uri $url = Uri.parse('/user.status');
    final Map<String, dynamic> $params = <String, dynamic>{
      'handle': handle,
      'from': from,
      'count': count,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      abortTrigger: abortTrigger,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
