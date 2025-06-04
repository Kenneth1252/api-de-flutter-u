import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<int> login(String email, String password) async {
  const String baseUrl =
      'https://app-iv-ii-main-td0mcu.laravel.cloud/api/login';

  var headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'cache-control': 'no-cache',
  };

  var url = Uri.parse(baseUrl);
  var body = json.encode({'email': email, 'password': password});

  try {
    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      // Guardamos el token y otros datos del usuario
      await saveUserData(
        data['accessToken'],
        data['user']['name'],
        data['user']['email'],
      );

      return 201; // Login exitoso
    } else if (response.statusCode == 401) {
      return 401; // Credenciales incorrectas
    } else {
      return response.statusCode; // Otros errores del servidor
    }
  } catch (e) {
    return 500; // Error interno
  }
}

Future<void> saveUserData(String accessToken, String name, String email) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('accessToken', accessToken);
  await prefs.setString('name', name);
  await prefs.setString('email', email);
}

Future<String?> getAccessToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('accessToken');
}

Future<String?> getUserName() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('name');
}

Future<String?> getUserEmail() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}
