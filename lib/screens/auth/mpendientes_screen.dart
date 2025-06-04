import 'package:app_materias/controller/mpendientes_controller.dart';
import 'package:app_materias/screens/auth/materiadetailscreen.dart';
import 'package:flutter/material.dart';

class MateriasPendientesScreen extends StatefulWidget {
  const MateriasPendientesScreen({super.key});

  @override
  State<MateriasPendientesScreen> createState() =>
      _MateriasPendientesScreenState();
}

class _MateriasPendientesScreenState extends State<MateriasPendientesScreen> {
  List<Map<String, dynamic>> materiasPendientes = [];
  TextEditingController nombreController = TextEditingController();
  int totalPendientes = 0;

  @override
  void initState() {
    super.initState();
    loadMateriasPendientes();
  }

  Future<void> loadMateriasPendientes({String? nombre}) async {
    var fetchedMaterias = await fetchMateriasPendientes(nombre: nombre);
    if (!mounted) return;

    setState(() {
      materiasPendientes = fetchedMaterias;
      totalPendientes = fetchedMaterias.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Imagen translúcida de fondo
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
                        "Materias Pendientes - Total: $totalPendientes",
                      ),
                      elevation: 2, // 🔹 Mejor visibilidad
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
                        loadMateriasPendientes(nombre: value);
                      },
                    ),
                    const SizedBox(height: 10),
                    materiasPendientes.isEmpty
                        ? const Center(
                          child: Text(
                            "No hay materias pendientes.",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        )
                        : Expanded(
                          child: ListView.builder(
                            itemCount: materiasPendientes.length,
                            itemBuilder: (context, index) {
                              var materia = materiasPendientes[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => MateriaDetailScreen(
                                            materia: materia,
                                          ), // 🔹 Usamos el mismo screen
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
                                            color: Colors.red,
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
