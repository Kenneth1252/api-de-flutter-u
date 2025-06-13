import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> register(String name, String email, String password) async {
  const String baseUrl =
      'https://app-iv-ii-main-td0mcu.laravel.cloud/api/register';

  var headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
  var url = Uri.parse(baseUrl);
  var body = json.encode({'name': name, 'email': email, 'password': password});

  var response = await http.Client().post(url, headers: headers, body: body);

  try {
    var responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      saveSharedPreferences(responseData['token_app']);
      return null; // Registro exitoso
    } else if (response.statusCode == 422) {
      return responseData['message']; // Mensaje de error del backend
    } else {
      return 'Error inesperado (${response.statusCode})';
    }
  } catch (e) {
    return 'Error en la conexión con el servidor';
  }
}

Future saveSharedPreferences(String accessToken) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('accessToken', accessToken);
}
