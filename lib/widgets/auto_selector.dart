// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/nt4_client.dart';

class AutoSelector extends StatelessWidget {
  const AutoSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<NT4Client>(
          builder: (context, nt, _) {
            final selectedAuto = nt.topics['/SmartDashboard/Auto/Selected'] ?? 'Default';
            final autoList = nt.topics['/SmartDashboard/Auto/List'] ?? ['Default'];
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Autonomous Mode',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: selectedAuto,
                  items: autoList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      nt.publish('/SmartDashboard/Auto/Selected', newValue);
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}