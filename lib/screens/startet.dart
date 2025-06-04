import 'package:app_materias/screens/auth/login_screen.dart';
import 'package:app_materias/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';

class StartetPage extends StatelessWidget {
  const StartetPage({super.key});

  String getGreeting() {
    int hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      return "Buenos días";
    } else if (hour >= 12 && hour < 18) {
      return "Buenas tardes";
    } else {
      return "Buenas noches";
    }
  }

  IconData getGreetingIcon() {
    int hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      return Icons.wb_sunny;
    } else if (hour >= 12 && hour < 18) {
      return Icons.wb_twilight;
    } else {
      return Icons.nights_stay;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Imagen translúcida de fondo
          Positioned.fill(
            child: Opacity(
              opacity: 0.7, // Ajusta la transparencia del fondo
              child: Image.asset(
                "assets/images/fondo.jpg", // Asegúrate de tener esta imagen en tus assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(getGreetingIcon(), color: Colors.orange, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        "${getGreeting()}, bienvenido!",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Image.network(
                    MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? "https://img.icons8.com/?size=100&id=1RNKkGO3VxHR&format=png"
                        : "https://img.icons8.com/?size=100&id=1RNKkGO3VxHR&format=png",
                    height: 146,
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF00BF6D),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text("Sign In"),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFFE9901),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text("Sign Up"),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
