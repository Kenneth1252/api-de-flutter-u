import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<int> register(String name, String email, String password) async {
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
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      saveSharedPreferences(data['token_app']); // Guarda el token generado

      return 201; // Indica éxito en el registro
    } else {
      debugPrint("Error en registro: ${response.statusCode}");
      return response.statusCode;
    }
  } catch (e) {
    debugPrint("Failed: $e");
    return 500; // Error interno
  }
}

Future saveSharedPreferences(String accessToken) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('accessToken', accessToken);
}
