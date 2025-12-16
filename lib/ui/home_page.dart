import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
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
  double? _temperature;
  double? _humidity;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  late final VoidCallback _temperatureListener;
  late final VoidCallback _humidityListener;

  @override
  void initState() {
    super.initState();
    _temperatureListener = () {
      setState(() => _temperature = mqttService.temperature.value);
    };
    _humidityListener = () {
      setState(() => _humidity = mqttService.humidity.value);
    };
    _loadUser();
    _listenConnectivity();
    _bindMqtt();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showOfflineNotice());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _connectivitySubscription?.cancel();
    mqttService.temperature.removeListener(_temperatureListener);
    mqttService.humidity.removeListener(_humidityListener);
    mqttService.disconnect();
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
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete account'),
            content:
                const Text('Are you sure you want to delete saved credentials?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    await authService.deleteUser();
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Log out'),
            content: const Text('Do you really want to leave the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Stay'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Log out'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    await authService.logout();
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/login');
  }

  void _goToProfile() {
    Navigator.pushNamed(context, '/profile');
  }

  Future<void> _bindMqtt() async {
    mqttService.temperature.addListener(_temperatureListener);
    mqttService.humidity.addListener(_humidityListener);

    final online = await connectivityService.hasConnection();
    if (!online) return;

    await mqttService.connect();
  }

  void _listenConnectivity() {
    _connectivitySubscription = connectivityService.changes.listen((status) {
      if (status == ConnectivityResult.none) {
        _showMessage('Internet connection lost. Live data paused.');
      } else {
        _showMessage('Back online. Reconnecting to MQTT...');
        mqttService.connect();
      }
    });
  }

  void _showOfflineNotice() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['offline'] == true) {
      _showMessage('You are offline. Saved session loaded.');
    }
  }

  String _formatSensorValue(double? value) {
    if (value == null) return '--';
    return value.toStringAsFixed(2);
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
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
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
            SensorCard(
              title: 'Temperature',
              value: _formatSensorValue(_temperature),
              unit: '°C',
              icon: Icons.thermostat,
            ),
            const SizedBox(height: 12),
            SensorCard(
              title: 'Humidity',
              value: _formatSensorValue(_humidity),
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
