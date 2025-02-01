// ignore_for_file: unused_import, use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/nt4_client.dart';
import 'dart:convert';
import '../utils/team_number.dart';

class CameraStream extends StatefulWidget {
  const CameraStream({Key? key}) : super(key: key);

  @override
  _CameraStreamState createState() => _CameraStreamState();
}

class _CameraStreamState extends State<CameraStream> {
  String _selectedCamera = 'USB Camera 0';
  final List<String> _availableCameras = ['USB Camera 0', 'USB Camera 1', 'Limelight'];
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Camera Feed',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: _selectedCamera,
                  items: _availableCameras.map((String camera) {
                    return DropdownMenuItem<String>(
                      value: camera,
                      child: Text(camera),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => _selectedCamera = newValue);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Consumer<NT4Client>(
                builder: (context, nt, _) {
                  final mjpegUrl = _getCameraUrl();
                  return _buildCameraView(mjpegUrl);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCameraUrl() {
    String baseUrl;
    if (_selectedCamera == 'Limelight') {
      baseUrl = 'http://limelight.local:5800';
    } else {
      final cameraNumber = int.parse(_selectedCamera.split(' ').last);
      baseUrl = 'http://10.${TeamNumber.get()}.2.$cameraNumber:1181';
    }
    return '$baseUrl/stream.mjpg';
  }

  Widget _buildCameraView(String url) {
    // Note: You'll need to implement MJPEG streaming.
    // This is a placeholder that shows how to connect to the camera
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Camera URL: $url'),
          const SizedBox(height: 16),
          const Text('Implement MJPEG streaming here'),
        ],
      ),
    );
  }
}