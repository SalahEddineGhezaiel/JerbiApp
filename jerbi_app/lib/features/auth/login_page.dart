import 'dart:ui';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
      _errorMessage = "Identifiant ou mot de passe invalide. Veuillez réessayer.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg1.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 250,
                    height: 100,
                    margin: const EdgeInsets.only(bottom: 32),
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        width: 370,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.18),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Se Connecter',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'SFPro',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 28,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Accès administrateur',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'SFPro',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 32),
                              _GlassTextField(
                                controller: _emailController,
                                hintText: 'Identifiant',
                                icon: Icons.person_outline,
                                keyboardType: TextInputType.emailAddress,
                                obscureText: false,
                                autofillHints: const [AutofillHints.username, AutofillHints.email],
                              ),
                              const SizedBox(height: 18),
                              _GlassTextField(
                                controller: _passwordController,
                                hintText: 'Mot De Passe',
                                icon: Icons.lock_outline,
                                obscureText: !_isPasswordVisible,
                                keyboardType: TextInputType.visiblePassword,
                                autofillHints: const [AutofillHints.password],
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: _togglePasswordVisibility,
                                ),
                              ),
                              const SizedBox(height: 28),
                              SizedBox(
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.white.withOpacity(0.18),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    textStyle: const TextStyle(
                                      fontFamily: 'SFPro',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : const Text('Se Connecter'),
                                ),
                              ),
                              if (_errorMessage != null) ...[
                                const SizedBox(height: 18),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.red[200]!),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red[600],
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _errorMessage!,
                                          style: TextStyle(
                                            color: Colors.red[700],
                                            fontSize: 14,
                                            fontFamily: 'SFPro',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final List<String>? autofillHints;
  final Widget? suffixIcon;

  const _GlassTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.obscureText,
    required this.keyboardType,
    this.autofillHints,
    this.suffixIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      style: const TextStyle(
        fontFamily: 'SFPro',
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'SFPro',
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.18), width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.18), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez saisir votre $hintText';
        }
        if (hintText == 'Mot De Passe' && value.length < 6) {
          return 'Incorrect, au moins 6 caractères';
        }
        return null;
      },
    );
  }
}
