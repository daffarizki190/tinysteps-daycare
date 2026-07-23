import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tinysteps/providers/auth_provider.dart';
import 'package:tinysteps/views/login_page.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

void main() {
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    // Stub ChangeNotifier methods so Provider doesn't throw
    when(() => mockAuthProvider.addListener(any())).thenReturn(null);
    when(() => mockAuthProvider.removeListener(any())).thenReturn(null);
    when(() => mockAuthProvider.dispose()).thenReturn(null);

    // Default stubbing
    when(() => mockAuthProvider.isLoading).thenReturn(false);
    when(() => mockAuthProvider.errorMessage).thenReturn('');
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider<AuthProvider>.value(
          value: mockAuthProvider,
          child: const LoginPage(),
        ),
      ),
    );
  }

  group('LoginPage Widget Tests', () {
    testWidgets('renders LoginPage UI elements correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Hello, Parents!'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2)); // Email and Password
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('shows loading indicator when isLoading is true', (WidgetTester tester) async {
      when(() => mockAuthProvider.isLoading).thenReturn(true);

      await tester.pumpWidget(createWidgetUnderTest());
      // pump without settle because animation might run continuously
      await tester.pump(); 

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when login fails', (WidgetTester tester) async {
      when(() => mockAuthProvider.login(any(), any())).thenAnswer((_) async => false);
      when(() => mockAuthProvider.errorMessage).thenReturn('Invalid credentials');

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Scroll to the Sign In button
      final signInFinder = find.text('Sign In');
      await tester.ensureVisible(signInFinder);
      await tester.pumpAndSettle();

      // Tap the Sign In button to trigger the error
      await tester.tap(signInFinder);
      await tester.pumpAndSettle();

      // Wait for setState and error message to appear, we may need to scroll to it
      final errorFinder = find.text('Invalid credentials');
      await tester.ensureVisible(errorFinder);
      
      expect(errorFinder, findsOneWidget);
    });
  });
}
