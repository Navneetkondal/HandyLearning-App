import '../models/ios_prep_models.dart';
import 'ios_prep_exam89_data.dart';
import 'ios_prep_git_puzzles_data.dart';
import 'ios_prep_benchmarks_data.dart';
import 'ios_prep_domains_detailed_data.dart';

export 'ios_prep_exam89_data.dart';
export 'ios_prep_senior100_data.dart';
export 'ios_prep_encyclopedia_data.dart';
export 'ios_prep_git_puzzles_data.dart';
export 'ios_prep_benchmarks_data.dart';
export 'ios_prep_domains_detailed_data.dart';

const prepBenchmarkCalibrations = benchmarkCalibrations;

/// Comprehensive data repository for iOS Senior & Lead Engineering Interview Preparation.
/// Extracted directly from .

/// -------------------------------------------------------------
/// MASTER 24 ARCHITECTURAL DOMAINS (Detailed & Complete)
/// -------------------------------------------------------------
final List<PrepDomain> prepDomains = detailedPrepDomains;

/// -------------------------------------------------------------
/// THE 89 TECHNICAL EXAMINATION BANK & SENIOR 100 Q&A (Categorized)
/// -------------------------------------------------------------
/// -------------------------------------------------------------
/// THE 89 TECHNICAL EXAMINATION BANK (Complete & Experience-Tagged)
/// -------------------------------------------------------------
final List<ExamQuestion> seniorExamQuestions = seniorExam89Questions;

/// -------------------------------------------------------------
final List<SystemDesignBlueprint> systemDesignBlueprints = [
  const SystemDesignBlueprint(
    id: 1,
    title: 'Offline-First Synchronization & Conflict Resolution Engine',
    subtitle: 'Enterprise Warehouse & Field Logistics Apps',
    goal:
        'Enable field workers to create, edit, and delete records while completely disconnected from cellular networks, synchronizing deltas with zero data loss upon reconnection.',
    asciiDiagram: '''[UI Layer] ──> [Optimistic Local Update] ──> [Core Data / SQLite (isSynced: false)]
                                                    │
                                            [Mutation Queue]
                                                    │
                           [NWPathMonitor detects Internet Reconnect]
                                                    │
                       [Batch Delta Sync Service: POST /sync/mutations]
                                                    │
                 [Server Conflict Resolution: Vector Clock / Last-Write-Wins]
                                                    │
                        [Server returns updated state & ackTokens]
                                                    │
                           [Core Data: mark isSynced = true]''',
    fivePhaseSteps: [
      'Phase 1: Clarify Scope & Constraints (Offline mutations, max 1% battery/day, zero data loss guarantee)',
      'Phase 2: High-Level Architecture (Optimistic UI -> Local DB -> Mutation Queue -> Sync Engine -> Backend)',
      'Phase 3: API Contract & Data Models (POST /sync/batch with idempotency tokens and timestamp clocks)',
      'Phase 4: Conflict Resolution Engine (Last-Write-Wins vs 3-way merge prompts)',
      'Phase 5: Failure Modes (Network drops, server 500s, exponential backoff with jitter)',
    ],
    keyDecisions: [
      'Optimistic UI: Updates local DB and renders immediately with subtle sync pending status.',
      'Idempotency Keys: Every mutation generates a UUID v4 stored in the transaction log.',
      'Conflict Strategy: Last-Write-Wins (LWW) with server NTP timestamps; field-level merge for multi-user edits.',
    ],
  ),
  const SystemDesignBlueprint(
    id: 2,
    title: 'High-Performance Multi-Tier Image Caching & Prefetching Pipeline',
    subtitle: 'Social Media Feeds & E-Commerce Catalogs',
    goal:
        'Provide 60/120fps smooth scrolling for image-heavy feeds with zero main-thread hitching and strict RAM limits.',
    asciiDiagram: '''[Cell Requests Image: URL]
           │
[Tier 1: Memory Cache (NSCache / LRU)] ──> Hit? ──> Return Decoded UIImage (0ms)
           │ Miss
[Tier 2: Disk Cache (File System)]     ──> Hit? ──> Background Read + Downsample ──> Store in RAM ──> Display (5ms)
           │ Miss
[Tier 3: Network Pipeline (URLSession)] ──> Download ──> Downsample to Cell Pixel Bounds ──> Write Disk ──> Display (100ms)''',
    fivePhaseSteps: [
      'Phase 1: Requirements (120fps smooth scrolling, 50MB RAM ceiling, offline cached images)',
      'Phase 2: 3-Tier Cache Architecture (RAM -> Disk -> Remote CDN)',
      'Phase 3: Downsampling Protocol (CGImageSourceCreateThumbnailAtIndex to prevent 48MB JPEG allocations)',
      'Phase 4: Cancellation on Cell Reuse (Cancel in-flight task on prepareForReuse)',
      'Phase 5: Jetsam & Eviction (NSCache auto-evicts on memory warning notification)',
    ],
    keyDecisions: [
      'Never decode full 4000x3000px JPEG into 100x100px cell (prevents 48MB RAM allocation).',
      'Downsample using Core Graphics thumbnail APIs before assigning to UIImageView.',
      'Auto-eviction on memory pressure notification via NSCache.',
    ],
    codeSnippet: '''func downsample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat = 3.0) -> UIImage? {
  let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
  guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else { return nil }
  
  let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
  let downsampleOptions = [
    kCGImageSourceCreateThumbnailFromImageAlways: true,
    kCGImageSourceShouldCacheImmediately: true,
    kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
  ] as CFDictionary
  
  guard let downsampled = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else { return nil }
  return UIImage(cgImage: downsampled)
}''',
  ),
  const SystemDesignBlueprint(
    id: 3,
    title: 'Real-Time Chat & Presence System (WebSocket + Push Fallback)',
    subtitle: 'Messaging, Customer Support & Live Collaboration',
    goal:
        'Deliver instant messages, typing indicators, and presence updates while conserving battery and handling mobile network transitions.',
    asciiDiagram: '''[Chat Client] <─── WebSocket (URLSessionWebSocketTask) ───> [Chat Server Gateway]
       │                                                              │
  App Backgrounded?                                              App Offline?
       │                                                              │
[Close WebSocket]                                             [APNs Push Fallback]''',
    fivePhaseSteps: [
      'Phase 1: Scope (Sub-second delivery, typing indicators, read receipts, offline queuing)',
      'Phase 2: Transport Layer (URLSessionWebSocketTask with Ping/Pong heartbeat)',
      'Phase 3: Reconnection & Network Monitoring (NWPathMonitor + exponential backoff with jitter)',
      'Phase 4: Background Lifecycle (Tear down socket on background; route via APNs)',
      'Phase 5: Message Deduplication (Local SQLite IDs + Server ACK frames)',
    ],
    keyDecisions: [
      'Heartbeat: Ping/Pong frame every 30 seconds to detect stale TCP connections.',
      'Background: Terminate socket on sceneDidEnterBackground to prevent OS killing the app.',
      'Deduplication: UUID client message IDs stored in local SQLite database.',
    ],
  ),
  const SystemDesignBlueprint(
    id: 4,
    title: 'Large File Chunked Resumable Upload / Download Architecture',
    subtitle: 'Video Inspection & Enterprise Media Uploads',
    goal:
        'Upload large multimedia inspection videos (500MB+) over flaky mobile connections without restarting from byte 0 on failure.',
    asciiDiagram: '''[Large File: 500MB] ──> Sliced into 5MB Chunks [Chunk 1, Chunk 2, ... Chunk 100]
                                             │
                 [URLSessionConfiguration.background(withIdentifier: "upload")]
                                             │
                          [Uploads continue even if app suspended]
                                             │
               Connection Drops? ──> Query GET /upload/{id}/status
                                             │
                       [Resume from last confirmed missing chunk]''',
    fivePhaseSteps: [
      'Phase 1: Scope (500MB+ video files, flaky 3G/4G, resume without re-uploading bytes)',
      'Phase 2: File Slicing (FileHandle chunking into 5MB binary blocks with MD5 hashes)',
      'Phase 3: Background URLSession (Delegated to system daemon `nsurlsessiond`)',
      'Phase 4: Resume Protocol (Server returns bitmask of received chunk indices)',
      'Phase 5: Integrity Verification (Server merges chunks and verifies SHA-256)',
    ],
    keyDecisions: [
      'Out-of-Process Background Session: Uploads persist across app termination.',
      'Chunking: 5MB chunks avoid memory footprint spikes.',
      'Resume protocol: Client queries status and uploads only missing chunk indices.',
    ],
  ),
  const SystemDesignBlueprint(
    id: 5,
    title: 'Client-Side Observability, Logging & MetricKit Telemetry Pipeline',
    subtitle: 'High-Scale Production App Telemetry (100k+ DAU)',
    goal:
        'Collect actionable crash, hang, and battery metrics across 100,000+ production devices without impacting CPU or cellular data limits.',
    asciiDiagram: '''[User Actions / Network / Logs] ──> [In-Memory Ring Buffer (Last 100 Breadcrumbs)]
                                                    │
                                         [Crash / OOM Detected?]
                                                    │
                                   [Attach Breadcrumbs to Crash Report]
                                                    │
                 [MetricKit (MXMetricManagerSubscriber): Daily OS Reports]
                                                    │
                        [Batched Gzip Upload on Wi-Fi + Charging]''',
    fivePhaseSteps: [
      'Phase 1: Requirements (Zero performance overhead, privacy compliance, crash reporting)',
      'Phase 2: In-Memory Ring Buffer (Fixed 100-event circular queue of breadcrumbs)',
      'Phase 3: MetricKit Subscriber (Captures thermal states, scroll hitch rates, wakeups)',
      'Phase 4: Batching & Compression (Gzip telemetry files on local disk)',
      'Phase 5: Upload Strategy (Opportunistic upload when device is on Wi-Fi and charging)',
    ],
    keyDecisions: [
      'Ring buffer avoids unbounded memory growth.',
      'MetricKit provides official OS hardware telemetry without draining battery.',
      'Opportunistic upload avoids cellular data consumption.',
    ],
  ),
];

