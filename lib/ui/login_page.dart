// lib/ui/login_page.dart
import 'package:flutter/material.dart';
import 'package:rmd2526zabrotskyimykola/ui/widgets/auth_text_field.dart';
import 'package:rmd2526zabrotskyimykola/ui/widgets/primary_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _goToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _goToRegister(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).size.width > 600 ? 80.0 : 24.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome to IoT Monitor',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 24),
              const AuthTextField(label: 'Email'),
              const SizedBox(height: 12),
              const AuthTextField(label: 'Password', obscureText: true),
              const SizedBox(height: 20),
              PrimaryButton(text: 'Login', onPressed: () => _goToHome(context)),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => _goToRegister(context),
                child: const Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
