import 'package:flutter/material.dart';
import 'package:quickctl/relay_ctl/widgets/discover_widget.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  return build(const DiscoverWidget());
}

PageRouteBuilder<dynamic> build(Widget screen) {
  return PageRouteBuilder<dynamic>(
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
