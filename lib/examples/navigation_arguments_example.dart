// Example: How to get variables from navigation route arguments in Flutter

import 'package:flutter/material.dart';

// Method 1: Using ModalRoute.of(context)!.settings.arguments
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? phoneNumber;
  String? userType;
  Map<String, dynamic>? userData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get arguments passed from previous screen
    final arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments != null) {
      // If arguments is a Map
      if (arguments is Map<String, dynamic>) {
        phoneNumber = arguments['phoneNumber'] as String?;
        userType = arguments['userType'] as String?;
        userData = arguments['userData'] as Map<String, dynamic>?;
      }

      // If arguments is a single value
      if (arguments is String) {
        phoneNumber = arguments;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Screen')),
      body: Column(
        children: [
          if (phoneNumber != null) Text('Phone Number: $phoneNumber'),
          if (userType != null) Text('User Type: $userType'),
          if (userData != null) Text('User Data: ${userData.toString()}'),
        ],
      ),
    );
  }
}

// Method 2: Using a custom arguments class (Recommended)
class LoginArguments {
  final String? phoneNumber;
  final String? userType;
  final Map<String, dynamic>? userData;
  final bool? isFromRegistration;

  LoginArguments({
    this.phoneNumber,
    this.userType,
    this.userData,
    this.isFromRegistration,
  });
}

class LoginScreenWithCustomArgs extends StatefulWidget {
  const LoginScreenWithCustomArgs({super.key});

  @override
  State<LoginScreenWithCustomArgs> createState() =>
      _LoginScreenWithCustomArgsState();
}

class _LoginScreenWithCustomArgsState extends State<LoginScreenWithCustomArgs> {
  LoginArguments? args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the custom arguments
    args = ModalRoute.of(context)!.settings.arguments as LoginArguments?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Screen')),
      body: Column(
        children: [
          if (args?.phoneNumber != null)
            Text('Phone Number: ${args!.phoneNumber}'),
          if (args?.userType != null) Text('User Type: ${args!.userType}'),
          if (args?.isFromRegistration == true)
            Text('Welcome! Please complete your login.'),
        ],
      ),
    );
  }
}

// Method 3: Using constructor parameters (for direct navigation)
class LoginScreenWithConstructor extends StatefulWidget {
  final String? phoneNumber;
  final String? userType;
  final bool isFromRegistration;

  const LoginScreenWithConstructor({
    super.key,
    this.phoneNumber,
    this.userType,
    this.isFromRegistration = false,
  });

  @override
  State<LoginScreenWithConstructor> createState() =>
      _LoginScreenWithConstructorState();
}

class _LoginScreenWithConstructorState
    extends State<LoginScreenWithConstructor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Screen')),
      body: Column(
        children: [
          if (widget.phoneNumber != null)
            Text('Phone Number: ${widget.phoneNumber}'),
          if (widget.userType != null) Text('User Type: ${widget.userType}'),
          if (widget.isFromRegistration)
            Text('Welcome! Please complete your login.'),
        ],
      ),
    );
  }
}

// Example of how to navigate TO these screens:

class ExampleNavigationUsage {
  // Method 1: Navigate with Map arguments
  void navigateToLoginWithMap(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/login',
      arguments: {
        'phoneNumber': '+1234567890',
        'userType': 'premium',
        'userData': {'name': 'John Doe', 'email': 'john@example.com'},
      },
    );
  }

  // Method 2: Navigate with custom arguments class
  void navigateToLoginWithCustomArgs(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/login',
      arguments: LoginArguments(
        phoneNumber: '+1234567890',
        userType: 'premium',
        isFromRegistration: true,
        userData: {'name': 'John Doe', 'email': 'john@example.com'},
      ),
    );
  }

  // Method 3: Navigate with constructor parameters
  void navigateToLoginWithConstructor(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => LoginScreenWithConstructor(
              phoneNumber: '+1234567890',
              userType: 'premium',
              isFromRegistration: true,
            ),
      ),
    );
  }

  // Method 4: Navigate with simple string argument
  void navigateToLoginWithString(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/login',
      arguments: '+1234567890', // Simple string
    );
  }
}

// Method 4: Using a helper function to safely extract arguments
class NavigationHelper {
  static T? getArgument<T>(BuildContext context, [String? key]) {
    final arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments == null) return null;

    // If T is the same type as arguments, return directly
    if (arguments is T) return arguments as T;

    // If arguments is a Map and we have a key
    if (arguments is Map<String, dynamic> && key != null) {
      return arguments[key] as T?;
    }

    return null;
  }

  static Map<String, dynamic>? getArgumentsAsMap(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    return arguments is Map<String, dynamic> ? arguments : null;
  }
}

// Usage of the helper:
class LoginScreenWithHelper extends StatefulWidget {
  @override
  State<LoginScreenWithHelper> createState() => _LoginScreenWithHelperState();
}

class _LoginScreenWithHelperState extends State<LoginScreenWithHelper> {
  @override
  Widget build(BuildContext context) {
    // Using the helper function
    final phoneNumber = NavigationHelper.getArgument<String>(
      context,
      'phoneNumber',
    );
    final userType = NavigationHelper.getArgument<String>(context, 'userType');
    final arguments = NavigationHelper.getArgumentsAsMap(context);

    return Scaffold(
      body: Column(
        children: [
          if (phoneNumber != null) Text('Phone: $phoneNumber'),
          if (userType != null) Text('Type: $userType'),
          if (arguments != null) Text('All args: ${arguments.toString()}'),
        ],
      ),
    );
  }
}
