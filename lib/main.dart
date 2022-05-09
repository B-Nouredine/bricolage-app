
import 'package:flutter/material.dart';
import 'package:bricolage_app/screens/Home/StartPage.dart';
import 'theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.system);
  @override
  Widget build(context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      themeMode: currentMode,
      home: const StartPage(),
    );
  });
  }
}

