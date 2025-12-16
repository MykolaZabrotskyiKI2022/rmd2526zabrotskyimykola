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
  final _emailCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _nameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() => _loading = true);

    final error = await authService.register(
      email: _emailCtrl.text,
      name: _nameCtrl.text,
      password: _passwordCtrl.text,
    );

    setState(() => _loading = false);

    if (error != null) {
      _show(error);
      return;
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _show(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).size.width > 600 ? 80.0 : 24.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
              text: _loading ? 'Loading...' : 'Register',
              onPressed: _loading ? () {} : _register,
            ),
          ],
        ),
      ),
    );
  }
}
