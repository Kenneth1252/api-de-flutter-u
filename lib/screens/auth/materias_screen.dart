import 'package:app_materias/screens/auth/materiadetailscreen.dart';
import 'package:flutter/material.dart';
import 'package:app_materias/controller/materias_controller.dart';

class MateriasScreen extends StatefulWidget {
  const MateriasScreen({super.key});

  @override
  State<MateriasScreen> createState() => _MateriasScreenState();
}

class _MateriasScreenState extends State<MateriasScreen> {
  List<Map<String, dynamic>> materias = [];
  TextEditingController nombreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadMaterias();
  }

  Future<void> loadMaterias({String? nombre}) async {
    var fetchedMaterias = await fetchMaterias(nombre: nombre);

    if (!mounted)
      return; // 🔹 Evita errores si el widget ya no está en pantalla

    setState(() {
      materias = fetchedMaterias;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Imagen translúcida de fondo que cubre toda la pantalla
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
                      .infinity, // 🔹 Asegura que el fondo cubra todo el espacio
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: const Color(0xFF00BF6D),
                      foregroundColor: Colors.white,
                      title: const Text("Materias"),
                      elevation: 2, // 🔹 Mayor visibilidad
                    ),
                    TextField(
                      controller: nombreController,
                      decoration: InputDecoration(
                        labelText: "Buscar Materia",
                        filled: true,
                        fillColor: Colors.white.withOpacity(
                          0.8,
                        ), // 🔹 Mayor contraste
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        loadMaterias(nombre: value);
                      },
                    ),
                    const SizedBox(height: 10),
                    materias.isEmpty
                        ? const Center(
                          child: Text(
                            "No hay materias cargadas.",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        )
                        : Expanded(
                          child: ListView.builder(
                            itemCount: materias.length,
                            itemBuilder: (context, index) {
                              var materia = materias[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => MateriaDetailScreen(
                                            materia: materia,
                                          ),
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
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                materia['estado'] == "pendiente"
                                                    ? Colors.red
                                                    : Colors.green,
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
