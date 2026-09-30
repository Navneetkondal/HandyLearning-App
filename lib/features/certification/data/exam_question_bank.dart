import '../models/certification_models.dart';
import '../../claude_certification/models/claude_mock_exam_data.dart';

/// Question bank repository for all certification tracks.
class ExamQuestionBank {
  static List<ExamQuestion> getQuestionsForTrack(ExamTrack track) {
    switch (track) {
      case ExamTrack.flutter:
        return _flutterQuestions;
      case ExamTrack.swiftui:
        return _swiftUiQuestions;
      case ExamTrack.claude:
        return _claudeQuestions;
    }
  }

  // =========================================================================
  // FLUTTER MASTER DEVELOPER EXAM (10 QUESTIONS)
  // =========================================================================
  static final List<ExamQuestion> _flutterQuestions = [
    const ExamQuestion(
      id: 101,
      track: ExamTrack.flutter,
      domainId: 1,
      domainName: 'State Architecture & Lifecycle',
      scenario:
          'In a large-scale enterprise application using Flutter Bloc, an event triggers an asynchronous operation. If a user rapidly fires the same event 5 times within 300ms, you must cancel in-flight requests and only process the most recent one. Which transformer should be supplied to on<Event>?',
      options: [
        'concurrent() from package:bloc_concurrency',
        'restartable() from package:bloc_concurrency',
        'droppable() from package:bloc_concurrency',
        'sequential() from package:bloc_concurrency',
      ],
      correctIndex: 1,
      rationale:
          'restartable() cancels any currently running handler when a new event arrives and executes the latest event immediately (equivalent to switchMap in RxDart). droppable() ignores new events until the active one finishes, while sequential() processes them FIFO.',
    ),
    const ExamQuestion(
      id: 102,
      track: ExamTrack.flutter,
      domainId: 2,
      domainName: 'Engine Pipeline & RenderObjects',
      scenario:
          'You are writing a custom RenderBox subclass. During layout, you need to query the size of a child RenderBox. In which phase is it strictly forbidden to inspect child.size, and what must be inspected instead?',
      options: [
        'Forbidden during performLayout(); must inspect child.constraints instead',
        'Forbidden during performLayout() before child.layout(constraints, parentUsesSize: true) has returned; must invoke layout with parentUsesSize: true',
        'Forbidden during paint(); must inspect child.semanticBounds instead',
        'Forbidden during applyPaintTransform(); must invoke markNeedsPaint()',
      ],
      correctIndex: 1,
      rationale:
          'A parent RenderBox cannot access child.size until after invoking child.layout(constraints, parentUsesSize: true). If parentUsesSize is false or omitted, child.size will throw an assertion error in debug mode.',
      codeSnippet: '''void performLayout() {
  child?.layout(constraints, parentUsesSize: true);
  final childSize = child?.size ?? Size.zero;
  size = constraints.constrain(childSize);
}''',
    ),
    const ExamQuestion(
      id: 103,
      track: ExamTrack.flutter,
      domainId: 3,
      domainName: 'Concurrency & Isolates',
      scenario:
          'A background parsing task handles a 15MB JSON response from a REST API. You use compute(parseJson, rawString). Why does this prevent UI jank, and how is memory handled between Dart 2.15+ isolates on the same isolate group?',
      options: [
        'compute() runs on the platform UI thread but defers execution to microtasks',
        'compute() spawns a worker isolate that shares the exact same heap memory without any garbage collection pause',
        'compute() runs on a separate worker thread within the same isolate group; in modern Dart, objects are transferred or shared with zero-copy or fast mutator handoff without blocking the UI event loop',
        'compute() compiles the Dart closure directly into C++ pthread binaries at runtime',
      ],
      correctIndex: 2,
      rationale:
          'Dart 2.15+ introduced isolate groups where worker isolates share the core VM isolate group heap. compute() executes off the main thread, keeping the 60/120fps UI event loop unblocked.',
    ),
    const ExamQuestion(
      id: 104,
      track: ExamTrack.flutter,
      domainId: 4,
      domainName: 'Layout Constraints & Slivers',
      scenario:
          'A developer wraps an unconstrained horizontal ListView inside a standard Column without providing a height. What runtime exception is triggered and why?',
      options: [
        'NoSuchMethodError because ListView has no parent element',
        'FlutterError: "Vertical viewport was given unbounded height" because Column provides unbounded vertical constraints (maxHeight = infinity) while vertical scrollables require bounded height',
        'RenderFlex overflowed by infinity pixels on the bottom axis',
        'StackOverflowError due to infinite recursive measurement in layout()',
      ],
      correctIndex: 1,
      rationale:
          'Column gives its children an unbounded vertical constraint (maxHeight: double.infinity). A vertical ListView requires bounded constraints to determine its viewport scroll extents, triggering "Vertical viewport was given unbounded height". Wrapping with Expanded or SizedBox resolves it.',
    ),
    const ExamQuestion(
      id: 105,
      track: ExamTrack.flutter,
      domainId: 5,
      domainName: 'Keys & Element Tree Lifecycle',
      scenario:
          'You have a reorderable list of StatefulWidgets with internal text inputs. When the list order changes, the text in each field jumps to the wrong items. What key type should be assigned to each list item widget to resolve this issue?',
      options: [
        'UniqueKey() created dynamically in the build() method',
        'ValueKey(item.id) with a unique, persistent identifier bound to each underlying entity',
        'GlobalKey() created inside the stateful widget constructor',
        'ObjectKey() referencing an anonymous Map object',
      ],
      correctIndex: 1,
      rationale:
          'ValueKey(item.id) provides a persistent identity that allows the Element tree to correctly match stateful Elements to their corresponding updated Widgets during list diffing/reordering. Generating UniqueKey() inside build() breaks state preservation on every rebuild.',
    ),
    const ExamQuestion(
      id: 106,
      track: ExamTrack.flutter,
      domainId: 2,
      domainName: 'Engine Pipeline & RenderObjects',
      scenario:
          'Which widget introduces a RepaintBoundary into the render tree, and under what conditions should you manually wrap an expensive custom widget with RepaintBoundary?',
      options: [
        'SizedBox; wrap whenever constraints do not change',
        'RepaintBoundary; wrap when an isolated subtree animates frequently while the surrounding background UI remains static, preventing unnecessary repainting of the entire canvas',
        'DecoratedBox; wrap whenever a borderRadius is applied',
        'Stack; wrap to isolate z-index rendering layers',
      ],
      correctIndex: 1,
      rationale:
          'RepaintBoundary creates a separate DisplayList / Skia/Impeller layer. When the child subtree repaints (e.g. high-frequency game sprite or radar animation), the parent tree is not repainted, conserving GPU raster budget.',
    ),
    const ExamQuestion(
      id: 107,
      track: ExamTrack.flutter,
      domainId: 1,
      domainName: 'State Architecture & Lifecycle',
      scenario:
          'In a Flutter StatefulWidget, when didChangeDependencies() is invoked, which of the following operations is safe and appropriate to perform?',
      options: [
        'Calling Navigator.of(context).push() unconditionally',
        'Accessing InheritedWidgets like Theme.of(context) or MediaQuery.of(context), or registering subscriptions that depend on inherited context',
        'Disposing active StreamSubscriptions or TextEditingControllers',
        'Directly calling setState() synchronously without any state changes',
      ],
      correctIndex: 1,
      rationale:
          'didChangeDependencies() is invoked immediately after initState() and whenever an InheritedWidget that this widget depends on updates. It is the first lifecycle method where BuildContext is fully safe to query InheritedWidgets.',
    ),
    const ExamQuestion(
      id: 108,
      track: ExamTrack.flutter,
      domainId: 3,
      domainName: 'Concurrency & Platform Channels',
      scenario:
          'When sending high-frequency sensor or video frame streams from native iOS/Android to Flutter at 60fps, which channel type provides binary streaming efficiency rather than discrete request-response overhead?',
      options: [
        'MethodChannel',
        'EventChannel with BinaryMessenger decoding',
        'BasicMessageChannel<String>',
        'PlatformViewSurface',
      ],
      correctIndex: 1,
      rationale:
          'EventChannel is specifically designed for continuous event streams from native platforms to Dart, mapping directly to a Dart Stream<dynamic> with optimized listener lifecycles.',
    ),
    const ExamQuestion(
      id: 109,
      track: ExamTrack.flutter,
      domainId: 5,
      domainName: 'Testing & Quality Assurance',
      scenario:
          'In Flutter widget testing, when a widget contains a repeating animation (e.g., AnimationController with repeat()), calling tester.pumpAndSettle() causes what result and how should it be handled?',
      options: [
        'The test passes immediately by automatically freezing the controller',
        'The test times out with a FlutterError because pumpAndSettle() waits indefinitely for all frames to settle, which never occurs with an infinite loop; tester.pump(Duration) must be used instead',
        'The test causes an OutOfMemory error in the headless test runner',
        'The test drops 60 frames and fails with a GoldenMismatchException',
      ],
      correctIndex: 1,
      rationale:
          'pumpAndSettle() pumps frames until no more microtasks or scheduled frames are pending. If an animation is repeating, frames never cease. The correct approach is calling tester.pump(const Duration(milliseconds: 100)) to advance by a finite step.',
    ),
    const ExamQuestion(
      id: 110,
      track: ExamTrack.flutter,
      domainId: 4,
      domainName: 'Layout Constraints & Slivers',
      scenario:
          'What is the core distinction between BoxConstraints and SliverConstraints in Flutter\'s rendering architecture?',
      options: [
        'BoxConstraints only handle width while SliverConstraints handle height',
        'BoxConstraints operate in 2D Euclidean space (minWidth, maxWidth, minHeight, maxHeight), whereas SliverConstraints provide 1D scrolling dimensions including scrollOffset, overlap, and remainingPaintExtent along an Axis',
        'BoxConstraints are resolved on the GPU while SliverConstraints are computed on the CPU',
        'BoxConstraints allow infinite size in all directions while SliverConstraints are always strictly finite',
      ],
      correctIndex: 1,
      rationale:
          'Box protocols use 2D Cartesian boundaries (min/max Width & Height). Sliver protocols model 1D scroll pipelines, passing scrollOffset, remainingCacheExtent, overlap, and viewport dimensions to produce a SliverGeometry.',
    ),
  ];

