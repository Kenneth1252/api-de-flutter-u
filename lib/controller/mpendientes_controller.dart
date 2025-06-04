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

Future<List<Map<String, dynamic>>> fetchMateriasPendientes({
  String? nombre,
  int? rangeStart,
}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? accessToken = prefs.getString('accessToken');

  if (accessToken == null) return [];

  String url = 'https://app-iv-ii-main-td0mcu.laravel.cloud/api/pendientes';
  Map<String, dynamic> requestBody = {
    'estado':
        'pendiente', // 🔹 Asegurar que la API reciba el filtro correctamente
  };

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

    // 🔹 Asegurar que solo se obtienen materias con estado "pendiente"
    materias =
        materias.where((materia) => materia['estado'] == "pendiente").toList();

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
