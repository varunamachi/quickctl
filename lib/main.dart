import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickctl/relayctl/screens/controllers_screen.dart';
import 'package:quickctl/router.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickCtl',
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      onGenerateRoute: onGenerateRoute,
      theme: _theme(),
      home: const ControllersScreen(),
    );
  }

  ThemeData _theme() {
    final baseTheme = ThemeData.dark();
    return baseTheme.copyWith(
      primaryColor: Colors.orange,
      colorScheme: const ColorScheme.dark().copyWith(
        primary: Colors.orange,
        background: Colors.orange,
      ),
    );
  }
}
