import 'package:flutter/material.dart';

/// Paleta de colores estilo VS Code Dark+ por tipo de token.
class HighlightColors {
  // ── Dark theme ─────────────────────────────────────────────────────────────
  static const Color keyword = Color(
    0xFF569CD6,
  ); // azul    → void, class, if...
  static const Color builtinType = Color(
    0xFF4EC9B0,
  ); // verde azulado → int, String, bool...
  static const Color modifier = Color(
    0xFF569CD6,
  ); // azul    → final, const, static...
  static const Color string = Color(0xFFCE9178); // naranja → 'texto', "texto"
  static const Color stringInterp = Color(
    0xFF9CDCFE,
  ); // celeste → $variable dentro del string
  static const Color comment = Color(0xFF6A9955); // verde   → // comentario
  static const Color number = Color(0xFFB5CEA8); // verde claro → 123, 3.14
  static const Color dartDoc = Color(0xFF608B4E); // verde oscuro → /// doc
  static const Color annotation = Color(0xFFDCDCAA); // amarillo → @override
  static const Color className = Color(0xFF4EC9B0); // verde azulado → MyClass
  static const Color functionName = Color(
    0xFFDCDCAA,
  ); // amarillo → myFunction()
  static const Color parameter = Color(0xFF9CDCFE); // celeste  → parámetros
  static const Color punctuation = Color(0xFFD4D4D4); // blanco gris → { } ( ) ;
  static const Color plainText = Color(
    0xFFD4D4D4,
  ); // blanco gris → texto normal
  static const Color importPath = Color(0xFFCE9178); // naranja → 'package:...'
}
