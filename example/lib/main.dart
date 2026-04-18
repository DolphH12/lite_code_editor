import 'package:flutter/material.dart';
import 'package:lite_code_editor/lite_code_editor.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiteCodeEditor Demo',
      theme: ThemeData.dark(),
      home: const EditorDemoPage(),
    );
  }
}

class EditorDemoPage extends StatefulWidget {
  const EditorDemoPage({super.key});

  @override
  State<EditorDemoPage> createState() => _EditorDemoPageState();
}

class _EditorDemoPageState extends State<EditorDemoPage> {
  late final CodeEditorController _controller;

  String _lastChanged = '';
  int? _selectedLineIndex;
  String? _selectedLineContent;
  bool _selectionMode = false;

  @override
  void initState() {
    super.initState();
    _controller = CodeEditorController(
      language: CodeLanguage.dart,
      initialCode: _sampleCode,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LiteCodeEditor — Fase 1'),
        actions: [
          // Toggle modo selección
          Row(
            children: [
              const Text('Selección'),
              Switch(
                value: _selectionMode,
                onChanged: (v) => setState(() {
                  _selectionMode = v;
                  _controller.selectLine(null);
                }),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Editor ────────────────────────────────────────────────────────
          Expanded(
            child: // En el widget CodeEditor del ejemplo agrega:
            CodeEditor(
              controller: _controller,
              theme: EditorTheme.dark(),
              selectionMode: _selectionMode,
              customKeywords: const [
                'runApp',
                'setState',
                'initState',
                'dispose',
                'BuildContext',
                'StatelessWidget',
                'StatefulWidget',
                'MaterialApp',
                'Scaffold',
                'AppBar',
                'Column',
                'Row',
                'Text',
                'Container',
                'Expanded',
                'Padding',
              ],
              onChanged: (code) => setState(() => _lastChanged = code),
              onLineSelected: (index, content) => setState(() {
                _selectedLineIndex = index;
                _selectedLineContent = content.trim();
              }),
            ),
          ),

          // ── Panel de debug ────────────────────────────────────────────────
          Container(
            color: const Color(0xFF252526),
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectionMode
                      ? 'MODO SELECCIÓN — toca un número de línea'
                      : 'MODO EDICIÓN — escribe libremente',
                  style: const TextStyle(
                    color: Color(0xFF569CD6),
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
                if (_selectionMode && _selectedLineIndex != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Línea seleccionada: ${_selectedLineIndex! + 1}',
                    style: const TextStyle(
                      color: Color(0xFF9CDCFE),
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Contenido: ${_selectedLineContent?.trim()}',
                    style: const TextStyle(
                      color: Color(0xFFCE9178),
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  'Total líneas: ${_controller.lines.length}',
                  style: const TextStyle(
                    color: Color(0xFF858585),
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Código de muestra ──────────────────────────────────────────────────────────

const _sampleCode = '''
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hello World'),
        ),
        body: const Center(
          child: Text('Hello, Flutter!'),
        ),
      ),
    );
  }
}
''';
