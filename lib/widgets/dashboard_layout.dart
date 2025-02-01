// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/nt4_client.dart';
import 'robot_state.dart';
import 'auto_selector.dart';
import '../widgets/telementary_view.dart';
import 'camera_stream.dart';

class DashboardLayout extends StatefulWidget {
  const DashboardLayout({Key? key}) : super(key: key);

  @override
  _DashboardLayoutState createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  String _robotAddress = 'localhost';
  
  @override
  void initState() {
    super.initState();
    _connectToRobot();
  }

  void _connectToRobot() {
    final nt = Provider.of<NT4Client>(context, listen: false);
    nt.connect(host: _robotAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FRC Dashboard'),
        actions: [
          Consumer<NT4Client>(
            builder: (context, nt, _) => Chip(
              label: Text(nt.isConnected ? 'Connected' : 'Disconnected'),
              backgroundColor: nt.isConnected ? Colors.green : Colors.red,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(context),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: const [
                RobotState(),
                Expanded(child: TelemetryView()),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: const [
                AutoSelector(),
                Expanded(child: CameraStream()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dashboard Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Robot Address',
                hintText: 'Enter team number or IP',
              ),
              onChanged: (value) => _robotAddress = value,
              controller: TextEditingController(text: _robotAddress),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Connect'),
            onPressed: () {
              Navigator.pop(context);
              _connectToRobot();
            },
          ),
        ],
      ),
    );
  }
}