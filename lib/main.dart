// ignore_for_file: depend_on_referenced_packages, avoid_print, use_super_parameters

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/nt4_client.dart';
import 'widgets/dashboard_layout.dart';
import 'package:logging/logging.dart';

void main() {
  // Setup logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(

    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NT4Client()),
      ],
      child: const FRCDashboard(),
    ),
  );
}

class FRCDashboard extends StatelessWidget {
  const FRCDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FRC Dashboard',
      theme: ThemeData.dark(),
      home: const DashboardLayout(),
    );
  }
}