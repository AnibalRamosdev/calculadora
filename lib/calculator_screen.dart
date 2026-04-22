import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:math' as math;
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
  File? _imagenFondo;

  final Map<String, dynamic> _configTemas = {
    "Normal": {"fondo": Colors.black, "teclado": const Color(0xFF17171C), "boton": const Color(0xFF2E2F3E), "accion": const Color(0xFF4B5EFC), "texto": Colors.white},
    "Primavera": {"fondo": const Color(0xFFE8F5E9), "teclado": const Color(0xFFC8E6C9), "boton": const Color(0xFF81C784), "accion": const Color(0xFFFF80AB), "texto": const Color(0xFF1B5E20)},
    "Verano": {"fondo": const Color(0xFFFFFDE7), "teclado": const Color(0xFFFFF9C4), "boton": const Color(0xFFFFD54F), "accion": const Color(0xFF0288D1), "texto": const Color(0xFFE65100)},
    "Otoño": {"fondo": const Color(0xFFEFEBE9), "teclado": const Color(0xFFD7CCC8), "boton": const Color(0xFFA1887F), "accion": const Color(0xFFE64A19), "texto": const Color(0xFF3E2723)},
    "Invierno": {"fondo": const Color(0xFFE3F2FD), "teclado": const Color(0xFFBBDEFB), "boton": const Color(0xFF90CAF9), "accion": Colors.white, "texto": const Color(0xFF0D47A1)},
  };

  Color _getColor(String tipo) => _configTemas[_temaEstacion][tipo];

  void _presionarBoton(String texto) {
    HapticFeedback.lightImpact();
    setState(() {
      if (texto == "AC") _pantalla = "0";
      else if (texto == "=") _pantalla = CalculatorLogic.calcular(_pantalla);
      else if (texto == "⌫") _pantalla = (_pantalla.length > 1) ? _pantalla.substring(0, _pantalla.length - 1) : "0";
      else {
        if (_pantalla == "0") _pantalla = texto;
        else _pantalla += texto;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_imagenFondo != null) Positioned.fill(child: Image.file(_imagenFondo!, fit: BoxFit.cover)),
          if (_imagenFondo != null) Positioned.fill(child: Container(color: Colors.black.withOpacity(0.3))),

          Scaffold(
            backgroundColor: _imagenFondo == null ? _getColor("fondo") : Colors.transparent,
            drawer: _buildDrawer(),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: _getColor("texto")),
              actions: [
                IconButton(
                  padding: const EdgeInsets.only(right: 20),
                  icon: Icon(_modoActual == "Basic" ? Icons.science_outlined : Icons.calculate_outlined, color: _getColor("accion")),
                  onPressed: () => setState(() => _modoActual = (_modoActual == "Basic") ? "Scientific" : "Basic"),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.all(30),
                    child: FittedBox(child: Text(_pantalla, style: TextStyle(fontSize: 80, color: _getColor("texto"), fontWeight: FontWeight.w200))),
                  ),
                ),
                _buildTeclado(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: _getColor("teclado"),
      child: ListView(
        children: [
          DrawerHeader(child: Text("MENÚ", style: TextStyle(color: _getColor("accion"), fontSize: 24))),
          _itemMenu(Icons.calculate, "Calculadora", "/"),
          _itemMenu(Icons.palette, "Personalización", "/personalizar"),
          _itemMenu(Icons.grid_view, "Modelos", "/modelos"),
        ],
      ),
    );
  }

  Widget _buildTeclado() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(color: _getColor("teclado"), borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
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

  Widget _crearFila(List<String> etiquetas) => Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: etiquetas.map((e) => _buildBoton(e)).toList());

  Widget _buildBoton(String texto) {
    bool esAccion = "÷×-+= ".contains(texto) && texto != "";
    Color colorBase = esAccion ? _getColor("accion") : _getColor("boton");

    if (_temaEstacion != "Normal") {
      CustomPainter pintor;
      switch (_temaEstacion) {
        case "Verano": pintor = BotonSolPainter(colorFondo: colorBase.withOpacity(0.3), colorBorde: colorBase); break;
        case "Primavera": pintor = BotonFlorPainter(colorFondo: colorBase.withOpacity(0.3), colorBorde: colorBase); break;
        case "Otoño": pintor = BotonHojaPainter(colorFondo: colorBase.withOpacity(0.3), colorBorde: colorBase); break;
        case "Invierno": pintor = BotonGotaPainter(colorFondo: colorBase.withOpacity(0.3), colorBorde: colorBase); break;
        default: pintor = BotonSolPainter(colorFondo: colorBase, colorBorde: colorBase);
      }

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        width: 75, height: 75,
        child: CustomPaint(
          painter: pintor,
          child: InkWell(
            onTap: () => _presionarBoton(texto),
            child: Center(child: Text(texto, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _getColor("texto")))),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      width: 72, height: 72,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: colorBase, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), elevation: 0),
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
        if (resultado != null) {
          setState(() {
            if (resultado is String) _temaEstacion = resultado;
            else if (resultado is File) _imagenFondo = resultado;
          });
        }
      },
    );
  }
}

