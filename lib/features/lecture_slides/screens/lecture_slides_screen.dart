import 'package:flutter/material.dart';

/// Interactive Lecture Slide Deck for instructors and students.
/// Enables seamless presentation mode on mobile, tablet, desktop, or projector.
class LectureSlidesScreen extends StatefulWidget {
  const LectureSlidesScreen({super.key});

  @override
  State<LectureSlidesScreen> createState() => _LectureSlidesScreenState();
}

class _LectureSlidesScreenState extends State<LectureSlidesScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_LectureSlideData> _slides = [
    const _LectureSlideData(
      number: 1,
      badge: 'LESSON 1',
      title: 'The Flutter Mental Model',
      subtitle: 'Understanding Declarative UI and the Golden Formula',
      bulletPoints: [
        'Declarative Paradigm: UI = f(State). Never mutate existing DOM/views in-place.',
        'Widget Tree vs Element Tree: Widgets are cheap, immutable blueprints. Elements manage lifecycle.',
        'Flutter updates pixels at 60/120 FPS by diffing widget subtrees.',
        'Everything is a Widget: Layout, padding, theme, and gestures are all composed as widgets.',
      ],
      codeSnippet: '''// Declarative UI Formula:
Widget build(BuildContext context) {
  return Text(state.userGreeting);
}''',
      speakerTip: 'Emphasize to students that calling build() is fast and cheap. Flutter only repaints changed pixels.',
    ),
    const _LectureSlideData(
      number: 2,
      badge: 'LESSON 2',
      title: 'UI Components & Box Constraints',
      subtitle: 'The Core Layout Rules and Component Family',
      bulletPoints: [
        'The Golden Box Rule: "Constraints go down. Sizes go up. Parent sets position."',
        'Row & Column: Linear layouts with MainAxisAlignment and CrossAxisAlignment.',
        'Stack & Positioned: 3D depth layering on the Z-axis (ideal for badges and image overlays).',
        'Wrap: Overflow-safe flow layout that wraps onto subsequent lines.',
        'ListView.builder: Viewport recycling memory optimization for large or infinite datasets.',
      ],
      codeSnippet: '''// Viewport recycling for 1000 items:
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, i) => ListTile(title: Text(items[i])),
);''',
      speakerTip: 'Warn students: NEVER use Column inside SingleChildScrollView for unbounded lists!',
    ),
    const _LectureSlideData(
      number: 3,
      badge: 'LESSON 3',
      title: 'Stateless vs Stateful Widgets',
      subtitle: 'Immutability, setState(), and the State Lifecycle',
      bulletPoints: [
        'StatelessWidget (stless): 100% immutable. All fields are final. Has only build(context).',
        'StatefulWidget (stful): Paired with a mutable State<T> object that survives rebuilds.',
        'setState(): Marks the Element dirty and schedules the next frame build.',
        'Lifecycle Order: createState ➔ initState ➔ didChangeDependencies ➔ build ➔ dispose.',
        'Golden Rule: Use stless for 90% of views. Use stful only for local controllers (Text, Scroll, Animation).',
      ],
      codeSnippet: '''@override
void dispose() {
  _controller.dispose(); // Always clean up controllers!
  super.dispose();
}''',
      speakerTip: 'Show students the side-by-side demo in the app where stless variable mutation fails to redraw.',
    ),
    const _LectureSlideData(
      number: 4,
      badge: 'LESSON 4',
      title: 'State Architecture Principles',
      subtitle: 'Ephemeral vs App State & The 4 Canonical States',
      bulletPoints: [
        'Ephemeral (Local) State: Widget-local (checkbox, text input) ➔ Managed via setState.',
        'App (Shared) State: Across multiple screens (User session, cart, theme) ➔ Managed via Cubit/Bloc.',
        'The 4 Canonical States: Initial ➔ Loading ➔ Success (Loaded) ➔ Error (with Retry).',
        'Immutability: Always emit a new copy (copyWith) so reactive frameworks detect changes.',
        'Equatable: Replaces reference equality with value equality, preventing redundant widget rebuilds.',
      ],
      codeSnippet: '''sealed class ProductState extends Equatable {
  const ProductState();
}
class ProductLoading extends ProductState {}
class ProductLoaded extends ProductState {
  final List<Product> items;
  const ProductLoaded(this.items);
}''',
      speakerTip: 'Ask students what happens when two regular Dart objects with the same properties are compared with ==.',
    ),
    const _LectureSlideData(
      number: 5,
      badge: 'LESSON 5',
      title: 'Cubit State Management',
      subtitle: 'Functions Emit States with Flutter BLoC',
      bulletPoints: [
        'What is Cubit? A streamlined BLoC without event classes. UI calls methods; Cubit calls emit(newState).',
        'BlocBuilder: Renders and rebuilds UI when state transitions occur.',
        'BlocListener: Executes one-off side-effects (SnackBars, navigation, dialogs).',
        'BlocConsumer: Combines builder and listener into a single widget.',
        'Performance Rule: Use context.read() inside callbacks; use BlocBuilder or context.select() inside build().',
      ],
      codeSnippet: '''class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  void increment() => emit(state + 1);
}''',
      speakerTip: 'Explain why navigating inside a build() method throws an exception, and why BlocListener solves it.',
    ),
    const _LectureSlideData(
      number: 6,
      badge: 'LESSON 6',
      title: 'The Repository Pattern',
      subtitle: 'Clean Architecture Data Flow & Error Translation',
      bulletPoints: [
        'Separation of Concerns: UI ➔ Cubit ➔ Repository Contract ➔ Repository Impl ➔ DataSource.',
        'Abstract Interface: The domain contract decouples business logic from HTTP, Dio, or SQLite.',
        'Exception Translation: Raw 500/timeout exceptions are translated into domain UserOperationExceptions.',
        '100% Testability: Swap in a MockDataSource or MockRepository with zero real network calls.',
        'Offline & Cache Ready: The repository implementation can fall back to local disk storage seamlessly.',
      ],
      codeSnippet: '''abstract class UserRepository {
  Future<List<User>> getUsers();
}''',
      speakerTip: 'Demonstrate the "Simulate Network Outage" switch in the Repository studio screen.',
    ),
    const _LectureSlideData(
      number: 7,
      badge: 'LESSON 7',
      title: 'Top Pitfalls & Interview Q&A',
      subtitle: 'Essential Rules for Production Flutter Apps',
      bulletPoints: [
        'Pitfall 1: RenderFlex yellow/black stripe overflows ➔ Wrap in Expanded or Wrap.',
        'Pitfall 2: Mutating state in-place ➔ Always emit new state copies via copyWith.',
        'Pitfall 3: Forgetting to dispose controllers ➔ Clean up in State.dispose().',
        'Interview Question: "Why does Flutter use an Element tree between Widgets and RenderObjects?"',
        'Answer: Widgets are immutable configurations recreated often; Elements persist and manage state efficiently.',
      ],
      codeSnippet: '''// Always add const to static constructors:
const SizedBox(height: 16);''',
      speakerTip: 'Congratulate your students on completing the core architecture curriculum!',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextSlide() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevSlide() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lecture Slide ${_currentPage + 1} of ${_slides.length}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
            tooltip: 'Previous Slide',
            onPressed: _currentPage > 0 ? _prevSlide : null,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
            tooltip: 'Next Slide',
            onPressed: _currentPage < _slides.length - 1 ? _nextSlide : null,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentPage + 1) / _slides.length,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _slides.length,
        onPageChanged: (i) => setState(() => _currentPage = i),
        itemBuilder: (context, index) {
          final slide = _slides[index];

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Slide Header Banner
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF1E3A8A), const Color(0xFF1E293B)]
                        : [const Color(0xFF2563EB), const Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(40),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        slide.badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      slide.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      slide.subtitle,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Core Points Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle_outline_rounded,
                              color: theme.colorScheme.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Key Teaching Takeaways',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      ...slide.bulletPoints.map((point) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  point,
                                  style: const TextStyle(fontSize: 13.5, height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Code Syntax Box
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFF0F172A),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.terminal_rounded, color: Colors.blueAccent, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Code Reference Blueprint',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SelectableText(
                        slide.codeSnippet,
                        style: const TextStyle(
                          fontFamily: 'Courier',
                          fontSize: 12.5,
                          color: Color(0xFFE2E8F0),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Speaker Teaching Tip Callout
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.amber.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withAlpha(60)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.school_rounded, color: Colors.amber, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Instructor Teaching Tip:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            slide.speakerTip,
                            style: TextStyle(
                              fontSize: 12.5,
                              height: 1.35,
                              color: isDark ? Colors.white70 : const Color(0xFF451A03),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            border: Border(top: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                onPressed: _currentPage > 0 ? _prevSlide : null,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Previous'),
              ),
              Text(
                'Slide ${_currentPage + 1} of ${_slides.length}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              ElevatedButton.icon(
                onPressed: _currentPage < _slides.length - 1 ? _nextSlide : null,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next Slide'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LectureSlideData {
  final int number;
  final String badge;
  final String title;
  final String subtitle;
  final List<String> bulletPoints;
  final String codeSnippet;
  final String speakerTip;

  const _LectureSlideData({
    required this.number,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.bulletPoints,
    required this.codeSnippet,
    required this.speakerTip,
  });
}
