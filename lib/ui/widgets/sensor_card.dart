import 'package:flutter/material.dart';

class SensorCard extends StatelessWidget {
  const SensorCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    super.key,
  });

  final String title;
  final String value;
  final String unit;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        trailing: Text(
          '$value$unit',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
