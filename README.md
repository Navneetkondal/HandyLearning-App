# Flutter Learning Hub 🚀

An interactive, production-grade Flutter educational application designed to teach **Basic UI Components**, **StatelessWidget vs StatefulWidget**, **Cubit State Management**, **State Architecture Principles**, and the **Clean Architecture Repository Pattern**.

---

## 🌟 What This Project Teaches

### 1. 📱 Basic UI Components Catalog (`lib/features/ui_components/`)
Comprehensive interactive sandboxes with live controls, real-time feedback, and copyable production code:
- **Layout & Structure**: `Row`, `Column`, `Stack`, `Positioned`, `Wrap`, `Container`, `SizedBox`, `Expanded`, `Flexible`, `Spacer`, and box alignment.
- **Buttons & User Inputs**: `ElevatedButton`, `OutlinedButton`, `TextButton`, `IconButton`, `FloatingActionButton`, `TextField`, `TextFormField` with form validation, `Checkbox`, `Switch`, `RadioGroup`, `Slider`, and `DropdownButtonFormField`.
- **Display & Typography**: `Text` styling hierarchy, `RichText` with `TextSpan`, `Card`, `Chip`, `Badge`, `Divider`, `Icon`, and `Image.network` with production-grade `loadingBuilder` & `errorBuilder` fallbacks.
- **Scrollables, Lists & Grids**: Viewport recycling with `ListView.builder`, `ListView.separated`, `GridView.builder` (`SliverGridDelegateWithFixedCrossAxisCount`), `ListTile`, and swipe-to-dismiss with `Dismissible`.
- **Modals, Dialogs & Feedback**: `AlertDialog`, `SimpleDialog`, `showModalBottomSheet`, and floating `SnackBar` with interactive actions.

### 2. ⚖️ StatelessWidget vs StatefulWidget (`lib/features/stless_vs_stful/`)
- **Live Side-by-Side Experiment**: Tap the `StatelessWidget` button to see an internal variable mutate while the UI stays frozen, then tap the `StatefulWidget` button to observe `setState()` mark the Element dirty and schedule a frame rebuild.
- **When to Use Each**: Explains why 90% of presentation widgets should be `StatelessWidget` and when `StatefulWidget` is appropriate (ephemeral widget-local controllers: `AnimationController`, `TextEditingController`, `FocusNode`).
- **Complete State Lifecycle**: Visual timeline breakdown of `createState()` ➔ `initState()` ➔ `didChangeDependencies()` ➔ `build()` ➔ `setState()` ➔ `dispose()`.

### 3. 🧠 Cubit & State Management (`lib/features/cubit_and_state/`)
- **Lightweight BLoC**: Eliminates event boilerplate — UI calls methods directly; the Cubit emits immutable state snapshots.
- **Immutable State with Equatable**: Value equality comparison preventing redundant widget repaints.
- **The 3 Core BLoC Consumers**:
  - `BlocBuilder`: For pure UI rendering (`builder: (context, state)`).
  - `BlocListener`: For one-off side-effects like SnackBars and navigation (`listener: (context, state)`).
  - `BlocConsumer`: Combines builder and listener in a single clean widget.
- **Performance Rule**: `context.read()` inside button callbacks vs `context.watch()` or `context.select()` inside widget build methods.
- **Live Transition Log**: Real-time audit trail of state transitions.

### 4. 🏛️ Repository Pattern & Clean Architecture (`lib/features/repository_pattern/`)
End-to-end data flow:
```text
UI (BlocBuilder / BlocConsumer)
           ▲
           │ States / Method Calls
           ▼
UserDirectoryCubit
           ▲
           │ Domain Models / Operations
           ▼
UserRepository (Abstract Contract)
           ▲
           │ Implemented by
           ▼
UserRepositoryImpl (Data Layer)
           ▲
           │ Raw Data / Exceptions
           ▼
UserMockDataSource (Simulated API with Latency & Errors)
```
- **Diagnostic Controls**: Toggle simulated network outages (503 HTTP timeout) to see how the Repository translates low-level errors into domain exceptions and renders the **Error State** with a one-tap **Retry** action.
- **4 Canonical UI States**: Exhaustive pattern matching across `Initial`, `Loading`, `Loaded`, and `Error`.

