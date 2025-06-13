import 'package:app_materias/controller/edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:app_materias/controller/profile_controller.dart';
import 'package:app_materias/screens/home.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isEditing = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    var userData = await fetchUserData();
    if (userData != null) {
      setState(() {
        nameController.text = userData['name'];
        emailController.text = userData['email'];
      });
    }
  }

  void toggleEditing() {
    if (!isEditing) {
      passwordController.clear();
      confirmPasswordController.clear();
    }
    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> saveChanges() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var errorMessage = await editUser(
        name: nameController.text,
        email:
            emailController
                .text, // 💡 Agregamos correctamente emailController.text aquí
        password:
            passwordController.text.isNotEmpty ? passwordController.text : null,
        confirmPassword:
            confirmPasswordController.text.isNotEmpty
                ? confirmPasswordController.text
                : null,
      );

      if (errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Perfil actualizado correctamente")),
      );

      setState(() {
        isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00BF6D),
        foregroundColor: Colors.white,
        title: const Text("Perfil"),
        elevation: 2,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.7,
              child: Image.asset("assets/images/fondo.jpg", fit: BoxFit.cover),
            ),
          ),
          SafeArea(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      "https://i.postimg.cc/cCsYDjvj/user-2.png",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // 🔹 Validación del nombre
                        TextFormField(
                          controller: nameController,
                          style: const TextStyle(color: Colors.black),
                          enabled: isEditing,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "El nombre es obligatorio";
                            }
                            if (value.length < 3) {
                              return "Debe tener al menos 3 caracteres";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Nombre",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 🔹 Validación del correo
                        TextFormField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.black),
                          enabled: isEditing,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "El correo es obligatorio";
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[a-zA-Z]{2,}$',
                            ).hasMatch(value)) {
                              return "Ingrese un correo válido";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Correo",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        if (isEditing) ...[
                          const SizedBox(height: 16),

                          // 🔹 Validación de la nueva contraseña con opción de visualizarla
                          TextFormField(
                            controller: passwordController,
                            obscureText: !isPasswordVisible,
                            style: const TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value != null &&
                                  value.isNotEmpty &&
                                  value.length < 6) {
                                return "Debe tener al menos 6 caracteres";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Nueva Contraseña",
                              filled: true,
                              fillColor: Colors.white,
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 🔹 Validación de la confirmación de contraseña con opción de visualizarla
                          TextFormField(
                            controller: confirmPasswordController,
                            obscureText: !isConfirmPasswordVisible,
                            style: const TextStyle(color: Colors.black),
                            validator: (value) {
                              if (passwordController.text.isNotEmpty &&
                                  value != passwordController.text) {
                                return "Las contraseñas no coinciden";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Confirmar Contraseña",
                              filled: true,
                              fillColor: Colors.white,
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isConfirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isConfirmPasswordVisible =
                                        !isConfirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (!isEditing)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: toggleEditing,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(
                                48,
                                48,
                              ), // Ajusta el alto, pero el ancho será dinámico
                            ),
                            child: const Text("Editar"),
                          ),
                        )
                      else
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: toggleEditing,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(150, 48),
                              ),
                              child: const Text("Cancelar Edición"),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: saveChanges,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(150, 48),
                              ),
                              child: const Text("Guardar Cambios"),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFE9901),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text("Volver al Home"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
