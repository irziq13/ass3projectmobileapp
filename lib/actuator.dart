
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class ActuatorPage extends StatefulWidget {
  const ActuatorPage({super.key});

  @override
  State<ActuatorPage> createState() => _ActuatorPageState();
}

class _ActuatorPageState extends State<ActuatorPage> {
  final DatabaseReference _myDatabase = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
    'https://laboratory-safety-system-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  bool manualMode = false;
  bool warningLight = false;
  bool buzzer = false;

  void _readActuatorStatus() {
    _myDatabase.child('LaboratorySafetySystem/control').onValue.listen(
          (DatabaseEvent event) {
        final value = event.snapshot.value;

        if (value == null || value is! Map) return;

        final data = Map<String, dynamic>.from(value);

        if (!mounted) return;

        setState(() {
          manualMode = data['manualMode'] == true;
          warningLight = data['relayManual'] == true;
          buzzer = data['buzzerManual'] == true;
        });
      },
    );
  }

  void _updateManualMode(bool value) {
    _myDatabase
        .child('LaboratorySafetySystem/control/manualMode')
        .set(value);
  }

  void _updateWarningLight(bool value) {
    _myDatabase
        .child('LaboratorySafetySystem/control/relayManual')
        .set(value);
  }

  void _updateBuzzer(bool value) {
    _myDatabase
        .child('LaboratorySafetySystem/control/buzzerManual')
        .set(value);
  }

  @override
  void initState() {
    super.initState();
    _readActuatorStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warning Light & Buzzer'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              title: const Text('Manual Control Mode'),
              subtitle: Text(
                manualMode
                    ? 'Manual Mode Enabled'
                    : 'Automatic Mode Enabled',
              ),
              value: manualMode,
              onChanged: _updateManualMode,
            ),
          ),

          const SizedBox(height: 15),

          Card(
            child: SwitchListTile(
              secondary: Icon(
                Icons.warning_amber,
                color: warningLight ? Colors.orange : Colors.grey,
                size: 35,
              ),
              title: const Text('Warning Light'),
              subtitle: Text(warningLight ? 'ON' : 'OFF'),
              value: warningLight,
              onChanged: manualMode ? _updateWarningLight : null,
            ),
          ),

          Card(
            child: SwitchListTile(
              secondary: Icon(
                Icons.notifications_active,
                color: buzzer ? Colors.red : Colors.grey,
                size: 35,
              ),
              title: const Text('Buzzer'),
              subtitle: Text(buzzer ? 'ON' : 'OFF'),
              value: buzzer,
              onChanged: manualMode ? _updateBuzzer : null,
            ),
          ),

          const SizedBox(height: 20),

          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Automatic safety mode activates the warning light and buzzer '
                    'when dangerous temperature or gas conditions are detected. '
                    'Manual controls are available only when Manual Mode is enabled. '
                    'Danger detection should always override manual settings.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
