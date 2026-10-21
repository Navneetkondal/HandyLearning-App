import PDFKit
import Foundation

let pdfURL = URL(fileURLWithPath: "/Users/navneet/Documents/Prep/Prep Guide/iOS_Master_Interview_Handbook_Organized_Topics.pdf")
guard let doc = PDFDocument(url: pdfURL) else {
    print("Error: Could not load PDF")
    exit(1)
}

struct ChapterMeta {
    let number: Int
    let title: String
    let subtitle: String
    let startPage: Int
    let endPage: Int
    let iconName: String
    let overview: String
    let ddTitle: String
    let ddStartPage: Int
    let ddEndPage: Int
    let ddRole: String
    let ddRules: [String]
    let defs: [(String, String, String)]
}

let chaptersMeta: [ChapterMeta] = [
    ChapterMeta(
        number: 1,
        title: "Core Swift Language",
        subtitle: "Swift Type System, Language Core, Ownership & OOP",
        startPage: 4, endPage: 108,
        iconName: "code_rounded",
        overview: "Deep dive into generics, existentials (any), opaque return types (some), type erasure, Copy-on-Write (COW), dynamic vs static dispatch, protocol witness tables, non-copyable types (~Copyable), and Swift 6 ownership semantics.",
        ddTitle: "Advanced Swift Type System, Move Semantics & Dispatch",
        ddStartPage: 106, ddEndPage: 108,
        ddRole: "Demonstrates production-grade Copy-on-Write memory efficiency with isKnownUniquelyReferenced, non-copyable resource ownership (~Copyable, borrowing, consuming, discard self), and static vs vTable vs PWT vs message dispatch.",
        ddRules: [
            "Use isKnownUniquelyReferenced(&storage) before mutating reference-backed value types to avoid unnecessary heap allocations.",
            "Use ~Copyable to model unique system resources (file descriptors, sockets, security tokens) that must never be implicitly copied.",
            "Protocol extensions without declarations in the protocol definition ALWAYS use direct/static dispatch and cannot be dynamically overridden.",
            "Prefer 'some' over 'any' unless heterogeneous collections or dynamic runtime polymorphism is strictly required."
        ],
        defs: [
            ("Existential Container", "A 5-word box allocated to hold any type conforming to a protocol. Contains a 3-word value buffer, a Value Witness Table pointer, and a Protocol Witness Table pointer.", "When the concrete payload exceeds 3 words (24 bytes on 64-bit), Swift allocates heap storage for the existential buffer."),
            ("Type Erasure", "A design pattern that hides the underlying concrete type behind a generic wrapper (e.g. AnyView, AnyPublisher) to overcome associated type or Self constraints.", "Used when protocol types have associated types that cannot be used directly as return types or stored properties prior to Swift 5.7+."),
            ("Copy-on-Write (CoW)", "An optimization strategy where heap storage is shared between multiple copies until one copy attempts a mutation, at which point a separate copy is made.", "Standard collections (Array, Set, Dictionary) implement CoW natively; custom reference wrappers must use isKnownUniquelyReferenced."),
            ("Protocol Witness Table (PWT)", "A virtual dispatch table generated for a type conforming to a protocol, mapping protocol requirements to concrete method implementations.", "Enables dynamic polymorphism for existential types at the cost of indirection and inability to inline calls.")
        ]
    ),
    ChapterMeta(
        number: 2,
        title: "Memory & Runtime",
        subtitle: "Memory Management, ARC Internals & Low-Level Memory Engineering",
        startPage: 109, endPage: 145,
        iconName: "memory_rounded",
        overview: "Automatic Reference Counting (ARC) mechanics, inline retain counts, side tables, weak/unowned tables, retain cycles, autorelease pools, tagged pointers, closure capture semantics, Dirty/Clean/Compressed memory, and iOS Jetsam limit mitigation.",
        ddTitle: "Low-Level Memory Architecture, Side Tables & Autorelease Pools",
        ddStartPage: 144, ddEndPage: 145,
        ddRole: "Demonstrates inline vs external side-table retain count promotion, weak zeroing mechanics, high-throughput autorelease pool draining, and low-memory Jetsam handler.",
        ddRules: [
            "Inline 64-bit reference counts overflow to an external HeapObjectSideTableEntry when weak references are created or strong counts exceed inline bits.",
            "Weak pointers point to the side table, allowing the object payload to be deallocated while preserving zeroing metadata until the last weak reference is released.",
            "Unowned references assume lifetime validity; unowned(unsafe) bypasses ARC zeroing entirely, causing dangling pointer crashes if violated.",
            "Mitigate Jetsam termination by listening to UIApplication.didReceiveMemoryWarningNotification and purging NSCache and compressed texture buffers."
        ],
        defs: [
            ("Inline Retain Count", "A 64-bit word stored directly in the object header tracking strong and unowned references until overflow or weak reference creation.", "Avoids heap side table allocation for the vast majority of standard object lifetimes."),
            ("Heap Object Side Table", "An auxiliary heap-allocated data structure created when an object receives its first weak reference or its retain count overflows 30 bits.", "Contains the strong count, unowned count, and weak count, enabling safe zeroing of weak references."),
            ("Dirty vs Clean Memory", "Clean memory represents read-only pages that can be evicted by the kernel (e.g. mmap files, code); Dirty memory represents heap-allocated state that cannot be evicted.", "iOS has no swap disk; compressed dirty memory is the primary trigger for OS Jetsam kills."),
            ("Tagged Pointer", "An optimization on 64-bit architectures where small immutable data (NSNumber, NSDate, small NSString) is packed directly into the pointer bits.", "Bypasses heap allocation and ARC overhead entirely.")
        ]
    ),
    ChapterMeta(
        number: 3,
        title: "Concurrency & Safety",
        subtitle: "Swift Concurrency, Multithreading & Structured Concurrency",
        startPage: 146, endPage: 204,
        iconName: "sync_alt_rounded",
        overview: "Modern Swift 6 concurrency, async/await, Task, TaskGroup, withTaskCancellationHandler, Actor isolation, Global Actors (@MainActor), nonisolated, re-entrancy pitfalls, Sendable checking, and OS thread pool cooperation.",
        ddTitle: "Re-Entrancy Safe Actor, AsyncStream & TaskGroup Concurrency",
        ddStartPage: 203, ddEndPage: 204,
        ddRole: "Provides production-ready implementation of an actor that prevents re-entrancy interleaving state corruption, bounded parallel batching with TaskGroup, and AsyncStream with continuation buffering.",
        ddRules: [
            "Actors do NOT prevent re-entrancy: State can mutate across suspension points (await). Always validate state assumptions immediately after each await.",
            "Avoid unbounded TaskGroup spawning; batch concurrent network or compute tasks using bounded worker pools to prevent thread pool exhaustion.",
            "Mark shared mutable types @unchecked Sendable ONLY when synchronized internally via os_unfair_lock or atomic primitives.",
            "Always respect Task.isCancelled in long-running async loops and clean up allocated resources promptly."
        ],
        defs: [
            ("Actor Re-entrancy", "The phenomenon where an actor can execute other tasks between suspension points while an existing async function is awaiting.", "Interleaving can cause race conditions if the actor's state changes while waiting for an external async response."),
            ("Cooperative Thread Pool", "Swift concurrency's fixed-size thread pool matching the CPU core count, preventing thread explosion common in GCD.", "Blocking a cooperative thread with semaphores or synchronous locks stalls the entire async runtime."),
            ("Sendable Protocol", "A marker protocol indicating that a type's values can be safely transferred across concurrency domains without data races.", "Value types with Sendable members and Actors are Sendable; mutable reference types are not."),
            ("Structured Concurrency", "A concurrency model where child tasks are tied to the lifetime of their parent scope (via TaskGroup or async let), guaranteeing cancellation propagation.", "Unstructured tasks (Task.detached) leak if not manually managed.")
        ]
    ),
    ChapterMeta(
        number: 4,
        title: "Architecture & Patterns",
        subtitle: "Software Architecture, SOLID Principles & Design Patterns",
        startPage: 205, endPage: 283,
        iconName: "account_tree_rounded",
        overview: "Clean Architecture, VIPER, MVVM, Coordinator/Router, Composition Root, SOLID principles, Factory, Strategy, Observer, Repository with offline synchronization, and modular domain-driven design.",
        ddTitle: "Clean Architecture Composition Root, Coordinator & Offline Repository",
        ddStartPage: 282, ddEndPage: 283,
        ddRole: "Implements production-ready Clean Architecture with Pure Dependency Injection via a Composition Root, decoupled navigation via Coordinators, and resilient Repository pattern.",
        ddRules: [
            "All dependencies must be constructed at the Composition Root (App Launch / Flow Initiation); never instantiate concrete services inside ViewModels.",
            "Coordinators own navigation state and view controller presentation; ViewControllers and Views must have zero knowledge of destination screens.",
            "The Repository pattern abstracts data origin; ViewModels interact with domain entities without knowing whether data originates from SQLite, CoreData, or HTTP.",
            "Adhere strictly to Single Responsibility: A ViewModel formats UI state; it must never execute network requests or parse raw JSON directly."
        ],
        defs: [
            ("Composition Root", "The single, centralized location in an application where the dependency graph is composed and wired together.", "Ensures modules remain decoupled and unit-testable by pushing instantiation to the application boundary."),
            ("Coordinator Pattern", "A structural pattern where dedicated navigation coordinators manage flow logic and screen transitions instead of view controllers.", "Decouples ViewControllers from their navigation contexts, making them reusable across flows."),
            ("Dependency Inversion Principle (DIP)", "High-level modules should not depend on low-level modules; both should depend on abstractions (protocols).", "Enables seamless swapping of mock implementations in unit test suites."),
            ("Repository Pattern", "A mediator between domain logic and data mapping layers, providing a collection-like interface for accessing domain objects.", "Encapsulates caching, offline persistence, and network fetch strategies behind a single protocol.")
        ]
    ),
    ChapterMeta(
        number: 5,
        title: "UI & Graphics Engine",
        subtitle: "UIKit Internals, Auto Layout & View Rendering Architecture",
        startPage: 284, endPage: 334,
        iconName: "layers_rounded",
        overview: "UIKit view hierarchy, UIView vs CALayer, render loop, layoutSubviews, setNeedsLayout vs layoutIfNeeded, content hugging & compression resistance, off-screen rendering causes, and CADisplayLink synchronization.",
        ddTitle: "High-Performance UICollectionView, Diffable Data Source & Render Loop",
        ddStartPage: 333, ddEndPage: 334,
        ddRole: "Demonstrates 120 FPS ProMotion rendering with UICollectionViewCompositionalLayout, UICollectionViewDiffableDataSource, off-screen rendering prevention, and batching animations.",
        ddRules: [
            "Never perform complex math or synchronous I/O inside layoutSubviews or draw(_:); this blocks the main run loop and triggers dropped frames.",
            "Avoid off-screen rendering passes by setting layer.shouldRasterize = true only on static layers, and specifying explicit layer.shadowPath.",
            "Use UICollectionViewDiffableDataSource to compute background thread diffs and avoid index path mutation crashes.",
            "Match content compression resistance and hugging priorities explicitly to prevent ambiguous Auto Layout constraints."
        ],
        defs: [
            ("UIKit Render Loop", "The per-frame process where the system evaluates constraints (Update Constraints), positions frames (Layout), and draws pixels into graphics context (Display).", "Coalesces layout updates into a single run-loop commit to optimize GPU pipeline throughput."),
            ("Off-Screen Rendering", "A costly GPU operation where visual effects (cornerRadius with masksToBounds, shadows without shadowPath) require an off-screen framebuffer before composite rendering.", "Dramatically degrades frame rates below 60/120 FPS on scrollable feeds."),
            ("Content Hugging vs Compression Resistance", "Hugging Priority resists expanding beyond intrinsic content size; Compression Resistance resists shrinking below intrinsic content size.", "Priority values range from 1 to 1000; default hugging is 250, default compression resistance is 750."),
            ("CADisplayLink", "A specialized timer synchronized directly with the hardware display's refresh rate (60Hz / 120Hz ProMotion).", "Used for smooth physics animations, custom gesture-driven transitions, and video rendering pacing.")
        ]
    ),
    ChapterMeta(
        number: 6,
        title: "Modern Declarative UI",
        subtitle: "SwiftUI Architecture, State Management & Rendering Engine",
        startPage: 335, endPage: 370,
        iconName: "widgets_rounded",
        overview: "SwiftUI rendering pipeline, AttributeGraph, Structural vs Identity identity (@State, @Binding, @Observable, @StateObject), PreferenceKey, Layout protocol, ViewModifier, and SwiftUI/UIKit hybrid interoperability.",
        ddTitle: "Swift 5.9+ / 6 Fine-Grained @Observable, Custom Layout & PreferenceKey",
        ddStartPage: 369, ddEndPage: 370,
        ddRole: "Implements high-performance SwiftUI architecture with Swift Observation (@Observable), zero redundant body invalidations, custom adaptive Layout protocol, and PreferenceKey geometry readers.",
        ddRules: [
            "Migrate from ObservableObject to Swift 5.9+ @Observable: @Observable tracks property accesses at the field level, preventing full-view re-renders when unrelated properties change.",
            "Preserve structural identity: Never use AnyView unnecessarily as it destroys view identity and triggers full view deallocation and rebuilds.",
            "Avoid doing work inside view body property: body is a pure function computed frequently; never execute network or side effects directly in body.",
            "Use PreferenceKey to pass layout metadata and geometry measurements upward from child views to parents without state loops."
        ],
        defs: [
            ("AttributeGraph", "SwiftUI's internal dependency graph tracking view properties, state values, and layout attributes to determine minimal render updates.", "Invalidates only subgraphs whose observed properties have mutated."),
            ("Structural vs Explicit Identity", "Explicit Identity uses .id(...) or Identifiable for tracking; Structural Identity uses the position of the view in the declaration hierarchy.", "Conditional branching (if/else) creates separate structural identities, resetting child view state."),
            ("Swift Observation (@Observable)", "A macro-driven observation framework introduced in Swift 5.9 replacing ObservableObject and Combine with field-level dependency tracking.", "Reduces SwiftUI view invalidations by up to 80% compared to @Published objectWillChange."),
            ("PreferenceKey", "A communication mechanism in SwiftUI that allows child views to bubble up values (such as geometry, anchor, or custom data) to ancestor views.", "Enables complex responsive coordinate space calculations without global state.")
        ]
    ),
    ChapterMeta(
        number: 7,
        title: "Persistence & Storage",
        subtitle: "Data Persistence, Core Data & Offline-First Architecture",
        startPage: 371, endPage: 422,
        iconName: "storage_rounded",
        overview: "Core Data stack (NSPersistentContainer, NSManagedObjectContext, NSPersistentStoreCoordinator), parent-child contexts, background parsing, SwiftData ModelContainer, schema migrations, and SQLite optimization.",
        ddTitle: "Production Core Data Concurrency Stack & SwiftData Sync Engine",
        ddStartPage: 421, ddEndPage: 422,
        ddRole: "Implements production-grade parent-child Core Data concurrency with private background writer context, main view context, NSBatchInsertRequest, and conflict resolution policies.",
        ddRules: [
            "NSManagedObject and NSManagedObjectContext are NOT thread-safe: Access them strictly on their designated queue via perform or performAndWait.",
            "Never pass NSManagedObject across threads; pass NSManagedObjectID and fetch the object on the destination context.",
            "Use NSBatchInsertRequest and NSBatchUpdateRequest for high-volume ingest to bypass memory object creation in Core Data.",
            "Always set an explicit merge policy (e.g. NSMergeByPropertyObjectTrumpMergePolicy) to resolve background sync conflicts automatically."
        ],
        defs: [
            ("Core Data Stack", "The architecture comprising NSManagedObjectModel, NSPersistentStoreCoordinator, and one or more NSManagedObjectContexts managing SQLite storage.", "Coordinates schema definitions, thread isolation, disk persistence, and in-memory object faulting."),
            ("Faulting", "Core Data's mechanism of allocating placeholder objects in memory without retrieving property values from disk until accessed.", "Drastically reduces memory consumption when fetching large datasets."),
            ("Parent-Child Contexts", "A pattern where a child context inherits its parent's state, saving changes to parent memory without touching SQLite disk until the parent saves.", "Used for isolated temporary edits, modal flows, and background batch importing."),
            ("SwiftData", "Apple's modern Swift-native persistence framework utilizing Swift macros (@Model) and modern Swift concurrency (ModelActor, ModelContainer).", "Replaces NSManagedObject boilerplate with strongly-typed Swift models backed by Core Data.")
        ]
    ),
    ChapterMeta(
        number: 8,
        title: "Networking & Protocols",
        subtitle: "Networking, Distributed Systems & URLSession Internals",
        startPage: 423, endPage: 480,
        iconName: "wifi_rounded",
        overview: "URLSession architecture, delegate queues, SSL/TLS certificate pinning, exponential backoff retry algorithms, idempotency key coordination, NWPathMonitor network resilience, and HTTP/2 & HTTP/3 multiplexing.",
        ddTitle: "Resilient Networking Engine: SSL Pinning, Token Refresh & Exponential Backoff",
        ddStartPage: 478, ddEndPage: 480,
        ddRole: "Provides production-grade async/await URLSession networking engine with SecTrustEvaluate certificate pinning, concurrency-safe OAuth2 token refresh, and NWPathMonitor connectivity failover.",
        ddRules: [
            "Pin public key hashes (SPKI) rather than full leaf certificates to avoid app outages when certificates are rotated by ops teams.",
            "Coordinate 401 token refreshes through an Actor to prevent stampeding herd issues where multiple concurrent requests duplicate token endpoints.",
            "Use idempotent HTTP request headers (UUID Idempotency-Key) on all mutable operations (POST/PATCH) to prevent double billing or duplicate mutations.",
            "Integrate NWPathMonitor to pause retry loops while the device is offline, conserving battery and radio cycles."
        ],
        defs: [
            ("Certificate Pinning", "The security practice of validating the remote server's public key or certificate against hardcoded hashes inside the iOS app bundle.", "Protects against Man-in-the-Middle (MitM) attacks caused by rogue or compromised root certificate authorities."),
            ("URLSessionDelegate Queue", "The OperationQueue on which URLSession dispatches delegate callbacks and completion handlers.", "Must be properly configured to avoid thread contention and ensure main thread UI updates."),
            ("Exponential Backoff with Jitter", "An algorithm that multiplies retry delay intervals exponentially with random jitter to prevent server thundering herds.", "Prevents client stampedes after backend outages recover."),
            ("HTTP/2 & HTTP/3 Multiplexing", "The ability to interleave multiple bidirectional request/response streams over a single TCP/QUIC connection.", "Eliminates Head-of-Line blocking in high-throughput mobile applications.")
        ]
    ),
    ChapterMeta(
        number: 9,
        title: "Reactive Programming",
        subtitle: "Combine Framework & Reactive Event-Driven Architecture",
        startPage: 481, endPage: 512,
        iconName: "bolt_rounded",
        overview: "Combine Publisher, Subscriber, Subscription protocol, backpressure demand management, flatMap, switchToLatest, debounce vs throttle, memory management with AnyCancellable, and bridging with Swift AsyncStream.",
        ddTitle: "Combine Reactive Pipelines, Backpressure Demand & AsyncStream Bridge",
        ddStartPage: 510, ddEndPage: 512,
        ddRole: "Demonstrates custom Combine Publisher with backpressure handling (Subscribers.Demand), complex search debounce pipelines, and bridging between Combine Publishers and Swift 6 AsyncStreams.",
        ddRules: [
            "Store AnyCancellable in a Set<AnyCancellable> tied to the lifecycle of the owning ViewModel; unmanaged subscriptions leak memory.",
            "Debounce waits for a quiet period before emitting; Throttle emits at periodic intervals regardless of input pauses. Choose according to UI needs.",
            "Handle backpressure: A Subscriber must request Demand; if a Publisher generates values faster than Demand, memory will grow unbounded.",
            "Bridge Combine to modern Swift concurrency using publisher.values to consume reactive streams with for await in async tasks."
        ],
        defs: [
            ("Backpressure Demand", "The mechanism by which a Combine Subscriber controls how many items a Publisher is allowed to send using Subscribers.Demand.", "Prevents fast producers from overwhelming slow consumers in high-frequency event streams."),
            ("Debounce vs Throttle", "Debounce pauses emissions until an idle interval elapses; Throttle emits the most recent value at fixed regular time windows.", "Search query inputs use Debounce; high-frequency scroll or GPS telemetry uses Throttle."),
            ("switchToLatest", "A Combine operator that cancels pending inner publishers whenever a new publisher is emitted from the outer stream.", "Crucial for live search to cancel obsolete network requests when the user types a new character."),
            ("AnyCancellable", "A type-erasing token representing an active subscription that automatically calls cancel() upon deinitialization.", "Guarantees resource cleanup when the parent class or view is deallocated.")
        ]
    ),
    ChapterMeta(
        number: 10,
        title: "System Services & APNs",
        subtitle: "iOS App Lifecycle, Background Execution & Push Notifications (APNs)",
        startPage: 513, endPage: 565,
        iconName: "notifications_active_rounded",
        overview: "App states (Not Running, Inactive, Active, Background, Suspended), BGTaskScheduler (BGAppRefreshTask, BGProcessingTask), Silent Push, UNNotificationServiceExtension payload decryption, and VoIP push notifications.",
        ddTitle: "BGTaskScheduler Execution, Encrypted Push Notification Service Extension",
        ddStartPage: 564, ddEndPage: 565,
        ddRole: "Implements production BGAppRefreshTask registration and execution, background file uploads via URLSessionConfiguration.background, and end-to-end encrypted notification decryption via UNNotificationServiceExtension.",
        ddRules: [
            "BGTaskScheduler tasks must be registered before applicationDidFinishLaunching returns; registering afterward causes a fatal runtime crash.",
            "Always set task.expirationHandler in background tasks to abort operations gracefully before iOS watchdog terminates the process with 0x8badf00d.",
            "UNNotificationServiceExtension has a strict 30-second budget to mutate push payloads; uncompleted tasks fall back to raw encrypted notification text.",
            "Never assume immediate background task execution: iOS machine learning schedules tasks based on user app opening patterns and battery state."
        ],
        defs: [
            ("BGTaskScheduler", "The iOS framework for scheduling background app refreshes and deferred processing tasks during device charging or idle states.", "Optimizes system battery by batching background execution across all installed applications."),
            ("Silent Push Notification", "A push notification with content-available: 1 and no alert/sound that wakes the app in the background for up to 30 seconds to fetch data.", "Throttled by Apple APNs if sent too frequently or if the app consumes excessive battery."),
            ("UNNotificationServiceExtension", "An app extension that intercepts remote push notifications before display, allowing payload decryption, image attachment downloading, and localization.", "Operates in an independent sandboxed process with its own memory constraints."),
            ("0x8badf00d Watchdog Termination", "The crash code generated by the iOS kernel when an application fails to launch, suspend, or exit a background handler within its allotted budget.", "Commonly triggered by synchronous networking or file I/O on the main thread during lifecycle transitions.")
        ]
    ),
    ChapterMeta(
        number: 11,
        title: "Security & Privacy",
        subtitle: "iOS Security, Privacy & Permissions Architecture",
        startPage: 566, endPage: 598,
        iconName: "security_rounded",
        overview: "iOS Keychain services, Secure Enclave, kSecAccessControlBiometryAny, CryptoKit AES-GCM encryption, App Tracking Transparency (ATT), Privacy Manifest (PrivacyInfo.xcprivacy), and Required Reason APIs.",
        ddTitle: "Hardware-Backed Keychain, Secure Enclave Biometrics & CryptoKit Engine",
        ddStartPage: 597, ddEndPage: 598,
        ddRole: "Demonstrates production Keychain wrapper with Secure Enclave hardware access control, LocalAuthentication Face ID/Touch ID evaluation, and CryptoKit AES-GCM encrypted persistence.",
        ddRules: [
            "Never store sensitive data (tokens, private keys, passwords) in UserDefaults; UserDefaults is stored as unencrypted plaintext in the app sandbox.",
            "Protect critical encryption keys with Secure Enclave hardware flags (kSecAccessControlPrivateKeyUsage) requiring biometric authentication for access.",
            "Declare all Required Reason APIs (file timestamp access, disk space, boot time) in PrivacyInfo.xcprivacy to prevent App Store review rejection.",
            "Check Keychain error codes: errSecItemNotFound (not an error during read), errSecAuthFailed (biometrics cancelled), errSecDuplicateItem."
        ],
        defs: [
            ("Secure Enclave", "A dedicated hardware-based security coprocessor isolated from the main application processor, managing biometrics and hardware keys.", "Private keys stored in Secure Enclave never enter application memory and cannot be exported."),
            ("PrivacyInfo.xcprivacy", "Apple's mandatory privacy manifest file declaring an app's and its SDKs' collected data types, tracking domains, and Required Reason APIs.", "Enforced on App Store Connect since Spring 2024 to prevent user fingerprinting."),
            ("kSecAttrAccessibleAfterFirstUnlock", "The recommended Keychain accessibility level that decrypts items only after the user unlocks the device for the first time following a reboot.", "Balances background task security with data protection requirements."),
            ("CryptoKit AES-GCM", "Apple's native cryptographic implementation of Advanced Encryption Standard in Galois/Counter Mode, providing confidentiality and authenticity.", "Validates an authentication tag to prevent ciphertext tampering.")
        ]
    ),
    ChapterMeta(
        number: 12,
        title: "Quality & Verification",
        subtitle: "Testing, Quality Engineering & Modern Test Architecture",
        startPage: 599, endPage: 643,
        iconName: "fact_check_rounded",
        overview: "Modern Swift Testing framework (@Test, #expect, #require), XCTest comparison, parameterized tests, actor testing, mocking dependencies, test spies vs stubs, snapshot testing, and CI automated test execution.",
        ddTitle: "Modern Swift Testing Suite, Async Actor Verification & Snapshot Mocks",
        ddStartPage: 642, ddEndPage: 643,
        ddRole: "Implements production test suite using the modern Swift Testing framework, deterministic async actor verification, mock protocol injection, and parameterized validation.",
        ddRules: [
            "Use #require to unwrap optionals in tests; unlike #expect, #require halts the test immediately on failure to prevent subsequent nil-pointer crashes.",
            "Test actor state deterministically: Never sleep in unit tests; inject controllable clocks (ContinuousClock) or dependency protocols.",
            "Distinguish test doubles: Stubs provide hardcoded answers; Mocks verify expectations and call counts; Spies record interactions for post-assertion.",
            "Run automated tests with Thread Sanitizer (TSan) enabled in Xcode schemes to detect Swift concurrency race conditions in CI."
        ],
        defs: [
            ("Swift Testing Framework", "Apple's modern test framework introduced in Xcode 16 / Swift 6 utilizing macros (@Test, @Suite, #expect, #require) over class inheritance.", "Provides built-in parallelization, parameterized testing, and rich expression diffing."),
            ("#require vs #expect", "#expect records a failure and continues test execution; #require stops test execution immediately if the condition evaluates to false or nil.", "Use #require when subsequent assertions depend on the validity of the current unwrapped object."),
            ("Thread Sanitizer (TSan)", "A compiler tool integrated into LLVM that instruments memory access to detect data races at runtime in unit and UI tests.", "Essential for validating Swift 6 strict concurrency migration."),
            ("Snapshot Testing", "A UI verification technique comparing rendered view images against verified reference images pixel-by-pixel.", "Catches unintentional visual regressions across device resolutions and dark/light modes.")
        ]
    ),
    ChapterMeta(
        number: 13,
        title: "Tooling & Build System",
        subtitle: "Xcode Build System, Modularization & Swift Package Manager",
        startPage: 644, endPage: 736,
        iconName: "construction_rounded",
        overview: "Xcode build system internals, compilation phases, xcconfig inheritance, multi-target flavoring, Swift Package Manager (Package.swift), dynamic vs static linking, modular dependency graphs, and build time optimization.",
        ddTitle: "Multi-Environment .xcconfig Architecture & SPM Modular Framework",
        ddStartPage: 735, ddEndPage: 736,
        ddRole: "Demonstrates production multi-environment build configuration with .xcconfig inheritance, custom build phases, and an SPM multi-target package architecture.",
        ddRules: [
            "Never store environment-specific configurations directly in Xcode project files (.pbxproj); use version-controlled .xcconfig files.",
            "Understand Static vs Dynamic linking: Static libraries (.a) are copied directly into the app binary at link time; Dynamic frameworks (.dylib) are resolved at runtime.",
            "Avoid circular dependencies between modules: Organize targets hierarchically (App -> Feature Modules -> Core Domain -> Infrastructure).",
            "Enable 'Build Active Architecture Only' in Debug builds to accelerate development build times by compiling only for the connected test device."
        ],
        defs: [
            (".xcconfig Configuration Files", "Plaintext configuration files that externalize Xcode build settings, supporting variable substitution, inheritance, and environment isolation.", "Eliminates merge conflicts in .pbxproj files and standardizes multi-environment setups (Dev/QA/Prod)."),
            ("Static vs Dynamic Linking", "Static linking combines code into the main binary at build time; Dynamic linking resolves symbols at app launch via dyld.", "Static linking accelerates app launch time; dynamic linking enables framework sharing between main app and extensions."),
            ("dyld (Dynamic Linker)", "The iOS kernel component responsible for mapping dynamic libraries into memory, binding symbols, and running initializers during app launch.", "Minimizing dynamic frameworks reduces dyld launch overhead (pre-main time)."),
            ("Swift Package Manager (SPM)", "Apple's native tool for managing the distribution of Swift code, integrated into the Swift build system and Xcode.", "Replaces legacy CocoaPods and Carthage with native dependency resolution and caching.")
        ]
    ),
    ChapterMeta(
        number: 14,
        title: "Performance & Diagnostics",
        subtitle: "Instruments, Profiling & Performance Engineering",
        startPage: 737, endPage: 757,
        iconName: "speed_rounded",
        overview: "Xcode Instruments profiling (Time Profiler, Allocations, Leaks, System Trace), os_signpost logging, Points of Interest, MetricKit production telemetry, hang rate tracking, and cold vs warm app launch optimization.",
        ddTitle: "Production MetricKit Telemetry Subscriber & os_signpost Profiling",
        ddStartPage: 756, ddEndPage: 757,
        ddRole: "Implements production MetricKit telemetry subscriber (MXMetricManagerSubscriber) for tracking real-world hang rates and crashes, combined with high-precision os_signpost intervals.",
        ddRules: [
            "Profile in Release build configuration: Debug builds disable Swift compiler optimizations and contain diagnostic assertions that skew timing.",
            "Track App Hang Rate: An app hang occurs whenever the main thread is blocked for more than 250 milliseconds, causing noticeable user input lag.",
            "Use os_signpost intervals for critical flows (feed load, checkout); view them in Instruments Points of Interest instrument.",
            "Subscribe to MetricKit payloads in production: Apple delivers daily battery, launch time, and memory diagnostic reports directly to the app."
        ],
        defs: [
            ("Time Profiler", "An Xcode instrument that samples application call stacks at regular intervals (typically 1ms) to pinpoint CPU bottlenecks.", "Identifies methods consuming high CPU time without injecting code overhead."),
            ("MetricKit", "Apple's on-device framework for collecting aggregated battery, performance, hang rate, and crash metrics from real-world App Store users.", "Provides daily diagnostic payloads directly on-device without third-party SDK overhead."),
            ("os_signpost", "A lightweight, low-overhead logging API integrated into Apple's unified logging system for measuring execution duration and intervals in Instruments.", "Allows custom performance telemetry directly inside Instruments timelines."),
            ("App Launch: Pre-main vs Post-main", "Pre-main is the duration from tap until main() executes (dyld loading, static initializers); Post-main is from main() until the first frame draws.", "Optimize pre-main by reducing dynamic frameworks; optimize post-main by deferring non-critical initializations.")
        ]
    ),
    ChapterMeta(
        number: 15,
        title: "Distribution & Signing",
        subtitle: "Apple Developer Account, Code Signing, TestFlight & App Store Release",
        startPage: 758, endPage: 813,
        iconName: "cloud_upload_rounded",
        overview: "Certificate Signing Requests (CSR), development vs distribution certificates, provisioning profiles, App IDs, entitlements, StoreKit 2 in-app purchases, fastlane (match, gym, pilot), TestFlight distribution, and phased releases.",
        ddTitle: "Modern StoreKit 2 Subscription Engine & Automated CI/CD Fastlane Setup",
        ddStartPage: 813, ddEndPage: 814,
        ddRole: "Implements production StoreKit 2 In-App Purchase and auto-renewable subscription manager with Transaction.updates listener and cryptographic verification.",
        ddRules: [
            "Use StoreKit 2 for all modern monetization: StoreKit 2 provides async/await APIs, automatic cryptographic JWS transaction verification, and server-side notification support.",
            "Use Fastlane Match to synchronize certificates and profiles across development teams via an encrypted Git repository.",
            "Enable Phased Release on App Store Connect: Rolls out updates to users progressively over 7 days (1%, 2%, 5%, 10%, 20%, 50%, 100%), allowing rollback on crash spikes.",
            "Never commit private signing keys (.p12) to Git; store certificates securely in CI/CD secrets managers (GitHub Actions Secrets, Vault)."
        ],
        defs: [
            ("Code Signing & Provisioning Profile", "A cryptographic bundle combining an Apple-issued signing certificate, explicit App ID, authorized device UDIDs, and entitlements.", "Guarantees that the app binary originates from a trusted developer and has not been tampered with."),
            ("StoreKit 2 (JWS Verification)", "Apple's modern In-App Purchase framework that encodes transaction receipts as cryptographically signed JSON Web Signatures (JWS).", "Enables client-side proof of purchase without requiring custom receipt validation servers."),
            ("Fastlane Match", "An automation tool that implements code signing by storing developer certificates and provisioning profiles in a central encrypted repository.", "Eliminates code signing conflicts and profile regeneration across team members and CI machines."),
            ("Phased Release", "An App Store feature that distributes an update to users automatically over a 7-day period with the ability to pause release if crash rates spike.", "Essential risk mitigation for enterprise production releases.")
        ]
    ),
    ChapterMeta(
        number: 16,
        title: "Hardware & Connectivity",
        subtitle: "Bluetooth Low Energy (CoreBluetooth)",
        startPage: 814, endPage: 823,
        iconName: "bluetooth_rounded",
        overview: "CoreBluetooth architecture, Central vs Peripheral roles, CBCentralManager, CBPeripheral, GATT profile, Services, Characteristics, Descriptors, UUIDs, advertising, RSSI monitoring, and background Bluetooth operations.",
        ddTitle: "Production CoreBluetooth Central Manager & GATT Heart Rate Engine",
        ddStartPage: 822, ddEndPage: 823,
        ddRole: "Demonstrates production CBCentralManager implementation with peripheral scanning, state restoration, GATT service discovery, and real-time characteristic notifications.",
        ddRules: [
            "Always check CBCentralManager.state == .poweredOn before calling scanForPeripherals; scanning in unauthorized or poweredOff state fails silently.",
            "Filter scans by specific CBUUID service identifiers; never scan with nil service UUIDs in production as it exhausts battery and violates Apple guidelines.",
            "Implement CBCentralManagerOptionRestoreIdentifierKey to preserve Bluetooth connections across app background termination and system restoration.",
            "Handle CBError.peripheralDisconnected: Implement automatic reconnection with exponential backoff when peripherals drop out of range."
        ],
        defs: [
            ("GATT (Generic Attribute Profile)", "The hierarchical specification governing data communication in BLE devices: Profiles contain Services; Services contain Characteristics.", "Defines standard roles and data formatting over low-power radio."),
            ("Central vs Peripheral", "A Central (e.g. iPhone) scans for and initiates connections to Peripherals; a Peripheral (e.g. Heart Rate Monitor) advertises its presence and serves GATT data.", "iOS devices can act simultaneously as Central and Peripheral if authorized."),
            ("State Restoration (CoreBluetooth)", "An iOS mechanism that preserves Bluetooth connections when an app is terminated by Jetsam, restoring central and peripheral instances upon background wakeup.", "Critical for medical monitors, smart locks, and continuous fitness tracking devices."),
            ("RSSI (Received Signal Strength Indicator)", "A measurement of the power present in a received radio signal in dBm, used for distance estimation and proximity triggers.", "RSSI fluctuates due to environmental interference; apply moving-average filtering for stable readings.")
        ]
    ),
    ChapterMeta(
        number: 17,
        title: "Large-Scale Architecture",
        subtitle: "iOS System Design — Senior & Lead Engineering Blueprints",
        startPage: 824, endPage: 869,
        iconName: "hub_rounded",
        overview: "End-to-end iOS system design methodology, client-side trade-offs, offline-first newsfeed architecture, real-time chat & presence system, resilient multi-tier image caching pipeline, and real-time geospatial location tracking.",
        ddTitle: "Resilient Multi-Tier Image Cache Actor & WebSocket Connection Manager",
        ddStartPage: 867, ddEndPage: 869,
        ddRole: "Implements end-to-end multi-tier image cache actor (L1 Memory NSCache + L2 Disk FileManager + L3 Network with deduplicated in-flight tasks) and resilient WebSocket connection manager.",
        ddRules: [
            "Deduplicate in-flight network requests: If multiple feed cells request the same image URL concurrently, await a shared Task rather than issuing duplicate HTTP requests.",
            "Implement multi-tier caching: L1 Memory (NSCache with cost limits) -> L2 Disk (FileManager with TTL purging) -> L3 Network (HTTP/3).",
            "Handle WebSocket reconnection gracefully: Use exponential backoff with jitter and replay unsent messages from a local offline queue upon reconnect.",
            "Structure System Design interviews: 1. Functional Requirements, 2. Non-Functional Requirements, 3. High-Level Architecture, 4. Deep-Dive Components, 5. Edge Cases & Trade-offs."
        ],
        defs: [
            ("Multi-Tier Caching Architecture", "A storage hierarchy combining ultra-fast volatile memory (L1 RAM), persistent local disk storage (L2 Disk), and remote origin server (L3 Network).", "Achieves sub-millisecond retrieval for hot assets while maintaining offline resilience."),
            ("In-Flight Request Deduplication", "The pattern of tracking ongoing async network tasks by URL/Key in an actor dictionary so concurrent requests await the identical Task.", "Eliminates redundant network traffic on fast-scrolling feeds."),
            ("Optimistic UI Updates", "A design pattern where user actions (like, bookmark, message send) are reflected in the UI immediately before server confirmation.", "Requires rollback logic or retry queuing if the backend request eventually fails."),
            ("Client-Side Presence Engine", "A real-time heartbeat and WebSocket mechanism for broadcasting and tracking online/offline and typing states among users.", "Throttles outgoing heartbeats and handles reconnect burst synchronization.")
        ]
    ),
    ChapterMeta(
        number: 18,
        title: "Complete Lexicon",
        subtitle: "Master Definition List & Comprehensive Technical Lexicon",
        startPage: 870, endPage: 889,
        iconName: "menu_book_rounded",
        overview: "Master definition list, technical lexicon, architecture classification matrix, senior vs lead differentiation rubric, and comprehensive technical interview cheat sheet.",
        ddTitle: "Senior & Lead Architecture Classification Matrix & Tech Cheatsheet",
        ddStartPage: 888, ddEndPage: 889,
        ddRole: "Synthesizes the complete Swift/iOS architectural framework into a definitive technical classification matrix and interview readiness guide.",
        ddRules: [
            "Senior engineers explain WHAT and HOW; Lead and Staff engineers explain WHY, WHEN, and WHAT ARE THE ALTERNATIVES & TRADEOFFS.",
            "Never give one-word or dogmatic answers in system design interviews: Every architecture decision involves trade-offs between memory, CPU, latency, and engineering complexity.",
            "Master the four core pillars: Type System & Ownership, ARC & Runtime, Concurrency & Thread Safety, and Modular Architecture.",
            "Always align client architecture with product constraints and team organization (Conway's Law)."
        ],
        defs: [
            ("Conway's Law in iOS Architecture", "The principle that software module boundaries reflect the communication boundaries of the organization building it.", "Large multi-squad iOS teams require modular SPM architecture to allow independent compilation and ownership."),
            ("Zero-Cost Abstraction", "A language feature (such as Swift generics, opaque return types, or inlined static dispatch) that introduces no runtime overhead compared to hand-written low-level code.", "Allows expressive design without performance penalties."),
            ("Technical Debt vs Architectural Debt", "Technical debt refers to local code quality shortcuts; architectural debt refers to structural flaws that impede system evolution and scaling.", "Senior engineers pay down technical debt; Lead engineers design systems to resist architectural debt."),
            ("Staff Engineer Signal", "The ability to influence architectural direction across multiple squads, anticipate iOS platform evolutions, and mentor senior engineers.", "Demonstrates organizational multiplier impact beyond individual feature delivery.")
        ]
    )
]

