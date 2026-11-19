
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class SensorValuePage extends StatefulWidget {
  const SensorValuePage({super.key});

  @override
  State<SensorValuePage> createState() => _SensorValuePageState();
}

class _SensorValuePageState extends State<SensorValuePage> {
  final DatabaseReference _myDatabase = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
    'https://laboratory-safety-system-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  String temperature = '--';
  String humidity = '--';
  String gasValue = '--';
  String safetyStatus = 'WAITING';

  bool relay = false;
  bool buzzer = false;

  void _readSensor() {
    _myDatabase.child('LaboratorySafetySystem/current').onValue.listen(
          (DatabaseEvent event) {
        final sensorFirebase = event.snapshot.value;

        if (sensorFirebase == null || sensorFirebase is! Map) {
          return;
        }

        final data = Map<String, dynamic>.from(sensorFirebase);

        if (!mounted) return;

        setState(() {
          temperature = data['temperature']?.toString() ?? '--';
          humidity = data['humidity']?.toString() ?? '--';
          gasValue = data['gas']?.toString() ?? '--';

          safetyStatus =
              data['safetyStatus']?.toString() ?? 'UNKNOWN';

          relay = data['relay'] == true;
          buzzer = data['buzzer'] == true;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _readSensor();
  }

  Widget _sensorCard(
      String title,
      String value,
      String unit,
      IconData icon,
      Color color,
      ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(title, style: const TextStyle(fontSize: 18)),
              Text(
                '$value $unit',
                style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      ],
    ),
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Reading'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),

          const Text(
            'Real-Time Sensor Monitoring',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          _sensorCard(
            'Temperature',
            temperature,
            '°C',
            Icons.thermostat,
            Colors.red,
          ),

          _sensorCard(
            'Humidity',
            humidity,
            '%',
            Icons.water_drop,
            Colors.blue,
          ),

          _sensorCard(
            'Gas Level',
            gasValue,
            'ADC',
            Icons.air,
            Colors.orange,
          ),

          const SizedBox(height: 20),

          Card(
            color: safetyStatus == 'SAFE'
                ? Colors.green
                : safetyStatus == 'WARNING'
                ? Colors.orange
                : safetyStatus == 'DANGER'
                ? Colors.red
                : Colors.grey,
            child: ListTile(
              leading: const Icon(
                Icons.health_and_safety,
                color: Colors.white,
              ),
              title: const Text(
                'Safety Status',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                safetyStatus,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(
                relay ? Icons.lightbulb : Icons.lightbulb_outline,
                color: relay ? Colors.orange : Colors.grey,
              ),
              title: const Text('Warning Light'),
              trailing: Text(relay ? 'ON' : 'OFF'),
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(
                Icons.notifications_active,
                color: buzzer ? Colors.red : Colors.grey,
              ),
              title: const Text('Buzzer'),
              trailing: Text(buzzer ? 'ON' : 'OFF'),
            ),
          ),
        ],
      ),
    );
  }
}
