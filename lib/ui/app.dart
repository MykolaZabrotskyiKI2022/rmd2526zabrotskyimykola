// lib/ui/app.dart
import 'package:flutter/material.dart';
import 'package:rmd2526zabrotskyimykola/ui/home_page.dart';
import 'package:rmd2526zabrotskyimykola/ui/login_page.dart';
import 'package:rmd2526zabrotskyimykola/ui/profile_page.dart';
import 'package:rmd2526zabrotskyimykola/ui/register_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Lab 2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/home': (_) => const HomePage(),
        '/profile': (_) => const ProfilePage(),
      },
    );
  }
}
