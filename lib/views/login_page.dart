import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_page.dart';
import 'register_page.dart';

// ── Warna lokal untuk halaman login ─────────────────────────
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
  // ── State ──────────────────────────────────────────────────
  String email = '';
  String password = '';
  String errorMessage = '';
  bool _obscurePassword = true;
  bool _rememberMe = false;

  // ── Controllers ────────────────────────────────────────────
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ── Animation: slide dari atas dengan bounceOut ────────────
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

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

  // ── Login handler ──────────────────────────────────────────
  void _handleSignIn() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.login(email, password);
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Welcome back, ${auth.userName}! 🎉',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            backgroundColor: const Color(0xFF659275),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } else {
      setState(() {
        errorMessage = auth.errorMessage;
      });
    }
  }

  // ── Build ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      body: SafeArea(
        child: Center( // Center everything instead of just SingleChildScrollView
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    _buildLogo(),
                    const SizedBox(height: 16),
                    const Text(
                      'Hello, Parents!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: _kTextTitle,
                        letterSpacing: -1.0,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
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
                    const SizedBox(height: 24),
                    _buildForm(),
                    const SizedBox(height: 12),
                    _buildRememberAndForgot(),
                    const SizedBox(height: 16),
                    _buildSignInButton(),
                    const SizedBox(height: 6),
                    errorMessage.isNotEmpty
                        ? _buildErrorMessage()
                        : const SizedBox.shrink(),
                    const SizedBox(height: 16),
                    _buildOrDivider(),
                    const SizedBox(height: 16),
                    _buildSSOButtons(),
                    const SizedBox(height: 16),
                    _buildSignUpLink(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Logo ───────────────────────────────────────────────────
  Widget _buildLogo() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/daycare_kita_logo.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.park_rounded,
                size: 52, color: _kPrimaryGreenDark);
          },
        ),
      ),
    );
  }

  // ── Form (Email + Password) ────────────────────────────────
  Widget _buildForm() {
    OutlineInputBorder border(Color color, {double width = 1}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    const TextStyle hintStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: _kPlaceholder,
    );

    const EdgeInsets fieldPadding = EdgeInsets.symmetric(
      vertical: 14,
      horizontal: 16,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email field
        _buildLabel('Email / Username'),
        const SizedBox(height: 6),
        SizedBox(
          height: 52,
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => setState(() => email = value),
            style: const TextStyle(fontSize: 15, color: _kTextTitle),
            decoration: InputDecoration(
              hintText: 'parent@example.com',
              hintStyle: hintStyle,
              filled: true,
              fillColor: _kSurface,
              contentPadding: fieldPadding,
              prefixIcon: const Icon(Icons.email_outlined,
                  color: _kPlaceholder, size: 20),
              border: border(_kBorder),
              enabledBorder: border(_kBorder),
              focusedBorder: border(_kPrimaryGreen, width: 2),
              errorBorder: border(_kError),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Password field
        _buildLabel('Password'),
        const SizedBox(height: 6),
        SizedBox(
          height: 52,
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            onChanged: (value) => setState(() => password = value),
            style: const TextStyle(fontSize: 15, color: _kTextTitle),
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
              prefixIcon: const Icon(Icons.lock_outline_rounded,
                  color: _kPlaceholder, size: 20),
              border: border(_kBorder),
              enabledBorder: border(_kBorder),
              focusedBorder: border(_kPrimaryGreen, width: 2),
              errorBorder: border(_kError),
            ),
          ),
        ),
      ],
    );
  }

  // ── Remember Me + Forgot Password ─────────────────────────
  Widget _buildRememberAndForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Checkbox Remember Me
        Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
                activeColor: _kPrimaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: const BorderSide(color: _kBorder, width: 1.5),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _rememberMe = !_rememberMe;
                });
              },
              child: const Text(
                'Remember Me',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _kTextSecondary,
                ),
              ),
            ),
          ],
        ),

        // Forgot Password
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Forgot Password feature coming soon!'),
                backgroundColor: _kPrimaryGreenDark,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
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
    );
  }

  // ── Sign In Button ─────────────────────────────────────────
  Widget _buildSignInButton() {
    final auth = Provider.of<AuthProvider>(context);
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: auth.isLoading ? null : _handleSignIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: _kPrimaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.14,
          ),
        ),
        child: auth.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5),
              )
            : const Text('Sign In'),
      ),
    );
  }

  // ── Error message ──────────────────────────────────────────
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

  // ── OR divider ─────────────────────────────────────────────
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

  // ── SSO Buttons (Google & Apple) ───────────────────────────
  Widget _buildSSOButtons() {
    return Column(
      children: [
        // Google SSO
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Google Sign-In coming soon!'),
                  backgroundColor: _kPrimaryGreenDark,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: _kBorder, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: _kSurface,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.g_mobiledata_rounded,
                      size: 24, color: Color(0xFFDB4437)),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _kTextTitle,
                    letterSpacing: 0.14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Apple SSO
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Apple Sign-In coming soon!'),
                  backgroundColor: _kPrimaryGreenDark,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: _kBorder, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: _kSurface,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.apple_rounded, size: 20, color: _kTextTitle),
                SizedBox(width: 8),
                Text(
                  'Continue with Apple',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _kTextTitle,
                    letterSpacing: 0.14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Sign Up link ───────────────────────────────────────────
  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: _kTextSecondary,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterPage()),
            );
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _kPrimaryGreenDark,
            ),
          ),
        ),
      ],
    );
  }

  // ── Helper ─────────────────────────────────────────────────
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
