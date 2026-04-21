import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io'; // IMPORTANTE para manejar la imagen de fondo
import 'calculator_logic.dart';

class CalculadoraHome extends StatefulWidget {
  const CalculadoraHome({super.key});
  @override
  State<CalculadoraHome> createState() => _CalculadoraHomeState();
}

class _CalculadoraHomeState extends State<CalculadoraHome> {
  String _pantalla = "0";
  String _modoActual = "Basic";
  File? _imagenFondo; // Variable para guardar el fondo elegido

  final Color _colorFondoBase = Colors.black;
  final Color _colorBotonNum = const Color(0xFF17171C).withOpacity(0.8);
  final Color _colorBotonAccion = const Color(0xFF4B5EFC);

  void _presionarBoton(String texto) {
    HapticFeedback.lightImpact();
    setState(() {
      if (texto == "AC") { _pantalla = "0"; }
      else if (texto == "=") { _pantalla = CalculatorLogic.calcular(_pantalla); }
      else { _pantalla = (_pantalla == "0") ? texto : _pantalla + texto; }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorFondoBase,
      // Usamos un Stack para poner la imagen debajo de todo
      body: Stack(
        children: [
          // 1. CAPA DE FONDO (Imagen de personalización)
          if (_imagenFondo != null)
            Positioned.fill(
              child: Image.file(_imagenFondo!, fit: BoxFit.cover),
            ),

          // 2. CAPA DE LA INTERFAZ
          Scaffold(
            backgroundColor: _imagenFondo == null ? _colorFondoBase : Colors.transparent,
            drawer: _buildMenu(),
            appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
            body: Column(
              children: [
                Expanded(
                    child: Container(
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.all(20),
                        child: Text(
                            _pantalla,
                            style: const TextStyle(fontSize: 80, color: Colors.white, fontWeight: FontWeight.w200)
                        )
                    )
                ),
                _buildTeclado(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- EL MENU LATERAL ---
  Widget _buildMenu() {
    return Drawer(
      backgroundColor: const Color(0xFF17171C),
      child: Column(
        children: [
          const DrawerHeader(child: Text("DISEÑO FIGMA", style: TextStyle(color: Color(0xFF4B5EFC), fontSize: 24))),
          _itemMenu(Icons.calculate, "Calculadora", "/"),
          _itemMenu(Icons.palette, "Personalización", "/personalizar"),
          _itemMenu(Icons.grid_view, "Modelos", "/modelos"),
        ],
      ),
    );
  }

  // --- EL TECLADO CON MODOS ---
  Widget _buildTeclado() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: const Color(0xFF17171C).withOpacity(0.9), // Un poco transparente para ver el fondo
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30))
      ),
      child: Column(
        children: [
          if (_modoActual == "Scientific") ...[
            _crearFila(["sin", "cos", "tan", "log"]),
            _crearFila(["DEG", "(", ")", "√"]),
            const Divider(color: Colors.white10),
          ],
          _crearFila(["AC", "⌫", "%", "÷"]),
          _crearFila(["7", "8", "9", "×"]),
          _crearFila(["4", "5", "6", "-"]),
          _crearFila(["1", "2", "3", "+"]),
          _crearFila(["0", ".", "+/-", "="]),
        ],
      ),
    );
  }

  Widget _crearFila(List<String> etiquetas) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: etiquetas.map((e) => _buildBoton(e)).toList());
  }

  Widget _buildBoton(String t) {
    return Container(
      margin: const EdgeInsets.all(4),
      width: 70, height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: (t == "=" || t == "+") ? _colorBotonAccion : _colorBotonNum,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
        ),
        onPressed: () => _presionarBoton(t),
        child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 20)),
      ),
    );
  }

  // --- NAVEGACIÓN INTELIGENTE ---
  Widget _itemMenu(IconData icono, String titulo, String ruta) {
    return ListTile(
      leading: Icon(icono, color: Colors.white),
      title: Text(titulo, style: const TextStyle(color: Colors.white)),
      onTap: () async {
        Navigator.pop(context); // Cierra el menú primero

        final resultado = await Navigator.pushNamed(context, ruta);

        if (resultado != null) {
          setState(() {
            if (ruta == "/modelos") {
              _modoActual = resultado.toString();
            } else if (ruta == "/personalizar") {
              _imagenFondo = resultado as File; // Recibe la foto de la otra pantalla
            }
          });
        }
      },
    );
  }
}