/// -------------------------------------------------------------
/// ENTERPRISE PRODUCTION DOMAIN DEFENSE
/// -------------------------------------------------------------
final List<EnterpriseDefenseCase> enterpriseDefenseCases = [
  const EnterpriseDefenseCase(
    id: 1,
    title: 'Stripe iOS SDK & Idempotent Checkout Architecture',
    interviewerTrap:
        'How do you prevent charging the customer twice if their connection drops midway through payment processing?',
    solution:
        'Client-side generated UUID v4 Idempotency Key sent in the header of the checkout request. If the connection drops before receiving the response, the app retries with the identical key. Stripe detects the duplicate key and returns the original transaction state without executing a second debit.',
    webhookTruth:
        'Client-side callbacks only drive immediate UI feedback. Real order fulfillment and inventory deduction depend strictly on server-to-server Stripe Webhooks (payment_intent.succeeded).',
    codeSnippet: r'''import StripePaymentSheet

final class CheckoutManager {
  func presentPaymentSheet(from viewController: UIViewController, clientSecret: String) {
    var config = PaymentSheet.Configuration()
    config.merchantDisplayName = "Altametrics Plum Ordering"
    config.allowsDelayedPaymentMethods = false
    
    let paymentSheet = PaymentSheet(paymentIntentClientSecret: clientSecret, configuration: config)
    paymentSheet.present(from: viewController) { result in
      switch result {
      case .completed:
        print("Payment authorized successfully!")
      case .canceled:
        print("User canceled payment sheet.")
      case .failed(let error):
        print("Payment failed: \(error.localizedDescription)")
      }
    }
  }
}''',
    technicalRules: [
      'Always generate UUID v4 idempotency keys on the client before the first network call.',
      'Never rely solely on client SDK success callbacks for order fulfillment.',
      'Server must verify webhook signatures using Stripe endpoint secrets.',
    ],
  ),
  const EnterpriseDefenseCase(
    id: 2,
    title: 'Core Location: Anti-Spoofing & Battery-Efficient Geofencing',
    interviewerTrap:
        'In workforce clock-in apps, how do you prevent fraudulent employee clock-ins using fake GPS mock apps or jailbreak tweaks?',
    solution:
        'Multi-layer verification: 1) Hardware accuracy validation (reject horizontalAccuracy < 0 or > 50m); 2) Stale timestamp check (reject data older than 10s); 3) Software simulation detection (isSimulatedBySoftware and isProducedByAccessory on iOS 15+).',
    webhookTruth:
        'Significant Location Change Monitoring provides battery consumption < 1%/day. High-precision GPS is spun up for only 30 seconds upon arrival at a geofence.',
    codeSnippet: '''func isValidClockInLocation(_ location: CLLocation) -> Bool {
  // 1. Hardware Accuracy Check
  guard location.horizontalAccuracy >= 0 && location.horizontalAccuracy <= 50 else { return false }
  
  // 2. Stale Cached Data Prevention
  guard abs(location.timestamp.timeIntervalSinceNow) < 10 else { return false }
  
  // 3. iOS 15+ Software Simulation Detection
  if #available(iOS 15.0, *) {
    guard !location.isSimulatedBySoftware && !location.isProducedByAccessory else { return false }
  }
  return true
}''',
    technicalRules: [
      'Reject coordinates where location.horizontalAccuracy < 0 or > 50.',
      'Reject stale cached data where abs(location.timestamp.timeIntervalSinceNow) > 10s.',
      'Use iOS 15+ !location.isSimulatedBySoftware to catch mock GPS tweaks.',
      'Use Significant Location Monitoring (< 1% battery/day) for passive geofencing.',
    ],
  ),
  const EnterpriseDefenseCase(
    id: 3,
    title: 'Multi-Target App Flavoring with .xcconfig (-40% Maintenance Overhead)',
    interviewerTrap:
        'How do you manage 3+ white-label enterprise client builds from a single codebase without messy #if CLIENT_A preprocessor conditionals?',
    solution:
        'Protocol-Oriented Configuration Injection combined with modular .xcconfig build configuration files. All brand assets, API base URLs, bundle IDs, and feature flags are defined in configuration files and injected via protocols at app launch.',
    webhookTruth:
        'Zero #if CLIENT_A code branching in business logic. All feature variants are controlled by compile-time configuration protocols or remote feature flags.',
    codeSnippet: '''public protocol EnterpriseBrandConfiguration {
  var brandName: String { get }
  var apiBaseURL: URL { get }
  var primaryColor: UIColor { get }
  var stripeKey: String { get }
}

public struct ConfigManager {
  public static let current: EnterpriseBrandConfiguration = {
    #if BRAND_A
    return BrandAConfig()
    #elseif BRAND_B
    return BrandBConfig()
    #else
    return DefaultBrandConfig()
    #endif
  }()
}''',
    technicalRules: [
      'Maintain separate .xcconfig files for Debug/Release of each brand flavor.',
      'Inject configurations via clean Swift protocols rather than inline compiler flags.',
      'Use asset catalog asset namespaces for client-specific iconography and themes.',
    ],
  ),
];

/// -------------------------------------------------------------
/// GIT MASTERCLASS & EVERYDAY PRODUCTION SCENARIOS
/// -------------------------------------------------------------
/// 33 Everyday and Architectural Git Scenarios from git.pdf
final List<GitScenario> gitScenarios = fullGitScenarios;

/// -------------------------------------------------------------
final List<SeniorityBand> seniorityRubricBands = [
  const SeniorityBand(
    levelName: 'Junior I / Fresher',
    yoeBand: '0–1 Year',
    bandCode: 'IC3 / Associate',
    coreFocus:
        'Syntax mastery, fundamental OOP/POP, UI building from mockups, basic Git branch workflows, standard JSON parsing.',
    roundExpectations:
        'Build simple screens in UIKit or SwiftUI; consume REST API via URLSession; map data to Decodable models.',
    targetDepth:
        'Understands Structs vs Classes, Optionals memory unwrapping, Array/Dictionary operations, basic MVC/MVVM separation.',
    disqualifyingRedFlags:
        'Inability to explain reference vs value semantics; force-unwrapping Optionals (!) causing crashes; lack of basic Git hygiene.',
  ),
  const SeniorityBand(
    levelName: 'Junior II / Associate',
    yoeBand: '1–3 Years',
    bandCode: 'IC3 / Software Eng I',
    coreFocus:
        'Memory management (ARC), escaping closures, delegate vs closure patterns, clean MVVM, basic unit testing with XCTest.',
    roundExpectations:
        'Write unit tests with mock network sessions; implement custom collection views with diffable data sources; debug memory leaks using Xcode Memory Graph.',
    targetDepth:
        'Understands retain cycles, [weak self] capture lists, GCD queues (main vs global), Keychain vs UserDefaults storage boundaries.',
    disqualifyingRedFlags:
        'Updating UI from background queues; unaware of retain cycles in closures; storing sensitive auth tokens in UserDefaults.',
  ),
  const SeniorityBand(
    levelName: 'Mid-Level Engineer',
    yoeBand: '3–5 Years',
    bandCode: 'IC4 / Software Eng II',
    coreFocus:
        'Clean Architecture, modular design, Swift Concurrency (async/await), Core Data / SwiftData persistence, Instruments performance profiling.',
    roundExpectations:
        'Design modular feature packages; implement resilient offline synchronization; profile main-thread hitches using Time Profiler.',
    targetDepth:
        'Actors, TaskGroup, Sendable checking, Custom Copy-on-Write, SSL Pinning, Downsampling images to prevent Jetsam memory crashes.',
    disqualifyingRedFlags:
        'Cannot explain why GCD thread explosion occurs; unable to prevent retain cycles in SwiftUI HostingControllers; no unit test discipline.',
  ),
  const SeniorityBand(
    levelName: 'Senior Engineer',
    yoeBand: '5–8 Years',
    bandCode: 'IC5 / Senior Engineer',
    coreFocus:
        'System design, architectural trade-offs (MVVM-C vs VIPER vs TCA), CI/CD pipelines, security audits, App Thinning, mentoring.',
    roundExpectations:
        'Drive 45-minute mobile system design sessions (Offline-First sync, Image Caching, Real-time WebSockets); lead refactoring initiatives.',
    targetDepth:
        'Cooperative thread pool mechanics, Mach-O linkers, Protocol Witness Tables, MetricKit telemetry pipelines, Idempotent payment architectures.',
    disqualifyingRedFlags:
        'Jumping straight into UI drawing in system design without clarifying non-functional constraints; inability to articulate trade-offs between architectural patterns.',
  ),
  const SeniorityBand(
    levelName: 'Staff / Principal Engineer',
    yoeBand: '8–12+ Years',
    bandCode: 'IC6 / Staff & Lead',
    coreFocus:
        'Cross-platform strategy, enterprise mobile infrastructure, app reliability engineering, multi-brand flavor systems, engineering excellence.',
    roundExpectations:
        'Architect enterprise multi-target infrastructure; define company-wide mobile design systems; resolve complex compiler and runtime performance bottlenecks.',
    targetDepth:
        'Custom allocators, LLVM optimization passes, binary size reduction via symbol stripping, multi-tier CDN edge caching, executive stakeholder defense.',
    disqualifyingRedFlags:
        'Dogmatism (insisting on one architecture for all problems); lack of empathy for developer velocity; unable to defend business impact and ROI of technical choices.',
  ),
];

