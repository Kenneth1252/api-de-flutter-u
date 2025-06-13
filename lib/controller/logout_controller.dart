import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> logoutUser() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? accessToken = prefs.getString('accessToken');

  if (accessToken == null) {
    return {'error': 'No hay sesión activa'};
  }

  var response = await http.post(
    Uri.parse('https://app-iv-ii-main-td0mcu.laravel.cloud/api/logout'),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    await prefs.remove('accessToken'); // Eliminamos el token guardado
    return jsonDecode(response.body);
  } else {
    return {'error': 'Error al cerrar sesión: ${response.statusCode}'};
  }
}