### 6. 🤖 Claude Certified Architect (Foundations) Track (`lib/features/claude_certification/`)
Curriculum aligned directly with [Claude Certification Guide](https://claudecertificationguide.com/learn):
- **Domain 1 (27%)**: Agentic Architecture & Orchestration (Think-Act-Observe loops, Supervisor/Subagent hierarchy, HITL guardrails).
- **Domain 2 (18%)**: Tool Design & MCP Integration (JSON schemas, Model Context Protocol Host/Client/Server, Resources vs Tools).
- **Domain 3 (20%)**: Claude Code Configuration & Workflows (CLAUDE.md memory guidelines, hooks, permissions, headless CI/CD).
- **Domain 4 (20%)**: Prompt Engineering & Structured Output (XML tag architecture, few-shot, JSON schemas, response prefill).
- **Domain 5 (15%)**: Context Management & Reliability (Prompt caching ephemeral breakpoints, 200k context budgets, error fallbacks).
- **Exam Specs**: 60 questions, 120 minutes, 720/1000 passing score, Pearson VUE proctored, interactive sample scenarios.

### 7. 🍎 SwiftUI & Modern iOS Track (`lib/features/swiftui_track/`)
Comprehensive Apple declarative framework curriculum:
- **Declarative Views**: `View` protocol, `some View`, immutable view structs, and view modifiers.
- **Layout Containers**: `VStack`, `HStack`, `ZStack`, `Spacer()`, `LazyVStack`, and `List`.
- **Property Wrappers**: `@State`, `@Binding`, `@StateObject`, `@ObservedObject`, and the modern iOS 17+ `@Observable` macro.
- **Clean MVVM Architecture**: Swift Protocols as abstract repository contracts, `async/await` concurrency, and dependency injection.
- **Flutter ➔ SwiftUI Rosetta Stone**: Direct side-by-side mapping comparing Flutter widgets, Cubits, and layouts to their SwiftUI counterparts.

### 8. 📽️ In-App Presentation Mode (`lib/features/lecture_slides/`)
- Interactive 7-slide presentation deck with swipe and button progression, progress indicator, code snippets, and instructor speaker notes for teaching in classroom or screen-sharing environments.

### 9. 🌓 Dual Theming (Light & Dark Mode)
- **Universal Dual Theme**: Native Material 3 color schemes (`ColorScheme.fromSeed`) with accessible WCAG AA contrast.
- **Reactive Switching**: Driven by root `ThemeCubit`, togglable via the header Sun/Moon button without application reload.

---

## 📂 Project Directory Structure

```text
FlutterLearningHub/
├── lib/
│   ├── main.dart                          # App bootstrapping, root ThemeCubit & routing
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_theme.dart             # Material 3 Light & Dark theme definitions
│   │   │   └── theme_cubit.dart           # ThemeMode state manager
│   │   └── widgets/
│   │       ├── code_snippet_card.dart     # Formatted code cards with copy-to-clipboard
│   │       ├── interactive_demo_box.dart  # Container card for live sandbox previews
│   │       └── section_header.dart        # Section headers with category badges
│   └── features/
│       ├── home/
│       │   └── screens/
│       │       └── home_dashboard_screen.dart # Master dashboard with navigation & cheatsheet
│       ├── ui_components/
│       │   └── screens/
│       │       ├── ui_catalog_screen.dart       # Catalog organizing all 5 UI categories
│       │       ├── layouts_demo_screen.dart     # Row, Column, Stack, Wrap, Container
│       │       ├── buttons_inputs_screen.dart   # Buttons, TextFields, Toggles, Sliders
│       │       ├── display_widgets_screen.dart  # Typography, Cards, Chips, Badges, Images
│       │       ├── lists_grids_screen.dart      # ListView.builder, GridView, Dismissible
│       │       └── dialogs_feedback_screen.dart # Dialogs, BottomSheet, SnackBar
│       ├── stless_vs_stful/
│       │   └── screens/
│       │       └── stless_vs_stful_screen.dart  # Interactive setState experiment & lifecycle
│       ├── cubit_and_state/
│       │   ├── cubit/
│       │   │   ├── counter_cubit.dart           # Counter Cubit with transition logs
│       │   │   └── counter_state.dart           # Immutable state with Equatable & copyWith
│       │   └── screens/
│       │       ├── cubit_intro_screen.dart      # BlocConsumer sandbox & cheat sheet
│       │       └── state_concept_screen.dart    # UI = f(State) & 4 canonical states
│       └── repository_pattern/
│           ├── data/
│           │   ├── datasources/
│           │   │   └── user_mock_datasource.dart# Simulated HTTP client with latency & failure switch
│           │   ├── models/
│           │   │   └── user_profile.dart        # UserProfile entity with JSON serialization
│           │   └── repositories/
│           │       └── user_repository_impl.dart# Repository implementation & error handling
│           ├── domain/
│           │   └── repositories/
│           │       └── user_repository.dart     # Abstract repository interface
│           ├── cubit/
│           │   ├── user_directory_cubit.dart    # User directory state manager
│           │   └── user_directory_state.dart    # Sealed state hierarchy (Initial, Loading, Loaded, Error)
│           └── screens/
│               └── user_directory_screen.dart   # Interactive Clean Architecture screen
└── test/
    ├── unit/
    │   ├── counter_cubit_test.dart              # Cubit unit tests & Equatable value equality
    │   └── user_directory_cubit_test.dart       # Repository data flow & error handling unit tests
    └── widget_test.dart                         # End-to-end dashboard rendering & scrolling test
```

---

## 🚀 Running the Project

### Prerequisites
- Flutter SDK 3.x+ (Dart 3.x+)

### Commands
```bash
# 1. Navigate to the project
cd /Users/navneet/Desktop/FlutterLearningHub

# 2. Fetch dependencies
flutter pub get

# 3. Run static analysis (Zero errors / Zero warnings guaranteed)
flutter analyze

# 4. Run automated tests
flutter test

# 5. Launch the app (on iOS Simulator, Android Emulator, macOS, or Chrome)
flutter run
```
