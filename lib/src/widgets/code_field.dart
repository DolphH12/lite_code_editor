import 'package:flutter/material.dart';
import '../../lite_code_editor.dart';

class CodeField extends StatefulWidget {
  final CodeEditorController controller;
  final EditorTheme theme;
  final bool readOnly;
  final bool selectionMode;
  final ValueChanged<String>? onChanged;
  final ScrollController scrollController;
  final List<String> customKeywords;
  final void Function(String word, Offset caretGlobalOffset)? onWordTyped;
  final VoidCallback? onDismissAutocomplete;

  const CodeField({
    super.key,
    required this.controller,
    required this.theme,
    required this.scrollController,
    this.readOnly = false,
    this.selectionMode = false,
    this.onChanged,
    this.customKeywords = const [],
    this.onWordTyped,
    this.onDismissAutocomplete,
  });

  @override
  State<CodeField> createState() => _CodeFieldState();
}

class _CodeFieldState extends State<CodeField> {
  final ScrollController _hScroll = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _fieldKey = GlobalKey(); // key del TextField
  String _previousText = '';

  @override
  void initState() {
    super.initState();
    _previousText = widget.controller.text;
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) widget.onDismissAutocomplete?.call();
    });
  }

  @override
  void dispose() {
    _hScroll.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ── Auto-indent ────────────────────────────────────────────────────────────

  void _handleChanged(String newText) {
    final prev = _previousText;
    final cursor = widget.controller.selection.baseOffset;

    if (newText.length == prev.length + 1 && cursor > 0) {
      final inserted = newText[cursor - 1];
      if (inserted == '\n') {
        final beforeNewline = newText.substring(0, cursor - 1);
        final lineStart = beforeNewline.lastIndexOf('\n') + 1;
        final currentLine = beforeNewline.substring(lineStart);

        final indentMatch = RegExp(r'^\s*').firstMatch(currentLine);
        var indent = indentMatch?[0] ?? '';

        if (currentLine.trimRight().endsWith('{')) indent += '  ';

        if (indent.isNotEmpty) {
          final fixed =
              newText.substring(0, cursor) + indent + newText.substring(cursor);
          final newCursor = cursor + indent.length;

          widget.controller.value = widget.controller.value.copyWith(
            text: fixed,
            selection: TextSelection.collapsed(offset: newCursor),
          );

          _previousText = fixed;
          widget.onChanged?.call(fixed);
          widget.onWordTyped?.call('', Offset.zero);
          return;
        }
      }
    }

    _previousText = newText;
    widget.onChanged?.call(newText);
    _notifyWord(newText, cursor);
  }

  // ── Posición global del caret ──────────────────────────────────────────────

  void _notifyWord(String fullText, int cursor) {
    if (cursor < 0 || cursor > fullText.length) return;

    final before = fullText.substring(0, cursor);
    final match = RegExp(r'[a-zA-Z_]\w*$').firstMatch(before);
    final word = match?[0] ?? '';

    if (word.isEmpty) {
      widget.onWordTyped?.call('', Offset.zero);
      return;
    }

    widget.onWordTyped?.call(word, _getCaretGlobalOffset(fullText, cursor));
  }

  Offset _getCaretGlobalOffset(String text, int cursor) {
    try {
      // 1. Medir el texto hasta el cursor
      final style = TextStyle(
        fontFamily: widget.theme.fontFamily,
        fontSize: widget.theme.fontSize,
        height: widget.theme.lineHeight,
      );

      final painter = TextPainter(
        text: TextSpan(text: text.substring(0, cursor), style: style),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: double.infinity);

      final localCaret = painter.getOffsetForCaret(
        TextPosition(offset: cursor),
        Rect.zero,
      );

      // 2. Origen global del TextField
      final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) return Offset.zero;

      final fieldOrigin = box.localToGlobal(Offset.zero);

      // 3. Scroll vertical actual
      final scrollDy = widget.scrollController.hasClients
          ? widget.scrollController.offset
          : 0.0;

      // 4. Combinar: origen del field + posición del caret - scroll + 1 línea de altura
      return Offset(
        fieldOrigin.dx + localCaret.dx + 12, // padding horizontal del TextField
        fieldOrigin.dy +
            localCaret.dy -
            scrollDy +
            widget.theme.fontSize * widget.theme.lineHeight,
      );
    } catch (_) {
      return Offset.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _hScroll,
      physics: const ClampingScrollPhysics(),
      child: IntrinsicWidth(
        child: TextField(
          key: _fieldKey, // ← aquí la key
          controller: widget.controller,
          focusNode: _focusNode,
          readOnly: widget.readOnly || widget.selectionMode,
          maxLines: null,
          expands: true,
          scrollController: widget.scrollController,
          scrollPhysics: const ClampingScrollPhysics(),
          style: TextStyle(
            fontFamily: widget.theme.fontFamily,
            fontSize: widget.theme.fontSize,
            height: widget.theme.lineHeight,
            color: widget.theme.textColor,
          ),
          cursorColor: widget.theme.cursorColor,
          decoration: const InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
          ),
          onChanged: _handleChanged,
        ),
      ),
    );
  }
}
