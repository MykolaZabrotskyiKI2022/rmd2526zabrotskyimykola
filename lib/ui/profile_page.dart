// lib/ui/profile_page.dart
import 'package:flutter/material.dart';
import 'package:rmd2526zabrotskyimykola/di/app_dependencies.dart';
import 'package:rmd2526zabrotskyimykola/domain/entities/app_user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AppUser? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await authService.getCurrentUser();

    if (!mounted) return;

    setState(() {
      _user = user;
      _loading = false;
    });
  }

  void _goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    final horizontal = isWide ? 120.0 : 24.0;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = _user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          onPressed: () => _goBack(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 16),

            Text(
              user?.name ?? 'Unknown user',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 8),

            Text('Email: ${user?.email ?? '-'}'),
            const SizedBox(height: 8),

            // Static "role"
            const Text('DHT role: Room monitor user'),

            const SizedBox(height: 24),

            const Divider(),

            const SizedBox(height: 12),

            FilledButton(
              onPressed: () {
                Navigator.pop(context, '/home');
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
