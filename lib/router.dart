import 'package:flutter/material.dart';
import 'package:quickctl/relay_ctl/screens/controllers_screen.dart';
import 'package:quickctl/relay_ctl/screens/discover_screen.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  if (settings.name == DiscoverScreen.id) {
    return build(const DiscoverScreen());
  }
  if (settings.name == ControllersScreen.id) {
    return build(const ControllersScreen());
  }
  return build(const Center(
    child: Text("Invalid route"),
  ));
}

PageRouteBuilder<Widget> build(Widget screen) {
  return PageRouteBuilder<Widget>(
    pageBuilder: (BuildContext ctx, __, ___) {
      return screen;
    },
    transitionsBuilder: (_, anim, __, child) {
      return FadeTransition(opacity: anim, child: child);
    },
  );
}

void navigateTo(BuildContext ctx, String path) {
  Navigator.pushNamed(ctx, path);
}

void popNav(BuildContext ctx, String route, {Object? args}) {
  Navigator.of(ctx).pushNamedAndRemoveUntil(
    route,
    (Route<dynamic> route) => false,
  );
}
