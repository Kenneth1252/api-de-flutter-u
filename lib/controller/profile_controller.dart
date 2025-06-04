import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>?> fetchUserData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? accessToken = prefs.getString('accessToken');

  if (accessToken == null) {
    return null;
  }

  var response = await http.get(
    Uri.parse('https://app-iv-ii-main-td0mcu.laravel.cloud/api/user'),
    headers: {'Authorization': 'Bearer $accessToken'},
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return null;
  }
}

Future<int> updateUserData(
  String name,
  String email, {
  String? password,
}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? accessToken = prefs.getString('accessToken');

  if (accessToken == null) {
    return 401;
  }

  var body = jsonEncode({
    'name': name,
    'email': email,
    if (password != null)
      'password': password, // Agregar contraseña si se quiere cambiar
  });

  var response = await http.put(
    Uri.parse('https://app-iv-ii-main-td0mcu.laravel.cloud/api/update-user'),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: body,
  );

  return response.statusCode;
}
