import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickctl/relay_ctl/screens/controllers_screen.dart';
import 'package:quickctl/router.dart';

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
