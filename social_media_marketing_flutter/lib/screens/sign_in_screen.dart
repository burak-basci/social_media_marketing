import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import '../services/serverpod_client.dart';

/// Example sign-in screen using Serverpod IDP authentication
/// Note: This is not currently used in the app. The app uses custom authentication
/// via the login screen in features/auth/login_screen.dart
class SignInScreen extends StatefulWidget {
  final Widget child;
  const SignInScreen({super.key, required this.child});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    final client = ServerpodClientManager.instance.client;

    // This example uses the IDP auth widget
    // For the actual app, see features/auth/login_screen.dart
    return Center(
      child: SignInWidget(
        client: client,
        onAuthenticated: () {},
      ),
    );
  }
}
