import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'calculator_logic.dart';

class CalculadoraHome extends StatefulWidget {
  const CalculadoraHome({super.key});

  @override
  State<CalculadoraHome> createState() => _CalculadoraHomeState();
}

class _CalculadoraHomeState extends State<CalculadoraHome> {
  String _pantalla = "0";
  String _modoActual = "Basic";
  String _temaEstacion = "Normal";

  // --- MAPA DE COLORES ESTACIONALES ---
  final Map<String, dynamic> _configTemas = {
    "Normal": {
      "fondo": Colors.black,
      "teclado": const Color(0xFF17171C),
      "boton": const Color(0xFF2E2F3E),
      "accion": const Color(0xFF4B5EFC),
      "texto": Colors.white,
    },
    "Primavera": {
      "fondo": const Color(0xFFE8F5E9),
      "teclado": const Color(0xFFC8E6C9),
      "boton": const Color(0xFF81C784),
      "accion": const Color(0xFFFF80AB),
      "texto": const Color(0xFF1B5E20),
    },
    "Verano": {
      "fondo": const Color(0xFFFFFDE7),
      "teclado": const Color(0xFFFFF9C4),
      "boton": const Color(0xFFFFD54F),
      "accion": const Color(0xFF0288D1),
      "texto": const Color(0xFFE65100),
    },
    "Otoño": {
      "fondo": const Color(0xFFEFEBE9),
      "teclado": const Color(0xFFD7CCC8),
      "boton": const Color(0xFFA1887F),
      "accion": const Color(0xFFE64A19),
      "texto": const Color(0xFF3E2723),
    },
    "Invierno": {
      "fondo": const Color(0xFFE3F2FD),
      "teclado": const Color(0xFFBBDEFB),
      "boton": const Color(0xFF90CAF9),
      "accion": Colors.white,
      "texto": const Color(0xFF0D47A1),
    },
  };

  // Función mágica para obtener el color dinámico
  Color _getColor(String tipo) {
    return _configTemas[_temaEstacion][tipo];
  }

  void _presionarBoton(String texto) {
    HapticFeedback.lightImpact();
    setState(() {
      if (texto == "AC") {
        _pantalla = "0";
      } else if (texto == "=") {
        _pantalla = CalculatorLogic.calcular(_pantalla);
      } else if (texto == "⌫") {
        _pantalla = (_pantalla.length > 1) ? _pantalla.substring(0, _pantalla.length - 1) : "0";
      } else {
        if (_pantalla == "0") _pantalla = texto;
        else _pantalla += texto;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getColor("fondo"), // <--- FONDO DINÁMICO
      drawer: Drawer(
        backgroundColor: _getColor("teclado"), // <--- MENÚ DINÁMICO
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("MENÚ", style: TextStyle(color: _getColor("accion"), fontSize: 24)),
            ),
            _itemMenu(Icons.calculate, "Calculadora", "/"),
            _itemMenu(Icons.palette, "Personalización", "/personalizar"),
            _itemMenu(Icons.grid_view, "Modelos", "/modelos"),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: _getColor("texto")), // <--- ICONO MENÚ DINÁMICO
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20),
            icon: Icon(
              _modoActual == "Basic" ? Icons.science_outlined : Icons.calculate_outlined,
              color: _getColor("accion"), // <--- BOTÓN CIENCIA DINÁMICO
            ),
            onPressed: () {
              setState(() {
                _modoActual = (_modoActual == "Basic") ? "Scientific" : "Basic";
              });
              HapticFeedback.mediumImpact();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(30),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _pantalla,
                  style: TextStyle(fontSize: 80, color: _getColor("texto"), fontWeight: FontWeight.w200),
                ),
              ),
            ),
          ),
          _buildTeclado(),
        ],
      ),
    );
  }

  Widget _buildTeclado() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: _getColor("teclado"), // <--- TECLADO DINÁMICO
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          if (_modoActual == "Scientific") ...[
            _crearFila(["sin", "cos", "tan", "log"]),
            _crearFila(["DEG", "(", ")", "√"]),
            Divider(color: _getColor("texto").withOpacity(0.1)),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: etiquetas.map((e) => _buildBoton(e)).toList(),
    );
  }

  Widget _buildBoton(String texto) {
    bool esAccion = "÷×-+= ".contains(texto) && texto != "";
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      width: 72,
      height: 72,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: esAccion ? _getColor("accion") : _getColor("boton"), // <--- BOTONES DINÁMICOS
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_temaEstacion == "Invierno" ? 10 : 24),
          ),
          elevation: 0,
        ),
        onPressed: () => _presionarBoton(texto),
        child: Text(texto, style: TextStyle(fontSize: 22, color: _getColor("texto"))),
      ),
    );
  }

  Widget _itemMenu(IconData icono, String titulo, String ruta) {
    return ListTile(
      leading: Icon(icono, color: _getColor("texto")),
      title: Text(titulo, style: TextStyle(color: _getColor("texto"))),
      onTap: () async {
        Navigator.pop(context);
        final resultado = await Navigator.pushNamed(context, ruta);
        if (resultado != null && resultado is String) {
          setState(() {
            _temaEstacion = resultado;
          });
        }
      },
    );
  }
}