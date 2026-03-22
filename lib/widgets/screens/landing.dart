import 'package:auto_route/auto_route.dart';
import 'package:code_forces_tracker/main.dart';
import 'package:code_forces_tracker/remote.dart';
import 'package:code_forces_tracker/router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

@RoutePage()
class LandingScreen extends HookWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final handleController = useTextEditingController();
    final isLoading = useState(false);

    Future<void> submit() async {
      final handle = handleController.text.trim();
      if (handle.isEmpty) return;

      FocusScope.of(context).unfocus();
      isLoading.value = true;

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

      try {
        final valid = await CFRepository.validateHandle(handle);
        scaffoldMessengerKey.currentState!.hideCurrentSnackBar();

        if (valid) {
          if (context.mounted) {
            context.router.push(MainRoute(handle: handle));
          }
        } else {
          scaffoldMessengerKey.currentState!.showSnackBar(
            const SnackBar(
              content: Text(
                'Handle not found!',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }
      } catch (_) {
        scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
        scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(
            content: Text(
              'An error occurred, please try again later.',
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
      } finally {
        isLoading.value = false;
      }
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
              onSubmitted: (_) => submit(),
            ),
            ElevatedButton(
              onPressed: isLoading.value ? null : submit,
              child: const Text('Track'),
            ),
          ],
        ),
      ),
    );
  }
}
