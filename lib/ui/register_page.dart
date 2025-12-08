import 'package:flutter/material.dart';
import 'package:rmd2526zabrotskyimykola/di/app_dependencies.dart';
import 'package:rmd2526zabrotskyimykola/ui/widgets/auth_text_field.dart';
import 'package:rmd2526zabrotskyimykola/ui/widgets/primary_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _nameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onRegisterPressed() async {
    setState(() => _isLoading = true);

    final error = await authService.register(
      email: _emailCtrl.text,
      name: _nameCtrl.text,
      password: _passwordCtrl.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (error != null) {
      _showMessage(error);
      return;
    }

    _showMessage('Registration successful');
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _goBackToLogin() {
    Navigator.pop(context);
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = width > 600 ? 80.0 : 24.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create IoT account',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 24),
              AuthTextField(label: 'Email', controller: _emailCtrl),
              const SizedBox(height: 12),
              AuthTextField(label: 'Name', controller: _nameCtrl),
              const SizedBox(height: 12),
              AuthTextField(
                label: 'Password',
                controller: _passwordCtrl,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                text: _isLoading ? 'Loading...' : 'Sign up',
                onPressed: _isLoading ? () {} : _onRegisterPressed,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _goBackToLogin,
                child: const Text('Back to login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