  // =========================================================================
  // SWIFTUI SPECIALIST EXAM (10 QUESTIONS)
  // =========================================================================
  static final List<ExamQuestion> _swiftUiQuestions = [
    const ExamQuestion(
      id: 201,
      track: ExamTrack.swiftui,
      domainId: 1,
      domainName: 'State Architecture & Observation',
      scenario:
          'In iOS 17+, Apple introduced the @Observable macro. How does @Observable fundamentally differ from the legacy ObservableObject protocol regarding view invalidation?',
      options: [
        'ObservableObject only invalidates on background threads, whereas @Observable invalidates on MainActor',
        'ObservableObject triggers objectWillChange whenever ANY @Published property mutates (causing all observing views to re-render), whereas @Observable tracks property-level access and only invalidates views that actually read the specific mutated property',
        '@Observable requires all properties to be declared as @Binding',
        '@Observable converts classes into value-type structs at runtime',
      ],
      correctIndex: 1,
      rationale:
          'Under ObservableObject, changing property A publishes objectWillChange and invalidates any view observing the object, even if that view only reads property B. With @Observable, Swift tracks getter accesses during body evaluation and invalidates views on a fine-grained, per-property basis.',
      codeSnippet: '''@Observable
class UserProfile {
  var name: String = "Alice"
  var avatarUrl: String = ""
}''',
    ),
    const ExamQuestion(
      id: 202,
      track: ExamTrack.swiftui,
      domainId: 2,
      domainName: 'View Identity & Lifetime',
      scenario:
          'What is the difference between Structural Identity and Explicit Identity in SwiftUI, and how does using an "if-else" statement in a ViewBuilder affect state persistence?',
      options: [
        'Structural identity uses UUID while explicit identity uses Integer tags',
        'Structural identity is established by the view\'s position in the compiler-generated Type hierarchy (e.g. _ConditionalContent<A, B>). Toggling an if-else condition destroys the old branch\'s state and instantiates a new branch rather than mutating in place',
        'Explicit identity only exists in UIKit, not in SwiftUI',
        'Structural identity guarantees that @State variables are never reset across conditional branches',
      ],
      correctIndex: 1,
      rationale:
          'ViewBuilder maps if-else branches to _ConditionalContent<TrueView, FalseView>. When the branch flips, SwiftUI treats TrueView and FalseView as distinct structural identities, destroying TrueView\'s @State and creating fresh @State for FalseView.',
    ),
    const ExamQuestion(
      id: 203,
      track: ExamTrack.swiftui,
      domainId: 3,
      domainName: 'Layout Protocol & Geometry',
      scenario:
          'In SwiftUI, when a parent view lays out its children, what is the three-step negotiation rule governed by the layout system?',
      options: [
        '1. Child demands size. 2. Parent conforms. 3. System renders.',
        '1. Parent proposes a size to child. 2. Child determines its own size based on its content and constraints. 3. Parent positions the child in its coordinate space.',
        '1. Parent measures device screen. 2. Parent divides space evenly. 3. Children clip overflowing content.',
        '1. Compiler runs autolayout constraints. 2. UIKit converts to frame. 3. SwiftUI displays.',
      ],
      correctIndex: 1,
      rationale:
          'SwiftUI layout is strictly a 3-step conversation: The parent proposes a ProposedViewSize; the child chooses its actual size (which the parent cannot override); and the parent positions the child within the parent\'s bounds.',
    ),
    const ExamQuestion(
      id: 204,
      track: ExamTrack.swiftui,
      domainId: 4,
      domainName: 'Swift Concurrency & Modifiers',
      scenario:
          'You attach the .task { } view modifier to a SwiftUI screen to load data from an asynchronous network endpoint. What happens when the view disappears before the network call completes?',
      options: [
        'The task continues executing in the background indefinitely until it finishes',
        'SwiftUI automatically cancels the structured Task when the view disappears or its identity changes',
        'The app crashes with an unhandled TaskCancelledException',
        'The task pauses execution and resumes when the app re-opens',
      ],
      correctIndex: 1,
      rationale:
          'The .task modifier binds the asynchronous work directly to the lifetime of the view. When the view is removed from the hierarchy, the associated Task is cooperatively cancelled automatically.',
    ),
    const ExamQuestion(
      id: 205,
      track: ExamTrack.swiftui,
      domainId: 1,
      domainName: 'State Architecture & Observation',
      scenario:
          'When passing a mutable value from a parent view to an editable child component (such as a TextField or custom Toggle), which property wrapper should the child view declare to establish two-way communication without owning the storage?',
      options: [
        '@State',
        '@Binding',
        '@ObservedObject',
        '@StateObject',
      ],
      correctIndex: 1,
      rationale:
          '@Binding creates a two-way connection to state owned by another view. It reads the current value from the source of truth and writes mutations directly back to it without storing duplicate state.',
    ),
    const ExamQuestion(
      id: 206,
      track: ExamTrack.swiftui,
      domainId: 5,
      domainName: 'UIKit Interoperability',
      scenario:
          'When wrapping a complex UIKit control (like MKMapView or UITextView) inside SwiftUI via UIViewRepresentable, which delegate/coordinator pattern is used to pass user interactions back into SwiftUI bindings?',
      options: [
        'NotificationCenter default observer',
        'makeCoordinator() returning a Coordinator class that conforms to the UIKit delegate protocol and updates SwiftUI bindings',
        'Direct static singleton binding',
        'KVO (Key-Value Observing) on the UIView subclass',
      ],
      correctIndex: 1,
      rationale:
          'UIViewRepresentable uses makeCoordinator() to instantiate an intermediary class. The coordinator acts as the delegate/target-action handler for the UIKit view and synchronizes events back into SwiftUI state bindings.',
    ),
    const ExamQuestion(
      id: 207,
      track: ExamTrack.swiftui,
      domainId: 3,
      domainName: 'Animation & Transitions',
      scenario:
          'What is the fundamental requirement for a custom SwiftUI property to support smooth interpolation during a withAnimation { } block?',
      options: [
        'The property must be an integer decorated with @Published',
        'The view or modifier must conform to the Animatable protocol and implement animatableData with a type conforming to VectorArithmetic',
        'The property must be passed through a CATransaction in CoreAnimation',
        'The view must be wrapped inside a GeometryReader',
      ],
      correctIndex: 1,
      rationale:
          'For custom properties to animate smoothly across frames, SwiftUI queries animatableData. By conforming to Animatable and supplying animatableData (such as Double, CGFloat, or AnimatablePair), SwiftUI interpolates values using VectorArithmetic.',
    ),
    const ExamQuestion(
      id: 208,
      track: ExamTrack.swiftui,
      domainId: 2,
      domainName: 'View Identity & Performance',
      scenario:
          'Why does using AnyView as a return type or wrapper inside frequently updated SwiftUI lists degrade rendering performance?',
      options: [
        'AnyView leaks Objective-C ARC references on each frame',
        'AnyView is a type-erased container that destroys compile-time type information, preventing SwiftUI from performing structural diffing and forcing full subtree destruction and reconstruction',
        'AnyView forces synchronous GPU rasterization on the main thread',
        'AnyView disables dark mode and dynamic type rendering',
      ],
      correctIndex: 1,
      rationale:
          'SwiftUI relies on precise compile-time generic view types to diff views. AnyView erases type information, meaning SwiftUI cannot compare old and new types efficiently, leading to full view re-instantiations and loss of animation transitions.',
    ),
    const ExamQuestion(
      id: 209,
      track: ExamTrack.swiftui,
      domainId: 4,
      domainName: 'Environment & Dependency Injection',
      scenario:
          'In iOS 17+, how is a custom environment value registered and consumed using the new @Entry macro?',
      options: [
        'By creating an Objective-C category on UIApplication',
        'By extending EnvironmentValues with an @Entry property, allowing direct injection via .environment(\\.myKey, value) and consumption via @Environment(\\.myKey)',
        'By declaring a global static variable in the App struct',
        'By registering the dependency inside UserDefaults',
      ],
      correctIndex: 1,
      rationale:
          'In Swift 5.9+ / iOS 17+, creating environment keys no longer requires boilerplate EnvironmentKey structs. Developers use `extension EnvironmentValues { @Entry var myKey: String = "default" }`.',
    ),
    const ExamQuestion(
      id: 210,
      track: ExamTrack.swiftui,
      domainId: 5,
      domainName: 'Navigation & Data Flow',
      scenario:
          'What major architectural flaw existed in the legacy NavigationView that led Apple to deprecate it in favor of NavigationStack and NavigationSplitView in iOS 16+?',
      options: [
        'NavigationView did not support navigation bars or titles',
        'NavigationLink in NavigationView eagerly instantiated destination views during initial screen load, causing massive performance and memory bloat, whereas NavigationStack uses data-driven path navigation with lazy destination resolution',
        'NavigationView only worked on macOS and iPadOS',
        'NavigationView prevented gesture-based back swipes',
      ],
      correctIndex: 1,
      rationale:
          'In NavigationView, NavigationLink(destination: DetailView()) instantiated DetailView immediately when the parent rendered. NavigationStack introduced data-driven navigation: `navigationDestination(for: Type.self)` lazily instantiates the destination view only when pushed onto the path.',
    ),
  ];

  // =========================================================================
  // CLAUDE CERTIFIED ARCHITECT EXAM (ADAPTED FROM POOL)
  // =========================================================================
  static final List<ExamQuestion> _claudeQuestions = claudeMockExamPool
      .map((q) => ExamQuestion(
            id: 300 + q.id,
            track: ExamTrack.claude,
            domainId: q.domainId,
            domainName: q.domainName,
            scenario: q.scenario,
            options: q.options,
            correctIndex: q.correctIndex,
            rationale: q.rationale,
          ))
      .toList();
}
