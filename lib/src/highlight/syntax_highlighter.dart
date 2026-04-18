import 'package:flutter/material.dart';

/// Contrato base para todos los highlighters.
/// Cada lenguaje implementa [highlight] y devuelve una lista de [TextSpan].
abstract class SyntaxHighlighter {
  /// Recibe el código completo y devuelve los spans coloreados.
  TextSpan highlight(String code);
}
