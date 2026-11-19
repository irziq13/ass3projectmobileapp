
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final DatabaseReference _myDatabase = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
    'https://laboratory-safety-system-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  List<Map<String, dynamic>> records = [];

  void _readHistory() {
    _myDatabase.child('LaboratorySafetySystem/history').onValue.listen(
          (DatabaseEvent event) {
        final value = event.snapshot.value;

        if (value == null || value is! Map) {
          setState(() {
            records = [];
          });
          return;
        }

        final data = Map<dynamic, dynamic>.from(value);

        List<Map<String, dynamic>> tempRecords = [];

        data.forEach((key, value) {
          if (value is Map) {
            tempRecords.add(Map<String, dynamic>.from(value));
          }
        });

        tempRecords.sort((a, b) {
          int timeA = a['timestamp'] ?? 0;
          int timeB = b['timestamp'] ?? 0;
          return timeB.compareTo(timeA);
        });

        if (!mounted) return;

        setState(() {
          records = tempRecords;
        });
      },
    );
  }

  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return 'Time unavailable';

    int time = int.tryParse(timestamp.toString()) ?? 0;

    if (time == 0) return 'Time unavailable';

    DateTime date = DateTime.fromMillisecondsSinceEpoch(time * 1000);

    String dateText =
        '${date.day}/${date.month}/${date.year}';

    String timeText =
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';

    return '$dateText $timeText';
  }

  @override
  void initState() {
    super.initState();
    _readHistory();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> chartRecords =
    records.take(20).toList().reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historical Sensor Data'),
        backgroundColor: Colors.blue,
      ),
      body: records.isEmpty
          ? const Center(
        child: Text('No historical records available'),
      )
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Temperature History',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: const FlTitlesData(
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: chartRecords.asMap().entries.map((entry) {
                      double temperature =
                      (entry.value['temperature'] ?? 0).toDouble();

                      return FlSpot(
                        entry.key.toDouble(),
                        temperature,
                      );
                    }).toList(),
                    isCurved: true,
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Previous Records',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ...records.map((record) {
            String status =
                record['safetyStatus']?.toString() ?? 'UNKNOWN';

            Color statusColor = status == 'SAFE'
                ? Colors.green
                : status == 'WARNING'
                ? Colors.orange
                : Colors.red;

            return Card(
              child: ListTile(
                leading: Icon(
                  Icons.history,
                  color: statusColor,
                ),
                title: Text(
                  'Temperature: ${record['temperature']} °C',
                ),
                subtitle: Text(
                  'Humidity: ${record['humidity']}% | '
                      'Gas: ${record['gas']}\n'
                      '${_formatTime(record['timestamp'])}',
                ),
                trailing: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
