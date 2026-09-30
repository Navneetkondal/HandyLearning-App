import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/code_snippet_card.dart';
import '../../../core/widgets/interactive_demo_box.dart';
import '../../../core/widgets/section_header.dart';

// ==========================================
// CHALLENGE 2 STATE & CUBIT (Search Filter)
// ==========================================
sealed class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<String> results;
  final String query;
  const SearchLoaded({required this.results, required this.query});
  @override
  List<Object?> get props => [results, query];
}

class SearchCubit extends Cubit<SearchState> {
  static const List<String> allFrameworks = [
    'Flutter (Dart)',
    'React Native (JS/TS)',
    'SwiftUI (Swift)',
    'Jetpack Compose (Kotlin)',
    'Angular (TypeScript)',
    'Vue.js (JavaScript)',
    'Next.js (React)',
    'Svelte (JavaScript)',
    'Django (Python)',
    'Spring Boot (Java)',
  ];

  SearchCubit() : super(const SearchInitial());

  Future<void> filter(String query) async {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());
    // Simulate realistic 300ms search latency
    await Future.delayed(const Duration(milliseconds: 300));

    final filtered = allFrameworks
        .where((item) => item.toLowerCase().contains(cleanQuery))
        .toList();

    emit(SearchLoaded(results: filtered, query: query));
  }
}

// ==========================================
// CHALLENGE 3 STATE & CUBIT (Auth Repository)
// ==========================================
abstract class AuthRepository {
  Future<bool> login(String email, String password);
}

class MockAuthRepository implements AuthRepository {
  bool forceFail = true;

  @override
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (forceFail) {
      forceFail = false; // toggle so next retry succeeds!
      throw Exception('401 Unauthorized: Invalid credentials or network glitch.');
    }
    forceFail = true; // reset
    return true;
  }
}

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final String userEmail;
  const AuthSuccess(this.userEmail);
  @override
  List<Object?> get props => [userEmail];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;
  AuthCubit(this.repository) : super(const AuthInitial());

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());
    try {
      await repository.login(email, password);
      emit(AuthSuccess(email));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void reset() => emit(const AuthInitial());
}

