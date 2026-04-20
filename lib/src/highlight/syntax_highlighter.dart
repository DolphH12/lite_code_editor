import 'package:flutter/material.dart';

/// Base contract for all syntax highlighters.
///
/// Each language implements [highlight] and returns a [TextSpan] tree
/// with colored children, one per token.
abstract class SyntaxHighlighter {
  /// Receives the full [code] string and returns a [TextSpan] with
  /// colored children ready to be rendered by a [RichText] or
  /// [TextEditingController.buildTextSpan].
  TextSpan highlight(String code);
}
