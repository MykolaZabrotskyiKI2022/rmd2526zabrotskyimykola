import 'package:flutter/material.dart';
import 'package:rmd2526zabrotskyimykola/di/app_dependencies.dart';
import 'package:rmd2526zabrotskyimykola/ui/home_page.dart';
import 'package:rmd2526zabrotskyimykola/ui/login_page.dart';
import 'package:rmd2526zabrotskyimykola/ui/profile_page.dart';
import 'package:rmd2526zabrotskyimykola/ui/register_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  Future<Widget> _resolveStartPage() async {
    final canAutoLogin = await authService.canAutoLogin();
    return canAutoLogin ? const HomePage() : const LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/home': (_) => const HomePage(),
        '/profile': (_) => const ProfilePage(),
      },
      home: FutureBuilder<Widget>(
        future: _resolveStartPage(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data!;
        },
      ),
    );
  }
}
