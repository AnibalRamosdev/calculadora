import 'package:math_expressions/math_expressions.dart';

class CalculatorLogic {
  static String calcular(String expresion) {
    try {
      // 1. Limpieza de símbolos visuales
      String exp = expresion
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('x', '*');

      // 2. LÓGICA DE PORCENTAJE RELATIVO (Ej: 100 - 10%)
      // Esta expresión regular busca: Numero, Operador (+ o -), y otro Numero con %
      final regExpRelativo = RegExp(r'(\d+\.?\d*)\s*([+\-])\s*(\d+\.?\d*)%');

      exp = exp.replaceAllMapped(regExpRelativo, (match) {
        double numBase = double.parse(match.group(1)!);
        String operador = match.group(2)!;
        double porcentaje = double.parse(match.group(3)!);

        // Calculamos el porcentaje basado en el primer número
        double valorCalculado = (numBase * porcentaje) / 100;
        return "$numBase $operador $valorCalculado";
      });

      // 3. LÓGICA DE PORCENTAJE SIMPLE (Ej: 50% * 2)
      // Si queda algún % suelto, lo dividimos por 100
      exp = exp.replaceAll('%', '/100');

      // 4. PROCESAR CON LA LIBRERÍA
      Parser p = Parser();
      Expression expression = p.parse(exp);
      ContextModel cm = ContextModel();
      double eval = expression.evaluate(EvaluationType.REAL, cm);

      // 5. FORMATEO FINAL
      if (eval % 1 == 0) {
        return eval.toInt().toString();
      } else {
        // Redondeo para evitar errores de precisión (ej: 0.000000004)
        String res = eval.toStringAsFixed(10);
        return res.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
      }
    } catch (e) {
      return "Error";
    }
  }
}