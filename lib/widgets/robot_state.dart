// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/nt4_client.dart';

class RobotState extends StatelessWidget {
  const RobotState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<NT4Client>(
          builder: (context, nt, _) {
            final robotEnabled = nt.topics['/FMSInfo/RobotEnabled'] ?? false;
            final mode = _getRobotMode(nt);
            final voltage = nt.topics['/SmartDashboard/Voltage'] ?? 0.0;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status: ${robotEnabled ? "Enabled" : "Disabled"}',
                  style: TextStyle(
                    color: robotEnabled ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Mode: $mode'),
                Text('Battery: ${voltage.toStringAsFixed(2)}V',
                  style: TextStyle(
                    color: voltage < 12.0 ? Colors.red : Colors.white,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getRobotMode(NT4Client nt) {
    if (nt.topics['/FMSInfo/IsAutonomous'] ?? false) return 'Autonomous';
    if (nt.topics['/FMSInfo/IsTeleop'] ?? false) return 'Teleop';
    if (nt.topics['/FMSInfo/IsTest'] ?? false) return 'Test';
    return 'Disabled';
  }
}
