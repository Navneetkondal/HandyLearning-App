import 'package:flutter/material.dart';
import '../../../core/widgets/code_snippet_card.dart';
import '../../../core/widgets/interactive_demo_box.dart';
import '../../../core/widgets/section_header.dart';

/// Screen teaching dialogs, bottom sheets, snackbars, and tooltips.
class DialogsFeedbackScreen extends StatelessWidget {
  const DialogsFeedbackScreen({super.key});

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 36),
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this resource? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.of(ctx).pop();
              _showSnackBar(context, 'Resource deleted successfully!', isError: true);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSimpleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Select Primary Language'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(ctx).pop('Dart');
              _showSnackBar(context, 'Selected Dart');
            },
            child: const Text('🎯 Dart (Flutter)'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(ctx).pop('Kotlin');
              _showSnackBar(context, 'Selected Kotlin');
            },
            child: const Text('🤖 Kotlin (Android)'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(ctx).pop('Swift');
              _showSnackBar(context, 'Selected Swift');
            },
            child: const Text('🍎 Swift (iOS)'),
          ),
        ],
      ),
    );
  }

  void _showModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Modal Bottom Sheet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text('Great for quick context actions, filtering, or share menus.'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Share Project'),
              onTap: () => Navigator.of(ctx).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_border_outlined),
              title: const Text('Bookmark for Later'),
              onTap: () => Navigator.of(ctx).pop(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : null,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.amber,
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialogs & User Feedback'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          const SectionHeader(
            title: '1. Modals & Overlays',
            subtitle: 'Prompting decisions and presenting supplementary sheets.',
            icon: Icons.layers_outlined,
            badgeText: 'Feedback',
          ),
          InteractiveDemoBox(
            label: 'Interactive Dialog Triggers',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showAlertDialog(context),
                  icon: const Icon(Icons.warning_amber_rounded),
                  label: const Text('Show AlertDialog'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _showSimpleDialog(context),
                  icon: const Icon(Icons.list_alt_rounded),
                  label: const Text('Show SimpleDialog'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showModalSheet(context),
                  icon: const Icon(Icons.vertical_align_top_rounded),
                  label: const Text('Show Bottom Sheet'),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => _showSnackBar(context, 'This is a floating SnackBar!'),
                  icon: const Icon(Icons.message_rounded),
                  label: const Text('Show SnackBar'),
                ),
              ],
            ),
          ),
          const CodeSnippetCard(
            title: 'AlertDialog & Navigator.pop Pattern',
            code: '''showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Title'),
    content: const Text('Message details...'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          // execute action
        },
        child: const Text('Confirm'),
      ),
    ],
  ),
);''',
            explanation:
                'Dialogs return a Future that completes when dismissed. Always close dialogs via Navigator.pop(context) before executing follow-up UI transitions.',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
