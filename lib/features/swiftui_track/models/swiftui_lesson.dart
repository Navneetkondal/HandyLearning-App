import 'package:flutter/material.dart';

/// Model representing a lesson in the SwiftUI & Modern iOS track.
class SwiftUiLesson {
  final int id;
  final String title;
  final String subtitle;
  final String tag;
  final String masteryLevel; // 'Basic', 'Intermediate', 'Advanced', 'Master'
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
    required this.masteryLevel,
    required this.icon,
    required this.color,
    required this.bulletPoints,
    required this.swiftCodeSnippet,
    required this.flutterEquivalentSnippet,
    required this.architecturalExplanation,
  });
}

final List<SwiftUiLesson> swiftUiLessons = [
  // 1. BASIC: Declarative Views & Modifiers
  const SwiftUiLesson(
    id: 1,
    title: 'Declarative Views & Modifiers',
    subtitle: 'The View protocol, some View, and view composition',
    tag: 'Fundamentals',
    masteryLevel: 'Basic',
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

  // 2. BASIC: Layout Stacks & Containers
  const SwiftUiLesson(
    id: 2,
    title: 'Layout Stacks & Containers',
    subtitle: 'VStack, HStack, ZStack, Spacer, and Lazy Stacks',
    tag: 'Layouts',
    masteryLevel: 'Basic',
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

  // 3. INTERMEDIATE: State Management Property Wrappers
  const SwiftUiLesson(
    id: 3,
    title: 'State Management Property Wrappers',
    subtitle: '@State, @Binding, @StateObject, @ObservedObject, and @Observable',
    tag: 'State Mgmt',
    masteryLevel: 'Intermediate',
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

  // 4. INTERMEDIATE: Clean Architecture & Protocols
  const SwiftUiLesson(
    id: 4,
    title: 'Clean Architecture with Swift Protocols',
    subtitle: 'Model -> Protocol Repository -> ViewModel -> View with async/await',
    tag: 'Clean Arch',
    masteryLevel: 'Intermediate',
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

  // 5. ADVANCED: Swift Concurrency & Actors
  const SwiftUiLesson(
    id: 5,
    title: 'Modern Swift Concurrency & Actor Isolation',
    subtitle: 'Actors, @MainActor, TaskGroup, and AsyncSequence',
    tag: 'Concurrency',
    masteryLevel: 'Advanced',
    icon: Icons.bolt_rounded,
    color: Color(0xFFEA580C),
    bulletPoints: [
      'Actor: Thread-safe reference type that serializes access to its mutable state to prevent data races.',
      '@MainActor: Global actor that guarantees code executes on the main UI dispatch queue.',
      'TaskGroup: Structured concurrent task execution with discardable results.',
      'AsyncSequence: Asynchronous stream of elements over time (equivalent to Dart Stream).',
    ],
    swiftCodeSnippet: '''// Swift Thread-Safe Actor
actor ImageDownloadCache {
    private var cache: [URL: Image] = [:]

    func image(for url: URL) async throws -> Image {
        if let cached = cache[url] { return cached }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let uiImage = UIImage(data: data) else { throw URLError(.cannotDecodeContentData) }
        let image = Image(uiImage: uiImage)
        cache[url] = image
        return image
    }
}

// UI ViewModel bounded to Main Thread
@MainActor
class FeedViewModel: ObservableObject {
    @Published var feedImages: [Image] = []
    private let cache = ImageDownloadCache()

    func fetchAll(urls: [URL]) async {
        // Concurrent TaskGroup
        await withTaskGroup(of: Image?.self) { group in
            for url in urls {
                group.addTask {
                    try? await self.cache.image(for: url)
                }
            }
            for await image in group {
                if let image { feedImages.append(image) }
            }
        }
    }
}''',
    flutterEquivalentSnippet: '''// Flutter Equivalent (Isolates + Streams)
class ImageCacheService {
  final Map<String, Uint8List> _cache = {};

  Future<Uint8List> fetchImage(String url) async {
    if (_cache.containsKey(url)) return _cache[url]!;
    // Offload network parsing to background compute isolate
    final bytes = await compute(_downloadHttpBytes, url);
    _cache[url] = bytes;
    return bytes;
  }
}''',
    architecturalExplanation:
        'Swift uses compiler-checked Actors and cooperative thread pools (GCD replacement). Flutter uses single-threaded event loops per Isolate with message-passing.',
  ),

  // 6. ADVANCED: Custom Layout Protocol & Interactive Animations
  const SwiftUiLesson(
    id: 6,
    title: 'Custom Layout Protocol & Spring Physics',
    subtitle: 'Implementing Layout protocol, matchedGeometryEffect, and interactive gestures',
    tag: 'Advanced UI',
    masteryLevel: 'Advanced',
    icon: Icons.auto_awesome_motion_rounded,
    color: Color(0xFF10B981),
    bulletPoints: [
      'Layout Protocol: Full custom layout container control: sizeThatFits() and placeSubviews().',
      'matchedGeometryEffect: Seamless hero-style transitions between different view hierarchies.',
      'Spring Physics: Damped springs (.spring(response:dampingRatio:)) without duration rigidity.',
      'Simultaneous Gestures: Combining drag, magnification, and tap with high responsiveness.',
    ],
    swiftCodeSnippet: '''// Custom Radial Flow Layout
struct RadialLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2.5
        let angleStep = (2 * .pi) / Double(subviews.count)

        for (index, subview) in subviews.enumerated() {
            let angle = angleStep * Double(index)
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            subview.place(at: CGPoint(x: x, y: y), anchor: .center, proposal: .unspecified)
        }
    }
}''',
    flutterEquivalentSnippet: '''// Flutter Equivalent (CustomMultiChildLayout)
class RadialLayoutDelegate extends MultiChildLayoutDelegate {
  final int itemCount;
  RadialLayoutDelegate({required this.itemCount});

  @override
  void performLayout(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2.5;
    for (int i = 0; i < itemCount; i++) {
      if (hasChild(i)) {
        final childSize = layoutChild(i, BoxConstraints.loose(size));
        final angle = (2 * pi / itemCount) * i;
        positionChild(i, center + Offset(radius * cos(angle), radius * sin(angle)) - Offset(childSize.width/2, childSize.height/2));
      }
    }
  }

  @override
  bool shouldRelayout(RadialLayoutDelegate old) => old.itemCount != itemCount;
}''',
    architecturalExplanation:
        'SwiftUI Layout protocol provides layout sizing and placement similar to Flutters MultiChildLayoutDelegate and RenderCustomMultiChildLayoutBox.',
  ),

  // 7. MASTER: SwiftUI AttributeGraph & Render Loop Optimization
  const SwiftUiLesson(
    id: 7,
    title: 'AttributeGraph Internals & Re-Render Auditing',
    subtitle: 'Eliminating invalidation cascades, EquatableView, and Instruments profiling',
    tag: 'Performance',
    masteryLevel: 'Master',
    icon: Icons.speed_rounded,
    color: Color(0xFFDC2626),
    bulletPoints: [
      'AttributeGraph: Apple’s internal directed acyclic graph maintaining view dependencies and attributes.',
      'Self._printChanges(): Debug hook to diagnose exactly which state change triggered a view body execution.',
      'Identity Stability: Structural Identity (if/else views) vs Explicit Identity (.id()) avoiding re-creation.',
      'Equatability: Conforming subviews to Equatable and wrapping with .equatable() to skip redundant body evaluations.',
    ],
    swiftCodeSnippet: '''// High-Performance Equatable Subview
struct HeavyRowView: View, Equatable {
    let item: ComplexItem
    
    // Explicit Equatable to prevent parent invalidation cascade
    static func == (lhs: HeavyRowView, rhs: HeavyRowView) -> Bool {
        lhs.item.id == rhs.item.id && lhs.item.updatedAt == rhs.item.updatedAt
    }

    var body: some View {
        let _ = Self._printChanges() // Diagnostic: prints exact reason for re-render
        HStack {
            Text(item.title)
            Spacer()
            Text(item.formattedValue)
        }
        .padding(.vertical, 8)
    }
}

// In List:
ForEach(items) { item in
    HeavyRowView(item: item).equatable() // Skips redraw if item hasn't changed
}''',
    flutterEquivalentSnippet: '''// Flutter Equivalent (const constructor + RepaintBoundary)
class HeavyRowWidget extends StatelessWidget {
  final ComplexItem item;
  const HeavyRowWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary( // Isolates render subtree to its own render layer
      child: Row(
        children: [
          Text(item.title),
          const Spacer(),
          Text(item.formattedValue),
        ],
      ),
    );
  }
}''',
    architecturalExplanation:
        'SwiftUI uses AttributeGraph to diff dependencies; Flutter uses the Element tree (Element.update) and RepaintBoundaries to prevent unnecessary subtree paints.',
  ),

  // 8. MASTER: Metal Shaders & Low-Level Graphics
  const SwiftUiLesson(
    id: 8,
    title: 'Metal Shaders & Low-Level Render Pipeline',
    subtitle: 'layerEffect, distortionEffect, MSL shaders, and Core Graphics',
    tag: 'Graphics & GPU',
    masteryLevel: 'Master',
    icon: Icons.grain_rounded,
    color: Color(0xFF9333EA),
    bulletPoints: [
      'Metal Shading Language (MSL): Write custom fragment shaders that compile directly onto Apple GPU cores.',
      '.layerEffect() & .distortionEffect(): Run real-time GPU pixel transformations on any SwiftUI view.',
      'Instruments Profiler: Profile frame drops with Metal System Trace and Time Profiler.',
      'Zero CPU Bottleneck: Offload complex blurs, waves, chromatic aberration, and water ripples to GPU.',
    ],
    swiftCodeSnippet: '''// SwiftUI iOS 17+ Custom Metal Shader
import SwiftUI

struct WaterWaveRippleView: View {
    @State private var time: Float = 0
    let timer = Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()

    var body: some View {
        Image("banner")
            .resizable()
            .scaledToFit()
            // Custom Metal shader compiled into default library
            .distortionEffect(
                ShaderLibrary.waveRipple(
                    .float(time),
                    .float2(300, 300)
                ),
                maxSampleOffset: CGSize(width: 30, height: 30)
            )
            .onReceive(timer) { _ in time += 0.05 }
    }
}

/* Metal Shader (.metal file):
#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

[[ stitchable ]] float2 waveRipple(float2 position, float time, float2 center) {
    float distance = length(position - center);
    float wave = sin(distance / 10.0 - time * 5.0) * 8.0;
    return position + normalize(position - center) * wave;
}
*/''',
    flutterEquivalentSnippet: '''// Flutter Equivalent (FragmentProgram & GLSL / SkSL)
class WaterRipplePainter extends CustomPainter {
  final FragmentShader shader;
  final double time;
  WaterRipplePainter({required this.shader, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, time);
    shader.setFloat(1, size.width);
    shader.setFloat(2, size.height);
    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(WaterRipplePainter old) => old.time != time;
}''',
    architecturalExplanation:
        'SwiftUI integrates Metal shaders via [[ stitchable ]] functions in iOS 17+. Flutter compiles GLSL/SPIR-V shaders via FragmentProgram and Impeller engine directly onto the GPU.',
  ),
];
