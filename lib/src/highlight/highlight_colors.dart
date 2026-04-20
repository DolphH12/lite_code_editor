import 'package:flutter/material.dart';

/// Color palette for syntax tokens, based on the VS Code Dark+ theme.
///
/// All colors are intended for use on dark backgrounds. For light
/// themes, override [EditorTheme] with your own token colors.
class HighlightColors {
  /// Color for Dart keywords such as `void`, `class`, `if`, `return`.
  static const Color keyword = Color(0xFF569CD6);

  /// Color for built-in types such as `int`, `String`, `bool`.
  static const Color builtinType = Color(0xFF4EC9B0);

  /// Color for modifier keywords such as `final`, `const`, `static`.
  static const Color modifier = Color(0xFF569CD6);

  /// Color for string literals.
  static const Color string = Color(0xFFCE9178);

  /// Color for string interpolation expressions (`$var`, `${expr}`).
  static const Color stringInterp = Color(0xFF9CDCFE);

  /// Color for single-line comments (`//`).
  static const Color comment = Color(0xFF6A9955);

  /// Color for plain text and unclassified tokens.
  static const Color plainText = Color(0xFFD4D4D4);

  /// Color for DartDoc comments (`///`).
  static const Color dartDoc = Color(0xFF608B4E);

  /// Color for annotations such as `@override`.
  static const Color annotation = Color(0xFFDCDCAA);

  /// Color for class names in UpperCamelCase.
  static const Color className = Color(0xFF4EC9B0);

  /// Color for function and method names.
  static const Color functionName = Color(0xFFDCDCAA);

  /// Color for parameters.
  static const Color parameter = Color(0xFF9CDCFE);

  /// Color for punctuation characters such as `{`, `}`, `(`, `)`.
  static const Color punctuation = Color(0xFFD4D4D4);

  /// Color for numeric literals.
  static const Color number = Color(0xFFB5CEA8);

  /// Color for import path strings.
  static const Color importPath = Color(0xFFCE9178);
}
