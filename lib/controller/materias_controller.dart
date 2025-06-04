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

Future<List<Map<String, dynamic>>> fetchMaterias({
  String? nombre,
  int? rangeStart,
}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? accessToken = prefs.getString('accessToken');

  if (accessToken == null) return [];

  String url = 'https://app-iv-ii-main-td0mcu.laravel.cloud/api/materias';
  Map<String, dynamic> requestBody = {};

  if (nombre != null) {
    requestBody['nombre'] = normalizeText(nombre);
  } else if (rangeStart != null) {
    requestBody['rangeStart'] = rangeStart;
    requestBody['rangeEnd'] = rangeStart + 9;
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

    // 🔹 Filtrar por nombre con comparación sin tildes y sin mayúsculas
    if (nombre != null) {
      materias =
          materias
              .where(
                (materia) => normalizeText(
                  materia['nombre'],
                ).contains(normalizeText(nombre)),
              )
              .toList();
    } else if (rangeStart != null) {
      materias =
          materias
              .where(
                (materia) =>
                    materia['id'] >= rangeStart &&
                    materia['id'] <= (rangeStart + 9),
              )
              .toList();
    }

    return materias;
  } else {
    return [];
  }
}
