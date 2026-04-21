import 'package:flutter/material.dart';

class PantallaModelos extends StatefulWidget {
  const PantallaModelos({super.key});

  @override
  State<PantallaModelos> createState() => _PantallaModelosState();
}

class _PantallaModelosState extends State<PantallaModelos> {
  String modeloSeleccionado = "Básico"; // Valor inicial

  final Color _colorFondo = Colors.black;
  final Color _colorTarjeta = const Color(0xFF17171C);
  final Color _colorAzulFigma = const Color(0xFF4B5EFC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorFondo,
      appBar: AppBar(
        title: const Text("Selector de Modelos"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _tarjetaModelo("Básico", "Interfaz simple", Icons.calculate),
                  const SizedBox(height: 16),
                  _tarjetaModelo("Científico", "Funciones avanzadas", Icons.science),
                ],
              ),
            ),

            // BOTÓN DE CONFIRMACIÓN CORREGIDO
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _colorAzulFigma,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  // TRADUCCIÓN DE NOMBRE:
                  // Si es "Científico", mandamos "Scientific" a la calculadora
                  String valorParaEnviar = (modeloSeleccionado == "Científico")
                      ? "Scientific"
                      : "Basic";

                  Navigator.pop(context, valorParaEnviar);
                },
                child: const Text("Confirmar Selección", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaModelo(String titulo, String subtitulo, IconData icono) {
    bool esElSeleccionado = modeloSeleccionado == titulo;
    return GestureDetector(
      onTap: () => setState(() => modeloSeleccionado = titulo),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _colorTarjeta,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: esElSeleccionado ? _colorAzulFigma : Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Icon(icono, color: esElSeleccionado ? _colorAzulFigma : Colors.white),
            const SizedBox(width: 20),
            Text(titulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Spacer(),
            if (esElSeleccionado) Icon(Icons.check_circle, color: _colorAzulFigma),
          ],
        ),
      ),
    );
  }
}