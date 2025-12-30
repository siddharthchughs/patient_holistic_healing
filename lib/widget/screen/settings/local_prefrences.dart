import 'package:shared_preferences/shared_preferences.dart';

void saveData(String? userName, String? age) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', userName ?? '');
  await prefs.setString('age', age ?? '');
}

void readData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? username = prefs.getString('username');
  int? age = prefs.getInt('age');

  print('Username: $username');
  print('Age: $age');
}

Future<void> clearData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
