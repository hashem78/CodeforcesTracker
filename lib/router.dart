import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:code_forces_tracker/presentation/screens/landing.dart';
import 'package:code_forces_tracker/presentation/screens/main.dart';
import 'package:code_forces_tracker/presentation/screens/settings.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LandingRoute.page, initial: true),
        AutoRoute(page: MainRoute.page),
        AutoRoute(page: SettingsRoute.page),
      ];
}
