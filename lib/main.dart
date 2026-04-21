import 'package:flutter/material.dart';
// Importamos nuestras pantallas (asegúrate de que los nombres de archivo coincidan)
import 'calculator_screen.dart';
import 'personalizacion_screen.dart';
import 'modelos_screen.dart';
import 'configuracion_screen.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Figma Calculator Pro',
      // Tema oscuro global basado en tu paleta de Figma
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      // Definición de las 4 rutas principales
      initialRoute: '/',
      routes: {
        '/': (context) => const CalculadoraHome(),
        '/personalizar': (context) => PantallaPersonalizar(), // QUITAMOS EL 'const'
        '/modelos': (context) => PantallaModelos(),           // QUITAMOS EL 'const'
        '/config': (context) => PantallaConfiguracion(),     // QUITAMOS EL 'const'
      },
    );
  }
}