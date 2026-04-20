import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'calculator_logic.dart';

class CalculadoraHome extends StatefulWidget {
  const CalculadoraHome({super.key});

  @override
  State<CalculadoraHome> createState() => _CalculadoraHomeState();
}

class _CalculadoraHomeState extends State<CalculadoraHome> {
  String _pantalla = "0";
  String _modoActual = "Basic";
  File? _imagenFondo;
  final ImagePicker _picker = ImagePicker();

  Future<void> _seleccionarImagen() async {
    try {
      final XFile? imagenSeleccionada = await _picker.pickImage(source: ImageSource.gallery);
      if (imagenSeleccionada != null) {
        setState(() {
          _imagenFondo = File(imagenSeleccionada.path);
        });
      }
    } catch (e) {
      print("Error al seleccionar imagen: $e");
    }
  }

  void _presionarBoton(String texto) {
    setState(() {
      if (texto == "AC") {
        _pantalla = "0";
      } else if (texto == "⌫") {
        _pantalla = (_pantalla.length > 1) ? _pantalla.substring(0, _pantalla.length - 1) : "0";
      } else if (texto == "=") {
        _pantalla = CalculatorLogic.calcular(_pantalla);
      } else if (texto == "DEG" || texto == "RAD") {
        CalculatorLogic.esGrados = !CalculatorLogic.esGrados;
      } else if (["sin", "cos", "tan", "log"].contains(texto)) {
        _pantalla = (_pantalla == "0") ? "$texto(" : _pantalla + "$texto(";
      } else if (texto == "+/-") {
        if (_pantalla != "0" && _pantalla != "Error") {
          _pantalla = _pantalla.startsWith("-") ? _pantalla.substring(1) : "-$_pantalla";
        }
      } else {
        if (_pantalla == "0" || _pantalla == "Error") {
          _pantalla = texto;
        } else {
          _pantalla += texto;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_imagenFondo != null)
            Positioned.fill(
              child: Image.file(
                _imagenFondo!,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.4),
                colorBlendMode: BlendMode.darken,
              ),
            ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      _pantalla,
                      style: const TextStyle(fontSize: 70, color: Colors.white, fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _botonCambioModo("Basic"),
                          const SizedBox(width: 20),
                          _botonCambioModo("Scientific"),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.image, color: Color(0xFF5203D5)),
                        onPressed: _seleccionarImagen,
                      )
                    ],
                  ),
                ),
                _construirTeclado(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirTeclado() {
    return Column(
      children: [
        if (_modoActual == "Scientific") ...[
          _crearFila([CalculatorLogic.esGrados ? "DEG" : "RAD", "(", ")", "log"]),
          _crearFila(["sin", "cos", "tan", "÷"]),
        ],
        if (_modoActual == "Basic") _crearFila(["AC", "⌫", "%", "÷"]),
        _crearFila(["7", "8", "9", "×"]),
        _crearFila(["4", "5", "6", "-"]),
        _crearFila(["1", "2", "3", "+"]),
        _crearFila(["0", ".", "+/-", "="]),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _botonCambioModo(String nombre) {
    bool seleccionado = _modoActual == nombre;
    return GestureDetector(
      onTap: () => setState(() => _modoActual = nombre),
      child: Text(
        nombre,
        style: TextStyle(
          fontSize: 18,
          color: seleccionado ? const Color(0xFF5203D5) : Colors.grey,
          fontWeight: seleccionado ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _crearFila(List<String> botones) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: botones.map((texto) => _botonPersonalizado(texto)).toList(),
    );
  }

  Widget _botonPersonalizado(String texto) {
    return Container(
      margin: const EdgeInsets.all(4),
      width: 75,
      height: 75,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: "AC%÷×-+=⌫()DEG RAD".contains(texto) || texto == "+/-"
              ? const Color(0xFF5203D5)
              : const Color(0xFF212121).withOpacity(0.8),
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
        ),
        onPressed: () => _presionarBoton(texto),
        child: Text(texto, style: const TextStyle(fontSize: 22, color: Colors.white)),
      ),
    );
  }
}