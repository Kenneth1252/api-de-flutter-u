import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String?> editUser({
  required String name,
  required String email,
  String? password,
  String? confirmPassword,
}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? accessToken = prefs.getString('accessToken');

  if (accessToken == null) {
    return "Error: Token inválido. Por favor, inicia sesión nuevamente.";
  }

  if (password != null &&
      confirmPassword != null &&
      password != confirmPassword) {
    return "Las contraseñas no coinciden.";
  }

  var request = http.MultipartRequest(
    'POST',
    Uri.parse('https://app-iv-ii-main-td0mcu.laravel.cloud/api/edit'),
  );

  request.headers['Authorization'] = 'Bearer $accessToken';
  request.fields['name'] = name;
  request.fields['email'] = email;
  if (password != null) {
    request.fields['password'] = password;
  }

  try {
    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    var jsonResponse = jsonDecode(responseData);

    if (response.statusCode == 200) {
      await prefs.setString('name', jsonResponse['user']['name']);
      await prefs.setString('email', jsonResponse['user']['email']);
      return null; // Éxito, sin errores
    } else if (response.statusCode == 422) {
      if (jsonResponse.containsKey('errors') &&
          jsonResponse['errors'].containsKey('email')) {
        return "Este correo ya está registrado. Por favor, utiliza otro.";
      }
      return jsonResponse['message']; // Mensaje genérico del backend
    } else if (response.statusCode == 401) {
      return "Error: Token inválido. Debes iniciar sesión nuevamente.";
    } else {
      return "Error inesperado (${response.statusCode}). Por favor, inténtalo más tarde.";
    }
  } catch (e) {
    return "Error de conexión con el servidor, Verifique campos editados o el correo ya esta en uso.";
  }
}
