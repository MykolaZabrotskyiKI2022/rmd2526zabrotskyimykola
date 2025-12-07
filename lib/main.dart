import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(title: 'Mock DHT22 Sensor Values'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int temperature = 22;
  int humidity = 45;

  final TextEditingController tempController = TextEditingController();
  final TextEditingController humController = TextEditingController();

  void applyTemp() {
    final value = int.tryParse(tempController.text.trim());

    if (tempController.text == 'default') {
      setState(() => temperature = 0);
      tempController.clear();
      return;
    }
    if (value == null) return;

    if (value < -40 || value > 80) {
      showMessage('Temperature must be between -40 and +80');
      return;
    }

    setState(() => temperature = value);
    tempController.clear();
  }

  Color tempColor() {
    if (temperature < 0) return Colors.blue;
    if (temperature < 25) return Colors.green;
    if (temperature < 40) return Colors.orange;
    return Colors.red;
  }

  void applyHum() {
    final value = int.tryParse(humController.text.trim());

    if (humController.text == 'default') {
      setState(() => humidity = 0);
      humController.clear();
      return;
    }
    if (value == null) return;

    if (value < 0 || value > 100) {
      showMessage('Humidity must be between 0 and 100%');
      return;
    }

    setState(() => humidity = value);
    humController.clear();
  }

  Color humColor() {
    if (humidity < 40) return Colors.blueGrey;
    if (humidity < 80) return Colors.green;
    return Colors.blue;
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Temperature', style: TextStyle(fontSize: 24)),

            Text(
              '$temperature°C',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(color: tempColor()),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: tempController,
              decoration: const InputDecoration(
                labelText: 'Enter temperature (-40 to +80) or \'default\'',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => applyTemp(),
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: applyTemp,
              child: const Text('Set temperature'),
            ),

            const Divider(height: 40, thickness: 1),

            const Text('Humidity', style: TextStyle(fontSize: 24)),
            Text(
              '$humidity%',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(color: humColor()),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: humController,
              decoration: const InputDecoration(
                labelText: 'Enter humidity (0–100%) or \'default\'',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => applyHum(),
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: applyHum,
              child: const Text('Set humidity'),
            ),
          ],
        ),
      ),
    );
  }
}
