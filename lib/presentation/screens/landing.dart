import 'package:auto_route/auto_route.dart';
import 'package:code_forces_tracker/core/app_sizing.dart';
import 'package:code_forces_tracker/main.dart';
import 'package:code_forces_tracker/providers/handle_validation.dart';
import 'package:code_forces_tracker/providers/locale.dart';
import 'package:code_forces_tracker/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class LandingScreen extends HookConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);
    final validationState = ref.watch(handleValidatorProvider);
    final t = ref.watch(localeProvider);

    ref.listen(handleValidatorProvider, (prev, next) {
      if (prev is! AsyncLoading) return;
      switch (next) {
        case AsyncData(value: HandleValidationResult.valid):
          scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
          final handle =
              formKey.currentState!.fields['handle']!.value as String;
          context.router.push(MainRoute(handle: handle.trim()));
        case AsyncData(value: HandleValidationResult.invalid):
          scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
          formKey.currentState!.fields['handle']!.invalidate(
            t.landing.validation.notFound,
          );
        case AsyncError():
          scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
          scaffoldMessengerKey.currentState!.showSnackBar(
            SnackBar(
              content: Text(
                t.landing.error,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        case _:
          break;
      }
    });

    void submit() {
      if (!(formKey.currentState?.saveAndValidate() ?? false)) return;
      final handle = formKey.currentState!.value['handle'] as String;
      FocusScope.of(context).unfocus();
      ref.read(handleValidatorProvider.notifier).validate(handle.trim());
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.router.push(const SettingsRoute()),
          ),
        ],
      ),
      body: FormBuilder(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.paddingXL,
              vertical: context.spaceMD,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: formMaxWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    t.appTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.fontXL,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: context.spaceLG),
                  FormBuilderTextField(
                    name: 'handle',
                    enabled: !validationState.isLoading,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: t.landing.handleLabel,
                      hintText: t.landing.handleHint,
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(
                        3,
                        errorText: t.landing.validation.minLength,
                      ),
                      FormBuilderValidators.maxLength(
                        24,
                        errorText: t.landing.validation.maxLength,
                      ),
                      FormBuilderValidators.match(
                        RegExp(r'^[a-zA-Z0-9._-]+$'),
                        errorText: t.landing.validation.invalidChars,
                      ),
                    ]),
                    onSubmitted: (_) => submit(),
                  ),
                  SizedBox(height: context.spaceMD),
                  switch (validationState) {
                    AsyncLoading() => Padding(
                      padding: EdgeInsets.all(context.paddingLG),
                      child: const CircularProgressIndicator(),
                    ),
                    _ => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: submit,
                        child: Text(t.landing.track),
                      ),
                    ),
                  },
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
