// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [LandingScreen]
class LandingRoute extends PageRouteInfo<void> {
  const LandingRoute({List<PageRouteInfo>? children})
    : super(LandingRoute.name, initialChildren: children);

  static const String name = 'LandingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LandingScreen();
    },
  );
}

/// generated route for
/// [MainScreen]
class MainRoute extends PageRouteInfo<MainRouteArgs> {
  MainRoute({Key? key, required String handle, List<PageRouteInfo>? children})
    : super(
        MainRoute.name,
        args: MainRouteArgs(key: key, handle: handle),
        rawPathParams: {'handle': handle},
        initialChildren: children,
      );

  static const String name = 'MainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MainRouteArgs>(
        orElse: () => MainRouteArgs(handle: pathParams.getString('handle')),
      );
      return MainScreen(key: args.key, handle: args.handle);
    },
  );
}

class MainRouteArgs {
  const MainRouteArgs({this.key, required this.handle});

  final Key? key;

  final String handle;

  @override
  String toString() {
    return 'MainRouteArgs{key: $key, handle: $handle}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MainRouteArgs) return false;
    return key == other.key && handle == other.handle;
  }

  @override
  int get hashCode => key.hashCode ^ handle.hashCode;
}
