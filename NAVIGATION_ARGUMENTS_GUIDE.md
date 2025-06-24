# 🚀 Flutter Navigation Route Arguments Guide

## Overview

This guide shows you different ways to pass and receive variables through navigation route arguments in Flutter.

## Methods to Get Route Arguments

### Method 1: Using ModalRoute.of(context)!.settings.arguments

```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();

  final arguments = ModalRoute.of(context)!.settings.arguments;

  if (arguments != null) {
    // Handle different argument types
    if (arguments is Map<String, dynamic>) {
      String? phoneNumber = arguments['phoneNumber'];
      bool isFromRegistration = arguments['isFromRegistration'] ?? false;
    } else if (arguments is String) {
      String phoneNumber = arguments;
    }
  }
}
```

### Method 2: Using Custom Arguments Class (Recommended)

```dart
// Define arguments class
class LoginArguments {
  final String? phoneNumber;
  final bool isFromRegistration;
  final String? successMessage;

  LoginArguments({
    this.phoneNumber,
    this.isFromRegistration = false,
    this.successMessage,
  });
}

// In your screen
@override
void didChangeDependencies() {
  super.didChangeDependencies();

  final args = ModalRoute.of(context)!.settings.arguments as LoginArguments?;

  if (args != null) {
    // Use args.phoneNumber, args.isFromRegistration, etc.
  }
}
```

### Method 3: Using Constructor Parameters

```dart
class LoginScreen extends StatefulWidget {
  final String? phoneNumber;
  final bool isFromRegistration;

  const LoginScreen({
    super.key,
    this.phoneNumber,
    this.isFromRegistration = false,
  });

  // In build method, use widget.phoneNumber, widget.isFromRegistration
}
```

## How to Navigate WITH Arguments

### 1. Map Arguments

```dart
Navigator.pushNamed(
  context,
  '/login',
  arguments: {
    'phoneNumber': '+1234567890',
    'isFromRegistration': true,
    'successMessage': 'Registration successful!',
  },
);
```

### 2. Custom Class Arguments

```dart
Navigator.pushNamed(
  context,
  '/login',
  arguments: LoginArguments(
    phoneNumber: '+1234567890',
    isFromRegistration: true,
    successMessage: 'Welcome!',
  ),
);
```

### 3. Simple String Argument

```dart
Navigator.pushNamed(
  context,
  '/login',
  arguments: '+1234567890', // Just a phone number
);
```

### 4. Constructor Parameters (MaterialPageRoute)

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => LoginScreen(
      phoneNumber: '+1234567890',
      isFromRegistration: true,
    ),
  ),
);
```

## Real-World Examples for Your App

### From Registration Screen to Login

```dart
// After successful registration
Navigator.pushReplacementNamed(
  context,
  '/login',
  arguments: {
    'phoneNumber': registeredPhoneNumber,
    'isFromRegistration': true,
    'successMessage': 'Registration successful! Please login.',
  },
);
```

### From Forgot Password to Login

```dart
// After password reset
Navigator.pushReplacementNamed(
  context,
  '/login',
  arguments: {
    'phoneNumber': userPhoneNumber,
    'successMessage': 'Password reset successful! Please login with your new password.',
  },
);
```

### From Profile Screen to Login (Logout)

```dart
Navigator.pushNamedAndRemoveUntil(
  context,
  '/login',
  (route) => false, // Remove all previous routes
  arguments: {
    'successMessage': 'You have been logged out successfully.',
  },
);
```

## Updated Login Screen Implementation

Here's how your login screen can handle these arguments:

```dart
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Variables to store route arguments
  String? prefilledPhoneNumber;
  bool isFromRegistration = false;
  String? successMessage;
  String? userType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments != null) {
      if (arguments is Map<String, dynamic>) {
        prefilledPhoneNumber = arguments['phoneNumber'] as String?;
        isFromRegistration = arguments['isFromRegistration'] as bool? ?? false;
        successMessage = arguments['successMessage'] as String?;
        userType = arguments['userType'] as String?;
      } else if (arguments is String) {
        prefilledPhoneNumber = arguments;
      }

      // Pre-fill phone number
      if (prefilledPhoneNumber != null && _phoneController.text.isEmpty) {
        _phoneController.text = prefilledPhoneNumber!;
      }

      // Show success message
      if (successMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(successMessage!),
              backgroundColor: Colors.green,
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Dynamic title based on arguments
          Text(
            isFromRegistration
                ? 'Complete Your Login'
                : 'Login to Your Account',
          ),

          // Show user type if provided
          if (userType != null)
            Text('User Type: $userType'),

          // Pre-filled phone field
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
            ),
          ),

          // Rest of your login form...
        ],
      ),
    );
  }
}
```

## Helper Function for Safe Argument Extraction

```dart
class NavigationHelper {
  static T? getArgument<T>(BuildContext context, String key) {
    final arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments is Map<String, dynamic>) {
      return arguments[key] as T?;
    }

    return null;
  }

  static Map<String, dynamic>? getAllArguments(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    return arguments is Map<String, dynamic> ? arguments : null;
  }
}

// Usage:
final phoneNumber = NavigationHelper.getArgument<String>(context, 'phoneNumber');
final isFromReg = NavigationHelper.getArgument<bool>(context, 'isFromRegistration') ?? false;
```

## Best Practices

1. **Use Custom Classes** for complex arguments (type safety)
2. **Use Maps** for simple key-value pairs
3. **Handle null cases** gracefully
4. **Pre-fill form fields** when arguments provide data
5. **Show messages** immediately using `addPostFrameCallback`
6. **Use meaningful argument names** for clarity

## Common Navigation Patterns

### Replace Current Screen

```dart
Navigator.pushReplacementNamed(context, '/login', arguments: {...});
```

### Clear All Previous Screens

```dart
Navigator.pushNamedAndRemoveUntil(
  context,
  '/login',
  (route) => false,
  arguments: {...},
);
```

### Go Back with Arguments

```dart
Navigator.pop(context, {'result': 'success', 'data': userData});
```

### Listen for Return Arguments

```dart
final result = await Navigator.pushNamed(context, '/login', arguments: {...});
if (result != null) {
  // Handle returned data
}
```

This comprehensive approach gives you flexible, type-safe navigation with arguments throughout your Flutter app! 🚀
