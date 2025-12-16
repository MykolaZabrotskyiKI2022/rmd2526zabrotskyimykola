import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:rmd2526zabrotskyimykola/di/app_dependencies.dart';
import 'package:rmd2526zabrotskyimykola/domain/entities/app_user.dart';
import 'package:rmd2526zabrotskyimykola/ui/widgets/sensor_card.dart';
import 'package:rmd2526zabrotskyimykola/domain/entities/weather_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppUser? _user;

  final TextEditingController _nameCtrl = TextEditingController();

  bool _isLoading = true;
  bool _mqttConnected = false;

  String _temperature = '--';
  String _humidity = '--';

  String _status = 'MQTT: offline';

  StreamSubscription<String>? _tempSub;
  StreamSubscription<String>? _humSub;
  StreamSubscription<List<ConnectivityResult>>? _connSub;

  Future<WeatherInfo>? _weatherFuture;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _tempSub?.cancel();
    _humSub?.cancel();
    _connSub?.cancel();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    await _loadUser();
    _weatherFuture = weatherRepository.getWeather('lviv');
    await _checkInternetOnStart();
    _watchConnectivity();
    await _setupMqttIfPossible();

    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _loadUser() async {
    final user = await authService.getCurrentUser();
    if (!mounted) return;

    setState(() {
      _user = user;
      _nameCtrl.text = user?.name ?? '';
    });
  }

  Future<void> _checkInternetOnStart() async {
    final ok = await internetService.hasInternet();
    if (!ok) {
      _showMessage('No Internet. MQTT will be unavailable.');
    }
  }

  void _watchConnectivity() {
    _connSub = Connectivity().onConnectivityChanged.listen((results) async {
      if (!mounted) return;

      final noNetwork = results.contains(ConnectivityResult.none);

      if (noNetwork) {
        _showMessage('Network lost. MQTT may stop updating.');
        setState(() {
          _mqttConnected = false;
          _status = 'MQTT: disconnected';
        });
        return;
      }

      final hasInternet = await internetService.hasInternet();
      if (!mounted) return;

      if (!hasInternet) {
        _showMessage('Network is back. But no Internet access.');
        setState(() {
          _mqttConnected = false;
          _status = 'MQTT: disconnected';
        });
        return;
      }

      if (!_mqttConnected) {
        _showMessage('Network is back. Reconnecting MQTT...');
        await _setupMqttIfPossible();
      }
    });
  }

  Future<void> _setupMqttIfPossible() async {
    final ok = await internetService.hasInternet();
    if (!ok) {
      return;
    }

    try {
      await mqttService.connect();

      _tempSub?.cancel();
      _humSub?.cancel();

      _tempSub = mqttService.temperatureStream().listen((value) {
        if (!mounted) return;
        setState(() => _temperature = value.trim());
      });

      _humSub = mqttService.humidityStream().listen((value) {
        if (!mounted) return;
        setState(() => _humidity = value.trim());
      });

      if (!mounted) return;
      setState(() => _mqttConnected = true);
      setState(() => _status = 'MQTT: connected');
    } catch (_) {
      if (!mounted) return;
      print('MQTT: Connection failed');
      setState(() {
        _status = 'MQTT: disconnected';
        _mqttConnected = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    final user = _user;
    if (user == null) {
      _showMessage('No user loaded');
      return;
    }

    final newName = _nameCtrl.text.trim();
    if (newName.isEmpty) {
      _showMessage('Name must not be empty');
      return;
    }

    final updated = user.copyWith(name: newName);
    await authService.updateUser(updated);

    if (!mounted) return;

    setState(() => _user = updated);
    _showMessage('User updated');
  }

  void _goToProfile() {
    Navigator.pushNamed(context, '/profile');
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Log out'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) return;

    await mqttService.disconnect();

    await authService.logout();
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _confirmDeleteUser() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete user'),
          content: const Text(
            'This will remove user data from local storage. Continue?',
          ),
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
        );
      },
    );

    if (shouldDelete != true) return;

    await authService.deleteUser();
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/login');
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
          IconButton(
            onPressed: _goToProfile,
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
          ),
          IconButton(
            onPressed: _confirmLogout,
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _status,
                style: TextStyle(
                  color: _mqttConnected ? Colors.green : Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (user != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Logged in as: ${user.email}'),
              ),
            const SizedBox(height: 16),

            SensorCard(
              title: 'Temperature',
              value: _temperature,
              unit: '°C',
              icon: Icons.thermostat,
            ),
            const SizedBox(height: 12),
            SensorCard(
              title: 'Humidity',
              value: _humidity,
              unit: '%',
              icon: Icons.water_drop,
            ),

            FutureBuilder<WeatherInfo>(
              future: _weatherFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: LinearProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Card(
                    child: ListTile(
                      title: const Text('Weather'),
                      subtitle: Text('Error: ${snapshot.error}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          setState(() {
                            _weatherFuture = weatherRepository.getWeather(
                              'lviv',
                            );
                          });
                        },
                      ),
                    ),
                  );
                }

                final w = snapshot.data!;
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.cloud),
                    title: Text('Weather in ${w.city}'),
                    subtitle: Text(
                      '${w.description} • Humidity ${w.humidity}% • Wind ${w.windSpeed} m/s',
                    ),
                    trailing: Text('${w.temp.toStringAsFixed(1)}°C'),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

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

            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _saveChanges,
                    child: const Text('Save changes'),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _confirmDeleteUser,
                  child: const Text('Delete user'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
