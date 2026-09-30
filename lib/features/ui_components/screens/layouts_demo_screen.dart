import 'package:flutter/material.dart';
import '../../../core/widgets/code_snippet_card.dart';
import '../../../core/widgets/interactive_demo_box.dart';
import '../../../core/widgets/section_header.dart';

/// Screen teaching foundational Flutter layout widgets:
/// Row, Column, Stack, Wrap, Container, SizedBox, Expanded, Flexible, and Alignment.
class LayoutsDemoScreen extends StatefulWidget {
  const LayoutsDemoScreen({super.key});

  @override
  State<LayoutsDemoScreen> createState() => _LayoutsDemoScreenState();
}

class _LayoutsDemoScreenState extends State<LayoutsDemoScreen> {
  // Row/Column Interactive Controls
  MainAxisAlignment _mainAxisAlignment = MainAxisAlignment.center;
  final CrossAxisAlignment _crossAxisAlignment = CrossAxisAlignment.center;
  bool _isRow = true;

  // Stack Interactive Controls
  Alignment _stackAlignment = Alignment.topRight;

  // Container Controls
  double _containerWidth = 140;
  double _containerHeight = 80;
  double _borderRadius = 12;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Layout Widgets Lab'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Intro Card
          Card(
            color: theme.colorScheme.primary.withAlpha(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.dashboard_customize_rounded,
                      color: theme.colorScheme.primary, size: 32),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Flutter Layout Engine',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Widgets render based on box constraints: "Constraints go down. Sizes go up. Parent sets position."',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SECTION 1: Row & Column
          const SectionHeader(
            title: '1. Row & Column',
            subtitle: 'Linear layouts for horizontal (Row) or vertical (Column) arrangement.',
            icon: Icons.view_column_rounded,
            badgeText: 'Fundamental',
          ),
          InteractiveDemoBox(
            label: _isRow ? 'Row Layout' : 'Column Layout',
            controls: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Direction: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ChoiceChip(
                      label: const Text('Row (Horizontal)'),
                      selected: _isRow,
                      onSelected: (val) => setState(() => _isRow = true),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Column (Vertical)'),
                      selected: !_isRow,
                      onSelected: (val) => setState(() => _isRow = false),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('MainAxis: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(width: 8),
                    DropdownButton<MainAxisAlignment>(
                      value: _mainAxisAlignment,
                      isDense: true,
                      items: MainAxisAlignment.values.map((alignment) {
                        return DropdownMenuItem(
                          value: alignment,
                          child: Text(alignment.name, style: const TextStyle(fontSize: 13)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _mainAxisAlignment = val);
                      },
                    ),
                  ],
                ),
              ],
            ),
            child: Container(
              height: 160,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _isRow
                  ? Row(
                      mainAxisAlignment: _mainAxisAlignment,
                      crossAxisAlignment: _crossAxisAlignment,
                      children: _buildDemoBoxes(),
                    )
                  : Column(
                      mainAxisAlignment: _mainAxisAlignment,
                      crossAxisAlignment: _crossAxisAlignment,
                      children: _buildDemoBoxes(),
                    ),
            ),
          ),
          const CodeSnippetCard(
            title: 'Row & Column Example',
            code: '''Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Widget1(),
    Expanded(child: Widget2()), // Takes remaining horizontal space
    Widget3(),
  ],
)''',
            explanation:
                'MainAxis is horizontal for Row and vertical for Column. Expanded forces a child to fill remaining available space.',
          ),

          // SECTION 2: Stack & Positioned
          const SectionHeader(
            title: '2. Stack & Positioned',
            subtitle: 'Layer multiple widgets on top of each other in 3D depth.',
            icon: Icons.layers_rounded,
            badgeText: 'Layering',
          ),
          InteractiveDemoBox(
            label: 'Stack Alignment Playground',
            controls: Row(
              children: [
                const Text('Badge Alignment: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                DropdownButton<Alignment>(
                  value: _stackAlignment,
                  isDense: true,
                  items: const [
                    DropdownMenuItem(value: Alignment.topRight, child: Text('Top Right')),
                    DropdownMenuItem(value: Alignment.topLeft, child: Text('Top Left')),
                    DropdownMenuItem(value: Alignment.bottomRight, child: Text('Bottom Right')),
                    DropdownMenuItem(value: Alignment.center, child: Text('Center')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _stackAlignment = val);
                  },
                ),
              ],
            ),
            child: Center(
              child: SizedBox(
                width: 200,
                height: 120,
                child: Stack(
                  children: [
                    // Base Layer
                    Container(
                      width: 200,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade600, Colors.purple.shade600],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Base Stack Layer',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Positioned / Aligned Floating Badge
                    Align(
                      alignment: _stackAlignment,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 4),
                          ],
                        ),
                        child: const Text(
                          '★ Stacked Overlay',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const CodeSnippetCard(
            title: 'Stack with Positioned Example',
            code: '''Stack(
  children: [
    Image.network('...'), // Background
    Positioned(
      top: 16,
      right: 16,
      child: FavoriteIconBadge(),
    ),
  ],
)''',
            explanation:
                'Widgets in a Stack are painted bottom-to-top. Use Positioned to pin coordinates (top, left, right, bottom).',
          ),

          // SECTION 3: Wrap Widget
          const SectionHeader(
            title: '3. Wrap Widget',
            subtitle: 'Flows children to the next line when space runs out, preventing overflow errors.',
            icon: Icons.wrap_text_rounded,
            badgeText: 'Overflow Safe',
          ),
          InteractiveDemoBox(
            label: 'Wrap Tags Preview',
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                'Flutter',
                'Dart',
                'Widgets',
                'Stateless',
                'Stateful',
                'Cubit',
                'Repository',
                'Clean Architecture',
                'Material 3',
              ].map((tag) {
                return Chip(
                  avatar: CircleAvatar(
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(tag[0], style: const TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                  label: Text(tag),
                );
              }).toList(),
            ),
          ),
          const CodeSnippetCard(
            title: 'Wrap Example',
            code: '''Wrap(
  spacing: 8.0,    // Gap between adjacent chips
  runSpacing: 8.0,// Gap between lines
  children: tags.map((t) => Chip(label: Text(t))).toList(),
)''',
            explanation:
                'Unlike Row which will crash with a Yellow-and-Black stripe RenderFlex overflow when exceeding width, Wrap wraps children onto new lines.',
          ),

          // SECTION 4: Container & SizedBox
          const SectionHeader(
            title: '4. Container & SizedBox',
            subtitle: 'The fundamental styling and spacing building blocks.',
            icon: Icons.check_box_outline_blank_rounded,
            badgeText: 'Styling',
          ),
          InteractiveDemoBox(
            label: 'Container Customization',
            controls: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Width: ${_containerWidth.toInt()}dp | Height: ${_containerHeight.toInt()}dp | Radius: ${_borderRadius.toInt()}dp',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                Slider(
                  value: _containerWidth,
                  min: 80,
                  max: 260,
                  onChanged: (val) => setState(() => _containerWidth = val),
                ),
                Slider(
                  value: _containerHeight,
                  min: 40,
                  max: 120,
                  onChanged: (val) => setState(() => _containerHeight = val),
                ),
                Slider(
                  value: _borderRadius,
                  min: 0,
                  max: 32,
                  onChanged: (val) => setState(() => _borderRadius = val),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: _containerWidth,
                height: _containerHeight,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(_borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withAlpha(80),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Styled Container',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const CodeSnippetCard(
            title: 'Container vs SizedBox Best Practice',
            code: '''// Use SizedBox when you only need width, height, or spacing (cheaper render):
const SizedBox(height: 16);
const SizedBox(width: 100, height: 100, child: MyWidget());

// Use Container when you need decoration (color, border, radius, shadow, padding):
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.grey),
  ),
  child: MyWidget(),
);''',
            explanation:
                'Performance tip: If you only need fixed dimensions or empty spacing, always prefer const SizedBox over Container.',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  List<Widget> _buildDemoBoxes() {
    return [
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
        child: const Center(child: Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      ),
      const SizedBox(width: 8, height: 8),
      Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(8)),
        child: const Center(child: Text('2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      ),
      const SizedBox(width: 8, height: 8),
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)),
        child: const Center(child: Text('3', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      ),
    ];
  }
}
