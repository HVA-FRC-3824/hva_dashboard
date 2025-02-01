// ignore_for_file: depend_on_referenced_packages, use_super_parameters

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/nt4_client.dart';

class TelemetryView extends StatelessWidget {
  const TelemetryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<NT4Client>(
          builder: (context, nt, _) {
            return DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Drivetrain'),
                      Tab(text: 'Mechanisms'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _DrivetrainTab(nt: nt),
                        _MechanismsTab(nt: nt),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DrivetrainTab extends StatelessWidget {
  final NT4Client nt;
  
  const _DrivetrainTab({required this.nt});

  @override
  Widget build(BuildContext context) {
    final gyroAngle = nt.topics['/SmartDashboard/Gyro/Angle'] ?? 0.0;
    final leftVel = nt.topics['/SmartDashboard/Drive/LeftVelocity'] ?? 0.0;
    final rightVel = nt.topics['/SmartDashboard/Drive/RightVelocity'] ?? 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gyro: ${gyroAngle.toStringAsFixed(2)}°'),
        const SizedBox(height: 8),
        Text('Left Velocity: ${leftVel.toStringAsFixed(2)} m/s'),
        Text('Right Velocity: ${rightVel.toStringAsFixed(2)} m/s'),
        const SizedBox(height: 16),
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  axisNameWidget: Text('Time (s)'),
                  sideTitles: SideTitles(showTitles: true),
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: Text('Velocity (m/s)'),
                  sideTitles: SideTitles(showTitles: true),
                ),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, leftVel),
                    FlSpot(1, rightVel),
                  ],
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MechanismsTab extends StatelessWidget {
  final NT4Client nt;
  
  const _MechanismsTab({required this.nt});

  @override
  Widget build(BuildContext context) {
    final armPosition = nt.topics['/SmartDashboard/Arm/Position'] ?? 0.0;
    final armSetpoint = nt.topics['/SmartDashboard/Arm/Setpoint'] ?? 0.0;
    final intakeSpeed = nt.topics['/SmartDashboard/Intake/Speed'] ?? 0.0;
    final shooterRPM = nt.topics['/SmartDashboard/Shooter/RPM'] ?? 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Arm Position: ${armPosition.toStringAsFixed(2)}°'),
        Text('Arm Setpoint: ${armSetpoint.toStringAsFixed(2)}°'),
        Text('Intake Speed: ${(intakeSpeed * 100).toStringAsFixed(1)}%'),
        Text('Shooter Speed: ${shooterRPM.toStringAsFixed(0)} RPM'),
        const SizedBox(height: 16),
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  axisNameWidget: Text('Time (s)'),
                  sideTitles: SideTitles(showTitles: true),
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: Text('Position (degrees)'),
                  sideTitles: SideTitles(showTitles: true),
                ),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, armPosition),
                    FlSpot(1, armSetpoint),
                  ],
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 3,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}