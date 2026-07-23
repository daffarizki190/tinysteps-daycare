import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

// ── Warna lokal (senada dengan LoginPage) ────────────────────
const Color _kBackground       = Color(0xFFF7FAF8);
const Color _kPrimaryGreen     = Color(0xFF85B38B);
const Color _kPrimaryGreenDark = Color(0xFF5E8C64);
const Color _kSurface          = Color(0xFFFFFFFF);
const Color _kTextTitle        = Color(0xFF1B1C1C);
const Color _kTextSecondary    = Color(0xFF6B7280);
const Color _kPlaceholder      = Color(0xFFC2C9BE);
const Color _kBorder           = Color(0xFFE5E7EB);
const Color _kError            = Color(0xFFEF4444);

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  // ── State ──────────────────────────────────────────────────
  String fullName = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String errorMessage = '';

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // ── Controllers ────────────────────────────────────────────
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // ── Sign Up handler ────────────────────────────────────────
  void _handleSignUp() async {
    // Validasi field kosong
    if (fullName.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty ||
        confirmPassword.trim().isEmpty) {
      setState(() {
        errorMessage = 'All fields must be filled';
      });
      return;
    }

    // Validasi format email sederhana
    if (!email.contains('@') || !email.contains('.')) {
      setState(() {
        errorMessage = 'Please enter a valid email address';
      });
      return;
    }

    // Validasi panjang password
    if (password.length < 6) {
      setState(() {
        errorMessage = 'Password must be at least 6 characters';
      });
      return;
    }

    // Validasi password match
    if (password != confirmPassword) {
      setState(() {
        errorMessage = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      errorMessage = '';
    });

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.register(fullName, email, password);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Registration successful! Please login.',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
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
        Navigator.pop(context);
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
        child: Center(
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
                    // Tombol kembali
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: _kPrimaryGreenDark,
                          size: 22,
                        ),
                      ),
                    ),
                    _buildLogo(),
                    const SizedBox(height: 16),
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: _kTextTitle,
                        letterSpacing: -1.0,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Join TinySteps to stay connected\nwith your little one.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: _kTextSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildForm(),
                    const SizedBox(height: 20),
                    _buildSignUpButton(),
                    const SizedBox(height: 6),
                    errorMessage.isNotEmpty
                        ? _buildErrorMessage()
                        : const SizedBox.shrink(),
                    const SizedBox(height: 16),
                    _buildSignInLink(),
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
      width: 90,
      height: 90,
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
                size: 40, color: _kPrimaryGreenDark);
          },
        ),
      ),
    );
  }

  // ── Form (4 fields) ────────────────────────────────────────
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
        // Field 1: Nama Lengkap
        _buildLabel('Full Name'),
        const SizedBox(height: 6),
        SizedBox(
          height: 52,
          child: TextField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            onChanged: (value) => setState(() => fullName = value),
            style: const TextStyle(fontSize: 15, color: _kTextTitle),
            decoration: InputDecoration(
              hintText: 'Enter your full name',
              hintStyle: hintStyle,
              filled: true,
              fillColor: _kSurface,
              contentPadding: fieldPadding,
              prefixIcon: const Icon(Icons.person_outline_rounded,
                  color: _kPlaceholder, size: 20),
              border: border(_kBorder),
              enabledBorder: border(_kBorder),
              focusedBorder: border(_kPrimaryGreen, width: 2),
              errorBorder: border(_kError),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Field 2: Email
        _buildLabel('Email'),
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
        const SizedBox(height: 12),

        // Field 3: Password
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
        const SizedBox(height: 12),

        // Field 4: Konfirmasi Password
        _buildLabel('Confirm Password'),
        const SizedBox(height: 6),
        SizedBox(
          height: 52,
          child: TextField(
            controller: _confirmController,
            obscureText: _obscureConfirmPassword,
            onChanged: (value) => setState(() => confirmPassword = value),
            style: const TextStyle(fontSize: 15, color: _kTextTitle),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: hintStyle,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: _kPlaceholder,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
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

  // ── Sign Up Button ─────────────────────────────────────────
  Widget _buildSignUpButton() {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: auth.isLoading ? null : _handleSignUp,
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
                : const Text('Sign Up'),
          ),
        );
      },
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

  // ── Sign In link ───────────────────────────────────────────
  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account?',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: _kTextSecondary,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Sign In',
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