/// -------------------------------------------------------------
/// THE 16 STAFF & PRINCIPAL ARCHITECT SIGNALS BANK
/// -------------------------------------------------------------
final List<StaffSignal> staffSignals = [
  const StaffSignal(
    id: 1,
    topic: 'Struct vs. Class Signal',
    category: 'Memory & Types',
    strongSignal:
        'Focuses on value semantics vs identity, register passing for small structs (<=3-4 words), and the hybrid semantics bug in structs holding classes.',
    weakSignal: '"Structs go to stack, classes to heap."',
    followUpQuestion:
        'How does Swift 5.9’s non-copyable type (~Copyable) change your architectural choice?',
    followUpAnswer:
        'Provides unique ownership semantics on value types, eliminating unnecessary ARC retain/release traffic on hot paths and modeling non-duplicable system resources.',
  ),
  const StaffSignal(
    id: 2,
    topic: 'Any vs. AnyObject Signal',
    category: 'Memory & Types',
    strongSignal:
        'Explains Existential Containers (3 words inline + VWT + metadata = 40B) and heap spilling for types > 24 bytes in Any.',
    weakSignal: '"Any is for anything, AnyObject is for objects."',
    followUpQuestion:
        'Why is protocol MyDelegate: AnyObject required for a weak delegate?',
    followUpAnswer:
        'Only reference types participate in ARC side-table tracking; value types cannot be weak because they have no persistent heap identity.',
  ),
  const StaffSignal(
    id: 3,
    topic: 'Access Control Signal',
    category: 'Swift Syntax & ABI',
    strongSignal:
        'Highlights module ABI stability, compiler whole-module optimization (WMO) devirtualization for internal/private, and the package access level introduced in Swift 5.9+.',
    weakSignal:
        'Only lists the 5 basic keywords without understanding overriding restrictions between public and open.',
    followUpQuestion:
        'What is the practical difference between public and open when designing an enterprise SDK?',
    followUpAnswer:
        'public allows consumers to read/instantiate outside the module but strictly prevents subclassing and overriding. open explicitly permits external subclassing and method overriding.',
  ),
  const StaffSignal(
    id: 4,
    topic: 'self vs. Self Signal',
    category: 'Swift Syntax & ABI',
    strongSignal:
        'Uses Self in protocol requirements for covariant return types, fluent builder patterns, and static factory methods.',
    weakSignal: 'Confuses instance self with dynamic type Self.',
    followUpQuestion:
        'Why does a protocol with `func copy() -> Self` require conforming classes to be declared `final` or have `required init`?',
    followUpAnswer:
        'Because subclasses inherit the method, and the compiler must guarantee that returning Self constructs the exact dynamic subclass, not the parent class.',
  ),
  const StaffSignal(
    id: 5,
    topic: 'static vs. class Functions Signal',
    category: 'Swift Syntax & ABI',
    strongSignal:
        'Explains that static func in classes enforces direct dispatch and forbids overriding, whereas class func maintains V-table dynamic dispatch slots.',
    weakSignal: 'Believes they are completely identical.',
    followUpQuestion:
        'Can a struct define a `class func`?',
    followUpAnswer:
        'No. Structs do not support inheritance or V-tables, so they can only define `static func`.',
  ),
  const StaffSignal(
    id: 6,
    topic: 'Static vs. Dynamic Dispatch Signal',
    category: 'Swift Syntax & ABI',
    strongSignal:
        'Identifies the protocol extension trap: unrequired extension methods are dispatched statically based on compile-time static type, not runtime instance!',
    weakSignal:
        'Unaware of Witness Tables or assumes all protocol methods are dynamic.',
    followUpQuestion:
        'What is the assembly-level mechanism of a Witness Table lookup?',
    followUpAnswer:
        'The existential container points to a Protocol Witness Table (PWT), which is an array of function pointers. Calling a required method performs an indirect call offset into the PWT.',
  ),
  const StaffSignal(
    id: 7,
    topic: 'Copy-on-Write (COW) Signal',
    category: 'Memory & Types',
    strongSignal:
        'Explains isKnownUniquelyReferenced, mutating nested structs triggering outer buffer copy, and implementing custom COW backing buffers.',
    weakSignal:
        'Believes every struct assignment copies all data immediately in memory.',
    followUpQuestion:
        'How do you write a custom thread-safe Copy-on-Write wrapper in Swift?',
    followUpAnswer:
        'Wrap the backing storage class in a struct, and before mutating, check `isKnownUniquelyReferenced(&storage)`. If false, allocate a new heap storage copy before writing.',
  ),
  const StaffSignal(
    id: 8,
    topic: 'strong / weak / unowned & ARC Signal',
    category: 'Memory & Types',
    strongSignal:
        'Details the 64-bit object header reference count layout, side tables for weak pointers, and the difference between unowned(safe) runtime traps vs unowned(unsafe) dangling memory.',
    weakSignal:
        'Recommends unowned solely to avoid optional unwrapping without understanding lifecycle guarantees.',
    followUpQuestion:
        'What happens when an object with an active weak reference is deallocated?',
    followUpAnswer:
        'The object deallocates its payload, but its Side Table remains in memory until all weak pointers pointing to it are read and zeroed out (lazy zeroing).',
  ),
  const StaffSignal(
    id: 9,
    topic: 'Escaping vs. Non-Escaping Closures Signal',
    category: 'Memory & Concurrency',
    strongSignal:
        'Knows non-escaping closures execute on the stack and never cause retain cycles. Only escaping closures stored in heap memory require [weak self].',
    weakSignal:
        'Adds [weak self] indiscriminately to every closure (including map, filter, and UIView.animate).',
    followUpQuestion:
        'Why does UIView.animate not require [weak self] even though it takes a closure?',
    followUpAnswer:
        'The animation closure is captured by the animation runtime for the duration of the animation, and released immediately upon completion; self does not hold a strong reference back to the animation engine.',
  ),
  const StaffSignal(
    id: 10,
    topic: 'Singleton Pattern Signal',
    category: 'Architecture & Design',
    strongSignal:
        'Explains Swift’s `static let` thread-safety via `dispatch_once`, but outlines testing and state pollution hazards, offering protocol-based dependency injection as the superior alternative.',
    weakSignal: 'Advocates singletons everywhere for "easy global data access."',
    followUpQuestion:
        'How do you refactor a legacy singleton so that unit tests can mock its behavior without changing existing call sites?',
    followUpAnswer:
        'Extract its interface into a protocol, make the singleton conform, and provide an injectable default property or factory that defaults to the shared instance.',
  ),
  const StaffSignal(
    id: 11,
    topic: 'UserDefaults vs. Keychain Signal',
    category: 'Security & Storage',
    strongSignal:
        'Explains hardware encryption in the Secure Enclave, persistence across app deletion, and kSecAttrAccessible flags for background vs unlocked states.',
    weakSignal: 'Stores auth tokens, passwords, or PII in UserDefaults.',
    followUpQuestion:
        'What accessibility level should be used for access tokens needed during background silent pushes?',
    followUpAnswer:
        'kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly. It remains decrypted after the user unlocks the phone once after reboot, even if locked when the push arrives.',
  ),
  const StaffSignal(
    id: 12,
    topic: 'Main Queue: async vs. sync Signal',
    category: 'Concurrency',
    strongSignal:
        'Articulates the exact serialization deadlock mechanics of DispatchQueue.main.sync on the main thread, and when sync is valid on private background queues (reader-writer barrier locks).',
    weakSignal: '"Never use sync anywhere in an application."',
    followUpQuestion:
        'Why does dispatching sync to the same serial queue deadlock?',
    followUpAnswer:
        'Because the serial queue is currently waiting for the calling task to finish before executing the new block, while the calling task is waiting synchronously for the block to execute.',
  ),
  const StaffSignal(
    id: 13,
    topic: 'Frame vs. Bounds Signal',
    category: 'UI & Rendering',
    strongSignal:
        'Explains coordinate spaces (superview vs own canvas), rotational bounding box expansion in frame, and how UIScrollView works by shifting bounds.origin.',
    weakSignal: '"They are the same unless you change the size."',
    followUpQuestion:
        'When a UIView is rotated 45 degrees, which property becomes undefined?',
    followUpAnswer:
        'view.frame becomes undefined (or invalid for sizing) according to Apple documentation; layout must use center, bounds, and transform instead.',
  ),
  const StaffSignal(
    id: 14,
    topic: 'UIKit vs. SwiftUI Signal',
    category: 'UI & Architecture',
    strongSignal:
        'Compares imperative object graphs vs declarative state diffing, structural identity in @ViewBuilder, and the performance cost of AnyView type erasure.',
    weakSignal: '"SwiftUI is just a simpler syntax for UIKit."',
    followUpQuestion:
        'Why should AnyView be avoided in SwiftUI high-frequency feeds?',
    followUpAnswer:
        'AnyView destroys static type information, preventing SwiftUI’s layout engine from diffing the view hierarchy incrementally, causing full re-renders and hitching.',
  ),
  const StaffSignal(
    id: 15,
    topic: 'Data Passing in UIKit Signal',
    category: 'UI & Architecture',
    strongSignal:
        'Chooses between 1-to-1 delegation/closures and 1-to-many Combine/NotificationCenter based on coupling, lifecycle ownership, and memory safety.',
    weakSignal: 'Uses NotificationCenter for direct parent-child screen communication.',
    followUpQuestion:
        'When is a closure preferred over a delegate protocol?',
    followUpAnswer:
        'For single-event callbacks with short lifecycles (e.g. action buttons or alert completions), while delegates are best for multi-method protocols and data sources.',
  ),
  const StaffSignal(
    id: 16,
    topic: 'Data Flow in SwiftUI Signal',
    category: 'UI & Architecture',
    strongSignal:
        'Differentiates Single Source of Truth from derived bindings, explains why @StateObject survives parent re-renders while @ObservedObject resets, and embraces iOS 17 @Observable macros.',
    weakSignal:
        'Uses @ObservedObject to instantiate models inside view structs.',
    followUpQuestion:
        'How does iOS 17’s @Observable macro improve render performance compared to ObservableObject?',
    followUpAnswer:
        'ObservableObject triggers view re-renders whenever ANY @Published property changes. @Observable provides property-level tracking; views only re-render when a specific accessed property changes.',
  ),
];

/// -------------------------------------------------------------
/// LIVE CODE REVIEW & REFACTORING SIMULATOR
/// -------------------------------------------------------------
final List<CodeReviewCase> codeReviewCases = [
  const CodeReviewCase(
    id: 1,
    title: 'Spot the 7 Defects in Senior Profile View Controller PR',
    submittedSnippet: '''// SUBMITTED PR CODE
class ProfileViewController: UIViewController {
    var userId: String! // 1. Implicitly unwrapped optional hazard
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        // 2. Hardcoded URL string without error handling
        let url = URL(string: "https://api.app.com/users/" + userId)!
        
        // 3. Concrete URLSession without dependency injection (untestable)
        URLSession.shared.dataTask(with: url) { data, response, error in
            // 4. Retain cycle: strong self captured in escaping closure
            // 5. Force unwrap on network data
            let user = try! JSONDecoder().decode(User.self, from: data!)
            
            // 6. UI mutated directly on background networking thread!
            self.user = user
            self.title = user.name
            
            // 7. Sensitive authentication token persisted in plain-text UserDefaults!
            UserDefaults.standard.set(user.authToken, forKey: "authToken")
        }.resume()
    }
}''',
    defects: [
      CodeReviewDefect(
        index: 1,
        title: 'Implicitly Unwrapped Optional (userId!)',
        priority: 'P1 - Stability/Crash',
        explanation: 'Crashes the app if ProfileViewController is instantiated without immediately setting userId.',
      ),
      CodeReviewDefect(
        index: 2,
        title: 'Force Unwrapped URL Construction',
        priority: 'P1 - Stability/Crash',
        explanation: 'URL(string: ...)! triggers a fatal runtime trap if userId contains spaces or non-URL encoded characters.',
      ),
      CodeReviewDefect(
        index: 3,
        title: 'Concrete URLSession & Zero Dependency Injection',
        priority: 'P3 - Architecture',
        explanation: 'Couples networking to singleton URLSession.shared, making unit tests impossible without external network mocks.',
      ),
      CodeReviewDefect(
        index: 4,
        title: 'Retain Cycle in Escaping Closure',
        priority: 'P1 - Stability/Crash',
        explanation: 'Strong capture of `self` causes memory leak if the user dismisses the view before dataTask finishes.',
      ),
      CodeReviewDefect(
        index: 5,
        title: 'Force Unwrapping Network Data (data!) & try!',
        priority: 'P1 - Stability/Crash',
        explanation: 'try! and data! crash the app with SIGABRT if user is offline, network fails, or payload schema changes.',
      ),
      CodeReviewDefect(
        index: 6,
        title: 'Main Thread UIKit Mutation Violation',
        priority: 'P1 - Stability/Crash',
        explanation: 'Mutating self.title on background URLSession thread causes race conditions, layout corruption, or app freezing.',
      ),
      CodeReviewDefect(
        index: 7,
        title: 'Auth Token Stored in Plain-Text UserDefaults',
        priority: 'P2 - Security/Privacy',
        explanation: 'Tokens in UserDefaults can be extracted from unencrypted iTunes backups. Must use hardware-backed iOS Keychain.',
      ),
    ],
    structuredFeedback: '''Senior Engineer Review Strategy:
• Priority 1 (Critical Stability): Eliminate all force-unwraps (try!, data!, url!). Add [weak self] or migrate to structured concurrency with task cancellation. Enforce @MainActor on UI updates.
• Priority 2 (Security): Move authToken storage to Keychain Services with kSecAttrAccessibleAfterFirstUnlock.
• Priority 3 (Architecture): Extract networking to a protocol-based UserService and introduce a testable ViewModel.''',
    productionRefactoredSnippet: '''// 1. Decoupled Service Protocol
protocol UserServiceProtocol: Sendable {
    func fetchUser(by id: String) async throws -> User
}

// 2. MainActor ViewModel with Swift 6 Concurrency
@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var state: ViewState = .idle
    private let userId: String
    private let userService: UserServiceProtocol
    private let keychainService: KeychainServiceProtocol

    enum ViewState: Equatable {
        case idle, loading, success(User), failure(String)
    }

    init(userId: String, userService: UserServiceProtocol, keychainService: KeychainServiceProtocol) {
        self.userId = userId
        self.userService = userService
        self.keychainService = keychainService
    }

    func loadData() async {
        state = .loading
        do {
            let user = try await userService.fetchUser(by: userId)
            try await keychainService.save(token: user.authToken)
            state = .success(user)
        } catch {
            state = .failure(error.localizedDescription)
        }
    }
}

// 3. Clean UIViewController Binding
final class ProfileViewController: UIViewController {
    private let viewModel: ProfileViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: null, bundle: null)
    }

    required init?(coder: NSCoder) { fatalError("Use dependency injection") }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        Task { [weak self] in
            await self?.viewModel.loadData()
        }
    }

    private func bindViewModel() {
        viewModel.\$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .loading: self?.showLoadingSpinner()
                case .success(let user): self?.title = user.name
                case .failure(let err): self?.showError(err)
                case .idle: break
                }
            }
            .store(in: &cancellables)
    }
}''',
  ),
];