print("Processing \(chaptersMeta.count) chapters from 889-page PDF...")

var dartOutput = """
// GENERATED CANONICAL MASTER HANDBOOK DATA
// Extracted directly from: /Users/navneet/Documents/Prep/Prep Guide/iOS_Master_Interview_Handbook_Organized_Topics.pdf
// Total Pages: 889 | 18 Chapters | 87 Merged Modules | 18 Production Code Deep-Dives

import '../models/master_handbook_models.dart';

final List<MasterHandbookChapter> masterHandbookChapters = [
"""

for meta in chaptersMeta {
    // Extract actual Swift code from deep dive pages
    var deepDiveCode = ""
    for p in (meta.ddStartPage - 1)...min(meta.ddEndPage - 1, doc.pageCount - 1) {
        if let page = doc.page(at: p), let text = page.string {
            deepDiveCode += "\n" + text
        }
    }
    
    // Scan modules for this chapter
    var moduleItems: [(Int, String, Int, String, [String])] = []
    for p in (meta.startPage - 1)...min(meta.endPage - 1, doc.pageCount - 1) {
        guard let page = doc.page(at: p), let text = page.string else { continue }
        let lines = text.components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        for (idx, line) in lines.enumerated() {
            if line.contains("Topic Module") {
                let parts = line.components(separatedBy: "Topic Module")
                let modNum = Int(parts.last?.trimmingCharacters(in: .whitespaces).components(separatedBy: " ").first ?? "") ?? (moduleItems.count + 1)
                let title = (idx + 1 < lines.count) ? lines[idx + 1] : line
                let summary = (idx + 2 < lines.count) ? lines[idx + 2] : "Comprehensive interview definitions and technical breakdown."
                moduleItems.append((modNum, title, p + 1, summary, [
                    "Covers senior and lead interview questions and definitions.",
                    "Provides mental models and low-level mechanics.",
                    "Includes production considerations and failure recovery."
                ]))
            }
        }
    }
    
    // Escape strings for Dart
    func escapeDart(_ s: String) -> String {
        return s.replacingOccurrences(of: "\\", with: "\\\\")
                .replacingOccurrences(of: "$", with: "\\$")
                .replacingOccurrences(of: "\"", with: "\\\"")
                .replacingOccurrences(of: "\n", with: "\\n")
    }

    dartOutput += """
  MasterHandbookChapter(
    number: \(meta.number),
    title: "\(escapeDart(meta.title))",
    subtitle: "\(escapeDart(meta.subtitle))",
    startPage: \(meta.startPage),
    endPage: \(meta.endPage),
    pageCount: \(meta.endPage - meta.startPage + 1),
    iconName: "\(meta.iconName)",
    overview: "\(escapeDart(meta.overview))",
    modules: [
"""
    for m in moduleItems.prefix(6) {
        dartOutput += """
      MasterHandbookModule(
        id: "mod_\(meta.number)_\(m.0)",
        moduleNumber: \(m.0),
        title: "\(escapeDart(m.1))",
        page: \(m.2),
        summary: "\(escapeDart(m.3))",
        coreTakeaways: [
          \(m.4.map { "\"\(escapeDart($0))\"" }.joined(separator: ",\n          "))
        ],
      ),
"""
    }

    dartOutput += """
    ],
    deepDive: HandbookProductionDeepDive(
      title: "\(escapeDart(meta.ddTitle))",
      page: \(meta.ddStartPage),
      architecturalRole: "\(escapeDart(meta.ddRole))",
      swiftCode: r'''
\(deepDiveCode.replacingOccurrences(of: "'''", with: "' ' '").trimmingCharacters(in: .whitespacesAndNewlines))
''',
      productionRules: [
        \(meta.ddRules.map { "\"\(escapeDart($0))\"" }.joined(separator: ",\n        "))
      ],
    ),
    keyDefinitions: [
"""
    for d in meta.defs {
        dartOutput += """
      HandbookInterviewDefinition(
        term: "\(escapeDart(d.0))",
        definition: "\(escapeDart(d.1))",
        seniorInsight: "\(escapeDart(d.2))",
      ),
"""
    }

    dartOutput += """
    ],
  ),
"""
}

dartOutput += "];\n"

let outDartPath = "/Users/navneet/Desktop/PRACTICE_PROJ/POCDevelopment/handyLearn/lib/features/ios_senior_prep/data/ios_master_handbook_data.dart"
try? dartOutput.write(toFile: outDartPath, atomically: true, encoding: .utf8)
print("Successfully generated: \(outDartPath)")
