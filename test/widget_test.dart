// test/widget_test.dart
//
// Smoke test untuk aplikasi TinySteps Day Care.
// Diperbarui agar sesuai dengan struktur app yang sudah diubah:
//  • Nama class root: TinyStepsApp (bukan MyApp)
//  • Halaman awal: LoginPage (bukan counter app bawaan)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tinysteps/main.dart';

void main() {
  testWidgets('Login page smoke test — elemen dasar tampil dengan benar', (
    WidgetTester tester,
  ) async {
    // Build aplikasi menggunakan class root yang benar: TinyStepsApp
    await tester.pumpWidget(const TinyStepsApp());

    // Tunggu animasi bounceOut selesai (durasi 1200 ms)
    await tester.pumpAndSettle();

    // Verifikasi elemen-elemen utama halaman Login tampil
    expect(find.text('TinySteps'), findsOneWidget);
    expect(find.text('Welcome Back 👋'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Login with Biometrics'), findsOneWidget);

    // Verifikasi TextField Email & Password tersedia
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('Validasi — error muncul jika form kosong saat Sign In ditekan', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TinyStepsApp());
    await tester.pumpAndSettle();

    // Tekan tombol Sign In tanpa mengisi field apapun
    await tester.tap(find.text('Sign In'));
    await tester.pump();

    // Pesan error harus muncul
    expect(find.text('Email and password cannot be empty'), findsOneWidget);
  });
}
