import 'dart:ui';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../shared/constants/constants.dart';
import '../../shared/utils/token_manager.dart';
import '../main/main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Form and controllers
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // State variables
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

  void _dismissKeyboard() {
    // Multiple methods to ensure keyboard dismissal on all platforms
    FocusScope.of(context).unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  String _getApiUrl() {
    // Different URLs for different platforms
    if (kIsWeb) {
      return 'http://localhost:5000/api/auth/login'; // Web
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api/auth/login'; // Android emulator
    } else if (Platform.isIOS) {
      return 'http://localhost:5000/api/auth/login'; // iOS simulator
    } else {
      return 'http://localhost:5000/api/auth/login'; // Desktop
    }
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    
    _dismissKeyboard(); // Dismiss keyboard
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final apiUrl = _getApiUrl();
      print('🔗 Attempting to connect to: $apiUrl'); // Debug log
      
      // Make API call to your backend
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': _emailController.text.trim(),
          'password': _passwordController.text,
        }),
      ).timeout(const Duration(seconds: 10));

      print('📡 Response status: ${response.statusCode}'); // Debug log
      print('📄 Response body: ${response.body}'); // Debug log

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        // Save token and admin data to memory
        final token = responseData['data']['token'];
        final adminData = responseData['data']['admin'];
        
        TokenManager.saveToken(token);
        TokenManager.saveAdminData(adminData);
        
        // Successful login
        setState(() {
          _isLoading = false;
          _errorMessage = null;
        });
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Connexion réussie! Bienvenue ${adminData['username']}'),
              backgroundColor: AppColors.success,
              duration: AppConstants.shortSnackBarDuration,
            ),
          );
        }
        
        // Navigate to main page
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
          );
        }
        
      } else {
        // Login failed
        setState(() {
          _isLoading = false;
          _errorMessage = responseData['message'] ?? 'Identifiants invalides';
        });
      }
    } catch (e) {
      print('❌ Login error: $e'); // Debug log
      setState(() {
        _isLoading = false;
        if (e.toString().contains('TimeoutException')) {
          _errorMessage = 'Timeout: Le serveur met trop de temps à répondre';
        } else if (e.toString().contains('SocketException') || e.toString().contains('Connection refused')) {
          _errorMessage = 'Impossible de se connecter au serveur.\n\nVérifiez que:\n• Le serveur backend est démarré\n• Il fonctionne sur le port 5000\n• URL: ${_getApiUrl()}';
        } else {
          _errorMessage = 'Erreur de connexion: ${e.toString()}';
        }
      });
    }
  }

  Widget _buildLogo() {
    return Container(
      width: AppDimensions.logoWidth,
      height: AppDimensions.logoHeight,
      margin: EdgeInsets.only(bottom: AppDimensions.spaceXXXL),
      child: Image.asset(
        AppConstants.logoAsset,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildFormHeader() {
    return Column(
      children: [
        Text(
          AppStrings.loginTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.loginTitle,
        ),
        SizedBox(height: AppDimensions.spaceS),
        Text(
          AppStrings.loginSubtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.loginSubtitle.copyWith(
            color: AppColors.whiteWithOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: AppDimensions.buttonHeightL,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.whiteWithOpacity(0.18),
          foregroundColor: AppColors.textOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: AppDimensions.iconSize,
                height: AppDimensions.iconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
                ),
              )
            : Text(AppStrings.loginButton, style: AppTextStyles.buttonLarge),
      ),
    );
  }

  Widget _buildErrorMessage() {
    if (_errorMessage == null) return const SizedBox.shrink();
    
    return Container(
      margin: EdgeInsets.only(top: AppDimensions.spaceL + 2),
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: AppDimensions.iconSizeS,
          ),
          SizedBox(width: AppDimensions.spaceS),
          Expanded(
            child: Text(
              _errorMessage!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusXXXL),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: AppDimensions.formWidth,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXXXL, 
            vertical: AppDimensions.paddingForm
          ),
          decoration: BoxDecoration(
            color: AppColors.whiteWithOpacity(0.15),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXXXL),
            border: Border.all(
              color: AppColors.whiteWithOpacity(0.18),
              width: AppDimensions.borderWidthMedium,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackWithOpacity(0.10),
                blurRadius: AppDimensions.spaceXXL,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildFormHeader(),
                SizedBox(height: AppDimensions.spaceXXXL),
                _GlassTextField(
                  controller: _emailController,
                  hintText: AppStrings.usernameHint,
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  autofillHints: const [AutofillHints.username, AutofillHints.email],
                ),
                SizedBox(height: AppDimensions.spaceL + 2),
                _GlassTextField(
                  controller: _passwordController,
                  hintText: AppStrings.passwordHint,
                  icon: Icons.lock_outline,
                  obscureText: !_isPasswordVisible,
                  keyboardType: TextInputType.visiblePassword,
                  autofillHints: const [AutofillHints.password],
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textOnPrimary,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                SizedBox(height: AppDimensions.spaceXXL + 4),
                _buildLoginButton(),
                _buildErrorMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _dismissKeyboard,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AppConstants.backgroundAsset,
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.paddingL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogo(),
                    _buildForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
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
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      style: AppTextStyles.inputText.copyWith(
        color: AppColors.textOnPrimary,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: AppColors.textOnPrimary,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.whiteWithOpacity(0.08),
        hintText: hintText,
        hintStyle: AppTextStyles.inputHint.copyWith(
          color: AppColors.whiteWithOpacity(0.7),
        ),
        prefixIcon: Icon(icon, color: AppColors.textOnPrimary),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM + 2),
          borderSide: BorderSide(
            color: AppColors.whiteWithOpacity(0.18), 
            width: AppDimensions.borderWidthMedium
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM + 2),
          borderSide: BorderSide(
            color: AppColors.whiteWithOpacity(0.18), 
            width: AppDimensions.borderWidthMedium
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM + 2),
          borderSide: BorderSide(
            color: AppColors.textOnPrimary, 
            width: AppDimensions.borderWidthThick
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: AppDimensions.paddingXL, 
          horizontal: AppDimensions.spaceL + 2
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return hintText == AppStrings.usernameHint 
              ? 'Veuillez saisir votre identifiant'
              : 'Veuillez saisir votre mot de passe';
        }
        return null;
      },
    );
  }
}