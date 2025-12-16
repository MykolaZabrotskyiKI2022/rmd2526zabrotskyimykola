import 'package:flutter/material.dart';
import 'package:rmd2526zabrotskyimykola/di/app_dependencies.dart';
import 'package:rmd2526zabrotskyimykola/ui/widgets/auth_text_field.dart';
import 'package:rmd2526zabrotskyimykola/ui/widgets/primary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    setState(() => _isLoading = true);

    final error = await authService.login(
      email: _emailCtrl.text,
      password: _passwordCtrl.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (error != null) {
      _showMessage(error);
      return;
    }

    Navigator.pushReplacementNamed(context, '/home');
  }

  void _goToRegister() {
    Navigator.pushNamed(context, '/register');
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = width > 600 ? 80.0 : 24.0;

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
              AuthTextField(label: 'Email', controller: _emailCtrl),
              const SizedBox(height: 12),
              AuthTextField(
                label: 'Password',
                controller: _passwordCtrl,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                text: _isLoading ? 'Loading...' : 'Login',
                onPressed: _isLoading ? () {} : _onLoginPressed,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _goToRegister,
                child: const Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
