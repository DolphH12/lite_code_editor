import 'package:flutter/material.dart';

/// Define todos los colores del editor.
class EditorTheme {
  // Fondo
  final Color background;
  final Color gutterBackground; // fondo de la columna de números
  final Color gutterBorder;

  // Texto base
  final Color textColor;
  final Color gutterTextColor;
  final Color gutterTextColorActive; // número de la línea activa

  // Línea seleccionada
  final Color lineSelectedBackground;
  final Color lineHighlightBackground; // línea donde está el cursor (edición)

  // Cursor y selección de texto
  final Color cursorColor;
  final Color selectionColor;

  // Fuente
  final String fontFamily;
  final double fontSize;
  final double lineHeight;

  const EditorTheme({
    required this.background,
    required this.gutterBackground,
    required this.gutterBorder,
    required this.textColor,
    required this.gutterTextColor,
    required this.gutterTextColorActive,
    required this.lineSelectedBackground,
    required this.lineHighlightBackground,
    required this.cursorColor,
    required this.selectionColor,
    required this.fontFamily,
    required this.fontSize,
    required this.lineHeight,
  });

  /// Tema oscuro estilo VS Code.
  factory EditorTheme.dark() => const EditorTheme(
    background: Color(0xFF1E1E2E),
    gutterBackground: Color(0xFF1E1E2E),
    gutterBorder: Color(0xFF3C3C3C),
    textColor: Color(0xFFD4D4D4),
    gutterTextColor: Color(0xFF858585),
    gutterTextColorActive: Color(0xFFCCCCCC),
    lineSelectedBackground: Color(0xFF2D4F6C),
    lineHighlightBackground: Color(0xFF2A2A2A),
    cursorColor: Color(0xFFAEAFAD),
    selectionColor: Color(0x664D9AFF),
    fontFamily: 'monospace',
    fontSize: 14,
    lineHeight: 1.5,
  );

  /// Tema claro (para uso futuro).
  factory EditorTheme.light() => const EditorTheme(
    background: Color(0xFFFFFFFF),
    gutterBackground: Color(0xFFF3F3F3),
    gutterBorder: Color(0xFFE0E0E0),
    textColor: Color(0xFF1E1E1E),
    gutterTextColor: Color(0xFF999999),
    gutterTextColorActive: Color(0xFF333333),
    lineSelectedBackground: Color(0xFFADD6FF),
    lineHighlightBackground: Color(0xFFF5F5F5),
    cursorColor: Color(0xFF000000),
    selectionColor: Color(0x664D9AFF),
    fontFamily: 'monospace',
    fontSize: 14,
    lineHeight: 1.5,
  );
}
