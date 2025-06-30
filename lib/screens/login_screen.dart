import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:mobile_app/widgets/title_text.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late AnimationController _fadeController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Variables to store route arguments
  String? prefilledPhoneNumber;
  bool isFromRegistration = false;
  String? successMessage;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Start animations
    _fadeController.forward();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get arguments from navigation route
    final arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments != null) {
      if (arguments is Map<String, dynamic>) {
        prefilledPhoneNumber = arguments['phone_number'] as String?;
        isFromRegistration = arguments['isFromRegistration'] as bool? ?? false;
        successMessage = arguments['successMessage'] as String?;
      } else if (arguments is String) {
        prefilledPhoneNumber = arguments;
      }

      if (prefilledPhoneNumber != null) {
        setState(() {
          _phoneController.text = prefilledPhoneNumber!;
        });
      }

      if (successMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showSuccessSnackbar(successMessage!);
        });
      }
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    // Add haptic feedback
    HapticFeedback.lightImpact();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final phoneNumber = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    final result = await authProvider.login(
      password: password,
      phoneNumber: phoneNumber,
    );

    if (result['success']) {
      if (mounted) {
        _showSuccessSnackbar('Connecté avec succès');
        // Add a small delay for better UX
        await Future.delayed(Duration(milliseconds: 500));
        Navigator.pushReplacementNamed(context, '/main');
      }
    } else {
      if (mounted) {
        _showErrorSnackbar(result['message'] ?? 'Erreur de connection');
      }
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre numéro de téléphone';
    }
    if (value.length < 8) {
      return 'Numéro de téléphone invalide';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre mot de passe';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.secondaryColor,
            AppColors.secondaryColor.withOpacity(0.8),
            AppColors.primaryColor.withOpacity(0.1),
          ],
          stops: [0.0, 0.7, 1.0],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Logo with scale animation
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.2),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'images/logo.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                // Title with improved typography
                TitleText(
                  text:
                      isFromRegistration
                          ? 'Finaliser votre connexion'
                          : 'Bienvenue !',
                  fontSize: AppDimension.fontSize24 + 4,
                  color: AppColors.primaryColor,
                ),
                SizedBox(height: 8),
                Text(
                  isFromRegistration
                      ? 'Connectez-vous pour continuer'
                      : 'Connectez-vous à votre compte',
                  style: TextStyle(
                    fontSize: AppDimension.fontSize18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    bool isPassword = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: isPassword && !_isPasswordVisible,
        style: TextStyle(
          fontSize: AppDimension.fontSize18,
          color: Colors.grey[800],
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.primaryColor),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                  : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red[400]!, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red[600]!, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildLoginButton(AuthProvider authProvider) {
    return Container(
      width: double.infinity,
      height: 56,
      margin: EdgeInsets.symmetric(vertical: 24),
      child:
          authProvider.isLoading
              ? Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              )
              : ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: AppColors.primaryColor.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ).copyWith(
                  elevation: MaterialStateProperty.resolveWith<double>((
                    Set<MaterialState> states,
                  ) {
                    if (states.contains(MaterialState.pressed)) return 0;
                    return 4;
                  }),
                ),
                child: Text(
                  'Se connecter',
                  style: TextStyle(
                    fontSize: AppDimension.fontSize18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
    );
  }

  Widget _buildSignUpPrompt() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Pas encore de compte? ',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pushReplacementNamed(context, '/register');
            },
            child: Text(
              "S'inscrire",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: AppDimension.radius14,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppDimension.init(context);

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          _buildGradientBackground(),

          // Main content
          SafeArea(
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 40),

                          // Header section
                          _buildHeader(),

                          SizedBox(height: 48),

                          // Input fields with animation
                          AnimatedBuilder(
                            animation: _slideAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _slideAnimation.value * 0.5),
                                child: FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Column(
                                    children: [
                                      // Phone number field
                                      _buildInputField(
                                        controller: _phoneController,
                                        label: 'Numéro de téléphone',
                                        hint: 'Entrez votre numéro',
                                        icon: Icons.phone_outlined,
                                        validator: _validatePhoneNumber,
                                      ),

                                      // Password field
                                      _buildInputField(
                                        controller: _passwordController,
                                        label: 'Mot de passe',
                                        hint: 'Entrez votre mot de passe',
                                        icon: Icons.lock_outlined,
                                        validator: _validatePassword,
                                        isPassword: true,
                                      ),

                                      // Login button
                                      _buildLoginButton(authProvider),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          // Sign up prompt
                          _buildSignUpPrompt(),

                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
