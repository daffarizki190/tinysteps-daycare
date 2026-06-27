import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/login_page.dart';
import 'features/auth/login_provider.dart';
import 'features/home/home_page.dart';
import 'features/home/data/tracker_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi LoginProvider sebelum runApp agar bisa cek session
  final loginProvider = LoginProvider();
  await loginProvider.initFromPrefs();

  // Menggunakan MultiProvider sesuai materi Pertemuan 5
  // Mendaftarkan semua ChangeNotifier di satu tempat
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TrackerProvider()),
        ChangeNotifierProvider.value(value: loginProvider),
      ],
      child: const TinyStepsApp(),
    ),
  );
}

class TinyStepsApp extends StatelessWidget {
  const TinyStepsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TinySteps Day Care',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Roboto'),
      // Menggunakan Consumer untuk mendengarkan perubahan login state
      // dan menentukan halaman awal secara reaktif
      home: Consumer<LoginProvider>(
        builder: (context, loginProvider, child) {
          return loginProvider.isLoggedIn
              ? const HomePage()
              : const LoginPage();
        },
      ),
    );
  }
}
