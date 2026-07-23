import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'providers/auth_provider.dart';
import 'providers/tracker_provider.dart';
import 'views/login_page.dart';
import 'views/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // ── Auto-Login: cek FlutterSecureStorage ───────────────────
  // Jika kunci 'session' bernilai 'logged_in', arahkan ke HomePage.
  // Jika tidak, arahkan ke LoginPage.
  const secureStorage = FlutterSecureStorage();
  final sessionValue = await secureStorage.read(key: 'session');
  final bool isLoggedIn = sessionValue == 'logged_in';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final auth = AuthProvider();
            // Pulihkan nama user dari secure storage jika sudah login
            if (isLoggedIn) {
              auth.restoreSession();
            }
            return auth;
          },
        ),
        ChangeNotifierProvider(create: (_) => TrackerProvider()),
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
        colorSchemeSeed: const Color(0xFF85B38B),
      ),
      home: initialLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
}
