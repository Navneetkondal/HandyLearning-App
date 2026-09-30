import 'package:flutter/material.dart';
import 'buttons_inputs_screen.dart';
import 'dialogs_feedback_screen.dart';
import 'display_widgets_screen.dart';
import 'layouts_demo_screen.dart';
import 'lists_grids_screen.dart';

/// Hub screen presenting organized categories for all basic Flutter UI components.
class UiCatalogScreen extends StatelessWidget {
  const UiCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final categories = [
      _UiCategory(
        title: 'Layout & Structure',
        subtitle: 'Row, Column, Stack, Wrap, Container, SizedBox, Expanded & Flexible',
        icon: Icons.view_quilt_rounded,
        color: const Color(0xFF2563EB),
        screen: const LayoutsDemoScreen(),
      ),
      _UiCategory(
        title: 'Buttons & Input Controls',
        subtitle: 'ElevatedButton, Outlined, Text, TextField, Checkbox, Switch, Slider, Dropdown',
        icon: Icons.smart_button_rounded,
        color: const Color(0xFF0D9488),
        screen: const ButtonsInputsScreen(),
      ),
      _UiCategory(
        title: 'Display & Visual Elements',
        subtitle: 'Text, RichText, Card, Chip, Badge, Divider, Icon & Image fallback handling',
        icon: Icons.style_rounded,
        color: const Color(0xFF7C3AED),
        screen: const DisplayWidgetsScreen(),
      ),
      _UiCategory(
        title: 'Scrollables, Lists & Grids',
        subtitle: 'ListView.builder, GridView.builder, ListTile, Dismissible viewport recycling',
        icon: Icons.view_stream_rounded,
        color: const Color(0xFFEA580C),
        screen: const ListsGridsScreen(),
      ),
      _UiCategory(
        title: 'Dialogs & Feedback',
        subtitle: 'AlertDialog, SimpleDialog, BottomSheet, SnackBar and Tooltips',
        icon: Icons.notifications_active_rounded,
        color: const Color(0xFF059669),
        screen: const DialogsFeedbackScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Components Catalog'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner
          Card(
            color: theme.colorScheme.primary.withAlpha(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.auto_stories_rounded, color: theme.colorScheme.primary, size: 36),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Flutter Basic Components',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Explore interactive sandboxes with live controls, explanations, and copyable production code.',
                          style: TextStyle(fontSize: 12.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Categories List
          ...categories.map((cat) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => cat.screen),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cat.color.withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(cat.icon, color: cat.color, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cat.subtitle,
                              style: TextStyle(
                                fontSize: 12.5,
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white60
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _UiCategory {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;

  const _UiCategory({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.screen,
  });
}
