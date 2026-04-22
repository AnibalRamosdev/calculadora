import 'package:flutter/material.dart';

class PantallaModelos extends StatefulWidget {
  const PantallaModelos({super.key});

  @override
  State<PantallaModelos> createState() => _PantallaModelosState();
}

class _PantallaModelosState extends State<PantallaModelos> {
  String temaSeleccionado = "Normal";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Modelos Estacionales", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(20),
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
                _tarjetaEstacion("Normal", Icons.calculate, Colors.grey),
                _tarjetaEstacion("Primavera", Icons.local_florist, Colors.green),
                _tarjetaEstacion("Verano", Icons.wb_sunny, Colors.orange),
                _tarjetaEstacion("Otoño", Icons.park, Colors.brown),
                _tarjetaEstacion("Invierno", Icons.ac_unit, Colors.blue),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B5EFC),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () => Navigator.pop(context, temaSeleccionado),
                child: const Text("Aplicar Diseño", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaEstacion(String nombre, IconData icono, Color colorTema) {
    bool esSeleccionado = (temaSeleccionado == nombre);
    return GestureDetector(
      onTap: () => setState(() => temaSeleccionado = nombre),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF17171C),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: esSeleccionado ? colorTema : Colors.transparent, width: 3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, size: 40, color: esSeleccionado ? colorTema : Colors.grey),
            const SizedBox(height: 10),
            Text(nombre, style: TextStyle(color: esSeleccionado ? Colors.white : Colors.grey)),
          ],
        ),
      ),
    );
  }
}