import 'package:flutter/material.dart';

/// Model representing a lesson in the SwiftUI & Modern iOS track.
class SwiftUiLesson {
  final int id;
  final String title;
  final String subtitle;
  final String tag;
  final IconData icon;
  final Color color;
  final List<String> bulletPoints;
  final String swiftCodeSnippet;
  final String flutterEquivalentSnippet;
  final String architecturalExplanation;

  const SwiftUiLesson({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.icon,
    required this.color,
    required this.bulletPoints,
    required this.swiftCodeSnippet,
    required this.flutterEquivalentSnippet,
    required this.architecturalExplanation,
  });
}

final List<SwiftUiLesson> swiftUiLessons = [
  const SwiftUiLesson(
    id: 1,
    title: 'Declarative Views & Modifiers',
    subtitle: 'The View protocol, some View, and view composition',
    tag: 'Fundamentals',
    icon: Icons.layers_outlined,
    color: Color(0xFF0284C7),
    bulletPoints: [
      'In SwiftUI, all UI components conform to the View protocol.',
      'body is a computed property returning "some View" (opaque return type).',
      'View modifiers (e.g. .padding(), .background()) wrap and return modified views.',
      'Views are immutable value structs (cheap to allocate and recreate).',
    ],
    swiftCodeSnippet: '''// SwiftUI Declarative View
struct ProfileBadgeView: View {
    let name: String
    let role: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(name)
                .font(.headline)
                .foregroundColor(.primary)
            Text(role)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}''',
    flutterEquivalentSnippet: '''// Flutter Equivalent (StatelessWidget)
class ProfileBadgeWidget extends StatelessWidget {
  final String name;
  final String role;
  const ProfileBadgeWidget({required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: Theme.of(context).textTheme.titleMedium),
          Text(role, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}''',
    architecturalExplanation:
        'Both SwiftUI and Flutter treat views as lightweight, immutable value types. In SwiftUI, modifiers wrap views into new struct types at compile time.',
  ),
  const SwiftUiLesson(
    id: 2,
    title: 'Layout Stacks & Containers',
    subtitle: 'VStack, HStack, ZStack, Spacer, and Lazy Stacks',
    tag: 'Layouts',
    icon: Icons.view_quilt_rounded,
    color: Color(0xFF2563EB),
    bulletPoints: [
      'VStack: Vertical stack (equivalent to Flutter Column).',
      'HStack: Horizontal stack (equivalent to Flutter Row).',
      'ZStack: Depth stack on the Z-axis (equivalent to Flutter Stack).',
      'Spacer(): Expands to fill available space (equivalent to Flutter Spacer / Expanded).',
      'LazyVStack & List: Viewport-recycled containers (equivalent to Flutter ListView.builder).',
    ],
    swiftCodeSnippet: '''// SwiftUI Stacks
ZStack(alignment: .topTrailing) {
    HStack(spacing: 12) {
        Image(systemName: "person.circle.fill")
            .resizable()
            .frame(width: 48, height: 48)
        VStack(alignment: .leading) {
            Text("Navneet")
            Text("Senior iOS / Flutter Lead")
        }
        Spacer()
    }
    
    // Floating badge
    Text("PRO")
        .font(.caption2)
        .bold()
        .padding(4)
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(Capsule())
}''',
    flutterEquivalentSnippet: '''// Flutter Equivalent
Stack(
  children: [
    Row(
      children: [
        const Icon(Icons.person, size: 48),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Navneet"),
            Text("Senior iOS / Flutter Lead"),
          ],
        ),
        const Spacer(),
      ],
    ),
    Positioned(
      top: 0,
      right: 0,
      child: Chip(label: Text("PRO")),
    ),
  ],
)''',
    architecturalExplanation:
        'SwiftUI uses layout priorities and content hugging, whereas Flutter uses strict box constraints (min/max width and height passed downward).',
  ),
  const SwiftUiLesson(
    id: 3,
    title: 'State Management Property Wrappers',
    subtitle: '@State, @Binding, @StateObject, @ObservedObject, and @Observable',
    tag: 'State Mgmt',
    icon: Icons.sync_alt_rounded,
    color: Color(0xFF7C3AED),
    bulletPoints: [
      '@State: Ephemeral private local state owned by a View (like setState).',
      '@Binding: Two-way reference to a parent @State variable without copying.',
      '@StateObject: Instantiates and owns a lifecycle-aware ViewModel (ObservableObject).',
      '@ObservedObject: Subscribes to an existing ViewModel passed in from outside.',
      '@Observable (iOS 17+ Macro): Modern observation without @Published or Combine boilerplate.',
    ],
    swiftCodeSnippet: '''// Modern SwiftUI Observable ViewModel (iOS 17+)
@Observable
class CounterViewModel {
    var count = 0
    var message = "Idle"

    func increment() {
        count += 1
        message = "Incremented to \\(count)"
    }
}

struct CounterView: View {
    @State private var viewModel = CounterViewModel()

    var body: some View {
        VStack {
            Text("\\(viewModel.count)")
                .font(.system(size: 48, weight: .bold))
            Button("Increment") {
                viewModel.increment()
            }
        }
    }
}''',
    flutterEquivalentSnippet: '''// Flutter Equivalent with Cubit
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  void increment() => emit(state + 1);
}

class CounterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterCubit, int>(
      builder: (context, count) {
        return Column(
          children: [
            Text('\$count', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () => context.read<CounterCubit>().increment(),
              child: const Text('Increment'),
            ),
          ],
        );
      },
    );
  }
}''',
    architecturalExplanation:
        'SwiftUI uses Swift Property Wrappers (@State, @Binding) and macro-based observation. Flutter uses InheritedWidgets and BLoC/Cubit streams to decouple UI from business logic.',
  ),
  const SwiftUiLesson(
    id: 4,
    title: 'Clean Architecture with Swift Protocols',
    subtitle: 'Model -> Protocol Repository -> ViewModel -> View with async/await',
    tag: 'Clean Arch',
    icon: Icons.account_tree_rounded,
    color: Color(0xFF0D9488),
    bulletPoints: [
      'Protocol Contract: Defines abstract repository methods independent of URLSession.',
      'Async / Await: Modern Swift structured concurrency replacing completion handler callbacks.',
      'Dependency Injection: Passing repository protocol to ViewModel initializer for 100% testability.',
      'Enums for View States: .idle, .loading, .success([User]), .failure(Error).',
    ],
    swiftCodeSnippet: '''// 1. Domain Contract
protocol UserRepository {
    func fetchUsers() async throws -> [UserProfile]
}

// 2. Data Layer Implementation
class UserRepositoryImpl: UserRepository {
    func fetchUsers() async throws -> [UserProfile] {
        let (data, _) = try await URLSession.shared.data(from: apiURL)
        return try JSONDecoder().decode([UserProfile].self, from: data)
    }
}

// 3. ViewModel
@Observable
class UserDirectoryViewModel {
    private let repository: UserRepository
    var users: [UserProfile] = []
    var isLoading = false
    var errorMessage: String?

    init(repository: UserRepository) {
        self.repository = repository
    }

    func loadUsers() async {
        isLoading = true
        do {
            users = try await repository.fetchUsers()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}''',
    flutterEquivalentSnippet: '''// Flutter Equivalent:
abstract class UserRepository {
  Future<List<UserProfile>> fetchUsers();
}

class UserDirectoryCubit extends Cubit<UserDirectoryState> {
  final UserRepository repository;
  UserDirectoryCubit({required this.repository}) : super(const UserDirectoryInitial());

  Future<void> loadUsers() async {
    emit(const UserDirectoryLoading());
    try {
      final users = await repository.fetchUsers();
      emit(UserDirectoryLoaded(users: users));
    } catch (e) {
      emit(UserDirectoryError(message: e.toString()));
    }
  }
}''',
    architecturalExplanation:
        'Both frameworks implement Clean Architecture identically: an abstract interface decouples networking/DB, while ViewModels (Swift) or Cubits (Flutter) manage asynchronous states.',
  ),
];
