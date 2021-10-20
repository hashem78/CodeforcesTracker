import 'package:code_forces_tracker/main.dart';
import 'package:code_forces_tracker/models/cfhandle.dart';
import 'package:code_forces_tracker/providers.dart';
import 'package:code_forces_tracker/widgets/screens/main.dart';
import 'package:code_forces_tracker/widgets/widgets/handle_inherited_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LandingScreen extends HookWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final handleController = useTextEditingController();
    return ProviderListener<CFHandle>(
      onChange: (context, value) {
        value.whenOrNull(
          loading: () {
            scaffoldMessengerKey.currentState!.showSnackBar(
              SnackBar(
                content: Row(
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Looking for handle'),
                  ],
                ),
              ),
            );
          },
          error: (error) {
            scaffoldMessengerKey.currentState!.showSnackBar(
              const SnackBar(
                content: Text(
                  'Handle not found!',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            );
          },
          data: (handle) {
            scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return HandleInheritedWidget(
                    const MainScreen(),
                    handle,
                  );
                },
              ),
            );
          },
        );
      },
      provider: handleProvider,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'CodeForces Tracker',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: handleController,
              ),
              ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  final handleNotifier = context.read(handleProvider.notifier);
                  handleNotifier.changeHandleTo(handleController.text);
                },
                child: const Text('Track'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
