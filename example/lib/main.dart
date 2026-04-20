import 'package:flutter/material.dart';
import 'package:lite_code_editor/lite_code_editor.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiteCodeEditor Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF12121F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF569CD6),
          surface: Color(0xFF1E1E2E),
        ),
      ),
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
  bool _selectionMode = false;
  int? _selectedLineIndex;
  String? _selectedLineContent;

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

  void _onSubmit() {
    final code = _controller.code;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Text(
          'Código capturado',
          style: TextStyle(color: Color(0xFF569CD6), fontSize: 16),
        ),
        content: Text(
          '${_controller.lines.length} líneas · '
          '${code.length} caracteres',
          style: const TextStyle(color: Color(0xFFD4D4D4)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Título ───────────────────────────────────────────────────
              const Text(
                'Editor de código',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4D4D4),
                  letterSpacing: 0.3,
                ),
              ),

              const SizedBox(height: 8),

              // ── Descripción ──────────────────────────────────────────────
              const Text(
                'Escribe o pega tu código Dart. Puedes editar libremente '
                'o activar el modo selección para elegir una línea específica.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF858585),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 6),

              // ── Toggle modo selección ────────────────────────────────────
              Row(
                children: [
                  const Text(
                    'Modo selección',
                    style: TextStyle(fontSize: 13, color: Color(0xFF9CDCFE)),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: _selectionMode,
                    activeThumbColor: const Color(0xFF569CD6),
                    onChanged: (v) => setState(() {
                      _selectionMode = v;
                      _controller.selectLine(null);
                      _selectedLineIndex = null;
                      _selectedLineContent = null;
                    }),
                  ),
                  if (_selectionMode && _selectedLineIndex != null) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Línea ${_selectedLineIndex! + 1}: '
                        '${_selectedLineContent?.trim() ?? ''}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: Color(0xFFCE9178),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 12),

              // ── Editor ───────────────────────────────────────────────────
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF3C3C6C),
                        width: 1,
                      ),
                    ),
                    child: CodeEditor(
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
                      onChanged: (code) => setState(() {}),
                      onLineSelected: (index, content) => setState(() {
                        _selectedLineIndex = index;
                        _selectedLineContent = content;
                      }),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Info líneas + botón ──────────────────────────────────────
              Row(
                children: [
                  Text(
                    '${_controller.lines.length} líneas  ·  '
                    '${_controller.code.length} caracteres',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF585870),
                      fontFamily: 'monospace',
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _onSubmit,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF569CD6),
                      foregroundColor: const Color(0xFF12121F),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Guardar código',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Código de muestra ──────────────────────────────────────────────────────

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
