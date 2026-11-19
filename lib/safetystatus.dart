
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class SafetyStatusPage extends StatefulWidget {
  const SafetyStatusPage({super.key});

  @override
  State<SafetyStatusPage> createState() => _SafetyStatusPageState();
}

class _SafetyStatusPageState extends State<SafetyStatusPage> {
  final DatabaseReference _myDatabase = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
    'https://laboratory-safety-system-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  String safetyStatus = 'WAITING';
  bool relay = false;
  bool buzzer = false;

  void _readStatus() {
    _myDatabase.child('LaboratorySafetySystem/current').onValue.listen(
          (DatabaseEvent event) {
        final value = event.snapshot.value;

        if (value == null || value is! Map) return;

        final data = Map<String, dynamic>.from(value);

        if (!mounted) return;

        setState(() {
          safetyStatus = data['safetyStatus']?.toString() ?? 'UNKNOWN';
          relay = data['relay'] == true;
          buzzer = data['buzzer'] == true;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _readStatus();
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.hourglass_empty;

    if (safetyStatus == 'SAFE') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (safetyStatus == 'WARNING') {
      statusColor = Colors.orange;
      statusIcon = Icons.warning;
    } else if (safetyStatus == 'DANGER') {
      statusColor = Colors.red;
      statusIcon = Icons.dangerous;
    }

    return Card(
      color: statusColor,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(statusIcon, color: Colors.white, size: 50),

            const SizedBox(height: 10),

            Text(
              'LAB SAFETY: $safetyStatus',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Warning Light: ${relay ? "ON" : "OFF"}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Buzzer: ${buzzer ? "ON" : "OFF"}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