/// -------------------------------------------------------------
/// LEAD & STAFF BEHAVIORAL CRISIS MANAGEMENT
/// -------------------------------------------------------------
final List<BehavioralCrisisScenario> behavioralCrisisScenarios = [
  const BehavioralCrisisScenario(
    id: 1,
    title: 'Severe Production Outage (P0/P1) & Blameless Post-Mortem',
    scenario:
        'A newly released app version causes a 15% crash on launch for users updating to iOS 17, completely halting checkout operations.',
    actionStep1Title: 'Immediate Containment & Kill-Switch',
    actionStep1Content:
        '(1) Instantly halt staged rollout in App Store Connect. (2) Trigger remote feature flag kill-switch via Firebase Remote Config to bypass the failing codepath. (3) Convene war room with lead mobile engineer, backend engineer, and release manager.',
    actionStep2Title: 'Root Cause Analysis (5 Whys)',
    actionStep2Content:
        'Using Xcode Organizer and symbolicated crash logs, identified that a Core Data lightweight migration failed because a non-optional attribute was added without a default value in the model version hash.',
    actionStep3Title: 'Permanent Prevention & Post-Mortem',
    actionStep3Content:
        'Added automated UI migration smoke tests in CI that launch fresh builds against a preserved corpus of legacy user databases before any App Store submission. Published a transparent, blameless post-mortem document.',
  ),
  const BehavioralCrisisScenario(
    id: 2,
    title: 'Resolving Architectural Deadlocks Between Senior Engineers',
    scenario:
        'Two senior engineers are deadlocked over whether to adopt The Composable Architecture (TCA) or stick with established MVVM + Combine for a major new product overhaul.',
    actionStep1Title: 'De-escalate & Establish Objective Criteria',
    actionStep1Content:
        'De-escalate emotional attachment by establishing objective evaluation criteria based on team velocity, onboarding curve, build times, testability, and runtime performance.',
    actionStep2Title: 'Timeboxed Proof of Concept (PoC)',
    actionStep2Content:
        'Commissioned both engineers to build the exact same non-trivial workflow (multi-step checkout with network retry and offline persistence) over a 2-day timebox.',
    actionStep3Title: 'Decision Matrix & Pragmatic Consensus',
    actionStep3Content:
        'While TCA provided superior test state exhaustion, its macro compilation penalty increased clean build times by 35% across the team. We agreed on a pragmatic compromise: adopting unidirectional data flow principles inside standard MVVM without bringing in a heavy third-party framework dependency.',
  ),
  const BehavioralCrisisScenario(
    id: 3,
    title: 'Managing and Coaching Underperforming Engineers',
    scenario:
        'A mid-level engineer is consistently missing sprint commitments, writing incomplete unit tests, and receiving extensive code review pushback.',
    actionStep1Title: 'Private 1-on-1 Root Cause Discovery',
    actionStep1Content:
        'Conducted a private 1-on-1 to understand blockers (discovered they were overwhelmed by legacy codebase dependencies and lacked mentorship in unit testing patterns).',
    actionStep2Title: 'Structured Action Plan & Pairing',
    actionStep2Content:
        'Broke down tasks into smaller, well-defined user stories with clear acceptance criteria. Paired on complex PRs for 3 weeks and established a pre-PR checklist (unit test coverage, memory graph inspection).',
    actionStep3Title: 'Measurable Growth & Autonomy',
    actionStep3Content:
        'Within 6 weeks, their PR turnaround time decreased by 50%, their test coverage reached 85%, and they successfully delivered a standalone analytics migration ahead of schedule.',
  ),
];

