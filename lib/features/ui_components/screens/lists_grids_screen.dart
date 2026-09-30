import 'package:flutter/material.dart';
import '../../../core/widgets/code_snippet_card.dart';
import '../../../core/widgets/interactive_demo_box.dart';
import '../../../core/widgets/section_header.dart';

/// Screen teaching efficient scrollables:
/// ListView.builder, ListView.separated, GridView.builder, ListTile, Dismissible.
class ListsGridsScreen extends StatefulWidget {
  const ListsGridsScreen({super.key});

  @override
  State<ListsGridsScreen> createState() => _ListsGridsScreenState();
}

class _ListsGridsScreenState extends State<ListsGridsScreen> {
  bool _isGrid = false;
  final int _itemCount = 8;
  int? _selectedIndex;

  late List<String> _items;

  @override
  void initState() {
    super.initState();
    _resetItems();
  }

  void _resetItems() {
    _items = List.generate(_itemCount, (i) => 'Item #${i + 1} - Flutter Widget');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scrollable Lists & Grids'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Intro
          Card(
            color: theme.colorScheme.secondary.withAlpha(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.view_agenda_rounded, color: theme.colorScheme.secondary, size: 32),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Viewport Recycling (Lazy Loading)',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ListView.builder only allocates memory and renders widgets that are currently visible on the screen.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SECTION 1: Interactive List / Grid Toggle
          SectionHeader(
            title: _isGrid ? '1. GridView.builder' : '1. ListView.separated',
            subtitle: 'Toggle between lazy vertical list and responsive 2-column grid.',
            icon: _isGrid ? Icons.grid_view_rounded : Icons.list_alt_rounded,
            badgeText: 'Lazy Rendering',
          ),
          InteractiveDemoBox(
            label: _isGrid ? 'GridView Playground' : 'ListView Playground (Swipe to dismiss)',
            controls: Row(
              children: [
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('List View'), icon: Icon(Icons.list)),
                    ButtonSegment(value: true, label: Text('Grid View'), icon: Icon(Icons.grid_view)),
                  ],
                  selected: {_isGrid},
                  onSelectionChanged: (set) {
                    setState(() => _isGrid = set.first);
                  },
                ),
                const Spacer(),
                IconButton.filledTonal(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Reset items',
                  onPressed: () => setState(_resetItems),
                ),
              ],
            ),
            child: SizedBox(
              height: 300,
              child: _isGrid ? _buildGridView(theme) : _buildListView(theme),
            ),
          ),
          const CodeSnippetCard(
            title: 'ListView.separated Pattern',
            code: '''ListView.separated(
  itemCount: items.length,
  separatorBuilder: (context, index) => const Divider(height: 1),
  itemBuilder: (context, index) {
    final item = items[index];
    return ListTile(
      leading: CircleAvatar(child: Text('\${index + 1}')),
      title: Text(item.title),
      subtitle: Text(item.description),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => onSelect(item),
    );
  },
);''',
            explanation:
                'itemBuilder is called on-demand as the user scrolls. Never use Column inside SingleChildScrollView for large lists.',
          ),

          // SECTION 2: GridView.builder Code
          const CodeSnippetCard(
            title: 'GridView.builder with FixedCrossAxisCount',
            code: '''GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,       // 2 columns
    crossAxisSpacing: 10,   // horizontal space
    mainAxisSpacing: 10,    // vertical space
    childAspectRatio: 1.2,  // width-to-height ratio
  ),
  itemCount: items.length,
  itemBuilder: (context, index) => ProductCard(items[index]),
);''',
            explanation:
                'SliverGridDelegateWithFixedCrossAxisCount locks the number of columns. For auto-responsive columns based on screen width, use SliverGridDelegateWithMaxCrossAxisExtent.',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildListView(ThemeData theme) {
    return ListView.separated(
      itemCount: _items.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = _items[index];
        final isSelected = _selectedIndex == index;

        return Dismissible(
          key: Key(item),
          background: Container(
            color: Colors.redAccent,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: const Icon(Icons.delete_outline, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.redAccent,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete_outline, color: Colors.white),
          ),
          onDismissed: (_) {
            setState(() {
              _items.removeAt(index);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Dismissed "$item"')),
            );
          },
          child: ListTile(
            selected: isSelected,
            selectedTileColor: theme.colorScheme.primary.withAlpha(25),
            leading: CircleAvatar(
              backgroundColor: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
              foregroundColor: isSelected ? Colors.white : theme.colorScheme.onSurface,
              child: Text('${index + 1}'),
            ),
            title: Text(item, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            subtitle: const Text('Swipe left/right to dismiss or tap to select', style: TextStyle(fontSize: 12)),
            trailing: Icon(
              isSelected ? Icons.check_circle_rounded : Icons.chevron_right_rounded,
              color: isSelected ? theme.colorScheme.primary : Colors.grey,
            ),
            onTap: () {
              setState(() {
                _selectedIndex = isSelected ? null : index;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildGridView(ThemeData theme) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.15,
      ),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped Card #${index + 1}')),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.widgets_rounded, color: theme.colorScheme.primary, size: 30),
                  const SizedBox(height: 8),
                  Text(
                    'Card #${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  const Text('Grid Cell', style: TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
