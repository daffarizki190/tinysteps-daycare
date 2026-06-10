import 'package:flutter/material.dart';
import '../../core/utils/utils.dart';
import '../home/home_page.dart';

const Color _kBackground       = Color(0xFFF7FAF8);
const Color _kPrimaryGreen     = Color(0xFF85B38B);
const Color _kPrimaryGreenDark = Color(0xFF5E8C64);
const Color _kSurface          = Color(0xFFFFFFFF);
const Color _kTextTitle        = Color(0xFF1B1C1C);
const Color _kTextSecondary    = Color(0xFF6B7280);
const Color _kPlaceholder      = Color(0xFFC2C9BE);
const Color _kBorder           = Color(0xFFE5E7EB);
const Color _kError            = Color(0xFFEF4444);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

  String email        = 'test';
  String password     = 'test';
  String errorMessage = '';

  bool _obscurePassword = true;


  final TextEditingController _emailController =
      TextEditingController(text: 'test');
  final TextEditingController _passwordController =
      TextEditingController(text: 'test');

  late AnimationController _animationController;
  late Animation<double>   _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnimation = Tween<double>(begin: -500.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    setState(() {

      if (email == 'test' && password == 'test') {
        errorMessage = '';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        return;
      }


      if (email.isEmpty || password.isEmpty) {
        errorMessage = 'Email and password cannot be empty';
      } else if (!AppUtils.isValidEmail(email)) {
        errorMessage = 'Please enter a valid email address';
      } else if (!AppUtils.isValidPassword(password)) {
        errorMessage = 'Password must be at least 6 characters';
      } else {
        errorMessage = '';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: child,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 52),
                  _buildLogo(),
                  const SizedBox(height: 32),
                  const Text(
                    'Hello, Parents!',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: _kTextTitle,
                      letterSpacing: -1.0,
                      height: 48 / 40,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Sign in to stay connected with your little one's day.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: _kTextSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  _buildForm(),
                  const SizedBox(height: 20),
                  _buildSignInButton(),
                  const SizedBox(height: 6),
                  errorMessage.isNotEmpty
                      ? _buildErrorMessage()
                      : const SizedBox.shrink(),
                  const SizedBox(height: 28),
                  _buildOrDivider(),
                  const SizedBox(height: 20),
                  _buildBiometricButton(),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/daycare_kita_logo.png',
      width: 160,
      height: 160,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFD4E8D7),
            border: Border.all(color: _kPrimaryGreen, width: 2.5),
          ),
          child: const Icon(Icons.park_rounded, size: 56, color: _kPrimaryGreenDark),
        );
      },
    );
  }

  Widget _buildForm() {
    OutlineInputBorder border(Color color, {double width = 1}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    const TextStyle hintStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: _kPlaceholder,
    );

    const EdgeInsets fieldPadding = EdgeInsets.symmetric(
      vertical: 17,
      horizontal: 16,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Email Address'),
        const SizedBox(height: 8),
        SizedBox(
          height: 56,
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => setState(() => email = value),
            style: const TextStyle(
              fontSize: 16,
              color: _kTextTitle,
            ),
            decoration: InputDecoration(
              hintText: 'parent@example.com',
              hintStyle: hintStyle,
              filled: true,
              fillColor: _kSurface,
              contentPadding: fieldPadding,
              border:         border(_kBorder),
              enabledBorder:  border(_kBorder),
              focusedBorder:  border(_kPrimaryGreen, width: 2),
              errorBorder:    border(_kError),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel('Password'),
            GestureDetector(
              onTap: () {
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _kPrimaryGreenDark,
                  letterSpacing: 0.14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 56,
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            onChanged: (value) => setState(() => password = value),
            style: const TextStyle(
              fontSize: 16,
              color: _kTextTitle,
            ),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: hintStyle,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: _kPlaceholder,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                splashRadius: 20,
              ),
              filled: true,
              fillColor: _kSurface,
              contentPadding: fieldPadding,
              border:         border(_kBorder),
              enabledBorder:  border(_kBorder),
              focusedBorder:  border(_kPrimaryGreen, width: 2),
              errorBorder:    border(_kError),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _handleSignIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: _kPrimaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            letterSpacing: 0.14,
          ),
        ),
        child: const Text('Sign In'),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, size: 15, color: _kError),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              errorMessage,
              style: const TextStyle(
                fontSize: 13,
                color: _kError,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: Color(0xFFD1D5DB), thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: Color(0xFFD1D5DB), thickness: 1),
        ),
      ],
    );
  }

  Widget _buildBiometricButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: () {
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: _kBorder, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: _kSurface,
          foregroundColor: _kTextSecondary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fingerprint, size: 22, color: _kPrimaryGreen),
            const SizedBox(width: 10),
            const Text(
              'Login with Biometrics',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _kTextSecondary,
                letterSpacing: 0.14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: _kTextTitle,
        letterSpacing: 0.14,
      ),
    );
  }
}
