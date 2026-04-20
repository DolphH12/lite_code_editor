import 'package:flutter/material.dart';

/// Defines all visual tokens of the code editor.
///
/// Use [EditorTheme.dark] or [EditorTheme.light] for built-in themes,
/// or construct your own with the default constructor.
class EditorTheme {
  /// Background color of the main code area.
  final Color background;

  /// Background color of the line number gutter.
  final Color gutterBackground;

  /// Color of the border between the gutter and the code area.
  final Color gutterBorder;

  /// Default text color for unstyled code tokens.
  final Color textColor;

  /// Color of inactive line numbers in the gutter.
  final Color gutterTextColor;

  /// Color of the line number for the active or selected line.
  final Color gutterTextColorActive;

  /// Background color of a selected line in selection mode.
  final Color lineSelectedBackground;

  /// Background color of the line where the cursor is placed.
  final Color lineHighlightBackground;

  /// Color of the text cursor.
  final Color cursorColor;

  /// Color of the text selection highlight.
  final Color selectionColor;

  /// Font family used for all code text.
  final String fontFamily;

  /// Font size in logical pixels for all code text.
  final double fontSize;

  /// Line height multiplier applied to all code lines.
  final double lineHeight;

  /// Creates a fully custom [EditorTheme].
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

  /// A dark theme inspired by VS Code Dark+.
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

  /// A clean light theme for bright UI environments.
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
