import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String normalizeText(String text) {
  return text
      .toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u');
}

Future<List<Map<String, dynamic>>> fetchMateriasAprobadas({
  String? nombre,
}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? accessToken = prefs.getString('accessToken');

  if (accessToken == null) return [];

  String url = 'https://app-iv-ii-main-td0mcu.laravel.cloud/api/pendientes';
  Map<String, dynamic> requestBody = {
    'estado': 'aprobada', // 🔹 Ahora filtramos solo materias aprobadas
  };

  if (nombre != null) {
    requestBody['nombre'] = normalizeText(nombre);
  }

  var response = await http.post(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    List<Map<String, dynamic>> materias = List<Map<String, dynamic>>.from(
      data['materias'],
    );

    // 🔹 Asegurar que solo se obtienen materias con estado "aprobada"
    materias =
        materias.where((materia) => materia['estado'] == "aprobada").toList();

    if (nombre != null) {
      materias =
          materias
              .where(
                (materia) => normalizeText(
                  materia['nombre'],
                ).contains(normalizeText(nombre)),
              )
              .toList();
    }

    return materias;
  } else {
    return [];
  }
}
