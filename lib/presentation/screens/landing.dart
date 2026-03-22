import 'package:auto_route/auto_route.dart';
import 'package:code_forces_tracker/main.dart';
import 'package:code_forces_tracker/providers/handle_validation.dart';
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
    final validationState = ref.watch(handleValidatorProvider);

    // Side effects: only react to transitions from loading
    ref.listen(handleValidatorProvider, (prev, next) {
      if (prev is! AsyncLoading) return;
      switch (next) {
        case AsyncData(value: HandleValidationResult.valid):
          scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
          context.router.push(MainRoute(handle: handleController.text.trim()));
        case AsyncData(value: HandleValidationResult.invalid):
          scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
          scaffoldMessengerKey.currentState!.showSnackBar(
            const SnackBar(
              content: Text(
                'Handle not found!',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        case AsyncError():
          scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
          scaffoldMessengerKey.currentState!.showSnackBar(
            const SnackBar(
              content: Text(
                'An error occurred, please try again later.',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        case _:
          break;
      }
    });

    void submit() {
      final handle = handleController.text.trim();
      if (handle.isEmpty) return;
      FocusScope.of(context).unfocus();
      ref.read(handleValidatorProvider.notifier).validate(handle);
    }

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
            TextField(
              controller: handleController,
              enabled: !validationState.isLoading,
              onSubmitted: (_) => submit(),
            ),
            switch (validationState) {
              AsyncLoading() => const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              _ => ElevatedButton(
                  onPressed: submit,
                  child: const Text('Track'),
                ),
            },
          ],
        ),
      ),
    );
  }
}
