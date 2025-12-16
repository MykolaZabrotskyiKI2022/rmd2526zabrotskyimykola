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
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final hasInternet = await internetService.hasInternet();
    if (!hasInternet) {
      _show('No Internet connection');
      return;
    }

    setState(() => _loading = true);

    final error = await authService.login(
      email: _emailCtrl.text,
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
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AuthTextField(label: 'Email', controller: _emailCtrl),
            const SizedBox(height: 12),
            AuthTextField(
              label: 'Password',
              controller: _passwordCtrl,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: _loading ? 'Loading...' : 'Login',
              onPressed: _loading ? () {} : _login,
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Create account'),
            ),
          ],
        ),
      ),
    );
  }
}
