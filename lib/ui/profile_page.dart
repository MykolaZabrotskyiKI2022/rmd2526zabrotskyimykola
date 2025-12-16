import 'package:flutter/material.dart';
import 'package:rmd2526zabrotskyimykola/di/app_dependencies.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    final padding = isWide ? 120.0 : 24.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: FutureBuilder(
          future: authService.getCurrentUser(),
          builder: (context, snapshot) {
            final user = snapshot.data;
            if (user == null) {
              return const Center(child: Text('No user'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 16),
                Text(user.name, style: const TextStyle(fontSize: 22)),
                Text('Email: ${user.email}'),
              ],
            );
          },
        ),
      ),
    );
  }
}
