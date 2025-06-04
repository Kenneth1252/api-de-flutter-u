import 'package:app_materias/controller/maprobadas_controller.dart';
import 'package:app_materias/screens/auth/materiadetailscreen.dart';
import 'package:flutter/material.dart';

class MateriasAprobadasScreen extends StatefulWidget {
  const MateriasAprobadasScreen({super.key});

  @override
  State<MateriasAprobadasScreen> createState() =>
      _MateriasAprobadasScreenState();
}

class _MateriasAprobadasScreenState extends State<MateriasAprobadasScreen> {
  List<Map<String, dynamic>> materiasAprobadas = [];
  TextEditingController nombreController = TextEditingController();
  int totalAprobadas = 0;

  @override
  void initState() {
    super.initState();
    loadMateriasAprobadas();
  }

  Future<void> loadMateriasAprobadas({String? nombre}) async {
    var fetchedMaterias = await fetchMateriasAprobadas(nombre: nombre);
    if (!mounted) return;

    setState(() {
      materiasAprobadas = fetchedMaterias;
      totalAprobadas = fetchedMaterias.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Imagen de fondo translúcida
          Positioned.fill(
            child: Opacity(
              opacity: 0.7, // Ajusta la transparencia aquí
              child: Image.asset("assets/images/fondo.jpg", fit: BoxFit.cover),
            ),
          ),
          SafeArea(
            child: Container(
              width: double.infinity,
              height:
                  double
                      .infinity, // 🔹 Asegura que el fondo cubra toda la pantalla
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: const Color(0xFF00BF6D),
                      foregroundColor: Colors.white,
                      title: Text(
                        "Materias Aprobadas - Total: $totalAprobadas",
                      ),
                      elevation: 2, // 🔹 Mayor visibilidad
                    ),
                    TextField(
                      controller: nombreController,
                      decoration: InputDecoration(
                        labelText: "Buscar Materia Aprobada",
                        filled: true,
                        fillColor: Colors.white.withOpacity(
                          0.8,
                        ), // 🔹 Mejor contraste
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        loadMateriasAprobadas(nombre: value);
                      },
                    ),
                    const SizedBox(height: 10),
                    materiasAprobadas.isEmpty
                        ? const Center(
                          child: Text(
                            "No hay materias aprobadas.",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        )
                        : Expanded(
                          child: ListView.builder(
                            itemCount: materiasAprobadas.length,
                            itemBuilder: (context, index) {
                              var materia = materiasAprobadas[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => MateriaDetailScreen(
                                            materia: materia,
                                          ), // 🔹 Usamos el mismo screen de detalles
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 6,
                                  color: Colors.black.withOpacity(0.6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          materia['nombre'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "Código: ${materia['codigo']}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "Créditos: ${materia['creditos']}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "Requisito: ${materia['requisito']}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "Estado: ${materia['estado'].toUpperCase()}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
