// ==========================================
// SECCIÓN 1: IMPORTACIONES
// ==========================================
import 'package:flutter/material.dart';      // Componentes de interfaz
import 'package:image_picker/image_picker.dart'; // Para abrir la galería
import 'dart:io';                             // Para manejar el archivo de imagen

// Clase principal de la pantalla de personalización
class PantallaPersonalizar extends StatefulWidget {
  const PantallaPersonalizar({super.key});

  @override
  State<PantallaPersonalizar> createState() => _PantallaPersonalizarState();
}

class _PantallaPersonalizarState extends State<PantallaPersonalizar> {
  // Variable para almacenar la imagen seleccionada
  File? _imagenSeleccionada;
  final ImagePicker _picker = ImagePicker();

  // Colores de tu diseño Figma
  final Color _colorFondo = Colors.black;
  final Color _colorAzulFigma = const Color(0xFF4B5EFC);
  final Color _colorTarjeta = const Color(0xFF17171C);

  // FUNCIÓN: Abre la galería y guarda la foto
  Future<void> _cambiarFondo() async {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);

    if (imagen != null) {
      setState(() {
        _imagenSeleccionada = File(imagen.path);
      });
      // Aquí podrías añadir una lógica para guardar esta ruta
      // y que la calculadora la lea (usando SharedPreferences más adelante)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorFondo,
      appBar: AppBar(
        title: const Text("Personalización", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Configura el fondo de tu calculadora",
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // VISTA PREVIA DE LA IMAGEN
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: _colorTarjeta,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
              ),
              child: _imagenSeleccionada == null
                  ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined, color: Colors.grey, size: 80),
                  SizedBox(height: 10),
                  Text("No hay imagen seleccionada", style: TextStyle(color: Colors.grey)),
                ],
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.file(_imagenSeleccionada!, fit: BoxFit.cover),
              ),
            ),

            const Spacer(), // Empuja el botón hacia abajo

            // BOTÓN PARA SELECCIONAR
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: _cambiarFondo,
                icon: const Icon(Icons.photo_library, color: Colors.white),
                label: const Text("Elegir de la Galería", style: TextStyle(fontSize: 18, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _colorAzulFigma,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}