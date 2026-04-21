// 1. IMPORTACIONES
import 'package:flutter/material.dart';

class PantallaConfiguracion extends StatefulWidget {
  const PantallaConfiguracion({super.key});

  @override
  State<PantallaConfiguracion> createState() => _PantallaConfiguracionState();
}

class _PantallaConfiguracionState extends State<PantallaConfiguracion> {
  // Estados de los interruptores (Switches)
  bool _vibracion = true;
  bool _mantenerPantalla = false;
  bool _historial = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Configuración"),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text("AJUSTES DE INTERFAZ", style: TextStyle(color: Color(0xFF4B5EFC), fontWeight: FontWeight.bold)),
          ),

          // Interruptor para la vibración (UX que ya programamos)
          _crearAjuste(
            titulo: "Vibración al tocar",
            subtitulo: "Feedback háptico en cada botón",
            valor: _vibracion,
            onChanged: (val) => setState(() => _vibracion = val),
          ),

          _crearAjuste(
            titulo: "Mantener pantalla encendida",
            subtitulo: "Evita que el móvil se bloquee al usar la app",
            valor: _mantenerPantalla,
            onChanged: (val) => setState(() => _mantenerPantalla = val),
          ),

          const Divider(color: Colors.white10),

          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text("SISTEMA", style: TextStyle(color: Color(0xFF4B5EFC), fontWeight: FontWeight.bold)),
          ),

          _crearAjuste(
            titulo: "Guardar Historial",
            subtitulo: "Almacena tus últimas 20 operaciones",
            valor: _historial,
            onChanged: (val) => setState(() => _historial = val),
          ),

          const ListTile(
            title: Text("Idioma de la aplicación"),
            subtitle: Text("Español (España)"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ],
      ),
    );
  }

  // WIDGET AUXILIAR: Crea un interruptor de ajuste con estilo limpio
  Widget _crearAjuste({required String titulo, required String subtitulo, required bool valor, required Function(bool) onChanged}) {
    return SwitchListTile(
      title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitulo, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      value: valor,
      activeColor: const Color(0xFF4B5EFC), // Azul de tu Figma
      onChanged: onChanged,
    );
  }
}