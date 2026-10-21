#!/usr/bin/env python3
"""
enrich_benchmarks_and_git.py
Generates:
1. lib/features/ios_senior_prep/data/ios_prep_benchmarks_data.dart (10 Landmark Benchmark Questions with authentic 4-tier calibrated answers)
2. lib/features/ios_senior_prep/data/ios_prep_git_puzzles_data.dart (33 full, professional Git scenarios with exact commands and step-by-step resolution)
"""

import os

BENCHMARKS_DART_PATH = "lib/features/ios_senior_prep/data/ios_prep_benchmarks_data.dart"
GIT_PUZZLES_DART_PATH = "lib/features/ios_senior_prep/data/ios_prep_git_puzzles_data.dart"

benchmarks = [
    {
        "id": 1,
        "question": "How does ARC manage memory, and what are its performance and architectural trade-offs?",
        "coreCompetency": "Memory Management & ARC Internals",
        "juniorAnswer": "ARC (Automatic Reference Counting) manages memory by tracking the number of strong references to class instances. At compile time, the compiler inserts retain and release calls automatically. When the reference count drops to zero, the object is deallocated and its deinit is called. Retain cycles occur when two objects hold strong references to each other, which we fix by marking one reference as weak or unowned.",
        "midAnswer": "ARC eliminates the non-deterministic pauses of garbage collectors by deterministically freeing memory on the thread where the last strong reference drops. We use strong references for ownership, weak (which is always optional and automatically zeros when the object is freed) for parent delegates or child-to-parent links, and unowned when the referenced object has an identical or longer lifecycle. In closures, we use [weak self] capture lists to prevent retain cycles. For bulk allocations in tight loops, autoreleasepool blocks drain transient Objective-C bridged objects immediately rather than waiting for the RunLoop to complete.",
        "seniorAnswer": "Under the hood, Swift stores inline reference counts in a 64-bit object header (isa pointer + inline retain count bits). When the retain count overflows or when a weak reference is created, Swift allocates an external Side Table. Weak pointers point directly to the side table rather than the object, allowing lazy zeroing without memory corruption. Unowned references increment an unowned reference count; if accessed after strong counts hit zero, an unowned(safe) access triggers a runtime trap (SIGTRAP) while unowned(unsafe) results in dangling memory reads. ARC introduces atomic CPU bus-locking overhead on every retain/release call. In performance-critical loops, excessive retain traffic can cause CPU cache line bouncing across cores.",
        "staffAnswer": "At Staff scale, memory management is an architectural system design problem involving dirty vs compressed memory, Jetsam thresholds, and CPU cache locality. Standard ARC atomic increments/decrements (swift_retain / swift_release) degrade throughput in high-frequency pipelines (audio buffers, 120fps graphics, telemetry streaming). We eliminate ARC overhead by adopting value semantics with Copy-on-Write (using isKnownUniquelyReferenced) or Swift 5.9+ non-copyable types (~Copyable) to enforce unique ownership at zero runtime cost. In large apps, we establish hard dirty memory ceilings (e.g. max 35MB for App Extensions, 150MB baseline for main app), monitor MetricKit MXDiagnosticPayloads for out-of-memory (OOM) Jetsam terminations, and implement multi-tier downsampling pipelines using CGImageSourceCreateThumbnailAtIndex to prevent multi-megabyte bitmap allocations.",
        "guide": "Calibrate candidate answer depth: Junior understands syntax and retain cycles; Mid understands weak/unowned lifecycles and autoreleasepool; Senior analyzes object headers, side tables, and atomic traffic; Staff articulates CPU bus locking, dirty memory budgeting, Jetsam mitigation, and ~Copyable zero-cost ownership."
    },
    {
        "id": 2,
        "question": "How do you achieve thread safety and prevent race conditions in Swift?",
        "coreCompetency": "Concurrency, Isolation & Thread Safety",
        "juniorAnswer": "We ensure thread safety by dispatching tasks to background queues using DispatchQueue.global() and then hopping back to DispatchQueue.main.async to update the user interface. We avoid mutating shared variables from multiple threads simultaneously.",
        "midAnswer": "Thread safety is achieved using serial DispatchQueues to serialize access to shared state, or using concurrent queues with dispatch barriers (DispatchWorkItemFlags.barrier) for reader-writer locks. We also use NSLock, NSRecursiveLock, or modern async/await with actors. In Swift, an actor protects its mutable state by synchronizing access through mailbox queues, ensuring only one task executes on its isolated state at a time.",
        "seniorAnswer": "In modern Swift, race prevention is divided into low-level OS primitives and Swift 6 compile-time data isolation. At the low level, OSAllocatedUnfairLock is the fastest mutex (replacing os_unfair_lock), outperforming DispatchQueues by avoiding thread hop context switches. For actors, seniors understand re-entrancy: when an actor method awaits an asynchronous call, it suspends and releases its lock. When it resumes, mutable state may have changed, creating logical race conditions. Seniors know how to protect invariants across suspension points by caching local state or re-verifying conditions after await.",
        "staffAnswer": "At an enterprise architecture level, thread safety shifts from runtime defensive locking to compile-time proof systems using Swift 6 Strict Concurrency. We enforce Sendable conformance across module boundaries, leveraging Region-Based Isolation (SE-0414) where non-Sendable values can safely cross isolation domains if the compiler proves no overlapping aliases exist. We design actor hierarchies where global state is isolated to @MainActor or domain-specific actors, avoiding actor hops that incur task context switching latency. For legacy C/C++ libraries or metal pipelines, we build custom locks using Atomic primitives from the swift-atomics package with acquire-release memory orderings, and mandate CI Thread Sanitizer (TSan) builds on every pull request to catch edge-case data races before release.",
        "guide": "Junior mentions GCD main/global; Mid understands serial queues, barriers, and actors; Senior explains OSAllocatedUnfairLock, actor re-entrancy suspension hazards, and invariant verification; Staff leads Swift 6 migration, Region-Based Isolation, lock-free atomics, and TSan CI gating."
    },
    {
        "id": 3,
        "question": "Explain Method Dispatch in Swift and how to optimize it.",
        "coreCompetency": "Method Dispatch & Compiler Optimization",
        "juniorAnswer": "Swift has static dispatch and dynamic dispatch. Static dispatch is faster because the compiler knows which method to call at compile time. Dynamic dispatch is used when classes inherit from each other and override methods, deciding which method to call at runtime.",
        "midAnswer": "Swift uses three dispatch mechanisms: 1) Direct (Static) Dispatch: functions in structs, enums, final classes, or private methods are inlined or jumped to directly. 2) Table (Virtual) Dispatch: classes use a virtual method table (V-Table) to lookup overridden methods; protocols use a Protocol Witness Table (PWT). 3) Message Dispatch: Objective-C runtime (@objc dynamic) uses objc_msgSend, supporting swizzling and runtime reflection.",
        "seniorAnswer": "Under the hood, Direct dispatch replaces calls with direct memory jumps (BL instruction on ARM64) and enables LLVM function inlining, instruction reordering, and dead-code stripping. V-Table dispatch requires an extra memory dereference through the object's metadata. Protocol Witness Tables require existential container overhead (3 words buffer + Value Witness Table + Protocol Witness Table = 40 bytes) and indirect pointer jumping. Seniors understand the protocol extension trap: methods declared only in a protocol extension (not in the protocol blueprint) use static dispatch based on the compile-time variable type, not the runtime dynamic type! Whole Module Optimization (WMO) optimizes dynamic dispatch by automatically devirtualizing methods if no subclasses override them across the module.",
        "staffAnswer": "At Staff scale, method dispatch impacts binary size, CPU instruction cache (L1 i-cache) locality, and framework boundary performance. Dynamic dispatch creates branch prediction misses and inhibits Link-Time Optimization (LTO). In large modular codebases (50+ SPM packages), public class methods across module boundaries cannot be devirtualized unless library evolution is disabled or @_specialize is applied. Staff engineers establish architectural rules: prefer structs and protocols with primary associated types (some Protocol) over existentials (any Protocol) to preserve static dispatch; mark all internal classes final by default; and profile dispatch overhead using Instruments Time Profiler to locate virtual call bottlenecks in hot loops.",
        "guide": "Junior knows static vs dynamic; Mid explains Direct, V-Table, PWT, and Message Dispatch with @objc; Senior highlights the Protocol Extension Dispatch Trap, existential container 40-byte overhead, and WMO devirtualization; Staff analyzes ARM64 BL branches, L1 i-cache misses, SPM modularity devirtualization barriers, and some vs any dispatch costs."
    },
    {
        "id": 4,
        "question": "How do you architect an enterprise iOS application for scale and modularity?",
        "coreCompetency": "Enterprise Architecture & SPM Modularity",
        "juniorAnswer": "We organize the project into folders like Models, Views, ViewControllers, and Services. We use MVVM to keep view controllers slim and separate business logic from the UI.",
        "midAnswer": "We decouple the app into separate layers: UI (Views & ViewModels), Domain (UseCases & Entities), and Data (Repositories & API Clients). We use Dependency Injection (passing protocols rather than concrete classes) and organize code into local Swift Package Manager (SPM) packages or frameworks for feature modularity.",
        "seniorAnswer": "Seniors implement Clean Architecture or Unidirectional Data Flow (TCA/MVI) with explicit module contracts. We divide the codebase into four horizontal tiers: App Entry/Composition Root -> Feature Modules -> Core Business Domain -> Foundational Infrastructure (Networking, Storage, Design System). Each feature module exposes only public protocols and models, keeping implementation internal. To eliminate circular dependencies, features communicate via App Coordinators or a type-safe Router/Event Bus. We use Xcode .xcconfig files to isolate build configurations and manage secrets across Dev, QA, Staging, and Prod schemes.",
        "staffAnswer": "Staff architects design multi-package SPM dependency graphs engineered for 100+ engineers and fast CI build times. We balance static libraries (which merge into the main binary, reducing dynamic linker dyld4 launch overhead) against dynamic frameworks (which allow independent compilation and hot module reloading during development). We enforce strict package access control using Swift 5.9's 'package' modifier to keep code shared across related packages without exposing it publicly. We implement a Composition Root pattern at the application launch boundary (AppDelegate/App) where the entire object graph is wired, forbidding Service Locators or global singletons. We build micro-apps (isolated example apps per SPM package) allowing feature teams to build and test their modules in seconds without compiling the monolithic host app.",
        "guide": "Junior describes folder structures; Mid separates layers and introduces local SPM; Senior details Clean Architecture tiers, circular dependency mitigation, and Coordinator routing; Staff governs SPM dependency graphs, static vs dynamic linking launch impact, micro-app developer velocity, and package access boundaries."
    },
    {
        "id": 5,
        "question": "What happens under the hood during a SwiftUI View update?",
        "coreCompetency": "SwiftUI Internal Mechanics & AttributeGraph",
        "juniorAnswer": "When a @State or @Binding variable changes, SwiftUI knows the data changed and automatically calls the body property of the view to re-render the screen with the new values.",
        "midAnswer": "SwiftUI Views are lightweight, immutable structs that represent a declarative description of the UI, not retained memory objects like UIView. When state changes, SwiftUI diffs the old view struct against the new view struct and applies only the changed attributes to the underlying rendering layer. We use @State for local state, @Binding for two-way bindings, and ObservableObject / @Observable for view models.",
        "seniorAnswer": "Under the hood, SwiftUI is backed by Apple's internal AttributeGraph C++ engine, which maintains a directed acyclic graph (DAG) of view dependencies. Every @State, @Binding, or @Environment property registers a dependency node. When a state property mutates, AttributeGraph marks only that node as dirty. During the next layout pass, SwiftUI traverses the dirty subgraphs. Seniors understand structural identity vs explicit identity (.id()): structural identity relies on the view's position within control flow (@ViewBuilder if/else branches), which allocates two distinct nodes in the graph; explicit identity binds state to a unique identifier. Unnecessary body evaluations occur when passing non-Equatable heavy dependencies or using AnyView, which destroys type metadata and forces full subtree invalidation.",
        "staffAnswer": "At Staff level, we optimize SwiftUI render pipelines for 120Hz ProMotion displays (strict 8.33ms per frame budget). We leverage the iOS 17 Observation framework (@Observable) which uses Swift macros and ObservationRegistrar to perform fine-grained property-level tracking; views only re-evaluate when the specific accessed property changes, unlike Combine ObservableObject which invalidates the view if ANY @Published property mutates. We profile view bodies using Instruments SwiftUI View Body Profiler and OSSignposter to eliminate body execution hitching. We enforce architectural rules: never perform computation or side-effects inside body; avoid AnyView; use structural identity deliberately to preserve view state and animations; and fall back to UIKit/CoreAnimation via UIViewRepresentable when sub-pixel custom interaction or specialized gesture recognition requires bare-metal control.",
        "guide": "Junior explains body re-rendering; Mid explains view struct diffing and state wrappers; Senior explains AttributeGraph DAG, dirty node propagation, and structural vs explicit identity; Staff optimizes for 120Hz frame budgets, compares @Observable vs ObservableObject property tracking, and profiles using Instruments."
    },
    {
        "id": 6,
        "question": "How do you diagnose and optimize App Launch Time?",
        "coreCompetency": "Runtime, dyld4 & App Launch Engineering",
        "juniorAnswer": "We optimize app launch by not doing too much work in application:didFinishLaunchingWithOptions: or viewDidLoad. We move heavy operations like database seeding or network requests to background threads so the UI appears quickly.",
        "midAnswer": "App launch is divided into Cold Launch (app process is created from disk) and Warm Launch (app is suspended in memory). We measure cold launch using Xcode Organizer or the Time Profiler instrument. We defer non-essential third-party SDK initializations (crash reporting, analytics, marketing SDKs) until after the first frame renders, and avoid blocking the main thread during initial view loading.",
        "seniorAnswer": "Seniors distinguish Pre-main time from Post-main time. Pre-main is handled by the dynamic linker (dyld4), which performs 4 stages: 1) dylib loading, 2) Rebase/Binding (adjusting pointer addresses for ASLR security), 3) ObjC runtime registration, 4) Initializers (+load methods, static constructors). We optimize pre-main by reducing dynamic framework count (converting to static libraries), removing deprecated +load methods in favor of +initialize or Swift lazy initializers, and minimizing global static variable instantiation. Post-main optimization involves trimming didFinishLaunchingWithOptions, deferring root view layout passes, and using MetricKit to collect real-world launch duration metrics (MXAppLaunchMetric) across user devices.",
        "staffAnswer": "Staff engineers establish an enterprise launch budget (<400ms cold launch target across the p95 user percentile). We instrument the launch path with OSSignposter and analyze the system trace using the Instruments App Launch template. We architect an asynchronous SDK Initialization Orchestrator: an acyclic DAG where essential security and feature-flag SDKs initialize concurrently, while non-blocking trackers (analytics, marketing) run after UIWindowScene becomes key and visible. We optimize binary layouts using Order Files and Link-Time Optimization (LTO) to group frequently accessed startup functions together on the same Mach-O code pages, drastically reducing Page Faults during initial binary paging into memory. We also configure dyld shared cache pre-warming and monitor launch regressions via CI automated performance tests on physical lab devices.",
        "guide": "Junior defers work to background threads; Mid separates cold vs warm and delays SDK init; Senior details dyld4 pre-main phases (dylib load, rebase/bind, initializers, Mach-O pages) and MetricKit; Staff enforces p95 launch budgets, architects asynchronous SDK DAG initializers, and leverages Order Files with LTO to prevent page faults."
    },
    {
        "id": 7,
        "question": "How do you architect an offline-first data sync engine with conflict resolution?",
        "coreCompetency": "Distributed Offline Sync & Persistence",
        "juniorAnswer": "We save data locally using CoreData or SQLite, and when the user is online, we make API calls to save it to the server. If there is no internet, we show an alert or save the request to try again later.",
        "midAnswer": "We implement an Optimistic UI pattern: user mutations immediately update the local database (CoreData/SwiftData/SQLite) and update the UI with a pending status. A background network monitor (NWPathMonitor) triggers a synchronization queue when connectivity resumes. Failed network requests are stored in a persistent mutation queue and retried with exponential backoff. When the server responds with the saved entity, we update local records with the official server ID.",
        "seniorAnswer": "Seniors design an end-to-end delta sync pipeline. To handle conflicts, we evaluate Last-Write-Wins (LWW) using UTC server timestamps vs Field-Level Merging vs 3-way User Prompts. Every mutation record in the local queue is assigned an Idempotency Key (UUID v4) and a monotonic sequence number to prevent duplicate processing on server retries. For deletions, we enforce Tombstoning (marking records isDeleted = true with a deletedAt timestamp) rather than physical row deletion, ensuring remote devices synchronize the deletion delta. We manage CoreData background concurrency using private queue contexts (newBackgroundContext) that merge changes into the view context via mergeChangesFromContextDidSaveNotification, eliminating main-thread SQLite lock contention.",
        "staffAnswer": "At Staff scale, offline synchronization is a distributed systems engineering challenge. In collaborative multi-user applications, Last-Write-Wins causes silent data loss; we architect Conflict-Free Replicated Data Types (CRDTs) such as State-based LWW-Element-Set or Operation-based text trees for collaborative editing. We implement Vector Clocks or Hybrid Logical Clocks (HLC) to capture causal ordering across devices without relying on synchronized physical clocks. We design chunked delta sync endpoints (GET /sync?cursor=XYZ) supporting server-driven pagination and partial synchronization. We optimize battery and cellular radio wake cycles by batching mutations, adhering to iOS background execution limits (BGAppRefreshTask and BGProcessingTask), and guaranteeing zero data loss during sudden app termination via atomic SQLite WAL (Write-Ahead Logging) transactions.",
        "guide": "Junior caches locally with basic retry; Mid explains optimistic UI, NWPathMonitor, and mutation queues; Senior covers delta sync, LWW vs field merge, idempotency keys, tombstoning, and CoreData background context merging; Staff architects CRDTs, Hybrid Logical Clocks, cursor-based delta pagination, and cellular radio battery optimization."
    },
    {
        "id": 8,
        "question": "How do you design a comprehensive testing strategy across the testing pyramid?",
        "coreCompetency": "Testing Strategy, CI/CD & Quality Engineering",
        "juniorAnswer": "We write unit tests in XCTest to verify our business logic and view model functions with XCTAssertEqual and XCTAssertTrue. We test happy paths and error cases.",
        "midAnswer": "We structure testing following the testing pyramid: a large base of Unit Tests (testing isolated domain logic, view models, and repositories with mock network protocols), a middle layer of Integration Tests (verifying persistence migrations, database queries, and repository-API coordination), and a lean top layer of UI Tests (XCUITest verifying critical user journeys like checkout and onboarding). We use protocols to inject mock dependencies and eliminate external network dependencies.",
        "seniorAnswer": "Seniors focus on test reliability, execution speed, and deterministic asynchronous testing. We eliminate flaky tests by avoiding arbitrary expectation timeouts (e.g. sleep or prolonged XCTWaiter), instead utilizing modern Swift Testing (#expect, @Test suite tags) or Swift Concurrency test clocks. In TCA/Clean architectures, we verify complete state mutations deterministically. We implement Snapshot Testing (swift-snapshot-testing) to catch visual regressions across different screen sizes, Dynamic Type settings, and Dark/Light modes without the heavy overhead of slow XCUITests. We mock the networking layer cleanly using custom URLProtocol subclasses to intercept requests without mocking high-level API clients.",
        "staffAnswer": "Staff engineers architect CI/CD test infrastructure that scales across 100+ pull requests daily without blocking developers. We design a stratified CI matrix: PR smoke tier runs fast unit and snapshot tests (<3 minutes) using test parallelization, test splitting, and build artifact caching (using Tuist or Bazel); nightly tier runs exhaustive end-to-end integration flows and localized UI tests across physical devices. We build Flaky Test Quarantining systems that automatically isolate non-deterministic tests from blocking PR merges while generating bug tickets for the owning team. We enforce strict test coverage baselines on critical financial and security modules, mandate mutation testing to verify test assertion quality, and use Xcode Cloud or GitHub Actions matrix workflows to prevent regressions across OS versions.",
        "guide": "Junior writes standard XCTAssert tests; Mid describes the unit/integration/UI pyramid with protocol mocks; Senior leverages Swift Testing, URLProtocol mocking, snapshot tests, and eliminates async flakiness; Staff architects CI/CD parallel execution, flaky test quarantine bots, mutation testing, and enterprise build caching."
    },
    {
        "id": 9,
        "question": "How do you architect security, authentication, and cryptographic storage on iOS?",
        "coreCompetency": "iOS Security, Keychain, CryptoKit & Enclave",
        "juniorAnswer": "We save sensitive data like passwords and tokens in the iOS Keychain instead of UserDefaults because Keychain is encrypted. We also communicate over HTTPS to secure network calls.",
        "midAnswer": "We store access and refresh tokens in Keychain Services using Security framework APIs with appropriate accessibility flags like kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly to prevent items from syncing to unmanaged iCloud backups. We implement biometric authentication using LocalAuthentication (LAContext) for Face ID / Touch ID. We secure network calls using SSL Pinning (pinning certificates or public keys) to protect against Man-in-the-Middle (MitM) proxy attacks.",
        "seniorAnswer": "Seniors architect defense-in-depth security. For cryptography, we utilize Apple's modern CryptoKit framework for symmetric encryption (AES-GCM, ChaCha20-Poly1305) and asymmetric key pairs (Curve25519, P-256). For high-security secrets, we generate private keys directly inside the hardware Secure Enclave using SecureEnclave.P256.Signing.PrivateKey, ensuring private keys can never be extracted or exported into RAM even if the kernel is compromised. We implement dynamic SSL Pinning via URLSessionDelegate (SecTrustEvaluateWithError) with Certificate Transparency validation and fallback pins. We prevent sensitive data leakage by hiding the snapshot preview in sceneWillResignActive and marking text fields as secure.",
        "staffAnswer": "Staff architects design zero-trust client architectures compliant with OWASP MASVS (Mobile Application Security Verification Standard). We integrate Apple App Attest and DeviceCheck to cryptographically verify app integrity and prevent API abuse from modified clients or botnets. We design secure OAuth 2.0 PKCE token refresh interceptors with cryptographic replay protection and mutual TLS (mTLS) for enterprise endpoints. We protect against runtime tampering, memory dumps, and reverse engineering through compile-time code obfuscation, anti-debugging checks (ptrace / sysctl), and jailbreak heuristic detection. We audit third-party SDK supply chain dependencies, enforce strict Privacy Manifests (PrivacyInfo.xcprivacy), and establish automated security vulnerability scanning in CI.",
        "guide": "Junior knows Keychain vs UserDefaults; Mid implements kSecAttrAccessible flags, Face ID (LAContext), and basic SSL pinning; Senior leverages Secure Enclave hardware keys, CryptoKit AES-GCM, Certificate Transparency, and background snapshot masking; Staff architects OWASP MASVS compliance, App Attest hardware validation, PKCE replay defense, anti-tampering, and privacy manifests."
    },
    {
        "id": 10,
        "question": "Explain the transition to Swift 6 Strict Concurrency and Region-Based Isolation.",
        "coreCompetency": "Swift 6 Strict Concurrency & Migration",
        "juniorAnswer": "Swift 6 makes concurrency safer by checking for data races at compile time. It requires types that are passed between threads to conform to the Sendable protocol.",
        "midAnswer": "In Swift 6, data-race safety is enforced by default. If you pass a mutable class instance across actor boundaries or background tasks, the compiler produces an error unless the class is Sendable (e.g. an immutable class with let properties, or an actor). We use @Sendable closures and mark UI classes with @MainActor to ensure they run on the main thread.",
        "seniorAnswer": "Seniors understand the mechanics of Sendable checking and isolation domains. Non-Sendable types cannot cross actor or task boundaries because shared mutable references cause data races. Swift 6 introduces Region-Based Isolation (SE-0414), which uses escape analysis: if a non-Sendable object is constructed locally and passed to another task, the compiler allows it IF it can mathematically prove that no aliases remain in the caller's isolation region (disconnected region). Seniors know how to migrate legacy code incrementally using Swift 5.10 with -warn-concurrency flags, resolving warnings via @unchecked Sendable with internal lock synchronization, nonisolated methods, and Task.detached with explicit captures.",
        "staffAnswer": "Staff engineers lead the organization-wide migration of massive multi-module codebases to the Swift 6 language mode without breaking developer velocity. We formulate an incremental migration roadmap: 1) Enable Complete Strict Concurrency checking (-strict-concurrency=complete) in Swift 5 mode on foundational packages first. 2) Modernize callback and delegate APIs to async/await and AsyncStream. 3) Replace ad-hoc GCD queues with Global Actors and domain-specific actors. 4) Restrict @unchecked Sendable usage through strict linting rules, requiring security and architecture review for any exceptions. 5) Train teams on Region-Based Isolation patterns, actor re-entrancy edge cases, and custom TaskExecutors. Staff engineers ensure third-party SPM dependencies are audited for Sendable compliance to prevent blocking compiler upgrades across the enterprise app.",
        "guide": "Junior defines Sendable; Mid explains actor boundaries and @MainActor; Senior details Region-Based Isolation (SE-0414), disconnected regions, and -warn-concurrency strategies; Staff leads enterprise-wide multi-module Swift 6 migration, manages @unchecked Sendable governance, and custom TaskExecutor integration."
    }
]