// --- PINTORES (FUERA DE LA CLASE) ---

class BotonSolPainter extends CustomPainter {
  final Color colorFondo, colorBorde;
  BotonSolPainter({required this.colorFondo, required this.colorBorde});
  @override
  void paint(Canvas canvas, Size size) {
    final pF = Paint()..color = colorFondo;
    final pB = Paint()..color = colorBorde..style = PaintingStyle.stroke..strokeWidth = 2;
    final c = Offset(size.width/2, size.height/2);
    canvas.drawCircle(c, size.width*0.3, pF);
    canvas.drawCircle(c, size.width*0.3, pB);
    for(int i=0; i<8; i++) {
      double a = i * math.pi / 4;
      canvas.drawLine(Offset(c.dx+math.cos(a)*size.width*0.35, c.dy+math.sin(a)*size.width*0.35), Offset(c.dx+math.cos(a)*size.width*0.48, c.dy+math.sin(a)*size.width*0.48), pB);
    }
  }
  @override bool shouldRepaint(CustomPainter old) => false;
}

class BotonFlorPainter extends CustomPainter {
  final Color colorFondo, colorBorde;
  BotonFlorPainter({required this.colorFondo, required this.colorBorde});
  @override
  void paint(Canvas canvas, Size size) {
    final pF = Paint()..color = colorFondo;
    final pB = Paint()..color = colorBorde..style = PaintingStyle.stroke..strokeWidth = 2;
    final c = Offset(size.width/2, size.height/2);
    for(int i=0; i<5; i++) {
      double a = i * 2 * math.pi / 5;
      canvas.drawCircle(Offset(c.dx+math.cos(a)*15, c.dy+math.sin(a)*15), 12, pF);
      canvas.drawCircle(Offset(c.dx+math.cos(a)*15, c.dy+math.sin(a)*15), 12, pB);
    }
    canvas.drawCircle(c, 8, pF);
  }
  @override bool shouldRepaint(CustomPainter old) => false;
}

class BotonHojaPainter extends CustomPainter {
  final Color colorFondo, colorBorde;
  BotonHojaPainter({required this.colorFondo, required this.colorBorde});
  @override
  void paint(Canvas canvas, Size size) {
    final pF = Paint()..color = colorFondo;
    final pB = Paint()..color = colorBorde..style = PaintingStyle.stroke..strokeWidth = 2;
    Path path = Path()..moveTo(size.width*0.5, size.height*0.1)
      ..quadraticBezierTo(size.width*0.9, size.height*0.4, size.width*0.5, size.height*0.9)
      ..quadraticBezierTo(size.width*0.1, size.height*0.4, size.width*0.5, size.height*0.1);
    canvas.drawPath(path, pF);
    canvas.drawPath(path, pB);
  }
  @override bool shouldRepaint(CustomPainter old) => false;
}

class BotonGotaPainter extends CustomPainter {
  final Color colorFondo, colorBorde;
  BotonGotaPainter({required this.colorFondo, required this.colorBorde});
  @override
  void paint(Canvas canvas, Size size) {
    final pF = Paint()..color = colorFondo;
    final pB = Paint()..color = colorBorde..style = PaintingStyle.stroke..strokeWidth = 2;
    Path path = Path()..moveTo(size.width*0.5, size.height*0.1)
      ..quadraticBezierTo(size.width*0.9, size.height*0.7, size.width*0.5, size.height*0.9)
      ..quadraticBezierTo(size.width*0.1, size.height*0.7, size.width*0.5, size.height*0.1);
    canvas.drawPath(path, pF);
    canvas.drawPath(path, pB);
  }
  @override bool shouldRepaint(CustomPainter old) => false;
}