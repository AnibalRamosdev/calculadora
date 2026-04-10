import 'package:flutter/material.dart';
import 'calculator_logic.dart'; // Importante: Conecta con tu archivo de lógica

class CalculadoraHome extends StatefulWidget {
  const CalculadoraHome({super.key});

  @override
  State<CalculadoraHome> createState() => _CalculadoraHomeState();
}

class _CalculadoraHomeState extends State<CalculadoraHome> {
  String _pantalla = "0";
  String _modoActual = "Basic";

  void _presionarBoton(String texto) {
    setState(() {
      if (texto == "AC") {
        _pantalla = "0";
      }
      else if (texto == "=") {
        // Aquí ocurre la magia: llamamos a la lógica que creaste
        _pantalla = CalculatorLogic.calcular(_pantalla);
      }
      else if (texto == "+/-") {
        // Lógica simple para cambiar signo
        if (_pantalla != "0") {
          if (_pantalla.startsWith("-")) {
            _pantalla = _pantalla.substring(1);
          } else {
            _pantalla = "-$_pantalla";
          }
        }
      }
      else {
        // Evitar que se acumulen ceros al inicio
        if (_pantalla == "0") {
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
      body: SafeArea(
        child: Column(
          children: [
            // 1. Pantalla de resultados
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView( // Por si la cifra es muy larga
                  reverse: true,
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    _pantalla,
                    style: const TextStyle(
                      fontSize: 70,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),

            // 2. Selectores de Modo
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _botonCambioModo("Basic"),
                  const SizedBox(width: 40),
                  _botonCambioModo("Scientific"),
                ],
              ),
            ),

            // 3. Teclado
            Column(
              children: [
                if (_modoActual == "Scientific")
                  _crearFila(["sin", "cos", "tan", "log"]),

                _crearFila(["AC", "+/-", "%", "÷"]),
                _crearFila(["7", "8", "9", "×"]),
                _crearFila(["4", "5", "6", "-"]),
                _crearFila(["1", "2", "3", "+"]),
                _crearFila(["0", ".", "="]),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _botonCambioModo(String nombre) {
    bool seleccionado = _modoActual == nombre;
    return GestureDetector(
      onTap: () => setState(() => _modoActual = nombre),
      child: Column(
        children: [
          Text(
            nombre,
            style: TextStyle(
              fontSize: 18,
              color: seleccionado ? const Color(0xFF5203D5) : Colors.grey[600],
              fontWeight: seleccionado ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (seleccionado)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 30,
              color: const Color(0xFF5203D5),
            ),
        ],
      ),
    );
  }

  Widget _crearFila(List<String> botones) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: botones.map((texto) => _botonPersonalizado(texto)).toList(),
      ),
    );
  }

  Widget _botonPersonalizado(String texto) {
    Color colorFondo = const Color(0xFF212121);
    Color colorTexto = Colors.white;

    if ("AC%÷×-+= ".contains(texto) || texto == "+/-") {
      colorFondo = const Color(0xFF5203D5);
    } else if ("sin cos tan log".contains(texto)) {
      colorFondo = const Color(0xFF1A1A1A);
    }

    return SizedBox(
      width: texto == "0" ? 160 : 80,
      height: 80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorFondo,
          shape: texto == "0" ? const StadiumBorder() : const CircleBorder(),
          elevation: 0,
        ),
        onPressed: () => _presionarBoton(texto),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: texto.length > 2 ? 18 : 28,
            color: colorTexto,
          ),
        ),
      ),
    );
  }
}