# Write benchmarks
with open(BENCHMARKS_DART_PATH, "w", encoding="utf-8") as f:
    f.write("// Comprehensive 10 Landmark Benchmark Calibration Questions across 4 Experience Tiers\n")
    f.write("// Fully calibrated for Junior, Mid, Senior, and Staff/Principal Engineering levels\n")
    f.write("import '../models/ios_prep_models.dart';\n\n")
    f.write("const List<BenchmarkCalibration> benchmarkCalibrations = [\n")
    for b in benchmarks:
        f.write("  BenchmarkCalibration(\n")
        f.write(f"    id: {b['id']},\n")
        f.write(f"    question: {repr(b['question'])},\n")
        f.write(f"    coreCompetency: {repr(b['coreCompetency'])},\n")
        f.write(f"    juniorAnswer: {repr(b['juniorAnswer'])},\n")
        f.write(f"    midAnswer: {repr(b['midAnswer'])},\n")
        f.write(f"    seniorAnswer: {repr(b['seniorAnswer'])},\n")
        f.write(f"    staffAnswer: {repr(b['staffAnswer'])},\n")
        f.write(f"    interviewEvaluationGuide: {repr(b['guide'])},\n")
        f.write("  ),\n")
    f.write("];\n")

print(f"Generated {len(benchmarks)} authentic landmark benchmark calibrations.")