/// -------------------------------------------------------------
/// MASTER 10 SENIOR/STAFF LIVE CODING & DSA CHALLENGES
/// -------------------------------------------------------------
final List<CodingChallenge> codingChallenges = [
  const CodingChallenge(
    id: 1,
    title: 'Thread-Safe LRU Cache (Actor + Doubly Linked List)',
    category: 'Data Structures',
    difficulty: 'Hard / Senior Staff',
    timeComplexity: 'O(1) Get, O(1) Put',
    spaceComplexity: 'O(Capacity)',
    problemStatement:
        'Design and implement a thread-safe Least Recently Used (LRU) Cache in Swift with a fixed maximum capacity. It must support `get(key:)` and `put(key:value:)` in O(1) average time, evicting the least recently accessed item when capacity is exceeded.',
    bruteForceApproach:
        'Using an Array or Dictionary with timestamp tracking. Finding the oldest item on eviction requires an O(N) scan.',
    optimizedApproach:
        'Combine a Swift Dictionary [Key: Node] for O(1) random access with a Doubly Linked List for O(1) head/tail node removal and insertion. Wrap in a Swift Concurrency `actor` for thread safety without lock contention.',
    swiftSolution: '''final class Node<Key: Hashable, Value> {
    let key: Key
    var val: Value
    var prev: Node?
    var next: Node?
    init(key: Key, val: Value) { self.key = key; self.val = val }
}

actor LRUCache<Key: Hashable, Value> {
    private let capacity: Int
    private var dict: [Key: Node<Key, Value>] = [:]
    private var head: Node<Key, Value>?
    private var tail: Node<Key, Value>?

    init(capacity: Int) { self.capacity = max(1, capacity) }

    func get(_ key: Key) -> Value? {
        guard let node = dict[key] else { return nil }
        moveToHead(node)
        return node.val
    }

    func put(_ key: Key, _ value: Value) {
        if let node = dict[key] {
            node.val = value
            moveToHead(node)
        } else {
            let newNode = Node(key: key, val: value)
            dict[key] = newNode
            addToHead(newNode)
            if dict.count > capacity { removeLRU() }
        }
    }

    private func moveToHead(_ node: Node<Key, Value>) {
        removeNode(node); addToHead(node)
    }

    private func addToHead(_ node: Node<Key, Value>) {
        node.next = head
        node.prev = nil
        head?.prev = node
        head = node
        if tail == nil { tail = head }
    }

    private func removeNode(_ node: Node<Key, Value>) {
        if node === head { head = node.next }
        if node === tail { tail = node.prev }
        node.prev?.next = node.next
        node.next?.prev = node.prev
        node.prev = nil; node.next = nil
    }

    private func removeLRU() {
        guard let lru = tail else { return }
        dict.removeValue(forKey: lru.key)
        removeNode(lru)
    }
}''',
    edgeCases: [
      'Capacity of 1: evicting the sole element must reset both head and tail pointers cleanly.',
      'Updating existing key: must update value AND mark as most recently used without leaking duplicate nodes.',
      'Actor reentrancy: ensuring synchronous list modifications remain atomic during synchronous accessor calls.',
    ],
    interviewFollowUp:
        'How would you add TTL (Time-To-Live) expiration per entry without degrading O(1) performance?',
    approaches: [
      CodingApproach(
        title: 'Approach 1: Array + Timestamp Scanning',
        timeComplexity: 'Get: O(1), Put/Evict: O(N)',
        spaceComplexity: 'O(N)',
        explanation:
            'Store key-value pairs in a standard Dictionary, alongside an array storing access timestamps. On each get, update the timestamp. When capacity is exceeded during a put, iterate through the entire timestamp array to find and remove the minimum value.',
        code: '''class NaiveLRUCache<Key: Hashable, Value> {
    private let capacity: Int
    private var storage: [Key: (value: Value, timestamp: Date)] = [:]

    init(capacity: Int) { self.capacity = capacity }

    func get(_ key: Key) -> Value? {
        guard var entry = storage[key] else { return nil }
        entry.timestamp = Date()
        storage[key] = entry
        return entry.value
    }

    func put(_ key: Key, _ value: Value) {
        if storage.count >= capacity && storage[key] == nil {
            // O(N) scan to locate oldest timestamp
            if let oldest = storage.min(by: { \$0.value.timestamp < \$1.value.timestamp }) {
                storage.removeValue(forKey: oldest.key)
            }
        }
        storage[key] = (value, Date())
    }
}''',
        verdict: 'Suboptimal: Eviction degrades to O(N) linear scans, causing frame drops during rapid cache inserts.',
      ),
      CodingApproach(
        title: 'Approach 2: Ordered Linked List without Hash Index',
        timeComplexity: 'Get: O(N), Put: O(1)',
        spaceComplexity: 'O(N)',
        explanation:
            'Maintain a doubly linked list where the most recent items are at the front. Without a dictionary mapping keys to nodes, finding a key requires traversing the linked list from head to tail in O(N) time.',
        code: '''class LinkedListLRU<Key: Equatable, Value> {
    final class Node {
        let key: Key; var value: Value; var next: Node?
        init(key: Key, value: Value) { self.key = key; self.value = value }
    }
    private var head: Node?

    func get(_ key: Key) -> Value? {
        var curr = head
        while let node = curr {
            if node.key == key { return node.value }
            curr = node.next
        }
        return nil
    }
}''',
        verdict: 'Suboptimal: O(N) read latency is unacceptable in interactive UI feeds and fast scrolling.',
      ),
      CodingApproach(
        title: 'Approach 3: Hash Map + Doubly Linked List + Swift Actor (Optimal Staff Standard)',
        timeComplexity: 'Get: O(1), Put: O(1)',
        spaceComplexity: 'O(Capacity)',
        explanation:
            'Combine an O(1) random-access Hash Map [Key: Node] with a Doubly Linked List for O(1) node detachment and insertion at the head. Wrap in a Swift Concurrency actor to ensure thread safety without manual lock contention or priority inversion.',
        code: '''final class Node<Key: Hashable, Value> {
    let key: Key; var val: Value; var prev: Node?; var next: Node?
    init(key: Key, val: Value) { self.key = key; self.val = val }
}

actor LRUCache<Key: Hashable, Value> {
    private let capacity: Int
    private var dict: [Key: Node<Key, Value>] = [:]
    private var head: Node<Key, Value>?, tail: Node<Key, Value>?

    init(capacity: Int) { self.capacity = max(1, capacity) }

    func get(_ key: Key) -> Value? {
        guard let node = dict[key] else { return nil }
        moveToHead(node)
        return node.val
    }

    func put(_ key: Key, _ value: Value) {
        if let node = dict[key] {
            node.val = value; moveToHead(node)
        } else {
            let node = Node(key: key, val: value)
            dict[key] = node; addToHead(node)
            if dict.count > capacity { removeLRU() }
        }
    }
    private func moveToHead(_ n: Node<Key, Value>) { removeNode(n); addToHead(n) }
    private func addToHead(_ n: Node<Key, Value>) {
        n.next = head; n.prev = nil; head?.prev = n; head = n
        if tail == nil { tail = head }
    }
    private func removeNode(_ n: Node<Key, Value>) {
        if n === head { head = n.next }
        if n === tail { tail = n.prev }
        n.prev?.next = n.next; n.next?.prev = n.prev
    }
    private func removeLRU() {
        guard let lru = tail else { return }
        dict.removeValue(forKey: lru.key); removeNode(lru)
    }
}''',
        verdict: 'Optimal: Guarantees strict O(1) read and write operations with modern Swift 6 thread safety.',
      ),
    ],
  ),

  const CodingChallenge(
    id: 2,
    title: 'Async Image Downloader & Request Coalescing Cache',
    category: 'Concurrency & Tasks',
    difficulty: 'Senior',
    timeComplexity: 'O(1) Cache hit, O(Network) Download',
    spaceComplexity: 'O(Total Cached Images)',
    problemStatement:
        'When fast-scrolling a feed with multiple cells displaying the same image URL, multiple network calls are triggered for the same asset. Build an actor-isolated downloader that coalesces duplicate in-flight requests into a single Task so only one network call is executed.',
    bruteForceApproach:
        'Triggering URLSession.shared.data(from: url) in each cell independently, leading to massive bandwidth waste, CPU decoding spikes, and thread starvation.',
    optimizedApproach:
        'Maintain a dictionary of in-flight `[URL: Task<UIImage, Error>]`. If a request is already running, subsequent callers `await` the existing task. Store completed images in an in-memory cache and remove the in-flight task upon completion.',
    swiftSolution: '''actor ImagePipeline {
    private var inFlight: [URL: Task<UIImage, Error>] = [:]
    private var memoryCache = NSCache<NSURL, UIImage>()

    func image(for url: URL) async throws -> UIImage {
        let nsURL = url as NSURL
        if let cached = memoryCache.object(forKey: nsURL) { return cached }
        if let existingTask = inFlight[url] { return try await existingTask.value }

        let task = Task<UIImage, Error> {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            guard let image = UIImage(data: data) else { throw URLError(.cannotDecodeContentData) }
            return image
        }
        inFlight[url] = task
        do {
            let image = try await task.value
            memoryCache.setObject(image, forKey: nsURL)
            inFlight[url] = nil
            return image
        } catch {
            inFlight[url] = nil
            throw error
        }
    }
}''',
    edgeCases: [
      'Task cancellation: if one cell is recycled and cancels its task, other cells waiting on the same URL should not fail.',
      'Memory warnings: NSCache automatically evicts images under memory pressure.',
      'Corrupt payload: ensuring failing tasks clean up their inFlight slot so retries can execute.',
    ],
    interviewFollowUp:
        'How would you integrate downsampling using ImageIO to prevent 48MB JPEG bitmap bloat before caching?',
    approaches: [
      CodingApproach(
        title: 'Approach 1: Naive Direct URLSession in Table Cells',
        timeComplexity: 'O(N × Network Requests)',
        spaceComplexity: 'O(N × Bitmap allocations)',
        explanation:
            'Each cell independently triggers URLSession dataTask when configured. If 10 cells display the same profile picture, 10 separate HTTP requests and 10 separate JPEG decodes occur simultaneously.',
        code: '''func configureCell(url: URL) {
    URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
        guard let data = data, let image = UIImage(data: data) else { return }
        DispatchQueue.main.async { self?.imageView.image = image }
    }.resume()
}''',
        verdict: 'Rejected in Interviews: Wasteful bandwidth, cell flickering, and memory spikes leading to OS OOM kills.',
      ),
      CodingApproach(
        title: 'Approach 2: Completion-Handler Dictionary with NSLock',
        timeComplexity: 'O(Network Request)',
        spaceComplexity: 'O(Queued Callbacks)',
        explanation:
            'Store an array of completion handlers per URL behind an NSLock. Subsequent requests append their callback. When the request returns, iterate and fire all callbacks.',
        code: '''final class CallbackCoalescer {
    private var handlers: [URL: [(UIImage?) -> Void]] = [:]
    private let lock = NSLock()

    func fetch(url: URL, completion: @escaping (UIImage?) -> Void) {
        lock.lock()
        if handlers[url] != nil {
            handlers[url]?.append(completion)
            lock.unlock(); return
        }
        handlers[url] = [completion]
        lock.unlock()
        // Run network call and invoke all callbacks...
    }
}''',
        verdict: 'Suboptimal: Callback pyramids, risk of retain cycles, and difficult cancellation handling.',
      ),
      CodingApproach(
        title: 'Approach 3: Actor-Isolated Task Coalescing Pipeline (Optimal Staff Standard)',
        timeComplexity: 'O(1) Cache Hit / 1 Network Call per Unique URL',
        spaceComplexity: 'O(In-Memory Cache)',
        explanation:
            'Use an actor-isolated dictionary of in-flight Swift Tasks `[URL: Task<UIImage, Error>]`. Callers await the shared Task. Completed images are stored in NSCache, which automatically responds to OS memory pressure.',
        code: '''actor ImagePipeline {
    private var inFlight: [URL: Task<UIImage, Error>] = [:]
    private var cache = NSCache<NSURL, UIImage>()

    func image(for url: URL) async throws -> UIImage {
        let nsURL = url as NSURL
        if let cached = cache.object(forKey: nsURL) { return cached }
        if let existing = inFlight[url] { return try await existing.value }

        let task = Task<UIImage, Error> {
            let (data, res) = try await URLSession.shared.data(from: url)
            guard (res as? HTTPURLResponse)?.statusCode == 200,
                  let img = UIImage(data: data) else { throw URLError(.badServerResponse) }
            return img
        }
        inFlight[url] = task
        defer { inFlight[url] = nil }
        let image = try await task.value
        cache.setObject(image, forKey: nsURL)
        return image
    }
}''',
        verdict: 'Optimal: Thread-safe, deduplicated, zero race conditions, and fully structured concurrency native.',
      ),
    ],
  ),

  const CodingChallenge(
    id: 3,
    title: 'Generic Async Debouncer & Throttler',
    category: 'Concurrency & Tasks',
    difficulty: 'Medium / Senior',
    timeComplexity: 'O(1) Dispatch',
    spaceComplexity: 'O(1) Task handle',
    problemStatement:
        'Implement reusable `Debouncer` and `Throttler` utilities in modern Swift Concurrency. A Debouncer executes the action only after a quiet period of duration N. A Throttler executes immediately, but ignores calls within interval N.',
    bruteForceApproach:
        'Using Timer or performSelector on runloops, which requires main-thread scheduling and manual invalidation.',
    optimizedApproach:
        'Use Swift Concurrency structured `Task` cancellation and `Task.sleep(for:)`. Maintain an active Task reference and cancel it when a new event arrives before the delay expires.',
    swiftSolution: '''actor Debouncer {
    private let duration: Duration
    private var task: Task<Void, Never>?

    init(duration: Duration) { self.duration = duration }

    func run(action: @escaping @Sendable () async -> Void) {
        task?.cancel()
        task = Task {
            do {
                try await Task.sleep(for: duration)
                guard !Task.isCancelled else { return }
                await action()
            } catch {}
        }
    }
}

actor Throttler {
    private let duration: Duration
    private var lastExecution: ContinuousClock.Instant?

    init(duration: Duration) { self.duration = duration }

    func run(action: @escaping @Sendable () async -> Void) async {
        let now = ContinuousClock.now
        if let last = lastExecution, (now - last) < duration { return }
        lastExecution = now
        await action()
    }
}''',
    edgeCases: [
      'Task cancellation during sleep must cleanly drop without firing action.',
      'Clock drift: using `ContinuousClock` instead of wall-clock time ensures accuracy across device sleep.',
    ],
    interviewFollowUp:
        'How would you guarantee that the final trailing event is always executed in a throttle implementation?',
    approaches: [
      CodingApproach(
        title: 'Approach 1: NSTimer & RunLoop Scheduling',
        timeComplexity: 'O(1)',
        spaceComplexity: 'O(1)',
        explanation:
            'Schedule an NSTimer on the current RunLoop. When a new event arrives, invalidate the old timer and create a new one.',
        code: '''class TimerDebouncer {
    private var timer: Timer?
    func debounce(delay: TimeInterval, action: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in action() }
    }
}''',
        verdict: 'Legacy: Bound to specific RunLoop modes, memory leak prone if target retains timer.',
      ),
      CodingApproach(
        title: 'Approach 2: GCD DispatchWorkItem Cancellation',
        timeComplexity: 'O(1)',
        spaceComplexity: 'O(1)',
        explanation:
            'Create a `DispatchWorkItem` and submit it to a DispatchQueue with a delay. Call `cancel()` on subsequent invocations.',
        code: '''final class GCDDebouncer {
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue
    init(queue: DispatchQueue = .main) { self.queue = queue }
    func debounce(delay: Double, action: @escaping () -> Void) {
        workItem?.cancel()
        let item = DispatchWorkItem(block: action)
        workItem = item
        queue.asyncAfter(deadline: .now() + delay, execute: item)
    }
}''',
        verdict: 'Acceptable: Pre-Swift 5.5 production standard, but lacks async/await and actor isolation.',
      ),
      CodingApproach(
        title: 'Approach 3: Structured Concurrency Task Cancellation (Optimal Staff Standard)',
        timeComplexity: 'O(1)',
        spaceComplexity: 'O(1)',
        explanation:
            'Use an actor to isolate task handles. Each invocation cancels the preceding `Task<Void, Never>`, then awaits `Task.sleep(for: duration)`. Cooperative cancellation ensures zero memory overhead.',
        code: '''actor ModernDebouncer {
    private let duration: Duration
    private var activeTask: Task<Void, Never>?
    init(duration: Duration) { self.duration = duration }

    func run(action: @escaping @Sendable () async -> Void) {
        activeTask?.cancel()
        activeTask = Task {
            do {
                try await Task.sleep(for: duration)
                guard !Task.isCancelled else { return }
                await action()
            } catch {}
        }
    }
}''',
        verdict: 'Optimal: Clean cooperative cancellation, continuous clock accuracy, and zero thread hops.',
      ),
    ],
  ),

  const CodingChallenge(
    id: 4,
    title: 'Copy-on-Write (CoW) SmartBuffer Implementation',
    category: 'Memory & CoW',
    difficulty: 'Hard / Senior Staff',
    timeComplexity: 'O(1) Copy, O(N) Mutation when shared',
    spaceComplexity: 'O(N) Buffer capacity',
    problemStatement:
        'Implement a custom value-type data structure `SmartArray<T>` in Swift that wraps a heap buffer with true Copy-on-Write semantics using `isKnownUniquelyReferenced`.',
    bruteForceApproach:
        'Standard struct with eager deep-copying: cloning the underlying buffer on every variable assignment, causing O(N) allocation churn.',
    optimizedApproach:
        'Wrap heap storage in a private reference class. When mutating, check `isKnownUniquelyReferenced(&storage)`. Only allocate a new cloned buffer if the reference count is greater than 1.',
    swiftSolution: '''final class StorageBox<T> {
    var elements: [T]
    init(elements: [T] = []) { self.elements = elements }
    func clone() -> StorageBox<T> { StorageBox(elements: elements) }
}

struct SmartArray<T> {
    private var storage: StorageBox<T>
    init() { self.storage = StorageBox() }
    var count: Int { storage.elements.count }

    subscript(index: Int) -> T {
        get { storage.elements[index] }
        set {
            ensureUniqueStorage()
            storage.elements[index] = newValue
        }
    }

    mutating func append(_ element: T) {
        ensureUniqueStorage()
        storage.elements.append(element)
    }

    private mutating func ensureUniqueStorage() {
        if !isKnownUniquelyReferenced(&storage) {
            storage = storage.clone()
        }
    }
}''',
    edgeCases: [
      'Passing `&storage` as inout to `isKnownUniquelyReferenced`: must be a direct stored property of a struct.',
      'Thread safety: `isKnownUniquelyReferenced` is atomic, but concurrent mutations on different threads still require synchronization.',
    ],
    interviewFollowUp:
        'Why does mutating a nested struct property trigger Copy-on-Write on the outer containing struct?',
    approaches: [
      CodingApproach(
        title: 'Approach 1: Naive Struct with Eager Deep Copying',
        timeComplexity: 'O(N) on Every Assignment',
        spaceComplexity: 'O(N × Copies)',
        explanation:
            'A struct that allocates a completely new internal storage buffer on every assignment, function argument pass, or return.',
        code: '''struct EagerArray<T> {
    private var buffer: [T]
    init(buffer: [T] = []) { self.buffer = buffer }
    mutating func append(_ item: T) { buffer.append(item) }
}''',
        verdict: 'Suboptimal: Severe memory churn when passing arrays across functions without mutating.',
      ),
      CodingApproach(
        title: 'Approach 2: Class Reference Type (No Value Semantics)',
        timeComplexity: 'O(1)',
        spaceComplexity: 'O(1)',
        explanation:
            'Using a pure class to avoid copying. However, assigning the object to a second variable shares the memory pointer, meaning mutating one affects both.',
        code: '''final class ReferenceArray<T> {
    var items: [T] = []
    func append(_ item: T) { items.append(item) }
}''',
        verdict: 'Rejected: Violates value semantics; causes critical unintended mutation bugs across view controllers.',
      ),
      CodingApproach(
        title: 'Approach 3: isKnownUniquelyReferenced CoW Box (Optimal Staff Standard)',
        timeComplexity: 'O(1) Assignment, O(N) Mutation ONLY when shared',
        spaceComplexity: 'O(N) Unified Buffer',
        explanation:
            'Store an underlying class reference `StorageBox`. On assignment, only the 8-byte pointer is copied. On mutation, check `isKnownUniquelyReferenced(&storage)`. If count == 1, mutate in-place in O(1); otherwise, deep copy in O(N).',
        code: '''final class StorageBox<T> {
    var elements: [T]; init(elements: [T] = []) { self.elements = elements }
    func clone() -> StorageBox<T> { StorageBox(elements: elements) }
}
struct SmartArray<T> {
    private var storage = StorageBox<T>()
    mutating func append(_ element: T) {
        if !isKnownUniquelyReferenced(&storage) { storage = storage.clone() }
        storage.elements.append(element)
    }
}''',
        verdict: 'Optimal: Matches the exact performance architecture of Swift Standard Library Array and Dictionary.',
      ),
    ],
  ),

  const CodingChallenge(
    id: 5,
    title: 'Polymorphic Codable & Lossy Array Decoder',
    category: 'Architecture',
    difficulty: 'Senior',
    timeComplexity: 'O(N) JSON traversal',
    spaceComplexity: 'O(N) Decoded entities',
    problemStatement:
        'In production APIs, a single malformed item in a feed JSON array crashes the entire `JSONDecoder().decode([FeedItem].self)`. Build a generic `LossyArray<T>` property wrapper that skips corrupted items gracefully and decodes polymorphic payloads based on a "type" discriminator key.',
    bruteForceApproach:
        'Calling `try JSONDecoder().decode([FeedItem].self, from: data)` where one unexpected null field drops the entire 100-item feed.',
    optimizedApproach:
        'Implement an unkeyed container decoding loop where each element is decoded inside an individual `try?` block. If decoding fails, advance the unkeyed index without aborting the overall array.',
    swiftSolution: '''@propertyWrapper
struct LossyArray<Element: Decodable>: Decodable {
    var wrappedValue: [Element]
    init(wrappedValue: [Element] = []) { self.wrappedValue = wrappedValue }

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var elements: [Element] = []
        while !container.isAtEnd {
            if let element = try? container.decode(Element.self) {
                elements.append(element)
            } else {
                _ = try? container.decode(EmptyCodable.self)
            }
        }
        self.wrappedValue = elements
    }
    private struct EmptyCodable: Decodable {}
}''',
    edgeCases: [
      'Empty array or unexpected null in root object.',
      'Unkeyed container index advancement: must advance scanner even when item decoding throws.',
    ],
    interviewFollowUp:
        'How would you log rejected telemetry payloads to Datadog/Sentry without interrupting user feeds?',
    approaches: [
      CodingApproach(
        title: 'Approach 1: Standard Swift JSONDecoder [FeedItem].self',
        timeComplexity: 'O(N)',
        spaceComplexity: 'O(N)',
        explanation:
            'Use standard JSONDecoder. If 99 out of 100 items are valid and 1 has a mismatched type or null field, decoding throws an exception and the entire list is lost.',
        code: '''let items = try JSONDecoder().decode([FeedItem].self, from: data)''',
        verdict: 'Fragile: Single backend API regression renders blank feed screens for 100% of mobile users.',
      ),
      CodingApproach(
        title: 'Approach 2: Manual KeyedContainer Optional Decoding',
        timeComplexity: 'O(N)',
        spaceComplexity: 'O(N)',
        explanation:
            'Decode items manually using optional fields and for loops inside a parent model, discarding nil values explicitly.',
        code: '''struct FeedResponse: Decodable {
    let items: [FeedItem]
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var list: [FeedItem] = []
        while !container.isAtEnd {
            if let item = try? container.decode(FeedItem.self) { list.append(item) }
        }
        self.items = list
    }
}''',
        verdict: 'Acceptable: Works, but requires mechanical boilerplate repetition across dozens of network responses.',
      ),
      CodingApproach(
        title: 'Approach 3: Generic LossyArray Property Wrapper (Optimal Staff Standard)',
        timeComplexity: 'O(N) Single Pass',
        spaceComplexity: 'O(N) Decoded Models',
        explanation:
            'A generic `@LossyArray` property wrapper that inspects the unkeyed container, swallows corrupted nodes with an `EmptyCodable` index consumer, and produces a clean array with zero manual boilerplate.',
        code: '''@propertyWrapper
struct LossyArray<Element: Decodable>: Decodable {
    var wrappedValue: [Element]
    init(wrappedValue: [Element] = []) { self.wrappedValue = wrappedValue }
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var elements: [Element] = []
        while !container.isAtEnd {
            if let item = try? container.decode(Element.self) { elements.append(item) }
            else { _ = try? container.decode(EmptyCodable.self) }
        }
        self.wrappedValue = elements
    }
    private struct EmptyCodable: Decodable {}
}''',
        verdict: 'Optimal: Reusable across the entire enterprise codebase; resilient against unexpected backend schema drifts.',
      ),
    ],
  ),

  const CodingChallenge(
    id: 6,
    title: 'Reactive Publisher & Subscription (Mini-Combine)',
    category: 'Architecture',
    difficulty: 'Senior Staff',
    timeComplexity: 'O(1) Emit, O(1) Subscribe, O(1) Cancel',
    spaceComplexity: 'O(Subscribers)',
    problemStatement:
        'Build a lightweight, thread-safe implementation of an Observable stream / Subject pattern in pure Swift without importing Combine or RxSwift.',
    bruteForceApproach:
        'Storing closures in an array without UUID tracking, making cancellation and removal O(N) or memory-leak prone.',
    optimizedApproach:
        'Use a thread-safe `Subject` backed by a concurrent `DispatchQueue` with barrier writes (or an OSAllocatedUnfairLock). Return a `CancellableToken` that removes its handler from the dictionary in O(1).',
    swiftSolution: '''final class CancellableToken {
    private var onCancel: (() -> Void)?
    init(onCancel: @escaping () -> Void) { self.onCancel = onCancel }
    func cancel() { onCancel?(); onCancel = nil }
    deinit { cancel() }
}

final class ObservableStream<Value> {
    private var subscribers: [UUID: (Value) -> Void] = [:]
    private let lock = NSLock()

    func send(_ value: Value) {
        lock.lock()
        let callbacks = Array(subscribers.values)
        lock.unlock()
        for callback in callbacks { callback(value) }
    }

    func subscribe(_ handler: @escaping (Value) -> Void) -> CancellableToken {
        let id = UUID()
        lock.lock(); subscribers[id] = handler; lock.unlock()
        return CancellableToken { [weak self] in
            guard let self else { return }
            self.lock.lock(); self.subscribers.removeValue(forKey: id); self.lock.unlock()
        }
    }
}''',
    edgeCases: [
      'Subscriber cancels while an emit loop is actively running (prevent deadlock).',
      'Memory leak prevention when closures capture strong references.',
    ],
    interviewFollowUp:
        'How would you implement backpressure and demand management as defined in Apple’s Combine `Subscriber` protocol?',
    approaches: [
      CodingApproach(
        title: 'Approach 1: Array of Callback Closures',
        timeComplexity: 'O(N) Emit, Impossible O(1) Cancel',
        spaceComplexity: 'O(N)',
        explanation:
            'Maintain an array of `[(Value) -> Void]` closures. When a subscriber leaves screen, there is no identifier to remove it, causing memory leaks.',
        code: '''class SimpleEmitter<T> {
    private var listeners: [(T) -> Void] = []
    func subscribe(_ cb: @escaping (T) -> Void) { listeners.append(cb) }
    func emit(_ val: T) { listeners.forEach { \$0(val) } }
}''',
        verdict: 'Suboptimal: Retain cycles and memory leaks without explicit token cancellation.',
      ),
      CodingApproach(
        title: 'Approach 2: Thread-Safe ObservableStream with CancellableToken (Optimal Staff Standard)',
        timeComplexity: 'O(1) Subscribe, O(1) Cancel, O(Subscribers) Emit',
        spaceComplexity: 'O(Subscribers)',
        explanation:
            'Store closures in a dictionary keyed by `UUID`. Return a `CancellableToken` conforming to ARC lifecycle: when the token deinits, it auto-cancels and removes itself from the publisher.',
        code: '''final class CancellableToken {
    private var onCancel: (() -> Void)?
    init(onCancel: @escaping () -> Void) { self.onCancel = onCancel }
    func cancel() { onCancel?(); onCancel = nil }
    deinit { cancel() }
}
final class ObservableStream<Value> {
    private var subscribers: [UUID: (Value) -> Void] = [:]
    private let lock = NSLock()
    func subscribe(_ handler: @escaping (Value) -> Void) -> CancellableToken {
        let id = UUID()
        lock.lock(); subscribers[id] = handler; lock.unlock()
        return CancellableToken { [weak self] in
            self?.lock.lock(); self?.subscribers.removeValue(forKey: id); self?.lock.unlock()
        }
    }
}''',
        verdict: 'Optimal: Clean RAII lifetime management identical to `AnyCancellable` in Apple Combine.',
      ),
    ],
  ),

  const CodingChallenge(
    id: 7,
    title: 'Thread-Safe Dependency Injection Container',
    category: 'Architecture',
    difficulty: 'Senior',
    timeComplexity: 'O(1) Resolution',
    spaceComplexity: 'O(Registered Services)',
    problemStatement:
        'Create a lightweight, thread-safe Service Locator / Dependency Injection Container in Swift supporting transient factories and thread-safe singleton lifetimes.',
    bruteForceApproach:
        'Global static singletons littered across the app, making mock injection in XCTest impossible.',
    optimizedApproach:
        'A container with registration keyed by `ObjectIdentifier(Service.self)`. Use `NSLock` or private concurrent queue to ensure thread-safe resolution across multi-threaded feature modules.',
    swiftSolution: '''protocol DIContainerProtocol {
    func register<T>(_ type: T.Type, factory: @escaping () -> T)
    func registerSingleton<T>(_ type: T.Type, instance: T)
    func resolve<T>(_ type: T.Type) -> T
}

final class AppContainer: DIContainerProtocol {
    static let shared = AppContainer()
    private var factories: [ObjectIdentifier: () -> Any] = [:]
    private var singletons: [ObjectIdentifier: Any] = [:]
    private let lock = NSLock()

    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        lock.lock(); defer { lock.unlock() }
        factories[ObjectIdentifier(type)] = factory
    }

    func registerSingleton<T>(_ type: T.Type, instance: T) {
        lock.lock(); defer { lock.unlock() }
        singletons[ObjectIdentifier(type)] = instance
    }

    func resolve<T>(_ type: T.Type = T.self) -> T {
        lock.lock(); defer { lock.unlock() }
        let id = ObjectIdentifier(type)
        if let singleton = singletons[id] as? T { return singleton }
        guard let factory = factories[id], let instance = factory() as? T else {
            fatalError("Dependency \\(type) has not been registered in container!")
        }
        return instance
    }
}''',
    edgeCases: [
      'Circular dependency detection: A depends on B which depends on A.',
      'Scope management: distinguishing transient instances from retained view model state.',
    ],
    interviewFollowUp:
        'How would you use Swift Property Wrappers (`@Injected`) to inject dependencies automatically at property initialization?',
    approaches: [
      CodingApproach(
        title: 'Approach 1: Static Singletons Scattered in Production Code',
        timeComplexity: 'O(1)',
        spaceComplexity: 'O(N)',
        explanation:
            'Referencing `NetworkService.shared` or `DatabaseManager.shared` directly inside UI ViewModels.',
        code: '''class HomeViewModel {
    func load() { NetworkService.shared.fetchData() }
}''',
        verdict: 'Rejected in Interviews: Tight coupling prevents isolated unit testing with mocks in XCTest.',
      ),
      CodingApproach(
        title: 'Approach 2: Thread-Safe ObjectIdentifier Container (Optimal Staff Standard)',
        timeComplexity: 'O(1) Resolution',
        spaceComplexity: 'O(Services)',
        explanation:
            'Key service dependencies by their compiler `ObjectIdentifier(Protocol.self)`. Synchronize access with an NSLock to prevent dictionary data races during concurrent resolution.',
        code: '''final class AppContainer {
    static let shared = AppContainer()
    private var factories: [ObjectIdentifier: () -> Any] = [:]
    private let lock = NSLock()
    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        lock.lock(); defer { lock.unlock() }
        factories[ObjectIdentifier(type)] = factory
    }
    func resolve<T>(_ type: T.Type = T.self) -> T {
        lock.lock(); defer { lock.unlock() }
        guard let f = factories[ObjectIdentifier(type)], let s = f() as? T else { fatalError() }
        return s
    }
}''',
        verdict: 'Optimal: Modular, testable, decoupled, and safe for concurrent execution across background threads.',
      ),
    ],
  ),

  const CodingChallenge(
    id: 8,
    title: 'Two Sum & Inward Two-Pointers Suite',
    category: 'Algorithms',
    difficulty: 'Medium',
    timeComplexity: 'O(N) Linear Time',
    spaceComplexity: 'O(N) for Two Sum, O(1) for Palindrome',
    problemStatement:
        '1. Two Sum: Find indices of two numbers in an array that sum to target.\n2. Valid Palindrome: Determine if a string is a palindrome, considering only alphanumeric characters and ignoring cases.',
    bruteForceApproach:
        'Nested for loops checking every pair in O(N^2) time.',
    optimizedApproach:
        '1. Two Sum: Hash Map storing complement `target - num` for O(N) single-pass lookup.\n2. Palindrome: Inward two pointers skipping non-alphanumeric characters in O(N) time with O(1) auxiliary space.',
    swiftSolution: '''// 1. Two Sum - O(N) Time, O(N) Space
func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var map: [Int: Int] = [:]
    for (i, num) in nums.enumerated() {
        if let match = map[target - num] { return [match, i] }
        map[num] = i
    }
    return []
}

// 2. Valid Palindrome - O(N) Time, O(1) Space
func isPalindrome(_ s: String) -> Bool {
    let chars = Array(s.lowercased())
    var left = 0, right = chars.count - 1
    while left < right {
        while left < right && !chars[left].isLetter && !chars[left].isNumber { left += 1 }
        while left < right && !chars[right].isLetter && !chars[right].isNumber { right -= 1 }
        if chars[left] != chars[right] { return false }
        left += 1; right -= 1
    }
    return true
}''',
    edgeCases: [
      'Empty strings or strings with only special characters (".,;").',
      'Arrays with negative numbers and duplicate elements.',
    ],
    interviewFollowUp:
        'How does Swift string indexing (`String.Index` vs `Array(s)`) affect runtime complexity due to grapheme cluster segmentation?',
    approaches: [
      CodingApproach(
        title: 'Approach 1: Two Sum Brute Force (Nested Loops)',
        timeComplexity: 'O(N^2)',
        spaceComplexity: 'O(1)',
        explanation:
            'Iterate through every pair of elements using nested loops `(i, j)` and test if `nums[i] + nums[j] == target`.',
        code: '''func twoSumBruteForce(_ nums: [Int], _ target: Int) -> [Int] {
    for i in 0..<nums.count {
        for j in (i + 1)..<nums.count {
            if nums[i] + nums[j] == target { return [i, j] }
        }
    }
    return []
}''',
        verdict: 'Time Limit Exceeded (TLE): Fails test cases when N > 10,000.',
      ),
      CodingApproach(
        title: 'Approach 2: Two Sum Sorting + Inward Two Pointers',
        timeComplexity: 'O(N log N)',
        spaceComplexity: 'O(N) for Index Tuples',
        explanation:
            'Pair elements with their original indices `(val, idx)`, sort by value in O(N log N), then use inward pointers moving left/right based on sum.',
        code: '''func twoSumTwoPointers(_ nums: [Int], _ target: Int) -> [Int] {
    let indexed = nums.enumerated().map { (\$0.element, \$0.offset) }.sorted { \$0.0 < \$1.0 }
    var left = 0, right = indexed.count - 1
    while left < right {
        let sum = indexed[left].0 + indexed[right].0
        if sum == target { return [indexed[left].1, indexed[right].1] }
        else if sum < target { left += 1 }
        else { right -= 1 }
    }
    return []
}''',
        verdict: 'Better than Brute Force, but requires O(N log N) sorting overhead and auxiliary storage for index pairs.',
      ),
      CodingApproach(
        title: 'Approach 3: Two Sum One-Pass Hash Map (Optimal Staff Standard)',
        timeComplexity: 'O(N) Linear Time',
        spaceComplexity: 'O(N) Hash Table',
        explanation:
            'Iterate once through the array. For each number, calculate `complement = target - num`. If present in the dictionary, return `[complementIndex, currentIndex]`. Otherwise insert `[num: currentIndex]`.',
        code: '''func twoSumOptimal(_ nums: [Int], _ target: Int) -> [Int] {
    var map: [Int: Int] = [:] // [Number: Index]
    for (i, num) in nums.enumerated() {
        if let match = map[target - num] { return [match, i] }
        map[num] = i
    }
    return []
}''',
        verdict: 'Optimal: Single-pass O(N) time with instant O(1) dictionary lookups.',
      ),
      CodingApproach(
        title: 'Approach 4: Valid Palindrome Inward Two Pointers (Optimal Staff Standard)',
        timeComplexity: 'O(N) Linear Time',
        spaceComplexity: 'O(1) Auxiliary Space',
        explanation:
            'Place pointers at the start and end of the string. Advance past non-alphanumeric characters without allocating a filtered duplicate string, comparing characters case-insensitively.',
        code: '''func isPalindrome(_ s: String) -> Bool {
    let chars = Array(s.lowercased())
    var l = 0, r = chars.count - 1
    while l < r {
        while l < r && !chars[l].isLetter && !chars[l].isNumber { l += 1 }
        while l < r && !chars[r].isLetter && !chars[r].isNumber { r -= 1 }
        if chars[l] != chars[r] { return false }
        l += 1; r -= 1
    }
    return true
}''',
        verdict: 'Optimal: Zero heap allocation and early termination on mismatch.',
      ),
    ],
  ),

  const CodingChallenge(
    id: 9,
    title: 'Binary Tree Level-Order (BFS) Traversal & Binary Search',
    category: 'Algorithms',
    difficulty: 'Medium',
    timeComplexity: 'O(N) for BFS, O(log N) for Binary Search',
    spaceComplexity: 'O(N) for Queue, O(1) for Binary Search',
    problemStatement:
        '1. BFS Level-Order: Return level-by-level array of node values from binary tree root.\n2. Binary Search: Find index of target in sorted array, or return -1.',
    bruteForceApproach:
        'Recursively calculating depth for each node (O(N^2) for BFS) or linear O(N) search.',
    optimizedApproach:
        '1. Queue-based BFS taking snapshot of queue length per level.\n2. Two pointers with `mid = left + (right - left) / 2` to prevent 32-bit integer overflow.',
    swiftSolution: '''final class TreeNode {
    var val: Int; var left: TreeNode?; var right: TreeNode?
    init(_ val: Int) { self.val = val }
}

func levelOrder(_ root: TreeNode?) -> [[Int]] {
    guard let root else { return [] }
    var result: [[Int]] = []
    var queue: [TreeNode] = [root]
    while !queue.isEmpty {
        let levelCount = queue.count
        var currentLevel: [Int] = []
        for _ in 0..<levelCount {
            let node = queue.removeFirst()
            currentLevel.append(node.val)
            if let l = node.left { queue.append(l) }
            if let r = node.right { queue.append(r) }
        }
        result.append(currentLevel)
    }
    return result
}''',
    edgeCases: [
      'Single node tree, completely skewed tree (linked list structure).',
      'Target element outside array bounds (smaller than index 0 or larger than last index).',
    ],
    interviewFollowUp:
        'How would you implement level-order traversal on iOS where queue.removeFirst() in Swift is O(N)? (Answer: Use pointer index offset instead of removeFirst).',
    approaches: [
      CodingApproach(
        title: 'Approach 1: Recursive DFS with Depth Tracking',
        timeComplexity: 'O(N)',
        spaceComplexity: 'O(H) Call Stack (O(N) worst case)',
        explanation:
            'Traverse the tree using Depth-First Search (pre-order), passing a `level` index. Append nodes into `result[level]`, creating arrays dynamically as depth increases.',
        code: '''func levelOrderDFS(_ root: TreeNode?) -> [[Int]] {
    var res: [[Int]] = []
    func dfs(_ node: TreeNode?, _ level: Int) {
        guard let node = node else { return }
        if level == res.count { res.append([]) }
        res[level].append(node.val)
        dfs(node.left, level + 1); dfs(node.right, level + 1)
    }
    dfs(root, 0)
    return res
}''',
        verdict: 'Good, but risks Call Stack Overflow on heavily skewed trees with deep depth.',
      ),
      CodingApproach(
        title: 'Approach 2: Iterative Queue-Based BFS (Optimal Staff Standard)',
        timeComplexity: 'O(N) Single Tree Traversal',
        spaceComplexity: 'O(W) Max Tree Width',
        explanation:
            'Maintain a FIFO queue. At each step, snapshot `count = queue.count` to process exactly one horizontal tree level in isolation before advancing.',
        code: '''func levelOrderBFS(_ root: TreeNode?) -> [[Int]] {
    guard let root else { return [] }
    var result: [[Int]] = [], queue: [TreeNode] = [root]
    while !queue.isEmpty {
        var currentLevel: [Int] = []
        for _ in 0..<queue.count {
            let node = queue.removeFirst()
            currentLevel.append(node.val)
            if let l = node.left { queue.append(l) }
            if let r = node.right { queue.append(r) }
        }
        result.append(currentLevel)
    }
    return result
}''',
        verdict: 'Optimal: Clean level isolation matching UI section rendering requirements.',
      ),
      CodingApproach(
        title: 'Approach 3: Binary Search with Overflow Protection (Optimal Staff Standard)',
        timeComplexity: 'O(log N)',
        spaceComplexity: 'O(1)',
        explanation:
            'Standard two-pointer binary search on sorted array using `mid = left + (right - left) / 2` to prevent 32-bit integer overflow.',
        code: '''func binarySearch(_ nums: [Int], _ target: Int) -> Int {
    var left = 0, right = nums.count - 1
    while left <= right {
        let mid = left + (right - left) / 2
        if nums[mid] == target { return mid }
        else if nums[mid] < target { left = mid + 1 }
        else { right = mid - 1 }
    }
    return -1
}''',
        verdict: 'Optimal: Logarithmic time complexity with safe integer arithmetic.',
      ),
    ],
  ),

  const CodingChallenge(
    id: 10,
    title: 'Dynamic Programming: Climbing Stairs & Minimum Coin Change',
    category: 'Algorithms',
    difficulty: 'Medium / Senior',
    timeComplexity: 'O(N) for Stairs, O(Amount * Coins) for Coin Change',
    spaceComplexity: 'O(1) for Stairs, O(Amount) for Coin Change',
    problemStatement:
        '1. Climbing Stairs: You are climbing a staircase of N steps. Each time you can climb 1 or 2 steps. In how many distinct ways can you reach top?\n2. Coin Change: Given coins of different denominations and total amount, compute minimum coins needed.',
    bruteForceApproach:
        'Recursive branching exploring all combinations in O(2^N) exponential time.',
    optimizedApproach:
        'Bottom-up dynamic programming tabulation, storing only the necessary subproblems to achieve linear runtime.',
    swiftSolution: '''// 1. Climbing Stairs - O(N) Time, O(1) Space
func climbStairs(_ n: Int) -> Int {
    if n <= 2 { return n }
    var prev2 = 1, prev1 = 2
    for _ in 3...n {
        let current = prev1 + prev2
        prev2 = prev1; prev1 = current
    }
    return prev1
}

// 2. Coin Change - O(Amount * Coins) Time, O(Amount) Space
func coinChange(_ coins: [Int], _ amount: Int) -> Int {
    guard amount > 0 else { return 0 }
    var dp = Array(repeating: amount + 1, count: amount + 1)
    dp[0] = 0
    for i in 1...amount {
        for coin in coins {
            if i >= coin { dp[i] = min(dp[i], dp[i - coin] + 1) }
        }
    }
    return dp[amount] > amount ? -1 : dp[amount]
}''',
    edgeCases: [
      'Amount = 0 returns 0 coins.',
      'No combination of coins can make the sum: return -1.',
    ],
    interviewFollowUp:
        'How do you convert bottom-up DP into space-optimized memoization for mobile memory constraints?',
    approaches: [
      CodingApproach(
        title: 'Approach 1: Naive Recursive Branching',
        timeComplexity: 'O(2^N) Exponential Time',
        spaceComplexity: 'O(N) Call Stack',
        explanation:
            'Branch recursively into `climb(n - 1) + climb(n - 2)`. Because overlapping subproblems are recalculated millions of times, runtime explodes exponentially.',
        code: '''func climbStairsNaive(_ n: Int) -> Int {
    if n <= 2 { return n }
    return climbStairsNaive(n - 1) + climbStairsNaive(n - 2)
}''',
        verdict: 'Time Limit Exceeded: Severe bottleneck; hangs completely on N >= 40.',
      ),
      CodingApproach(
        title: 'Approach 2: Top-Down Recursion with Memoization Table',
        timeComplexity: 'O(N)',
        spaceComplexity: 'O(N) Cache Array',
        explanation:
            'Store results of subproblems in an array `memo = [Int: Int]` or `Array(repeating: -1, count: n + 1)`. Look up prior computed states in O(1).',
        code: '''func climbStairsMemo(_ n: Int) -> Int {
    var memo = [Int: Int]()
    func helper(_ step: Int) -> Int {
        if step <= 2 { return step }
        if let cached = memo[step] { return cached }
        let result = helper(step - 1) + helper(step - 2)
        memo[step] = result
        return result
    }
    return helper(n)
}''',
        verdict: 'Accepted: Linear runtime, but incurs O(N) heap allocation for the cache.',
      ),
      CodingApproach(
        title: 'Approach 3: Bottom-Up Tabulation with Rolling State (Optimal Staff Standard)',
        timeComplexity: 'O(N) Linear Time',
        spaceComplexity: 'O(1) Constant Auxiliary Space',
        explanation:
            'Notice that `dp[i]` only depends on `dp[i - 1]` and `dp[i - 2]`. Discard the full array and maintain only two rolling variables `(prev1, prev2)` to eliminate heap allocations entirely.',
        code: '''func climbStairsOptimal(_ n: Int) -> Int {
    if n <= 2 { return n }
    var prev2 = 1, prev1 = 2
    for _ in 3...n {
        let current = prev1 + prev2
        prev2 = prev1; prev1 = current
    }
    return prev1
}''',
        verdict: 'Optimal: Fastest execution with zero dynamic memory allocations.',
      ),
    ],
  ),
];

