import 'package:flutter/material.dart';

/// Master / Principal Architect Level: Flutter Engine Internals.
/// Covers: The Three Trees, Custom RenderBox, PipelineOwner, and Dart FFI Interop.
class EngineInternalsScreen extends StatelessWidget {
  const EngineInternalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Engine & RenderObjects'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF581C87), const Color(0xFF1E293B)]
                    : [const Color(0xFF9333EA), const Color(0xFF7E22CE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MASTER / ARCHITECT LEVEL',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'The Three Trees & Engine Internals',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Understand how Flutter renders pixels from scratch: Widget Tree ➔ Element Tree ➔ RenderObject Tree, layout protocols, custom RenderBoxes, and Dart FFI native interop.',
                  style: TextStyle(color: Colors.white, fontSize: 13, height: 1.35),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Live Custom RenderObject Demo
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.purple.withAlpha(120), width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Live Custom RenderBox Demo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'This widget does not use Container, Column, or CustomPaint. It subclasses LeafRenderObjectWidget directly to implement its own sizing, layout, and canvas drawing on the GPU pipeline.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Custom RenderObject in action
                  Center(
                    child: _CustomCheckerboardWidget(
                      primaryColor: isDark ? Colors.purple.shade400 : Colors.purple.shade700,
                      secondaryColor: isDark ? Colors.purple.shade900 : Colors.purple.shade100,
                      boxSize: const Size(200, 100),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Section 1: The Three Trees Architecture
          Text(
            'The Three Trees of Flutter',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _buildTreeCard(
            '1. Widget Tree (The Blueprint)',
            'Immutable, ephemeral configuration. Recreated hundreds of times per second with negligible cost. Does not hold state or layout geometry.',
            const Color(0xFF2563EB),
            Icons.widgets_rounded,
          ),
          const SizedBox(height: 8),
          _buildTreeCard(
            '2. Element Tree (The Brain / Manager)',
            'Persistent graph of elements. Manages widget lifecycle, handles diffing (Widget.canUpdate: runtimeType && key), and holds pointers to corresponding RenderObjects.',
            const Color(0xFF0D9488),
            Icons.account_tree_rounded,
          ),
          const SizedBox(height: 8),
          _buildTreeCard(
            '3. RenderObject Tree (The Geometry & Renderer)',
            'Mutable, long-lived objects. Calculates layout constraints, determines exact pixel dimensions (Size), handles hit testing, and issues Skia/Impeller GPU draw calls.',
            const Color(0xFF9333EA),
            Icons.brush_rounded,
          ),

          const SizedBox(height: 20),

          // Section 2: Layout Protocol
          Text(
            'The Golden Law of Flutter Layout',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '1. Constraints go down (Parent passes min/max width & height to child).\n'
                '2. Sizes go up (Child chooses its Size within given constraints and informs parent).\n'
                '3. Parents decide positions (Parent positions child inside its coordinate space).',
                style: TextStyle(fontFamily: 'monospace', fontSize: 13, height: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Section 3: Native FFI Interop
          Text(
            'Dart FFI & Native Code Assets (C/C++ / Rust)',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Direct Dynamic Linking without MethodChannel Serialization Overhead:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '// Call native C library directly at C-speed:\n'
                      'typedef NativeSum = Int32 Function(Int32 a, Int32 b);\n'
                      'typedef DartSum = int Function(int a, int b);\n'
                      'final dylib = DynamicLibrary.open("libcalc.dylib");\n'
                      'final DartSum nativeSum = dylib.lookupFunction<NativeSum, DartSum>("sum");\n'
                      'final result = nativeSum(40, 2); // 42 without IPC overhead!',
                      style: TextStyle(fontFamily: 'monospace', color: Colors.greenAccent, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeCard(String title, String description, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 12.5, height: 1.35)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom LeafRenderObjectWidget demonstrating zero-boilerplate direct RenderBox creation
class _CustomCheckerboardWidget extends LeafRenderObjectWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Size boxSize;

  const _CustomCheckerboardWidget({
    required this.primaryColor,
    required this.secondaryColor,
    required this.boxSize,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCheckerboard(
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      boxSize: boxSize,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant _RenderCheckerboard renderObject) {
    renderObject
      ..primaryColor = primaryColor
      ..secondaryColor = secondaryColor
      ..boxSize = boxSize;
  }
}

class _RenderCheckerboard extends RenderBox {
  Color _primaryColor;
  Color _secondaryColor;
  Size _boxSize;

  _RenderCheckerboard({
    required this._primaryColor,
    required this._secondaryColor,
    required this._boxSize,
  });

  set primaryColor(Color value) {
    if (_primaryColor == value) return;
    _primaryColor = value;
    markNeedsPaint();
  }

  set secondaryColor(Color value) {
    if (_secondaryColor == value) return;
    _secondaryColor = value;
    markNeedsPaint();
  }

  set boxSize(Size value) {
    if (_boxSize == value) return;
    _boxSize = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    size = constraints.constrain(_boxSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final cellWidth = size.width / 4;
    final cellHeight = size.height / 2;

    for (int row = 0; row < 2; row++) {
      for (int col = 0; col < 4; col++) {
        final paint = Paint()
          ..color = (row + col) % 2 == 0 ? _primaryColor : _secondaryColor;
        final rect = Rect.fromLTWH(
          offset.dx + (col * cellWidth),
          offset.dy + (row * cellHeight),
          cellWidth,
          cellHeight,
        );
        canvas.drawRect(rect, paint);
      }
    }
  }
}
