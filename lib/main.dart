import 'package:flutter/material.dart';
import 'calculator_screen.dart';

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