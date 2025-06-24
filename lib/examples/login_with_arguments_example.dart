// Practical example for your login screen
// This shows how to modify your existing login screen to receive arguments

import 'package:flutter/material.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:mobile_app/widgets/button_text.dart';
import 'package:mobile_app/widgets/text_field_input.dart';
import 'package:mobile_app/widgets/title_text.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

// Arguments class for login screen
class LoginScreenArguments {
  final String? prefilledPhoneNumber;
  final String? userType;
  final bool isFromRegistration;
  final Map<String, dynamic>? userData;
  final String? successMessage;

  LoginScreenArguments({
    this.prefilledPhoneNumber,
    this.userType,
    this.isFromRegistration = false,
    this.userData,
    this.successMessage,
  });
}

class LoginScreenWithArguments extends StatefulWidget {
  const LoginScreenWithArguments({super.key});

  @override
  State<LoginScreenWithArguments> createState() =>
      _LoginScreenWithArgumentsState();
}

class _LoginScreenWithArgumentsState extends State<LoginScreenWithArguments> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  LoginScreenArguments? args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the arguments passed from navigation
    final routeArgs = ModalRoute.of(context)!.settings.arguments;

    if (routeArgs != null) {
      if (routeArgs is LoginScreenArguments) {
        args = routeArgs;
      } else if (routeArgs is Map<String, dynamic>) {
        // Handle Map arguments
        args = LoginScreenArguments(
          prefilledPhoneNumber: routeArgs['phoneNumber'] as String?,
          userType: routeArgs['userType'] as String?,
          isFromRegistration: routeArgs['isFromRegistration'] as bool? ?? false,
          userData: routeArgs['userData'] as Map<String, dynamic>?,
          successMessage: routeArgs['successMessage'] as String?,
        );
      } else if (routeArgs is String) {
        // Handle simple string argument (phone number)
        args = LoginScreenArguments(prefilledPhoneNumber: routeArgs);
      }

      // Pre-fill phone number if provided
      if (args?.prefilledPhoneNumber != null) {
        _phoneController.text = args!.prefilledPhoneNumber!;
      }

      // Show success message if provided
      if (args?.successMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(args!.successMessage!),
              backgroundColor: Colors.green,
            ),
          );
        });
      }
    }
  }

  void _login() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final phoneNumber = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    // Authentication logic
    final result = await authProvider.login(
      password: password,
      phoneNumber: phoneNumber,
    );

    if (result['success']) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Connecté avec succès')));
        Navigator.pushReplacementNamed(context, '/main');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Erreur de connection')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppDimension.init(context);

    return Scaffold(
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Container(
              height: AppDimension.screenHeight,
              width: AppDimension.screenWidth,
              color: AppColors.secondaryColor,
              child: Padding(
                padding: EdgeInsets.only(top: AppDimension.distance50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Show different title based on arguments
                    TitleText(
                      text:
                          args?.isFromRegistration == true
                              ? 'Finaliser votre connexion'
                              : 'Connecter à votre compte',
                      fontSize: AppDimension.fontSize24,
                      color: AppColors.primaryColor,
                    ),
                    // Show user type if provided
                    if (args?.userType != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Type: ${args!.userType}',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: AppDimension.fontSize18,
                          ),
                        ),
                      ),

                    // Logo
                    Expanded(
                      flex: 2,
                      child: Image.asset('images/logo.png', width: 300),
                    ),

                    // Phone field
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimension.radius14,
                        vertical: 0.0,
                      ),
                      child: SizedBox(
                        height: AppDimension.screenHeight * 0.08,
                        child: InputTextField(
                          controller: _phoneController,
                          fillBg: true,
                          hintText: 'Numéro de téléphone',
                          fillcolor: AppColors.primaryColor,
                          focuscolor: AppColors.primaryColor,
                          bordercolor: AppColors.primaryColor,
                          labelText: "Numéro de téléphone",
                          fontsize: AppDimension.fontSize18,
                          borderRadius: AppDimension.radius14,
                          labelColor: AppColors.secondaryColor,
                          passwordField: false,
                        ),
                      ),
                    ),

                    // Password field
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimension.radius14,
                        vertical: 0.0,
                      ),
                      child: SizedBox(
                        height: AppDimension.screenHeight * 0.08,
                        child: InputTextField(
                          controller: _passwordController,
                          fillBg: true,
                          hintText: 'Mot de passe',
                          fillcolor: AppColors.primaryColor,
                          focuscolor: AppColors.primaryColor,
                          bordercolor: AppColors.primaryColor,
                          labelText: "Mot de passe",
                          fontsize: AppDimension.fontSize18,
                          borderRadius: AppDimension.radius14,
                          labelColor: AppColors.secondaryColor,
                          passwordField: true,
                        ),
                      ),
                    ),

                    // Login Button
                    authProvider.isLoading
                        ? CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        )
                        : TextButtonWidget(
                          text:
                              args?.isFromRegistration == true
                                  ? 'Finaliser la connexion'
                                  : 'Se connecter',
                          height: AppDimension.distance50,
                          fontSize: AppDimension.fontSize18,
                          bgcolor: AppColors.primaryColor,
                          borderRadius: AppDimension.radius14,
                          textcolor: AppColors.secondaryColor,
                          onPressed: _login,
                        ),

                    // CTA - Hide if coming from registration
                    if (args?.isFromRegistration != true)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Pas encore de compte?'),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/register',
                                );
                              },
                              child: Text(
                                "S'incrire",
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Example of how to navigate to this login screen from other screens:
class NavigationExamples {
  // From registration screen after successful registration
  static void navigateFromRegistration(
    BuildContext context,
    String phoneNumber,
  ) {
    Navigator.pushReplacementNamed(
      context,
      '/login',
      arguments: LoginScreenArguments(
        prefilledPhoneNumber: phoneNumber,
        isFromRegistration: true,
        successMessage: 'Inscription réussie! Veuillez vous connecter.',
      ),
    );
  }

  // From home screen with user type
  static void navigateWithUserType(BuildContext context, String userType) {
    Navigator.pushNamed(
      context,
      '/login',
      arguments: LoginScreenArguments(userType: userType),
    );
  }

  // From forgot password screen
  static void navigateFromForgotPassword(
    BuildContext context,
    String phoneNumber,
  ) {
    Navigator.pushReplacementNamed(
      context,
      '/login',
      arguments: LoginScreenArguments(
        prefilledPhoneNumber: phoneNumber,
        successMessage:
            'Mot de passe réinitialisé. Connectez-vous avec votre nouveau mot de passe.',
      ),
    );
  }

  // Simple navigation with just phone number
  static void navigateWithPhoneNumber(
    BuildContext context,
    String phoneNumber,
  ) {
    Navigator.pushNamed(
      context,
      '/login',
      arguments: phoneNumber, // Simple string argument
    );
  }

  // Using Map arguments (alternative approach)
  static void navigateWithMapArguments(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/login',
      arguments: {
        'phoneNumber': '+1234567890',
        'userType': 'premium',
        'isFromRegistration': true,
        'successMessage': 'Welcome!',
        'userData': {'name': 'John Doe', 'email': 'john@example.com'},
      },
    );
  }
}
