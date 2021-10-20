import 'dart:convert';

import 'package:code_forces_tracker/models/cfhandle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class HandleNotifier extends StateNotifier<CFHandle> {
  HandleNotifier() : super(const CFHandle.initial());

  Future<void> changeHandleTo(String handle) async {
    // This doesn't depend on the repository because this is where
    // The user's handle is established to be correct or not
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
      Future.delayed(const Duration(seconds: 1)).whenComplete(
        () {
          state = const CFHandle.initial();
        },
      );
    }
  }
}
