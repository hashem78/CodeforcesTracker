import 'dart:convert';

import 'package:code_forces_tracker/models/cfhandle.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'handle.g.dart';

@riverpod
class Handle extends _$Handle {
  @override
  CFHandle build() => const CFHandle.initial();

  Future<void> changeHandleTo(String handle) async {
    state = const CFHandle.loading();
    final response = await http.get(
      Uri.parse('https://codeforces.com/api/user.info?handles=$handle'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final status = jsonResponse['status'] as String;
      if (status == 'FAILED') {
        state = CFHandle.error('The handle $handle doesn\'t exist');
      } else {
        state = CFHandle.data(handle: handle);
      }
    } else {
      state = const CFHandle.error('An error occured, please try again later.');
      Future.delayed(const Duration(seconds: 1)).whenComplete(() {
        state = const CFHandle.initial();
      });
    }
  }
}
