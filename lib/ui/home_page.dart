import 'package:flutter/material.dart';
import 'package:rmd2526zabrotskyimykola/di/app_dependencies.dart';
import 'package:rmd2526zabrotskyimykola/domain/entities/app_user.dart';
import 'package:rmd2526zabrotskyimykola/ui/widgets/sensor_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppUser? _user;
  final TextEditingController _nameCtrl = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final user = await authService.getCurrentUser();
    if (!mounted) return;

    setState(() {
      _user = user;
      _nameCtrl.text = user?.name ?? '';
      _isLoading = false;
    });
  }

  Future<void> _saveChanges() async {
    final user = _user;
    if (user == null) {
      _showMessage('No user loaded');
      return;
    }

    final updated = user.copyWith(name: _nameCtrl.text.trim());
    await authService.updateUser(updated);

    setState(() => _user = updated);
    _showMessage('User updated');
  }

  Future<void> _deleteUser() async {
    await authService.deleteUser();
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/login');
  }

  void _goToProfile() {
    Navigator.pushNamed(context, '/profile');
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = _user;

    return Scaffold(
      appBar: AppBar(
        title: Text(user?.email ?? 'IoT Dashboard'),
        actions: [
          IconButton(onPressed: _goToProfile, icon: const Icon(Icons.person)),
          IconButton(onPressed: _deleteUser, icon: const Icon(Icons.delete)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (user != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Logged in as: ${user.email}'),
              ),
            const SizedBox(height: 16),
            const SensorCard(
              title: 'Temperature',
              value: '22',
              unit: '°C',
              icon: Icons.thermostat,
            ),
            const SizedBox(height: 12),
            const SensorCard(
              title: 'Humidity',
              value: '45',
              unit: '%',
              icon: Icons.water_drop,
            ),
            const Divider(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Edit display name:', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