/// -------------------------------------------------------------
/// MASTER 8 CUTTING-EDGE & CRITICAL AREAS (2025–2026 STANDARDS)
/// -------------------------------------------------------------
final List<CuttingEdgeTopic> cuttingEdgeTopics = [
  const CuttingEdgeTopic(
    id: 1,
    title: 'Apple Privacy Manifests & Required Reason APIs',
    category: 'Privacy & Security',
    description:
        'Mandatory in Xcode 15/16 for all App Store submissions. Declares data collection categories, tracking domains, and approved reasons for accessing fingerprint-sensitive iOS APIs.',
    keyMechanics: [
      'NSPrivacyTracking (Boolean): Declares whether data is linked with third-party datasets for advertising.',
      'NSPrivacyTrackingDomains (Array): Network endpoints blocked by iOS if user denies App Tracking Transparency (ATT).',
      'NSPrivacyCollectedDataTypes: Specific data buckets (Name, Email, Device ID, Diagnostics, Purchase History).',
      'Required Reason APIs: System APIs (File Timestamp, System Boot Time, Disk Space, Active Keyboards, UserDefaults). Must provide valid Apple code (e.g. CA92.1 for UserDefaults access to app preferences).',
    ],
    codeSnippet: '''<!-- PrivacyInfo.xcprivacy snippet -->
<dict>
    <key>NSPrivacyAccessedAPITypes</key>
    <array>
        <dict>
            <key>NSPrivacyAccessedAPIType</key>
            <string>NSPrivacyAccessedAPICategoryUserDefaults</string>
            <key>NSPrivacyAccessedAPITypeReasons</key>
            <array>
                <string>CA92.1</string>
            </array>
        </dict>
    </array>
</dict>''',
    seniorTakeaway:
        'Third-party CocoaPods or Swift Packages missing privacy manifests will trigger rejection emails in App Store Connect. Audit SPM dependencies with Xcode Organizer Generate Privacy Report.',
  ),

  const CuttingEdgeTopic(
    id: 2,
    title: 'Swift 6 Strict Concurrency & Non-Copyable Types (~Copyable)',
    category: 'Swift 6 & Toolchain',
    description:
        'Swift 6 eliminates data races at compile time using complete actor isolation, Sendable enforcement, and explicit ownership transfer (`consuming`, `borrowing`, `~Copyable`).',
    keyMechanics: [
      '~Copyable Structs/Enums: Suppresses implicit duplication. Enables unique ownership on value types without heap allocation.',
      'consuming vs borrowing: consuming transfers ownership of the parameter and consumes the caller binding; borrowing inspects without retaining.',
      'deinit in structs: Non-copyable structs can define a deinit method to cleanly release hardware handles or file descriptors.',
    ],
    codeSnippet: '''struct FileDescriptor: ~Copyable {
    private let fd: Int32
    init(fd: Int32) { self.fd = fd }

    consuming func close() {
        // Ownership consumed! Caller cannot use file descriptor again
        darwin_close(fd)
    }

    deinit {
        darwin_close(fd)
    }
}''',
    seniorTakeaway:
        'Non-copyable types provide the zero-cost performance of value types with the deterministic lifetime and unique ownership of classes.',
  ),

  const CuttingEdgeTopic(
    id: 3,
    title: 'Core Data vs. SwiftData: Architectural Evolution',
    category: 'Persistence & Data',
    description:
        'SwiftData replaces NSManagedObjectContext queue confinement with @ModelActor, pure Swift macros (@Model), and declarative schema migrations.',
    keyMechanics: [
      '@Model Macro: Generates schema metadata and property observers using Swift macros without .xcdatamodeld files.',
      '@ModelActor: A dedicated actor bound to a private ModelContext, guaranteeing safe background persistence and zero thread locks.',
      'NSBatchInsertRequest in Core Data: Still essential in legacy enterprise apps to stream 50,000+ server records into SQLite bypassing context RAM.',
      'Faulting & WAL Mode: Write-Ahead Logging allows concurrent readers while a background context writes.',
    ],
    codeSnippet: '''@ModelActor
actor DatabaseSyncActor {
    func batchInsert(items: [RemoteFeedItem]) throws {
        for item in items {
            modelContext.insert(FeedItem(id: item.id, title: item.title))
        }
        try modelContext.save()
    }
}''',
    seniorTakeaway:
        'For greenfield apps targeting iOS 17+, choose SwiftData with @ModelActor. For high-throughput enterprise apps supporting iOS 15/16, Core Data with SQLite WAL remains standard.',
  ),

  const CuttingEdgeTopic(
    id: 4,
    title: 'Xcode Instruments: Generation Analysis & Memory Graph',
    category: 'Profiling & Telemetry',
    description:
        'Professional performance profiling workflow to diagnose abandoned memory, memory leaks, and frame hitching.',
    keyMechanics: [
      'Generation Analysis ("Mark Generation"): In Allocations instrument, mark a baseline generation, push a screen, pop it, and mark again. Inspect persistent delta objects.',
      'Time Profiler Invert Call Tree: Focuses CPU samples on leaf functions written in your app code rather than system frameworks.',
      'Memory Graph Debugger: Generates an interactive graph of Mach-O heap nodes. Bold circles indicate active retain cycles.',
      'MetricKit MXHangDiagnostic: Tracks main-thread unresponsiveness exceeding 250ms in production.',
    ],
    codeSnippet: '''// MetricKit Subscriber Implementation
import MetricKit

final class TelemetryManager: NSObject, MXMetricManagerSubscriber {
    override init() {
        super.init()
        MXMetricManager.shared.add(self)
    }

    func didReceive(_ payloads: [MXDiagnosticPayload]) {
        for payload in payloads {
            if let hangs = payload.hangDiagnostics {
                // Upload hang stacktraces to telemetry backend
            }
        }
    }
}''',
    seniorTakeaway:
        'Never rely on guessing or print statements for memory leaks. Master Generation Analysis in Allocations to catch leaks before App Store submission.',
  ),

  const CuttingEdgeTopic(
    id: 5,
    title: 'APNs Push Notifications: Service vs. Content Extensions',
    category: 'Privacy & Security',
    description:
        'Architectural separation between background payload mutation (Service Extension) and interactive custom notification UI (Content Extension).',
    keyMechanics: [
      'UNNotificationServiceExtension: Background process executed for up to 30 seconds before display. Decrypts E2E payloads and downloads image/video attachments.',
      'UNNotificationContentExtension: Renders custom interactive view controllers on the lock screen when long-pressed.',
      'App Groups: Shared container sandbox (`UserDefaults(suiteName:)` & SQLite) to share auth credentials between main app and extensions.',
    ],
    codeSnippet: '''class NotificationService: UNNotificationServiceExtension {
    override func didReceive(_ request: UNNotificationRequest,
                            withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        let bestAttempt = request.content.mutableCopy() as? UNMutableNotificationContent
        // 1. Decrypt end-to-end ciphertext
        // 2. Download media attachment and attach via UNNotificationAttachment
        contentHandler(bestAttempt ?? request.content)
    }
}''',
    seniorTakeaway:
        'Notification extensions run as separate system processes with strict 24MB memory limits. Large image decoding in extensions triggers immediate Jetsam termination.',
  ),

  const CuttingEdgeTopic(
    id: 6,
    title: 'Secure Enclave & Biometric Keychain Access',
    category: 'Privacy & Security',
    description:
        'Hardware-backed cryptographic coprocessor. Private keys generated within the Secure Enclave never touch application RAM or the iOS kernel.',
    keyMechanics: [
      'kSecAttrTokenIDSecureEnclave: Enforces key generation exclusively inside the hardware security enclave.',
      'kSecAccessControlBiometryAny: Requires Face ID or Touch ID authentication before private key signing operations execute.',
      'kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly: Accessible after device unlock, stays accessible while phone is locked for silent pushes, never synced to iCloud.',
    ],
    codeSnippet: '''let access = SecAccessControlCreateWithFlags(
    kCFAllocatorDefault,
    kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
    [.privateKeyUsage, .biometryAny],
    nil
)!''',
    seniorTakeaway:
        'Never store auth tokens in plain-text UserDefaults. Enterprise apps must use Keychain Services backed by appropriate accessibility classes.',
  ),

  const CuttingEdgeTopic(
    id: 7,
    title: 'MetricKit Production Observability & Crash Diagnostics',
    category: 'Profiling & Telemetry',
    description:
        'Apple’s official framework for daily production performance, battery drain, thermal state, and crash report telemetry delivered by the OS.',
    keyMechanics: [
      'MXMetricPayload: Aggregated 24-hour reports of CPU instructions, GPU rendering, cellular/WiFi bytes, disk write amplification.',
      'MXCrashDiagnostic: Symbolicated crash reports delivered directly by the OS, capturing crashes even if the app process died before third-party crash reporters ran.',
      'MXDiskWriteExceptionDiagnostic: Detects apps writing excessive data to flash storage (>1GB per day), reducing battery and hardware life.',
    ],
    codeSnippet: '''func didReceive(_ payloads: [MXMetricPayload]) {
    for payload in payloads {
        let hangTime = payload.applicationTimeMetrics?.cumulativeHangsTime
        let cpuTime = payload.cpuMetrics?.cumulativeCPUTime
    }
}''',
    seniorTakeaway:
        'MetricKit captures OOM Jetsam kills and Watchdog terminations (0x8badf00d) that third-party SDKs fail to record because the process is killed instantly by the kernel.',
  ),

  const CuttingEdgeTopic(
    id: 8,
    title: 'Universal Links vs. Custom URL Schemes & AASA Security',
    category: 'Privacy & Security',
    description:
        'Deep linking architecture comparing cryptographically verified Universal Links with legacy custom URL schemes.',
    keyMechanics: [
      'apple-app-site-association (AASA): JSON file hosted on the HTTPS domain root with valid TLS, linking bundle IDs to web URL paths.',
      'Custom URL Schemes (myapp://): Unverified. Any malicious app installed on the device can register the exact same scheme (Scheme Hijacking).',
      'Graceful Fallback: Universal Links seamlessly open in Safari if the app is not installed, eliminating broken link dialogs.',
    ],
    codeSnippet: '''// apple-app-site-association JSON
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAMID.com.company.app",
        "paths": [ "/products/*", "/orders/*" ]
      }
    ]
  }
}''',
    seniorTakeaway:
        'Universal Links are mandatory for authentication redirects (OAuth, Magic Links, Stripe Payment returns) to prevent malicious URL scheme hijacking.',
  ),
];
