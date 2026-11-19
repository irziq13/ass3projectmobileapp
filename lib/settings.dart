import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:laboratory_safety_system/loginpage.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: ListTile(
              leading: Icon(
                Icons.health_and_safety,
                color: Colors.teal,
              ),
              title: Text('Laboratory Safety System'),
              subtitle: Text('IoT Monitoring System'),
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: ListTile(
              leading: const Icon(Icons.memory),
              title: const Text('Controller'),
              subtitle: const Text('ESP32 Development Board'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.sensors),
              title: const Text('Sensors'),
              subtitle: const Text(
                'Temperature, Humidity and Gas',
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.warning_amber),
              title: const Text('Actuators'),
              subtitle: const Text(
                'Warning Light and Buzzer',
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.cloud_done),
              title: const Text('Firebase'),
              subtitle: const Text('Realtime Database'),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Account Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Logged-in User'),
              subtitle: Text(user?.email ?? 'No user'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Authentication'),
              subtitle: const Text('Firebase Email/Password'),
            ),
          ),

          const SizedBox(height: 20),

          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              subtitle: const Text('Sign out from your account'),
              onTap: () => _logout(context),
            ),
          ),
        ],
      ),
    );
  }
}
