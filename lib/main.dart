import 'package:flutter/material.dart';

void main() => runApp(const CalculadoraApp());

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi Calculadora Figma',
      theme: ThemeData.dark(),
      home: const CalculadoraHome(),
    );
  }
}

class CalculadoraHome extends StatefulWidget {
  const CalculadoraHome({super.key});

  @override
  State<CalculadoraHome> createState() => _CalculadoraHomeState();
}

class _CalculadoraHomeState extends State<CalculadoraHome> {
  String _pantalla = "0";
  String _modoActual = "Basic"; // Controla si es Básica o Científica

  void _presionarBoton(String texto) {
    setState(() {
      if (texto == "AC") {
        _pantalla = "0";
      } else if (texto == "=") {
        _pantalla = "Resultado"; // Aquí irá la lógica matemática
      } else {
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

            // 2. SELECTORES DE MODO (Basic / Scientific)
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

            // 3. TECLADO COMPLETO
            Column(
              children: [
                // Si el modo es Scientific, añadimos una fila extra arriba
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

  // Widget para los botones de texto Basic/Scientific
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
    Color colorFondo = const Color(0xFF424242); // Gris oscuro para números
    Color colorTexto = Colors.white;

    // Tu color púrpura para funciones y operadores
    if (texto == "AC" || texto == "+/-" || texto == "%" || "÷×-+= ".contains(texto)) {
      colorFondo = const Color(0xFF5203D5);
    }
    // Color más oscuro para botones científicos
    else if ("sin cos tan log".contains(texto)) {
      colorFondo = const Color(0xFF212121);
    }

    return SizedBox(
      width: texto == "0" ? 170 : 80,
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
            fontSize: texto.length > 2 ? 18 : 30, // Texto más pequeño si es "sin", "cos", etc.
            color: colorTexto,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}