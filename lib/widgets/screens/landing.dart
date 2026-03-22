import 'package:auto_route/auto_route.dart';
import 'package:code_forces_tracker/main.dart';
import 'package:code_forces_tracker/models/cfhandle.dart';
import 'package:code_forces_tracker/notifiers/handle.dart';
import 'package:code_forces_tracker/router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class LandingScreen extends HookConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handleController = useTextEditingController();
    ref.listen<CFHandle>(handleProvider, (previous, value) {
      switch (value) {
        case CFHandleLoading():
          scaffoldMessengerKey.currentState!.showSnackBar(
            SnackBar(
              content: Row(
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(width: 10),
                  Text('Looking for handle'),
                ],
              ),
            ),
          );
        case CFHandleError():
          scaffoldMessengerKey.currentState!.showSnackBar(
            const SnackBar(
              content: Text(
                'Handle not found!',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        case CFHandleData(:final handle):
          scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
          context.router.push(MainRoute(handle: handle));
        case _:
          break;
      }
    });
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'CodeForces Tracker',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            TextField(controller: handleController),
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                final handleNotifier = ref.read(handleProvider.notifier);
                handleNotifier.changeHandleTo(handleController.text);
              },
              child: const Text('Track'),
            ),
          ],
        ),
      ),
    );
  }
}
