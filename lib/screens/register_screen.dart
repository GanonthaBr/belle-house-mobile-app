import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:mobile_app/widgets/phone_input_field.dart';
import 'package:mobile_app/widgets/text_field_input.dart';
import 'package:mobile_app/widgets/title_text.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late AnimationController _fadeController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 60.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Start animations with slight delay
    Future.delayed(Duration(milliseconds: 200), () {
      _fadeController.forward();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
        duration: Duration(seconds: 3),
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

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      _showErrorSnackbar('Veuillez accepter les termes et conditions');
      return;
    }

    // Add haptic feedback
    HapticFeedback.lightImpact();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final phoneNumber = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      _showErrorSnackbar('Les mots de passe ne correspondent pas');
      return;
    }

    final result = await authProvider.register(
      phoneNumber: phoneNumber,
      password: password,
      username: username,
    );

    if (result['success']) {
      if (mounted) {
        _showSuccessSnackbar('Votre compte a été créé avec succès');
        // Add delay for better UX
        await Future.delayed(Duration(milliseconds: 1000));
        Navigator.pushNamed(
          context,
          '/login',
          arguments: {
            'phone_number': phoneNumber,
            'isFromRegistration': true,
            'successMessage': 'Inscription réussie! Connectez-vous maintenant.',
          },
        );
      }
    } else {
      if (mounted) {
        _showErrorSnackbar(
          result['message'] ?? 'Erreur lors de la création de votre compte',
        );
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

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre nom d\'utilisateur';
    }
    if (value.length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    if (value.length > 30) {
      return 'Le nom ne peut pas dépasser 30 caractères';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un mot de passe';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
      return 'Le mot de passe doit contenir des lettres et des chiffres';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    }
    if (value != _passwordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.secondaryColor,
            AppColors.secondaryColor.withOpacity(0.9),
            AppColors.primaryColor.withOpacity(0.15),
          ],
          stops: [0.0, 0.6, 1.0],
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
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.25),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'images/logo.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Title with improved typography
                TitleText(
                  text: 'Rejoignez-nous !',
                  fontSize: AppDimension.fontSize24 + 2,
                  color: AppColors.primaryColor,
                ),
                SizedBox(height: 8),
                Text(
                  'Créez votre compte en quelques étapes',
                  style: TextStyle(
                    fontSize: AppDimension.radius8 * 2,
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
    bool isConfirmPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    bool isPasswordField = isPassword || isConfirmPassword;
    bool isVisible =
        isConfirmPassword ? _isConfirmPasswordVisible : _isPasswordVisible;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        obscureText: isPasswordField && !isVisible,
        style: TextStyle(
          fontSize: AppDimension.radius8 * 2,
          color: Colors.grey[800],
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.primaryColor),
          suffixIcon:
              isPasswordField
                  ? IconButton(
                    icon: Icon(
                      isVisible ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isConfirmPassword) {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        } else {
                          _isPasswordVisible = !_isPasswordVisible;
                        }
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
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: AppDimension.radius14,
          ),
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: AppDimension.radius14,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          errorStyle: TextStyle(fontSize: 12, color: Colors.red[600]),
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    String password = _passwordController.text;
    int strength = 0;
    List<String> requirements = [];

    if (password.length >= 6) {
      strength++;
    } else {
      requirements.add('Au moins 6 caractères');
    }

    if (RegExp(r'[A-Z]').hasMatch(password)) {
      strength++;
    } else {
      requirements.add('Une majuscule');
    }

    if (RegExp(r'[0-9]').hasMatch(password)) {
      strength++;
    } else {
      requirements.add('Un chiffre');
    }

    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      strength++;
    } else {
      requirements.add('Un caractère spécial');
    }

    Color getStrengthColor() {
      if (strength <= 1) return Colors.red;
      if (strength <= 2) return Colors.orange;
      if (strength <= 3) return Colors.yellow[700]!;
      return Colors.green;
    }

    String getStrengthText() {
      if (strength <= 1) return 'Faible';
      if (strength <= 2) return 'Moyen';
      if (strength <= 3) return 'Bon';
      return 'Excellent';
    }

    if (password.isEmpty) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Force du mot de passe: ',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                getStrengthText(),
                style: TextStyle(
                  fontSize: 12,
                  color: getStrengthColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: strength / 4,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(getStrengthColor()),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: _acceptTerms,
            onChanged: (value) {
              setState(() {
                _acceptTerms = value ?? false;
              });
            },
            activeColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _acceptTerms = !_acceptTerms;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(top: 12),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    children: [
                      TextSpan(text: 'J\'accepte les '),
                      TextSpan(
                        text: 'termes et conditions',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(text: ' et la '),
                      TextSpan(
                        text: 'politique de confidentialité',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(AuthProvider authProvider) {
    return Container(
      width: double.infinity,
      height: 56,
      margin: EdgeInsets.symmetric(vertical: 20),
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
                onPressed: _register,
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
                  'S\'inscrire',
                  style: TextStyle(
                    fontSize: AppDimension.fontSize18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
    );
  }

  Widget _buildLoginPrompt() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Déjà un compte? ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: AppDimension.radius14,
            ),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, '/login');
            },
            child: Text(
              'Se connecter',
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
                    height:
                        AppDimension.screenHeight -
                        MediaQuery.of(context).padding.top,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 20),

                          // Header section
                          _buildHeader(),

                          SizedBox(height: 32),

                          // Input fields with animation
                          AnimatedBuilder(
                            animation: _slideAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _slideAnimation.value * 0.3),
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
                                        keyboardType: TextInputType.phone,
                                      ),

                                      // Username field
                                      _buildInputField(
                                        controller: _usernameController,
                                        label: 'Nom d\'utilisateur',
                                        hint: 'Entrez votre prénom',
                                        icon: Icons.person_outlined,
                                        validator: _validateUsername,
                                      ),

                                      // Password field
                                      _buildInputField(
                                        controller: _passwordController,
                                        label: 'Mot de passe',
                                        hint: 'Créez un mot de passe sécurisé',
                                        icon: Icons.lock_outlined,
                                        validator: _validatePassword,
                                        isPassword: true,
                                      ),

                                      // Password strength indicator
                                      _buildPasswordStrengthIndicator(),

                                      // Confirm password field
                                      _buildInputField(
                                        controller: _confirmPasswordController,
                                        label: 'Confirmer le mot de passe',
                                        hint: 'Répétez votre mot de passe',
                                        icon: Icons.lock_outline,
                                        validator: _validateConfirmPassword,
                                        isConfirmPassword: true,
                                      ),

                                      // Terms and conditions
                                      _buildTermsCheckbox(),

                                      // Register button
                                      _buildRegisterButton(authProvider),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          // Login prompt
                          _buildLoginPrompt(),

                          SizedBox(height: 20),
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