// ==========================================
// MAIN SCREEN
// ==========================================
class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  // Challenge 1 state: Lightbulb
  bool _isLightOn = false;

  late final SearchCubit _searchCubit;
  late final AuthCubit _authCubit;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchCubit = SearchCubit();
    _authCubit = AuthCubit(MockAuthRepository());
  }

  @override
  void dispose() {
    _searchCubit.close();
    _authCubit.close();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Challenges Lab'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Banner
          Card(
            color: const Color(0xFF10B981).withAlpha(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events_rounded, color: Color(0xFF10B981), size: 36),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hands-On Coding Challenges',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Test your students on setState mechanics, Cubit search debouncing, and Repository error handling with Retry.',
                          style: TextStyle(fontSize: 12.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // CHALLENGE 1
          const SectionHeader(
            title: 'Challenge 1: The Lightbulb Toggle',
            subtitle: 'Build a StatefulWidget that toggles a lightbulb icon and text using setState().',
            icon: Icons.lightbulb_rounded,
            badgeText: 'StatefulWidget',
          ),
          InteractiveDemoBox(
            label: 'Challenge 1 Live Sandbox',
            child: Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isLightOn = !_isLightOn;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isLightOn ? Colors.amber.withAlpha(50) : (isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0)),
                        boxShadow: _isLightOn
                            ? [
                                BoxShadow(
                                  color: Colors.amber.withAlpha(120),
                                  blurRadius: 30,
                                  spreadRadius: 6,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        _isLightOn ? Icons.lightbulb_rounded : Icons.lightbulb_outline_rounded,
                        size: 60,
                        color: _isLightOn ? Colors.amber : Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _isLightOn ? '💡 Light is ON' : '🌑 Light is OFF',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _isLightOn ? Colors.amber.shade700 : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Tap the bulb above to trigger setState()',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ),
          const CodeSnippetCard(
            title: 'Challenge 1 Solution',
            code: '''class LightBulbWidget extends StatefulWidget {
  @override
  State<LightBulbWidget> createState() => _LightBulbWidgetState();
}

class _LightBulbWidgetState extends State<LightBulbWidget> {
  bool _isOn = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(Icons.lightbulb, color: _isOn ? Colors.amber : Colors.grey),
          onPressed: () => setState(() => _isOn = !_isOn),
        ),
        Text(_isOn ? 'Light is ON' : 'Light is OFF'),
      ],
    );
  }
}''',
            explanation:
                'Demonstrates basic setState() lifecycle. Tapping the bulb calls setState(), scheduling the next frame to repaint the color.',
          ),

          // CHALLENGE 2
          const SectionHeader(
            title: 'Challenge 2: Search Filter with Cubit',
            subtitle: 'Type in the box to trigger SearchCubit.filter() with 300ms simulated latency.',
            icon: Icons.search_rounded,
            badgeText: 'Cubit + State',
          ),
          InteractiveDemoBox(
            label: 'SearchCubit Sandbox',
            child: Column(
              children: [
                TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    labelText: 'Search frameworks (e.g. Flutter, Swift, React)...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchCtrl.clear();
                              _searchCubit.filter('');
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  onChanged: (query) {
                    _searchCubit.filter(query);
                    setState(() {});
                  },
                ),
                const SizedBox(height: 12),
                BlocBuilder<SearchCubit, SearchState>(
                  bloc: _searchCubit,
                  builder: (context, state) {
                    return switch (state) {
                      SearchInitial() => const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('Type a query to search technologies in real-time',
                              style: TextStyle(color: Colors.grey, fontSize: 13)),
                        ),
                      SearchLoading() => const Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                              SizedBox(width: 12),
                              Text('Filtering results...', style: TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                      SearchLoaded(results: final res, query: final q) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Found ${res.length} matches for "$q":',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 6),
                            if (res.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(12),
                                child: Text('No frameworks found matching your query.',
                                    style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                              )
                            else
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: res.map((item) => Chip(label: Text(item))).toList(),
                              ),
                          ],
                        ),
                    };
                  },
                ),
              ],
            ),
          ),

          // CHALLENGE 3
          const SectionHeader(
            title: 'Challenge 3: Repository Pattern with Retry',
            subtitle: 'Simulates a 50% network failure rate with automatic recovery on Retry.',
            icon: Icons.replay_rounded,
            badgeText: 'Clean Architecture',
          ),
          InteractiveDemoBox(
            label: 'AuthRepository Studio',
            child: BlocConsumer<AuthCubit, AuthState>(
              bloc: _authCubit,
              listener: (context, state) {
                if (state is AuthSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Welcome back, ${state.userEmail}!'), backgroundColor: Colors.green),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    switch (state) {
                      AuthInitial() => Column(
                          children: [
                            const Text('Simulate user login with failure and retry handling:'),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () => _authCubit.login('student@flutter.dev', 'password123'),
                              icon: const Icon(Icons.login),
                              label: const Text('Log In via AuthRepository'),
                            ),
                          ],
                        ),
                      AuthLoading() => const Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 10),
                              Text('Calling AuthRepository.login()...', style: TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                      AuthSuccess(userEmail: final email) => Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 40),
                              const SizedBox(height: 8),
                              Text('Authenticated as $email',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () => _authCubit.reset(),
                                child: const Text('Reset Challenge'),
                              ),
                            ],
                          ),
                        ),
                      AuthError(message: final err) => Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.withAlpha(50)),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.error_outline_rounded, color: Colors.red, size: 40),
                              const SizedBox(height: 6),
                              const Text('Authentication Failed (Simulated)',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                              const SizedBox(height: 4),
                              Text(err, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
                                onPressed: () => _authCubit.login('student@flutter.dev', 'password123'),
                                icon: const Icon(Icons.replay, color: Colors.white),
                                label: const Text('Retry Login', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                    },
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
