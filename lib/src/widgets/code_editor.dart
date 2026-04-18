import 'package:flutter/material.dart';
import '../../lite_code_editor.dart';
import '../controller/code_editor_controller.dart';
import '../highlight/dart_highlighter.dart';
import '../highlight/syntax_highlighter.dart';
import 'code_field.dart';
import 'line_numbers.dart';

class CodeEditor extends StatefulWidget {
  final CodeEditorController controller;
  final EditorTheme? theme;
  final bool readOnly;
  final bool selectionMode;
  final ValueChanged<String>? onChanged;
  final void Function(int lineIndex, String lineContent)? onLineSelected;
  final List<String> customKeywords;

  const CodeEditor({
    super.key,
    required this.controller,
    this.theme,
    this.readOnly = false,
    this.selectionMode = false,
    this.onChanged,
    this.onLineSelected,
    this.customKeywords = const [],
  });

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  late final ScrollController _codeScroll;
  late final ScrollController _gutterScroll;
  List<String> _suggestions = [];

  List<String> get _allKeywords => [
    ...DartHighlighter.keywords,
    ...DartHighlighter.builtinTypes,
    ...widget.customKeywords,
  ];

  @override
  void initState() {
    super.initState();
    _codeScroll = ScrollController();
    _gutterScroll = ScrollController();
    _codeScroll.addListener(_syncGutter);
    widget.controller.addListener(_onControllerChanged);
  }

  void _syncGutter() {
    if (!_gutterScroll.hasClients) return;
    final offset = _codeScroll.offset.clamp(
      _gutterScroll.position.minScrollExtent,
      _gutterScroll.position.maxScrollExtent,
    );
    _gutterScroll.jumpTo(offset);
  }

  void _onControllerChanged() => setState(() {});

  void _onLineTap(int lineIndex) {
    widget.controller.selectLine(lineIndex);
    widget.onLineSelected?.call(lineIndex, widget.controller.lines[lineIndex]);
  }

  // ── Autocomplete ───────────────────────────────────────────────────────────

  void _onWordTyped(String word, Offset _) {
    if (word.isEmpty) {
      _clearSuggestions();
      return;
    }

    final filtered =
        _allKeywords
            .where(
              (k) =>
                  k.toLowerCase().startsWith(word.toLowerCase()) && k != word,
            )
            .toSet()
            .toList()
          ..sort();

    setState(() => _suggestions = filtered);
  }

  void _clearSuggestions() {
    if (_suggestions.isEmpty) return;
    setState(() => _suggestions = []);
  }

  void _onSuggestionSelected(String suggestion) {
    final ctrl = widget.controller;
    final text = ctrl.text;
    final cursor = ctrl.selection.baseOffset;
    if (cursor < 0) return;

    final before = text.substring(0, cursor);
    final after = text.substring(cursor);
    final wordStart = before.lastIndexOf(RegExp(r'[^a-zA-Z0-9_]')) + 1;
    final newBefore = before.substring(0, wordStart) + suggestion;
    final newText = newBefore + after;
    final newCursor = newBefore.length;

    ctrl.value = ctrl.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursor),
    );

    _clearSuggestions();
    widget.onChanged?.call(newText);
  }

  EditorTheme get _theme => widget.theme ?? EditorTheme.dark();

  @override
  void dispose() {
    _codeScroll.removeListener(_syncGutter);
    _codeScroll.dispose();
    _gutterScroll.dispose();
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lines = widget.controller.lines;

    return ScrollConfiguration(
      behavior: const _NoOverscrollBehavior(),
      child: Container(
        color: _theme.background,
        child: Column(
          children: [
            // ── Editor (gutter + código) ───────────────────────────────────
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LineNumbers(
                    lineCount: lines.length,
                    selectedLine: widget.selectionMode
                        ? widget.controller.selectedLine
                        : null,
                    theme: _theme,
                    fontSize: _theme.fontSize,
                    lineHeight: _theme.lineHeight,
                    scrollController: _gutterScroll,
                    onLineTap: null,
                  ),
                  Expanded(
                    child: widget.selectionMode
                        ? _SelectableLineList(
                            lines: lines,
                            selectedLine: widget.controller.selectedLine,
                            theme: _theme,
                            highlighter: widget.controller.highlighter,
                            scrollController: _codeScroll,
                            onLineTap: _onLineTap,
                          )
                        : CodeField(
                            controller: widget.controller,
                            theme: _theme,
                            readOnly: widget.readOnly,
                            selectionMode: false,
                            scrollController: _codeScroll,
                            customKeywords: widget.customKeywords,
                            onWordTyped: _onWordTyped,
                            onDismissAutocomplete: _clearSuggestions,
                            onChanged: widget.onChanged,
                          ),
                  ),
                ],
              ),
            ),

            // ── Barra de sugerencias horizontal (estilo teclado) ───────────
            if (_suggestions.isNotEmpty && !widget.selectionMode)
              _SuggestionsBar(
                suggestions: _suggestions,
                theme: _theme,
                onSelected: _onSuggestionSelected,
                onDismiss: _clearSuggestions,
              ),
          ],
        ),
      ),
    );
  }
}

