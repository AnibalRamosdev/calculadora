import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PantallaPersonalizar extends StatefulWidget {
  const PantallaPersonalizar({super.key});

  @override
  State<PantallaPersonalizar> createState() => _PantallaPersonalizarState();
}

class _PantallaPersonalizarState extends State<PantallaPersonalizar> {
  File? _imagenSeleccionada;
  final ImagePicker _picker = ImagePicker();

  final Color _colorFondo = Colors.black;
  final Color _colorAzulFigma = const Color(0xFF4B5EFC);
  final Color _colorTarjeta = const Color(0xFF17171C);

  Future<void> _elegirImagen() async {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() {
        _imagenSeleccionada = File(imagen.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorFondo,
      appBar: AppBar(
        title: const Text("Fondo de Pantalla", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // ÁREA DE VISTA PREVIA
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _colorTarjeta,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white10),
                ),
                child: Stack( // Stack para poner el botón de borrar encima
                  alignment: Alignment.center,
                  children: [
                    _imagenSeleccionada == null
                        ? const Text("Sin fondo personalizado", style: TextStyle(color: Colors.grey))
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Image.file(_imagenSeleccionada!, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                    ),

                    // Botón pequeño para borrar la selección
                    if (_imagenSeleccionada != null)
                      Positioned(
                        top: 20,
                        right: 20,
                        child: FloatingActionButton.small(
                          backgroundColor: Colors.redAccent,
                          onPressed: () => setState(() => _imagenSeleccionada = null),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // BOTONES DE ACCIÓN
            Column(
              children: [
                // Botón Galería
                _botonPersonalizado(
                  onPressed: _elegirImagen,
                  texto: "Cambiar Imagen",
                  icono: Icons.photo_library,
                  color: _colorTarjeta,
                ),
                const SizedBox(height: 16),

                // Botón Confirmar y Volver
                _botonPersonalizado(
                  onPressed: () {
                    // ENVIAMOS LA IMAGEN DE VUELTA A LA CALCULADORA
                    Navigator.pop(context, _imagenSeleccionada);
                  },
                  texto: "Aplicar Fondo",
                  icono: Icons.check_circle,
                  color: _colorAzulFigma,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _botonPersonalizado({required VoidCallback onPressed, required String texto, required IconData icono, required Color color}) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icono, color: Colors.white),
        label: Text(texto, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
      ),
    );
  }
}