import 'package:flutter/material.dart';
import '../../lite_code_editor.dart';

class LineNumbers extends StatelessWidget {
  final int lineCount;
  final int? selectedLine;
  final int? activeLine;
  final EditorTheme theme;
  final double lineHeight;
  final double fontSize;
  final ScrollController scrollController;
  final ValueChanged<int>? onLineTap;

  const LineNumbers({
    super.key,
    required this.lineCount,
    required this.theme,
    required this.lineHeight,
    required this.fontSize,
    required this.scrollController,
    this.selectedLine,
    this.activeLine,
    this.onLineTap,
  });

  @override
  Widget build(BuildContext context) {
    final digits = lineCount.toString().length;
    final gutterWidth = (digits * fontSize * 0.65 + 15).clamp(30.0, 80.0);

    return Container(
      width: gutterWidth,
      decoration: BoxDecoration(
        color: theme.gutterBackground,
        border: Border(right: BorderSide(color: theme.gutterBorder, width: 1)),
      ),
      child: ListView.builder(
        controller: scrollController,
        // ── Clave: misma física + sin rebote ──────────────────────────────
        physics: const NeverScrollableScrollPhysics(),
        itemCount: lineCount,
        itemBuilder: (context, index) {
          final isSelected = selectedLine == index;
          final isActive = activeLine == index;

          return GestureDetector(
            onTap: onLineTap != null ? () => onLineTap!(index) : null,
            child: Container(
              height: fontSize * lineHeight,
              color: isSelected
                  ? theme.lineSelectedBackground
                  : Colors.transparent,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontFamily: theme.fontFamily,
                  fontSize: fontSize,
                  height: lineHeight,
                  color: isSelected || isActive
                      ? theme.gutterTextColorActive
                      : theme.gutterTextColor,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
