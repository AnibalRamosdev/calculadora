import 'package:flutter/material.dart';

class PantallaConfiguracion extends StatelessWidget {
  const PantallaConfiguracion({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuración")),
      body: const Center(child: Text("Pantalla de Configuración")),
    );
  }
}