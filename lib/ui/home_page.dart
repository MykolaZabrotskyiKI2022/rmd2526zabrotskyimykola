// lib/ui/home_page.dart
import 'package:flutter/material.dart';
import 'package:rmd2526zabrotskyimykola/ui/widgets/sensor_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _goToProfile(BuildContext context) {
    Navigator.pushNamed(context, '/profile');
  }

  void _goToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    final cards = [
      const SensorCard(
        title: 'Temperature',
        value: '22',
        unit: '°C',
        icon: Icons.thermostat,
      ),
      const SensorCard(
        title: 'Humidity',
        value: '45',
        unit: '%',
        icon: Icons.water_drop,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('IoT Dashboard'),
        actions: [
          IconButton(
            onPressed: () => _goToProfile(context),
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () => _goToLogin(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: cards[0]),
                  const SizedBox(width: 16),
                  Expanded(child: cards[1]),
                ],
              )
            : Column(
                children: [cards[0], const SizedBox(height: 16), cards[1]],
              ),
      ),
    );
  }
}