# 33 Clean & Professional Git Scenarios
full_git_list = [
    {
        "id": 1,
        "title": "Scenario A: git merge vs. git rebase",
        "category": "Architectural & Recovery",
        "command": "# Merge feature into main (3-way merge commit)\ngit checkout main\ngit merge feature/user-auth\n\n# Or Rebase feature onto main (Linear history)\ngit checkout feature/user-auth\ngit rebase main",
        "explanation": "git merge combines histories by creating a new 3-way merge commit, preserving historical topology. git rebase replays commits linearly on top of main, creating an ultra-clean history that makes git bisect effortless.",
        "steps": [
            "git merge preserves branch history and exact commit timestamps at the cost of cluttered non-linear history.",
            "git rebase rewrites commit hashes to produce a linear graph, ideal for PR branches before merging into main.",
            "Golden Rule: Never rebase commits that have already been pushed to public shared branches!"
        ]
    },
    {
        "id": 2,
        "title": "Scenario B: Interactive Rebase & Squashing Commits",
        "category": "Architectural & Recovery",
        "command": "# Squash last 4 commits into 1 atomic commit\ngit rebase -i HEAD~4\n\n# In interactive editor:\n# pick e4a12b0 Initial implementation of auth\n# squash a1c45f2 Fix typo in auth view\n# squash b9d18e3 Update unit test assertions\n# squash d3e91a0 Address PR review feedback",
        "explanation": "Squash messy local work-in-progress commits into clean, logical atomic units before opening or merging a PR.",
        "steps": [
            "Run git rebase -i HEAD~N to open the interactive rebase editor.",
            "Keep the first commit as 'pick' and change subsequent commits to 'squash' (or 'fixup' to discard message).",
            "Save and exit editor, then write a concise, conventional commit message for the merged commit.",
            "If already pushed to a private branch, force update with git push --force-with-lease."
        ]
    },
    {
        "id": 3,
        "title": "Scenario C: Finding Regression Commits with git bisect",
        "category": "Architectural & Recovery",
        "command": "git bisect start\ngit bisect bad                 # Current HEAD has the bug\ngit bisect good v1.4.0         # Last known working release\n\n# Git checks out midpoint commits automatically (Binary Search O(log N))\n# Build and test, then mark status:\ngit bisect good   # or git bisect bad\n\n# Once identified, finish bisect session:\ngit bisect reset",
        "explanation": "Binary search through commit history to identify the exact commit that introduced a production regression or test failure.",
        "steps": [
            "Start bisect with git bisect start.",
            "Mark current buggy commit with git bisect bad.",
            "Mark last known good tag/SHA with git bisect good <commit/tag>.",
            "Test each midpoint commit checked out by Git and mark good or bad.",
            "Git outputs the exact offending commit hash and author. Reset with git bisect reset."
        ]
    },
    {
        "id": 4,
        "title": "Scenario D: Recovering Dropped Commits with git reflog",
        "category": "Architectural & Recovery",
        "command": "# View history of HEAD movements\ngit reflog\n\n# Find the commit SHA before the accidental reset (e.g. HEAD@{2})\ngit checkout -b recovery-branch <commit-SHA>",
        "explanation": "Git never immediately deletes loose objects. Even after an accidental git reset --hard or deleted branch, git reflog tracks every HEAD movement, enabling 100% recovery.",
        "steps": [
            "Run git reflog to inspect recent HEAD positions.",
            "Identify the commit SHA right before the destructive action occurred.",
            "Create a new branch from that commit: git checkout -b recovery-branch <SHA>.",
            "Verify all files and commits are safely restored."
        ]
    },
    {
        "id": 5,
        "title": "Scenario 1: Cloning a Remote Repository & Exploring Code",
        "category": "Branching & PRs",
        "command": "git clone https://github.com/org/repo.git\ncd repo\ngit status",
        "explanation": "Download a remote project with full history and inspect current workspace status.",
        "steps": [
            "Copy repository HTTPS or SSH clone URL.",
            "Run git clone <repo-url> in your target directory.",
            "Navigate into folder with cd <repo-name> and verify with git status."
        ]
    },
    {
        "id": 6,
        "title": "Scenario 2: Cloned Repo Shows Main but Code is on Feature Branch",
        "category": "Branching & PRs",
        "command": "# List all available branches (local and remote)\ngit branch -a\n\n# Switch to the target remote branch\ngit switch <branch-name>\n# Or legacy syntax: git checkout <branch-name>",
        "explanation": "By default, cloning checks out the default branch (main/master). Fetch and switch to the active development branch.",
        "steps": [
            "Inspect remote branches with git branch -a or git branch -r.",
            "Switch directly using modern git switch <branch-name>.",
            "Git automatically creates a tracking branch linked to origin/<branch-name>."
        ]
    },
    {
        "id": 7,
        "title": "Scenario 3: Pulling Latest Remote Updates Safely",
        "category": "Everyday Staging & Commits",
        "command": "git pull origin <current-branch-name>\n# Recommended: pull with rebase to keep history linear\ngit pull --rebase origin <current-branch-name>",
        "explanation": "Download and integrate latest remote commits into your active working branch.",
        "steps": [
            "Ensure working directory has no uncommitted conflicting changes.",
            "Run git pull origin <branch-name>.",
            "Use git pull --rebase to avoid creating unnecessary merge bubble commits."
        ]
    },
    {
        "id": 8,
        "title": "Scenario 4: Staging All Modifications & Creating a Commit",
        "category": "Everyday Staging & Commits",
        "command": "# Stage all changes and deletions\ngit add .\n\n# Commit with descriptive conventional message\ngit commit -m \"feat(auth): implement biometric token refresh\"",
        "explanation": "Stage all modified and newly created files into index and record a permanent commit.",
        "steps": [
            "Inspect changes with git status and git diff.",
            "Stage all modified files using git add . (or git add -A).",
            "Commit with a clear message: git commit -m \"type(scope): description\"."
        ]
    },
    {
        "id": 9,
        "title": "Scenario 5: Selectively Staging Individual Files & Unstaging",
        "category": "Everyday Staging & Commits",
        "command": "# Stage specific file\ngit add path/to/MyFile.swift\n\n# Stage multiple specific files\ngit add path/to/File1.swift path/to/File2.swift\n\n# Unstage an accidentally added file\ngit restore --staged path/to/AccidentalFile.swift\n# Legacy unstage: git reset HEAD path/to/AccidentalFile.swift",
        "explanation": "Stage only relevant files for atomic commits while leaving unrelated modifications unstaged.",
        "steps": [
            "Add files selectively using their relative or full paths: git add <path>.",
            "If a file was added accidentally, unstage it with git restore --staged <path>.",
            "Verify staged files with git diff --staged."
        ]
    },
    {
        "id": 10,
        "title": "Scenario 6: Discarding Local Uncommitted Modifications",
        "category": "Everyday Staging & Commits",
        "command": "# Discard all uncommitted changes in tracked files\ngit reset --hard HEAD\n\n# Discard changes in a single file\ngit restore path/to/File.swift\n# Legacy single file: git checkout HEAD -- path/to/File.swift\n\n# Remove untracked new files and directories\ngit clean -fd",
        "explanation": "Revert modified files back to the exact state of the latest commit.",
        "steps": [
            "To restore a single file: git restore <file-path>.",
            "To discard all tracked changes: git reset --hard HEAD.",
            "To delete untracked temporary files: git clean -fd."
        ]
    },
    {
        "id": 11,
        "title": "Scenario 7: Undoing the Most Recent Commit (Soft vs Hard)",
        "category": "Everyday Staging & Commits",
        "command": "# Undo commit, KEEP all changes in staging area\ngit reset --soft HEAD~1\n\n# Undo commit, KEEP changes in working tree (unstaged)\ngit reset --mixed HEAD~1\n\n# Undo commit and PERMANENTLY DESTROY all changes\ngit reset --hard HEAD~1",
        "explanation": "Rewind HEAD by one commit. Use --soft to preserve changes for re-committing, or --hard to completely discard.",
        "steps": [
            "Use git reset --soft HEAD~1 to re-package your changes into a better commit.",
            "Use git reset --hard HEAD~1 only if you want to completely discard the commit and its changes.",
            "Verify status with git status."
        ]
    },
    {
        "id": 12,
        "title": "Scenario 8: Stashing Uncommitted Work to Pull Remote Changes",
        "category": "Conflict Resolution",
        "command": "# Stash changes including untracked files with a name\ngit stash save \"WIP: network layer changes\" -u\n\n# Pull latest remote changes\ngit pull --rebase\n\n# Re-apply the stashed work\ngit stash pop",
        "explanation": "Temporarily shelf dirty working directory modifications so you can pull clean updates without merge conflicts.",
        "steps": [
            "Save state with git stash save \"description\" -u (-u includes untracked files).",
            "Pull latest changes from remote.",
            "Restore stashed work using git stash pop (or git stash apply 0 to keep the stash entry)."
        ]
    },
    {
        "id": 13,
        "title": "Scenario 9: Resolving Merge Conflicts After Stash Pop",
        "category": "Conflict Resolution",
        "command": "# View conflicting files\ngit status\n\n# Open file and resolve conflict markers (<<<<<<<, =======, >>>>>>>)\n# After editing, mark as resolved:\ngit add path/to/ResolvedFile.swift\n\n# Complete the resolution\ngit commit -m \"fix: resolve conflicts between stash and remote\"",
        "explanation": "When stashed changes collide with newly pulled commits, Git inserts conflict markers for manual resolution.",
        "steps": [
            "Identify conflicted files marked with 'both modified' in git status.",
            "Open each file and choose between incoming changes, current changes, or a combination.",
            "Remove all <<<<<<<, =======, and >>>>>>> markers.",
            "Stage resolved files with git add <file> and commit."
        ]
    },
    {
        "id": 14,
        "title": "Scenario 10: Creating & Switching to a New Branch for Work",
        "category": "Branching & PRs",
        "command": "# Modern command to create and switch\ngit switch -c feature/new-login-flow\n\n# Legacy equivalent:\ngit checkout -b feature/new-login-flow",
        "explanation": "Branch off the current branch into an isolated feature branch to commit your new work.",
        "steps": [
            "Run git switch -c <branch-name>.",
            "Stage and commit your changes safely in the new branch.",
            "To switch back to previous branch: git switch -."
        ]
    },
    {
        "id": 15,
        "title": "Scenario 11: Amending Missing Files or Message to Latest Commit",
        "category": "Everyday Staging & Commits",
        "command": "# Stage forgotten file\ngit add path/to/ForgottenFile.swift\n\n# Amend into previous commit without opening editor\ngit commit --amend --no-edit\n\n# Or amend to modify commit message\ngit commit --amend -m \"docs: updated architecture diagram\"",
        "explanation": "Fold forgotten modifications into the latest commit instead of polluting history with 'fix typo' commits.",
        "steps": [
            "Stage the missing file using git add <file>.",
            "Run git commit --amend --no-edit to merge changes into HEAD.",
            "Note: Amending rewrites the commit SHA. If already pushed, use git push --force-with-lease."
        ]
    },
    {
        "id": 16,
        "title": "Scenario 12: Pushing a New Branch & Raising a Pull Request",
        "category": "Branching & PRs",
        "command": "# Push branch and configure upstream tracking\ngit push --set-upstream origin feature/user-profile\n\n# Short syntax once set:\ngit push",
        "explanation": "Publish your local feature branch to the remote repository and link it for seamless pushing/pulling.",
        "steps": [
            "Run git push -u origin <branch-name>.",
            "Terminal displays the PR creation URL directly (GitHub/GitLab/Bitbucket).",
            "Open link in browser, specify target base branch (main), fill description, and submit PR."
        ]
    },
    {
        "id": 17,
        "title": "Scenario 13: Deleting Local and Remote Branches Cleanly",
        "category": "Branching & PRs",
        "command": "# Switch to main first\ngit switch main\n\n# Delete merged local branch (safe)\ngit branch -d feature/old-branch\n\n# Force delete unmerged local branch\ngit branch -D feature/old-branch\n\n# Delete remote branch on origin\ngit push origin --delete feature/old-branch",
        "explanation": "Prune stale feature branches locally and remotely after PR merge to keep repository clean.",
        "steps": [
            "Ensure you are not currently on the branch you want to delete: git switch main.",
            "Delete local branch: git branch -d <branch-name>.",
            "Delete remote branch: git push origin --delete <branch-name>.",
            "Prune local tracking references: git fetch --prune."
        ]
    },
    {
        "id": 18,
        "title": "Scenario 14: Renaming Local and Remote Branches",
        "category": "Branching & PRs",
        "command": "# Rename currently checked out local branch\ngit branch -m new-feature-name\n\n# Delete old remote branch\ngit push origin --delete old-feature-name\n\n# Push new branch and reset upstream\ngit push -u origin new-feature-name",
        "explanation": "Safely rename a branch locally and update the corresponding remote tracking branch.",
        "steps": [
            "Rename current branch using git branch -m <new-name>.",
            "Delete old branch on remote: git push origin --delete <old-name>.",
            "Push renamed branch: git push -u origin <new-name>."
        ]
    },
    {
        "id": 19,
        "title": "Scenario 15: Made Unintended Changes on Shared Branch (Moving to New Branch)",
        "category": "Branching & PRs",
        "command": "# Create and switch to new branch with existing uncommitted changes intact\ngit switch -c feature/my-isolated-work\n\n# Commit on new branch\ngit add .\ngit commit -m \"feat: isolated feature work\"",
        "explanation": "If you started editing directly on a shared branch (main/develop), branch off immediately without losing any uncommitted edits.",
        "steps": [
            "Run git switch -c <new-feature-branch> before committing.",
            "All dirty changes travel with you into the new branch.",
            "Commit safely in the new branch, leaving main clean."
        ]
    },
    {
        "id": 20,
        "title": "Scenario 16: Updating a Pushed Commit (Safe Force Push)",
        "category": "Everyday Staging & Commits",
        "command": "# Amend the commit locally\ngit add .\ngit commit --amend\n\n# Push safely using --force-with-lease (prevents overwriting teammate commits)\ngit push --force-with-lease origin feature/my-branch",
        "explanation": "When updating an already-pushed PR branch commit, always use --force-with-lease instead of destructive --force.",
        "steps": [
            "Amend or rebase your commit locally.",
            "Never use bare git push -f (which blindly destroys remote changes).",
            "Use git push --force-with-lease, which checks if someone else pushed commits to the remote first."
        ]
    },
    {
        "id": 21,
        "title": "Scenario 17: Push Rejected Because Remote Contains Newer Work",
        "category": "Conflict Resolution",
        "command": "# Pull and rebase your commits on top of remote\ngit pull --rebase origin <branch-name>\n\n# Push your cleanly rebased commits\ngit push origin <branch-name>",
        "explanation": "When another engineer pushed commits to the same branch, Git rejects non-fast-forward pushes. Rebase on top of remote before pushing.",
        "steps": [
            "Execute git pull --rebase origin <branch-name>.",
            "Git pauses if conflicts arise; resolve them and continue with git rebase --continue.",
            "Push cleanly with git push origin <branch-name>."
        ]
    },
    {
        "id": 22,
        "title": "Scenario 18: Resolving Conflicts During git pull --rebase",
        "category": "Conflict Resolution",
        "command": "# Check conflicted files\ngit status\n\n# Edit files, remove conflict markers, then mark resolved:\ngit add path/to/File.swift\n\n# Continue rebase process\ngit rebase --continue\n\n# (If you need to cancel: git rebase --abort)",
        "explanation": "Standard procedure for resolving rebase conflicts commit-by-commit.",
        "steps": [
            "Git pauses at the first conflicting commit.",
            "Open conflicted files and resolve markers.",
            "Stage resolved files using git add <file> (do NOT run git commit).",
            "Run git rebase --continue. Repeat until all commits are applied."
        ]
    },
    {
        "id": 23,
        "title": "Scenario 19: Pushing Safely with Lease Validation",
        "category": "Everyday Staging & Commits",
        "command": "git push --force-with-lease origin <branch-name>",
        "explanation": "--force-with-lease ensures you only overwrite the remote if no one else has updated it since your last fetch.",
        "steps": [
            "Protects against overwriting teammates' work in shared or pair-programming branches.",
            "If lease fails, run git fetch to inspect teammate's new commits before proceeding."
        ]
    },
    {
        "id": 24,
        "title": "Scenario 20: PR Shows Merge Conflicts with Base Branch (main)",
        "category": "Conflict Resolution",
        "command": "# Update local main first\ngit switch main\ngit pull origin main\n\n# Switch back to feature branch and rebase on main\ngit switch feature/my-feature\ngit rebase main\n\n# Resolve any conflicts, add files, and continue\ngit rebase --continue\n\n# Push updated branch to GitHub\ngit push --force-with-lease origin feature/my-feature",
        "explanation": "Sync feature branch with latest main so PR can be cleanly merged without conflicts.",
        "steps": [
            "Update main to ensure you have latest production commits.",
            "Rebase feature branch on top of main: git rebase main.",
            "Resolve conflicts and push with lease. PR conflict banner vanishes automatically."
        ]
    },
    {
        "id": 25,
        "title": "Scenario 21: Squashing Multiple Commits via Interactive Rebase",
        "category": "History Rewriting & Rebase",
        "command": "# Squash last N commits into a single commit\ngit rebase -i HEAD~N\n\n# Set first commit as 'pick', and all subsequent commits as 'squash'\n# Save and enter single unified commit message",
        "explanation": "Consolidate multiple small commits into a single cohesive commit before merging.",
        "steps": [
            "Run git rebase -i HEAD~N (where N is number of commits).",
            "Change pick to squash on lines 2 through N.",
            "Save and combine commit messages into one concise summary."
        ]
    },
    {
        "id": 26,
        "title": "Scenario 22: Squashing Multiple Commits via Soft Reset",
        "category": "History Rewriting & Rebase",
        "command": "# Reset HEAD to N commits ago while keeping all changes staged\ngit reset --soft HEAD~N\n\n# Commit everything as one single commit\ngit commit -m \"feat: complete unified implementation\"",
        "explanation": "Faster alternative to interactive rebase for squashing the last N commits.",
        "steps": [
            "Run git reset --soft HEAD~N.",
            "All changes from the last N commits remain staged in the index.",
            "Run git commit -m \"message\" to record as a single new commit."
        ]
    },
    {
        "id": 27,
        "title": "Scenario 23: Aborting or Resuming an Interrupted Rebase",
        "category": "Conflict Resolution",
        "command": "# To cancel completely and return to pre-rebase state:\ngit rebase --abort\n\n# To skip the current commit if changes are redundant:\ngit rebase --skip\n\n# To resume after resolving conflicts and staging:\ngit rebase --continue",
        "explanation": "Escape hatches and progression commands during complex rebase operations.",
        "steps": [
            "If a rebase gets messy or was started accidentally, execute git rebase --abort immediately.",
            "Your workspace returns 100% to the exact state before git rebase was run."
        ]
    },
    {
        "id": 28,
        "title": "Scenario 24: Copying a Commit to Another Branch (Cherry-Pick)",
        "category": "History Rewriting & Rebase",
        "command": "# Switch to target branch\ngit switch release/1.4.0\n\n# Cherry-pick the specific bugfix commit by SHA\ngit cherry-pick 7a8b9c2",
        "explanation": "Apply a specific commit from one branch (e.g. main) directly onto another branch (e.g. release hotfix).",
        "steps": [
            "Find the commit hash: git log --oneline.",
            "Switch to the target branch: git switch <target-branch>.",
            "Execute git cherry-pick <commit-SHA>.",
            "A new commit with identical changes is created on the target branch."
        ]
    },
    {
        "id": 29,
        "title": "Scenario 25: Resolving Conflicts During Cherry-Pick",
        "category": "Conflict Resolution",
        "command": "# Resolve conflict markers in code, then stage:\ngit add path/to/File.swift\n\n# Complete cherry-pick\ngit cherry-pick --continue\n\n# Or abort cherry-pick safely\ngit cherry-pick --abort",
        "explanation": "Handle conflicts that arise when cherry-picking onto a branch missing prerequisite changes.",
        "steps": [
            "Resolve conflict markers in the affected files.",
            "Stage resolved files: git add <file>.",
            "Run git cherry-pick --continue (or --abort to cancel)."
        ]
    },
    {
        "id": 30,
        "title": "Scenario 26: Moving a Range of Commits to a New Branch",
        "category": "History Rewriting & Rebase",
        "command": "# Cherry-pick a contiguous range of commits (from SHA1 exclusive to SHA2 inclusive)\ngit cherry-pick SHA1..SHA2\n\n# Or rebase branch onto a new base\ngit rebase --onto target-branch starting-commit-SHA feature-branch",
        "explanation": "Port an entire sequence of commits from one feature branch to another.",
        "steps": [
            "Use git cherry-pick <start-SHA>..<end-SHA> to apply a range in order.",
            "Alternatively use git rebase --onto for advanced branch transplanting."
        ]
    },
    {
        "id": 31,
        "title": "Scenario 27: Reverting a Merged Pull Request (Reverting a Merge Commit)",
        "category": "Architectural & Recovery",
        "command": "# Revert a standard commit\ngit revert <commit-SHA>\n\n# Revert a MERGE commit (specify parent mainline index, usually 1)\ngit revert -m 1 <merge-commit-SHA>\n\n# Push the revert commit to production branch\ngit push origin main",
        "explanation": "Safely back out a broken feature merged into main by creating an inverse commit without rewriting history.",
        "steps": [
            "Identify the merge commit hash from git log.",
            "Execute git revert -m 1 <merge-SHA> (parent 1 preserves mainline history).",
            "Push the generated revert commit to immediately restore production stability."
        ]
    },
    {
        "id": 32,
        "title": "Scenario 28: Resetting Current Branch to Match a Different Branch Exactly",
        "category": "Architectural & Recovery",
        "command": "# Overwrite local branch to match origin/main completely\ngit fetch origin\ngit reset --hard origin/main",
        "explanation": "Hard reset local branch state so it mirrors another branch identically, discarding all divergent local commits.",
        "steps": [
            "Fetch latest remote state: git fetch origin.",
            "Run git reset --hard origin/<target-branch>.",
            "Current branch HEAD and working directory match target branch exactly."
        ]
    },
    {
        "id": 33,
        "title": "Scenario 29: Undoing a Pushed Commit from Remote Branch",
        "category": "Architectural & Recovery",
        "command": "# Preferred safe method: create inverse revert commit\ngit revert <bad-commit-SHA>\ngit push origin <branch-name>\n\n# Alternative for private branches (Rewriting remote history)\ngit reset --hard HEAD~1\ngit push --force-with-lease origin <branch-name>",
        "explanation": "Best practice for rolling back bad commits on shared vs private branches.",
        "steps": [
            "For public/shared branches: always use git revert to record an inverse commit without breaking colleagues' repos.",
            "For private feature branches: git reset --hard HEAD~1 followed by git push --force-with-lease."
        ]
    }
]

# Write git scenarios
with open(GIT_PUZZLES_DART_PATH, "w", encoding="utf-8") as f:
    f.write("// Complete 33 Everyday & Architectural Git Scenarios from Master Prep Guide\n")
    f.write("// Professional engineering lead scenarios with exact commands and step-by-step procedures\n")
    f.write("import '../models/ios_prep_models.dart';\n\n")
    f.write("const List<GitScenario> fullGitScenarios = [\n")
    for s in full_git_list:
        f.write("  GitScenario(\n")
        f.write(f"    id: {s['id']},\n")
        f.write(f"    title: {repr(s['title'])},\n")
        f.write(f"    category: {repr(s['category'])},\n")
        f.write(f"    command: {repr(s['command'])},\n")
        f.write(f"    explanation: {repr(s['explanation'])},\n")
        f.write("    steps: [\n")
        for st in s['steps']:
            f.write(f"      {repr(st)},\n")
        f.write("    ],\n")
        f.write("  ),\n")
    f.write("];\n")

print(f"Generated {len(full_git_list)} professional Git scenarios successfully.")
