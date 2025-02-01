// lib/utils/team_number.dart
class TeamNumber {
  static int? _teamNumber;
  
  static void set(int number) {
    _teamNumber = number;
  }
  
  static String get() {
    if (_teamNumber == null) return '0';
    final teamStr = _teamNumber.toString().padLeft(4, '0');
    return '${teamStr.substring(0, 2)}.${teamStr.substring(2)}';
  }
  
  static String getRobotAddress() {
    if (_teamNumber == null) return 'localhost';
    return '10.${get()}.2.2';
  }
  
  static String getRadioAddress() {
    if (_teamNumber == null) return 'localhost';
    return '10.${get()}.2.1';
  }

  static String getCameraAddress(int cameraIndex) {
    if (_teamNumber == null) return 'localhost';
    return '10.${get()}.2.${11 + cameraIndex}';
  }
}