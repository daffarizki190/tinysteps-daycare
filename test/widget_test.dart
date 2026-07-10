// test/widget_test.dart
//
// Smoke test untuk aplikasi TinySteps Day Care.
// Diperbarui agar sesuai dengan struktur app yang sudah diubah:
//  • Nama class root: TinyStepsApp (bukan MyApp)
//  • Halaman awal: LoginPage (bukan counter app bawaan)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tinysteps/main.dart';
import 'package:tinysteps/features/auth/controllers/auth_controller.dart';
import 'package:tinysteps/features/home/controllers/home_controller.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Login page smoke test — elemen dasar tampil dengan benar',
      (WidgetTester tester) async {
    // Build aplikasi menggunakan class root yang benar: TinyStepsApp
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthController()),
          ChangeNotifierProvider(create: (_) => HomeController()),
        ],
        child: const TinyStepsApp(initialLoggedIn: false),
      ),
    );

    // Tunggu animasi bounceOut selesai (durasi 1200 ms)
    await tester.pumpAndSettle();

    // Verifikasi TextField Email & Password tersedia
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('Validasi — error muncul jika form kosong saat Sign In ditekan',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthController()),
          ChangeNotifierProvider(create: (_) => HomeController()),
        ],
        child: const TinyStepsApp(initialLoggedIn: false),
      ),
    );
    await tester.pumpAndSettle();

    // Tekan tombol Sign In tanpa mengisi field apapun
    await tester.tap(find.text('Sign In'));
    await tester.pump();

    // Pesan error harus muncul
    expect(
      find.text('Email and password cannot be empty'),
      findsOneWidget,
    );
  });
}
