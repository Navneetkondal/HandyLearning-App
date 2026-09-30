import 'package:flutter/material.dart';
import '../../../core/widgets/code_snippet_card.dart';
import '../../../core/widgets/interactive_demo_box.dart';
import '../../../core/widgets/section_header.dart';

/// Screen teaching display and informational widgets:
/// Text, RichText, Card, Chip, Badge, Divider, Icon, and Image loading.
class DisplayWidgetsScreen extends StatelessWidget {
  const DisplayWidgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Display & Visual Widgets'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // SECTION 1: Text & RichText
          const SectionHeader(
            title: '1. Text & RichText',
            subtitle: 'Typography hierarchy and formatted inline text spans.',
            icon: Icons.text_fields_rounded,
            badgeText: 'Typography',
          ),
          InteractiveDemoBox(
            label: 'Typography Hierarchy & Styling',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Display Large: Flutter UI',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('Headline Medium: Building declarative trees',
                    style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
                const SizedBox(height: 6),
                Text(
                  'Body Medium: This is standard readable body text. In Flutter, widgets are rebuilt whenever state changes, ensuring responsive and declarative screen updates.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                // RichText Example
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      children: [
                        const TextSpan(text: 'RichText allows '),
                        TextSpan(
                          text: 'multiple inline styles ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const TextSpan(text: 'such as '),
                        const TextSpan(
                          text: 'underlined text, ',
                          style: TextStyle(decoration: TextDecoration.underline),
                        ),
                        TextSpan(
                          text: 'colored accents, ',
                          style: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: 'and different font sizes inside a single paragraph.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const CodeSnippetCard(
            title: 'RichText & TextSpan Pattern',
            code: '''RichText(
  text: TextSpan(
    style: TextStyle(color: Colors.black, fontSize: 16),
    children: [
      TextSpan(text: 'Normal text and '),
      TextSpan(
        text: 'Bold Highlight',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    ],
  ),
);''',
            explanation:
                'Use RichText when a single sentence or paragraph requires varied colors, weights, or clickable inline links.',
          ),

          // SECTION 2: Card, Badge & Chip
          const SectionHeader(
            title: '2. Card, Chip & Badge',
            subtitle: 'Surfacing grouped content, metadata chips, and notification badges.',
            icon: Icons.credit_card_rounded,
            badgeText: 'Surfaces',
          ),
          InteractiveDemoBox(
            label: 'Surface & Meta Elements',
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Badge(
                              label: const Text('3'),
                              backgroundColor: Colors.red,
                              child: const Icon(Icons.notifications_rounded, size: 28),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Flutter Card Component',
                                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                  const Text('Container with elevation & rounded corners',
                                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Divider(),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            Chip(
                              avatar: const Icon(Icons.star, size: 16, color: Colors.amber),
                              label: const Text('Featured'),
                            ),
                            Chip(
                              avatar: const Icon(Icons.timer_outlined, size: 16),
                              label: const Text('5 min read'),
                            ),
                            ActionChip(
                              avatar: const Icon(Icons.share_outlined, size: 16),
                              label: const Text('Share'),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // SECTION 3: Image & Network Handling
          const SectionHeader(
            title: '3. Images & Fallbacks',
            subtitle: 'Handling placeholders, loading states, and error builders properly.',
            icon: Icons.image_rounded,
            badgeText: 'Media',
          ),
          InteractiveDemoBox(
            label: 'Network Image with Loading & Error Builder',
            child: Row(
              children: [
                // Simulated Loaded Image / Gradient Placeholder
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade700, Colors.cyan.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_outlined, color: Colors.white, size: 36),
                        SizedBox(height: 6),
                        Text(
                          'Local / Asset Image',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Network Image with Error Builder
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      'https://invalid-broken-url-for-demo.com/image.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                          padding: const EdgeInsets.all(8),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image_rounded, color: Colors.redAccent, size: 32),
                              SizedBox(height: 4),
                              Text(
                                'Error Builder Fallback',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.redAccent),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const CodeSnippetCard(
            title: 'Production-Safe Image.network',
            code: '''Image.network(
  imageUrl,
  fit: BoxFit.cover,
  loadingBuilder: (context, child, progress) {
    if (progress == null) return child; // Fully loaded!
    return const Center(child: CircularProgressIndicator());
  },
  errorBuilder: (context, error, stackTrace) {
    return const Icon(Icons.broken_image, color: Colors.red);
  },
);''',
            explanation:
                'Never use Image.network without errorBuilder in production. If the user is offline or the URL fails, errorBuilder prevents a crash.',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
