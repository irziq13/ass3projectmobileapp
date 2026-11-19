import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:laboratory_safety_system/loginpage.dart';
import 'package:laboratory_safety_system/sensorvalue.dart';
import 'package:laboratory_safety_system/actuator.dart';
import 'package:laboratory_safety_system/history.dart';
import 'package:laboratory_safety_system/settings.dart';
import 'package:laboratory_safety_system/safetystatus.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const Loginpage(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.health_and_safety),
        title: const Text('Laboratory Safety System'),
        centerTitle: true,
        backgroundColor: const Color(0xFFDCECEC),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 15),

            const Text(
              'Laboratory Safety System',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const SafetyStatusPage(),

            const SizedBox(height: 15),

            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    tileColor: Colors.teal.shade100,
                    leading: const Icon(Icons.sensors),
                    title: const Text('Sensor Reading'),
                    subtitle: const Text('Temperature, humidity and gas'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SensorValuePage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  ListTile(
                    tileColor: Colors.orange.shade100,
                    leading: const Icon(Icons.history),
                    title: const Text('Historical Data'),
                    subtitle: const Text('Previous sensor readings'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HistoryPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  ListTile(
                    tileColor: Colors.red.shade100,
                    leading: const Icon(Icons.warning_amber),
                    title: const Text('Warning Light & Buzzer'),
                    subtitle: const Text('Control actuators'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ActuatorPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  ListTile(
                    tileColor: Colors.blue.shade100,
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    subtitle: const Text('System information'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors),
            label: 'Sensors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SensorValuePage(),
              ),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HistoryPage(),
              ),
            );
          }
        },
      ),
    );
  }
}
