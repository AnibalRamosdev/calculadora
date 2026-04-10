import 'package:math_expressions/math_expressions.dart';

class CalculatorLogic {
  static String calcular(String expresion) {
    try {
      // Reemplazamos los símbolos visuales por los que entiende la librería
      String finalExp = expresion
          .replaceAll('×', '*') // El símbolo de multiplicación de tu UI
          .replaceAll('x', '*') // Por si usas x minúscula
          .replaceAll('÷', '/'); // El símbolo de división de tu UI

      Parser p = Parser();
      Expression exp = p.parse(finalExp);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      // Si el resultado es entero, quitamos el .0
      return (eval % 1 == 0) ? eval.toInt().toString() : eval.toString();
    } catch (e) {
      return 'Error';
    }
  }
}