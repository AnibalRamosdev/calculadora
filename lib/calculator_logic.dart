import 'package:math_expressions/math_expressions.dart';

class CalculatorLogic {
  static String calcular(String expresion) {
    try {
      // 1. Limpieza de símbolos visuales
      String exp = expresion
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('x', '*');

      // 2. Lógica de porcentaje relativo (Ej: 100 - 10%)
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

      // 4. Procesar con la librería math_expressions
      Parser p = Parser();
      Expression expression = p.parse(exp);
      ContextModel cm = ContextModel();
      double eval = expression.evaluate(EvaluationType.REAL, cm);

      // 5. Formateo de salida
      if (eval % 1 == 0) {
        return eval.toInt().toString();
      } else {
        String res = eval.toStringAsFixed(8);
        return res.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
      }
    } catch (e) {
      return "Error";
    }
  }
}