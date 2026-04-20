import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

class CalculatorLogic {
  // Estado global para el modo de la calculadora
  static bool esGrados = true;

  static String calcular(String expresion) {
    try {
      // 1. Limpieza y reemplazo de símbolos visuales
      String exp = expresion
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('x', '*');

      // 2. Lógica de porcentaje relativo (Ej: 100 - 10% -> 100 - 10)
      final regExpRelativo = RegExp(r'(\d+\.?\d*)\s*([+\-])\s*(\d+\.?\d*)%');
      exp = exp.replaceAllMapped(regExpRelativo, (match) {
        double numBase = double.parse(match.group(1)!);
        String operador = match.group(2)!;
        double porcentaje = double.parse(match.group(3)!);
        double valorCalculado = (numBase * porcentaje) / 100;
        return "$numBase $operador $valorCalculado";
      });

      // 3. Porcentaje simple (Ej: 50% -> 0.5)
      exp = exp.replaceAll('%', '/100');

      // 4. Conversión a Grados si está activo (DEG)
      // Buscamos sin, cos, tan y convertimos lo que hay dentro de los paréntesis
      if (esGrados) {
        exp = exp.replaceAllMapped(RegExp(r'(sin|cos|tan)\(([^)]+)\)'), (match) {
          String funcion = match.group(1)!;
          String contenido = match.group(2)!;
          return "$funcion($contenido * ${math.pi} / 180)";
        });
      }

      // 5. Evaluación matemática
      Parser p = Parser();
      Expression expression = p.parse(exp);
      ContextModel cm = ContextModel();
      double eval = expression.evaluate(EvaluationType.REAL, cm);

      // 6. Formateo de resultado profesional
      if (eval.isNaN || eval.isInfinite) return "Error";

      if (eval % 1 == 0) {
        return eval.toInt().toString();
      } else {
        // Redondeo a 8 decimales para evitar basura binaria (0.0000000004)
        String res = eval.toStringAsFixed(8);
        return res.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
      }
    } catch (e) {
      return "Error";
    }
  }
}