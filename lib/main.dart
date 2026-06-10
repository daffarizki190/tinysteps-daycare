import 'package:flutter/material.dart';
import 'features/auth/login_page.dart';

void main() {
  runApp(const TinyStepsApp());
}

class TinyStepsApp extends StatelessWidget {
  const TinyStepsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TinySteps Day Care',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
    );
  }
}
