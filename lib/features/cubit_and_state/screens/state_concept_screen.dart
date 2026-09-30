import 'package:flutter/material.dart';
import '../../../core/widgets/code_snippet_card.dart';
import '../../../core/widgets/interactive_demo_box.dart';
import '../../../core/widgets/section_header.dart';

/// Screen teaching foundational state concepts:
/// UI = f(State), Ephemeral vs App State, and the 4 Canonical UI States.
class StateConceptScreen extends StatefulWidget {
  const StateConceptScreen({super.key});

  @override
  State<StateConceptScreen> createState() => _StateConceptScreenState();
}

class _StateConceptScreenState extends State<StateConceptScreen> {
  _DemoUiState _simulatedState = _DemoUiState.initial;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('State Architecture & Principles'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Banner
          Card(
            color: const Color(0xFF0D9488).withAlpha(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.hub_rounded, color: Color(0xFF0D9488), size: 36),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'The Golden Equation: UI = f(State)',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Flutter is declarative. You do not manually manipulate DOM or widget nodes; you change the state, and Flutter reconstructs the UI.',
                          style: TextStyle(fontSize: 12.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SECTION 1: The 4 Canonical UI States
          const SectionHeader(
            title: '1. The 4 Canonical UI States',
            subtitle: 'Every production async screen in Flutter transitions across these 4 states.',
            icon: Icons.alt_route_rounded,
            badgeText: 'Architecture',
          ),
          InteractiveDemoBox(
            label: 'State Machine Simulator',
            controls: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _DemoUiState.values.map((s) {
                return ChoiceChip(
                  label: Text(s.name.toUpperCase()),
                  selected: _simulatedState == s,
                  onSelected: (val) {
                    if (val) setState(() => _simulatedState = s);
                  },
                );
              }).toList(),
            ),
            child: Container(
              height: 180,
              alignment: Alignment.center,
              child: _buildStateView(theme),
            ),
          ),
          const CodeSnippetCard(
            title: 'Sealed Class Pattern for the 4 States',
            code: '''// Dart 3 Sealed Class hierarchy for pristine pattern matching:
sealed class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {
  final List<Product> products;
  const ProductSuccess(this.products);
  @override
  List<Object?> get props => [products];
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);
  @override
  List<Object?> get props => [message];
}''',
            explanation:
                'Using sealed classes guarantees exhaustive switch expressions in UI builders, preventing forgotten edge cases or missing error states.',
          ),

          // SECTION 2: Ephemeral vs App State
          const SectionHeader(
            title: '2. Ephemeral State vs App State',
            subtitle: 'Know where your data belongs in the application.',
            icon: Icons.table_chart_rounded,
          ),
          Table(
            border: TableBorder.all(
              color: theme.brightness == Brightness.dark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(10),
            ),
            columnWidths: const {
              0: FlexColumnWidth(1.2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1.5),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(20),
                ),
                children: const [
                  Padding(padding: EdgeInsets.all(10), child: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.all(10), child: Text('Examples', style: TextStyle(fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.all(10), child: Text('Tool of Choice', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
              const TableRow(
                children: [
                  Padding(padding: EdgeInsets.all(10), child: Text('Ephemeral (Local)', style: TextStyle(fontWeight: FontWeight.w600))),
                  Padding(padding: EdgeInsets.all(10), child: Text('TextEditingController, PageView index, simple accordion toggle')),
                  Padding(padding: EdgeInsets.all(10), child: Text('StatefulWidget / setState')),
                ],
              ),
              const TableRow(
                children: [
                  Padding(padding: EdgeInsets.all(10), child: Text('App State (Shared)', style: TextStyle(fontWeight: FontWeight.w600))),
                  Padding(padding: EdgeInsets.all(10), child: Text('User Auth session, Shopping Cart, API Data, App Theme')),
                  Padding(padding: EdgeInsets.all(10), child: Text('Cubit + Repository')),
                ],
              ),
            ],
          ),

          // SECTION 3: Why Immutability & Equatable
          const SectionHeader(
            title: '3. Why Immutability & Equatable?',
            subtitle: 'Preventing phantom mutations and avoiding redundant widget repaints.',
            icon: Icons.lock_outline_rounded,
            badgeText: 'Equatable',
          ),
          const CodeSnippetCard(
            title: 'Object Reference vs Value Equality in Dart',
            code: '''class RegularState {
  final int count;
  RegularState(this.count);
}

// Dart compares memory references by default:
final a = RegularState(5);
final b = RegularState(5);
print(a == b); // ❌ FALSE! Different memory addresses!

// With Equatable:
class EquatableState extends Equatable {
  final int count;
  const EquatableState(this.count);
  @override
  List<Object?> get props => [count];
}

final x = EquatableState(5);
final y = EquatableState(5);
print(x == y); // ✅ TRUE! Same values in props!''',
            explanation:
                'BLoC and Cubit use == to check if the new state differs from the old state. Without Equatable, emitting a new instance with the exact same values triggers an unnecessary widget rebuild!',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStateView(ThemeData theme) {
    switch (_simulatedState) {
      case _DemoUiState.initial:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty_rounded, size: 40, color: Colors.grey.shade500),
            const SizedBox(height: 8),
            const Text('Initial State: Idle', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Text('Awaiting user interaction or search query', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        );
      case _DemoUiState.loading:
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Loading State: Fetching remote data...', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        );
      case _DemoUiState.success:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_rounded, size: 44, color: Colors.green),
            const SizedBox(height: 8),
            const Text('Success State: Data Ready!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Text('Showing 12 items populated in list', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        );
      case _DemoUiState.error:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 44, color: Colors.red),
            const SizedBox(height: 8),
            const Text('Error State: Network Timeout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
            const SizedBox(height: 6),
            ElevatedButton.icon(
              onPressed: () => setState(() => _simulatedState = _DemoUiState.loading),
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Retry Request'),
            ),
          ],
        );
    }
  }
}

enum _DemoUiState { initial, loading, success, error }
