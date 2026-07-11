import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/views/login_page.dart';
import 'features/home/views/home_page.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/home/controllers/home_controller.dart';
import 'core/localization/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final String savedLanguage = prefs.getString('language_code') ?? 'en';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()..checkLoginStatus()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => LanguageProvider(savedLanguage)),
      ],
      child: TinyStepsApp(initialLoggedIn: isLoggedIn),
    ),
  );
}

class TinyStepsApp extends StatelessWidget {
  final bool initialLoggedIn;
  const TinyStepsApp({super.key, required this.initialLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TinySteps Day Care',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: initialLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
}
