import 'package:flutter/material.dart';
import 'package:staff_app/shared/screens/application_page.dart';
import 'package:staff_app/shared/theming/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.light(),
      debugShowCheckedModeBanner: false,
      home: const ApplicationPage(),
    );
  }
}