// ── Barra horizontal de sugerencias ───────────────────────────────────────

class _SuggestionsBar extends StatelessWidget {
  final List<String> suggestions;
  final EditorTheme theme;
  final ValueChanged<String> onSelected;
  final VoidCallback onDismiss;

  const _SuggestionsBar({
    required this.suggestions,
    required this.theme,
    required this.onSelected,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFF181825),
        border: Border(
          top: BorderSide(color: const Color(0xFF3C3C6C), width: 1),
        ),
      ),
      child: Row(
        children: [
          // ── Chips scrolleables ──────────────────────────────────────────
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              itemCount: suggestions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () => onSelected(suggestions[i]),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A4A),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: const Color(0xFF569CD6),
                        width: 0.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      suggestions[i],
                      style: TextStyle(
                        fontFamily: theme.fontFamily,
                        fontSize: theme.fontSize - 2,
                        color: const Color(0xFF9CDCFE),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ── Botón cerrar ────────────────────────────────────────────────
          GestureDetector(
            onTap: onDismiss,
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Color(0xFF3C3C6C), width: 1),
                ),
              ),
              child: const Icon(
                Icons.close,
                size: 14,
                color: Color(0xFF858585),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Lista seleccionable ────────────────────────────────────────────────────

class _SelectableLineList extends StatelessWidget {
  final List<String> lines;
  final int? selectedLine;
  final EditorTheme theme;
  final SyntaxHighlighter highlighter;
  final ScrollController scrollController;
  final ValueChanged<int> onLineTap;

  const _SelectableLineList({
    required this.lines,
    required this.selectedLine,
    required this.theme,
    required this.highlighter,
    required this.scrollController,
    required this.onLineTap,
  });

  @override
  Widget build(BuildContext context) {
    final lineH = theme.fontSize * theme.lineHeight;

    return ListView.builder(
      controller: scrollController,
      physics: const ClampingScrollPhysics(),
      itemCount: lines.length,
      itemBuilder: (context, index) {
        final isSelected = selectedLine == index;
        final lineText = lines[index].isEmpty ? ' ' : lines[index];
        final span = highlighter.highlight(lineText);

        return GestureDetector(
          onTap: () => onLineTap(index),
          child: Container(
            height: lineH,
            color: isSelected
                ? theme.lineSelectedBackground
                : Colors.transparent,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: RichText(
              maxLines: 1,
              overflow: TextOverflow.visible,
              text: TextSpan(
                style: TextStyle(
                  fontFamily: theme.fontFamily,
                  fontSize: theme.fontSize,
                  height: theme.lineHeight,
                ),
                children: span.children ?? [span],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Sin overscroll ─────────────────────────────────────────────────────────

class _NoOverscrollBehavior extends ScrollBehavior {
  const _NoOverscrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const ClampingScrollPhysics();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}
