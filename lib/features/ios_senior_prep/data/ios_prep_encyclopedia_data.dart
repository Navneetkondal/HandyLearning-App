// Generated Master 26-Document Preparation Encyclopedia (106 deep cards)
import '../models/ios_prep_models.dart';

const List<PrepEncyclopediaTopic> prepEncyclopediaTopics = [
  PrepEncyclopediaTopic(
    id: 1,
    part: "Part A: Shobhakar Tiwari & Technical Foundation Series (Junior to Lead)",
    title: "1. What is Swift? Is it an OOP or POP (Protocol-Oriented Programming) language?",
    overview: "Senior Answer: Swift is a multi-paradigm language supporting Object-Oriented, Functional, Imperative, and Protocol-Oriented Programming. However, Apple explicitly designed Swift to favor Protocol-Oriented Programming (POP). While OOP relies on class inheritance hierarchies (which lead to fragile base classes, tight coupling, and unintended state sharing), POP uses protocols with default implementations via protocol extensions. This allows value types (structs, enums) to compose behavior horizontally without the memory overhead or reference risks of inheritance.",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 2,
    part: "Part A: Shobhakar Tiwari & Technical Foundation Series (Junior to Lead)",
    title: "2. What is an Optional internally? Is it an Enum or a Struct?",
    overview: "Senior Answer: An Optional in Swift is an `enum` defined in the Swift Standard Library as:",
    keyPoints: [
    ],
    codeSnippet: "public enum Optional: ExpressibleByNilLiteral {\n    case none\n    case some(Wrapped)\n    \n    public init(_ some: Wrapped) { self = .some(some) }\n    public init(nilLiteral: ()) { self = .none }\n}",
  ),
  PrepEncyclopediaTopic(
    id: 3,
    part: "Part A: Shobhakar Tiwari & Technical Foundation Series (Junior to Lead)",
    title: "3. What are all the ways to unwrap an Optional in Swift?",
    overview: "Senior Answer: There are 7 distinct ways to unwrap an Optional in Swift:",
    keyPoints: [
      "Optional Binding (`if let` / `if var`): Conditionally unwraps and scopes the variable inside the block.",
      "Guard Statement (`guard let`): Unwraps and keeps the variable in the outer scope; enforces early return.",
      "Nil-Coalescing Operator (`??`): Provides a default fallback value if nil: `let port = customPort ?? 8080`.",
      "Optional Chaining (`?.`): Safely calls methods or properties, returning nil if any link in the chain is nil.",
      "Pattern Matching (`switch` or `if case let`): `if case .some(let value) = optional { ... }`.",
      "Force Unwrapping (`!`): Directly accesses value; crashes with `fatalError` if nil. Only valid when invariant is proven.",
      "Implicitly Unwrapped Optional (`Type!`): Automatically unwrapped on access. Used for UIKit IBOutlets and 2-phase init.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 4,
    part: "Part A: Shobhakar Tiwari & Technical Foundation Series (Junior to Lead)",
    title: "4. Difference between guard let and if let? When to use which?",
    overview: "Senior Answer:",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 5,
    part: "Part A: Shobhakar Tiwari & Technical Foundation Series (Junior to Lead)",
    title: "5. What is the mutating keyword in Swift Structs?",
    overview: "Senior Answer: Structs in Swift are value types with immutable semantics. By default, methods of a value type cannot modify its stored properties. Marking a method as `mutating` tells the compiler that the method is allowed to modify the struct's properties. Under the hood, the compiler passes `self` as an implicit `inout` parameter, creating a mutated copy and reassigning it to the variable.",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 6,
    part: "Part A: Shobhakar Tiwari & Technical Foundation Series (Junior to Lead)",
    title: "6. Explain Designated vs Convenience Initializers in Swift classes.",
    overview: "Senior Answer:",
    keyPoints: [
      "Designated Initializer: The primary initializer of a class. It must initialize all stored properties introduced by that class and must call a designated initializer of its immediate superclass (vertical delegation).",
      "Convenience Initializer: A secondary, supporting initializer marked with `convenience`. It must call another initializer from the same class (lateral delegation) and ultimately resolve to a designated initializer.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 7,
    part: "Part A: Shobhakar Tiwari & Technical Foundation Series (Junior to Lead)",
    title: "7. Explain Swift's Two-Phase Initialization.",
    overview: "Senior Answer: Two-phase initialization prevents property access before initialization and prevents properties from being accidentally overwritten by another initializer:",
    keyPoints: [
      "Phase 1 (Bottom-up property initialization): Each class initializes its own stored properties from the subclass up to the root class. No instance methods or `self` can be accessed yet.",
      "Phase 2 (Top-down customization): Once the root class finishes Phase 1, the instance is valid in memory. Initializers can now access `self`, call instance methods, and read properties.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 8,
    part: "Part B: Ruchit 2025 Series (Junior, Senior, SwiftUI Edition)",
    title: "8. Class vs Struct vs Actor in Swift 6?",
    overview: "Senior Answer:",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 9,
    part: "Part B: Ruchit 2025 Series (Junior, Senior, SwiftUI Edition)",
    title: "9. What is @autoclosure and where is it used?",
    overview: "Senior Answer: An `@autoclosure` is an attribute applied to a closure parameter that automatically wraps an argument expression into a closure without requiring explicit braces `{ }` at the call site. It enables lazy evaluation—the expression is evaluated only if and when the function calls the closure. Real-world example: the short-circuiting `assert(_:_:file:line:)` and the nil-coalescing operator `??`:",
    keyPoints: [
    ],
    codeSnippet: "public func ?? (optional: T?, defaultValue: @autoclosure () throws -> T) rethrows -> T {\n    switch optional {\n    case .some(let value): return value\n    case .none: return try defaultValue() // evaluated ONLY if optional is nil!\n    }\n}",
  ),
  PrepEncyclopediaTopic(
    id: 10,
    part: "Part B: Ruchit 2025 Series (Junior, Senior, SwiftUI Edition)",
    title: "10. How does Codable handle Custom JSON decoding & Snake_Case?",
    overview: "Senior Answer: `Codable` is a typealias for `Encodable & Decodable`. By default, property names match JSON keys. For snake_case keys from APIs, set `decoder.keyDecodingStrategy = .convertFromSnakeCase`. For mismatched keys, define an explicit `CodingKeys` enum:",
    keyPoints: [
    ],
    codeSnippet: "struct UserProfile: Decodable {\n    let userID: String\n    let fullName: String\n    let createdAt: Date\n    \n    enum CodingKeys: String, CodingKey {\n        case userID = \"user_id\"\n        case fullName = \"name\"\n        case createdAt = \"created_at\"\n    }\n}",
  ),
  PrepEncyclopediaTopic(
    id: 11,
    part: "Part B: Ruchit 2025 Series (Junior, Senior, SwiftUI Edition)",
    title: "11. What are Result Builders (@resultBuilder)?",
    overview: "Senior Answer: Introduced in Swift 5.4, a `@resultBuilder` is a type that allows developers to define domain-specific languages (DSLs) by transforming a sequence of statements into a single combined value. It powers SwiftUI's `@ViewBuilder` and Swift's regex builders. The compiler converts child expressions inside a closure into calls to `buildBlock`, `buildEither(first:)`, `buildOptional`, and `buildArray`.",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 12,
    part: "Part B: Ruchit 2025 Series (Junior, Senior, SwiftUI Edition)",
    title: "12. Any vs AnyObject vs AnyHashable in Swift?",
    overview: "Senior Answer:",
    keyPoints: [
      "`Any`: Can represent an instance of any type at all, including value types (structs, enums, ints), reference types (classes), and functions/closures.",
      "`AnyObject`: Can represent an instance of any class type (reference types only). Equivalent to Obj-C `id`. Used to constrain protocols to class-only conformances.",
      "`AnyHashable`: A type-erased wrapper for any type conforming to `Hashable`. Allows heterogeneous collections where elements have different underlying types but all support hashing (e.g. dictionary keys in analytics payloads).",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 13,
    part: "Part B: Ruchit 2025 Series (Junior, Senior, SwiftUI Edition)",
    title: "13. What is the difference between some View and any View?",
    overview: "Senior Answer:",
    keyPoints: [
      "`some View` (Opaque Type): The function returns a single, specific concrete type that conforms to `View`, but hides the exact type name from the caller. Resolved at compile-time with zero runtime boxing overhead, enabling static dispatch and full compiler optimizations.",
      "`any View` (Existential Type): A runtime box that can hold any type conforming to `View` dynamically. It incurs allocation overhead (existential container) and dynamic dispatch through a witness table. `AnyView` in SwiftUI should be avoided because it breaks SwiftUI's structural identity diffing, forcing full view rebuilds.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 14,
    part: "Part C: The All-Rounder & 280 iOS Developer Interview Answers",
    title: "14. Explain the UIViewController Lifecycle in depth.",
    overview: "Senior Answer: The execution sequence and responsibilities are:",
    keyPoints: [
      "`init(coder:)` / `init(nibName:bundle:)`: Object allocation and dependency injection. View hierarchy is not yet loaded.",
      "`loadView()`: Creates or loads the controller's main view. Never call super if overriding to create programmatic view hierarchy.",
      "`viewDidLoad()`: Called once when the view hierarchy is loaded into memory. Ideal for one-time setup, subview hierarchy assembly, and initial data binding. Bounds are not yet final!",
      "`viewWillAppear(_:)`: Called right before the view becomes visible. Ideal for refreshing UI data, registering notification observers, and starting animations.",
      "`viewWillLayoutSubviews()`: Called before the view lays out its subviews.",
      "`viewDidLayoutSubviews()`: Called after Auto Layout has solved constraints. Bounds are now final and accurate. Ideal for setting layer corner radii, gradient frames, and CAShapeLayers.",
      "`viewDidAppear(_:)`: Called when the view is fully on screen. Ideal for presenting modals, starting network polling, or firing page-view analytics.",
      "`viewWillDisappear(_:)`: View is about to be dismissed or covered. Resign first responder, pause timers.",
      "`viewDidDisappear(_:)`: View is off-screen. Teardown expensive observers or stop video playback.",
      "`deinit`: View controller deallocated by ARC. Cancel network tasks, tear down notifications.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 15,
    part: "Part C: The All-Rounder & 280 iOS Developer Interview Answers",
    title: "15. Auto Layout: Content Hugging vs Compression Resistance vs Intrinsic Content Size?",
    overview: "Senior Answer:",
    keyPoints: [
      "Intrinsic Content Size: The natural size a view requires to display its content without clipping (e.g. a UILabel's size based on its text and font).",
      "Content Hugging Priority (Resists Growing): Determines how strongly a view resists being made larger than its intrinsic content size. Higher priority = hugs content tightly; lower priority = stretches to fill space.",
      "Content Compression Resistance Priority (Resists Shrinking): Determines how strongly a view resists being made smaller than its intrinsic content size. Higher priority = resists clipping/truncation; lower priority = gets clipped first.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 16,
    part: "Part C: The All-Rounder & 280 iOS Developer Interview Answers",
    title: "16. Difference between Frame and Bounds in UIKit?",
    overview: "Senior Answer:",
    keyPoints: [
      "`frame`: The view's location and size in its superview's coordinate system. Used by the superview to position and layout the view. If a view is rotated via a transform, its frame expands to become the bounding box of the rotated view!",
      "`bounds`: The view's location and size in its own coordinate system. By default, `bounds.origin = (0, 0)`. Modifying `bounds.origin` scrolls the view's content (how `UIScrollView` works under the hood).",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 17,
    part: "Part C: The All-Rounder & 280 iOS Developer Interview Answers",
    title: "17. Explain the UIResponder Chain and Hit-Testing.",
    overview: "Senior Answer: When a touch occurs, iOS finds the deepest front-most subview that contains the touch point using reverse pre-order depth-first search:",
    keyPoints: [
    ],
    codeSnippet: "// Hit-testing algorithm executed by UIWindow:\noverride func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {\n    guard isUserInteractionEnabled && !isHidden && alpha > 0.01 else { return nil }\n    guard self.point(inside: point, with: event) else { return nil }\n    for subview in subviews.reversed() { // frontmost subview first\n        let convertedPoint = subview.convert(point, from: self)\n        if let hitView = subview.hitTest(convertedPoint, with: event) {\n            return hitView\n        }\n    }\n    return self\n}",
  ),
  PrepEncyclopediaTopic(
    id: 18,
    part: "Part C: The All-Rounder & 280 iOS Developer Interview Answers",
    title: "18. How does UITableView cell reuse work under the hood?",
    overview: "Senior Answer: Allocating a new `UITableViewCell` or `UICollectionViewCell` allocates memory, inflates views, and measures text metrics on the main thread, causing frame drops during fast scrolling. To solve this, UIKit maintains an internal Reuse Pool dictionary keyed by reuse identifier. When a cell scrolls off screen, the table view removes it from the display hierarchy and places it into the pool. When `dequeueReusableCell(withIdentifier:for:)` is called for a new row entering the screen, UIKit pulls an existing cell from the pool, resets its state, and binds new data, maintaining a flat memory footprint of only ~12 cells even for a 1,000,000-row list.",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 19,
    part: "Part D: Cracking The iOS Interview & Architecture Mastery",
    title: "19. How do you resolve performance stutter in complex SwiftUI Lists?",
    overview: "Senior Answer: Common causes and architectural fixes:",
    keyPoints: [
      "Unstable View Identity: Ensure items passed to `ForEach` have truly unique and stable `Identifiable` IDs. Never use array indices as IDs if the list can be filtered or sorted.",
      "Computation inside `body`: Heavy sorting, date formatting, or filtering inside the `body` property executes on every render cycle. Move all computations to the ViewModel and expose pre-calculated values.",
      "Granular State Splitting: When a single large `@ObservedObject` publishes changes, every view observing it re-evaluates its body. In iOS 17+, migrate to the `@Observable` macro, which tracks property access at the individual field level so only views accessing the mutated field re-render.",
      "Image Decoding on Main Thread: Decode images off-screen using `CGImageSourceCreateThumbnailAtIndex` with sub-sampling before displaying.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 20,
    part: "Part D: Cracking The iOS Interview & Architecture Mastery",
    title: "20. How do you manage Background URLSession Downloads when the App is Terminated?",
    overview: "Senior Answer: Configure a background session with a unique identifier: `URLSessionConfiguration.background(withIdentifier: \"com.app.bgdownload\")`. iOS hands the download off to a background system daemon (`nsurlsessiond`) that runs independently of app lifecycle. If the app is killed by the system to reclaim memory, `nsurlsessiond` continues downloading. When complete, iOS relaunches the app in the background, calling `application(_:handleEventsForBackgroundURLSession:completionHandler:)`. The app recreates the session with the same identifier, receives delegate completion callbacks, moves the downloaded file from temp directory, and calls the stored system completion handler.",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 21,
    part: "Part E: Swift Language Deep Dive (ImpQuestionsSwift)",
    title: "21. Difference between default and @unknown default in Switch statements?",
    overview: "Senior Answer: Introduced in Swift 5 for non-frozen enums from system SDKs. A regular `default:` silently catches all unhandled cases, hiding newly introduced enum cases in newer iOS versions. Marking `@unknown default:` catches any future cases at runtime while producing a compiler warning if the switch statement does not explicitly handle all currently known cases. This guarantees future compatibility without missing new SDK cases.",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 22,
    part: "Part E: Swift Language Deep Dive (ImpQuestionsSwift)",
    title: "22. What is @frozen and how does it affect ABI stability?",
    overview: "Senior Answer: The `@frozen` attribute declares that an enum or struct will never add, remove, or reorder its cases or stored properties in future library versions. This allows the Swift compiler to optimize code by allocating memory for the enum inline and generating direct jump tables without requiring dynamic runtime metadata lookups.",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 23,
    part: "Part E: Swift Language Deep Dive (ImpQuestionsSwift)",
    title: "23. Explain the defer statement: execution order and mechanics.",
    overview: "Senior Answer: The `defer` statement registers a block of code to be executed when the current scope exits, regardless of how it exits (normal return, thrown error, or break). If multiple `defer` statements are declared within the same scope, they execute in reverse order of declaration (LIFO - Last In, First Out), acting like a stack. Essential for balancing resource acquisition (e.g. unlocking a lock, closing a file descriptor, ending a background task).",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 24,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "24. Concurrency-Safe Testing in Swift 6.1: Why @TaskLocal replaces Static Globals? (Maciej Gomółka)",
    overview: "Senior Answer: In legacy `XCTest`, tests ran serially, allowing developers to mock dependencies (like `CurrentDate.now`) by mutating a static global variable. In modern Swift Testing (Swift 6.1), test suites run concurrently in parallel across multiple threads. Mutating a shared static global creates data races and test flakiness. The modern solution is `@TaskLocal`:",
    keyPoints: [
    ],
    codeSnippet: "enum TestContext {\n    @TaskLocal static var currentDate: Date = Date()\n}\n\n// In Swift Testing:\n@Test func calculateExpiry() async {\n    let mockDate = Date(timeIntervalSince1970: 1700000000)\n    await TestContext.\$currentDate.withValue(mockDate) {\n        let service = SubscriptionService()\n        #expect(service.isExpired() == false)\n    } // mockDate is strictly scoped to this asynchronous task hierarchy!\n}",
  ),
  PrepEncyclopediaTopic(
    id: 25,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "25. Bridging Combine and Swift Concurrency in SwiftUI (Matheus Gois)",
    overview: "Senior Answer: In modern apps transitioning to Swift Concurrency:",
    keyPoints: [
      "Combine to AsyncSequence: Any Combine `Publisher` can be consumed asynchronously using its `.values` property:\n      `for await value in searchPublisher.debounce(for: .milliseconds(300), scheduler: RunLoop.main).values {\n    await performSearch(query: value)\n}`",
      "Async/Await to Combine: Wrap an async function in a `Future` or bridge via `PassthroughSubject`.",
      "Delegate to Async: Wrap legacy delegate callbacks in `withCheckedThrowingContinuation`, guaranteeing that continuation is resumed exactly once.",
    ],
    codeSnippet: "for await value in searchPublisher.debounce(for: .milliseconds(300), scheduler: RunLoop.main).values {\n    await performSearch(query: value)\n}",
  ),
  PrepEncyclopediaTopic(
    id: 26,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "26. Core Data vs SwiftData Architectural Comparison",
    overview: "Senior Answer:",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 27,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "27. Modern CI/CD Pipeline Architecture for iOS (Dominika Poleschuk)",
    overview: "Senior Answer: A production iOS CI/CD pipeline consists of:",
    keyPoints: [
      "Continuous Integration (CI): Triggered on Pull Request creation. Runs SwiftLint/SwiftFormat, executes unit and snapshot tests in parallel using `fastlane scan`, and checks for ABI breaking changes.",
      "Code Signing with Fastlane Match: Eliminates code signing chaos by storing encrypted provisioning profiles and certificates in a dedicated private Git repository encrypted with OpenSSL/git-crypt. Shared deterministically across CI runners.",
      "Continuous Delivery (CD): Triggered on merge to `release` branch. Increments build number, compiles release archive using `fastlane gym`, uploads dSYMs to Crashlytics, and deploys to TestFlight via App Store Connect API keys (JWT).",
      "Phased Rollout: Configured to automatically roll out to 1% -> 2% -> 5% -> 10% -> 20% -> 50% -> 100% over 7 days while monitoring Crashlytics error rates to allow emergency rollbacks.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 28,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "28. self vs Self in Swift?",
    overview: "Senior Answer:",
    keyPoints: [
      "`self` (lowercase): Refers to the current instance of a type inside an instance method or property, or refers to the type object itself inside a static/class method (e.g. `self.name` or `let type = self`).",
      "`Self` (uppercase): Refers to the static type of the current instance or conforming type. In protocols, `Self` represents whatever concrete type conforms to the protocol (e.g. `func clone() -> Self`). In class hierarchies, `Self` enables dynamic return typing for subclass polymorphism.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 29,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "29. static func vs class func in Swift?",
    overview: "Senior Answer:",
    keyPoints: [
      "`static func`: Defines a type-level method that is statically dispatched. It cannot be overridden by subclasses (equivalent to `final class func`). Used in structs, enums, and classes.",
      "`class func`: Can only be used inside classes. It is dynamically dispatched through the class's V-Table and can be overridden by subclasses.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 30,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "30. What are Swift Access Control levels from most to least restrictive?",
    overview: "Senior Answer: Swift provides 5 explicit access levels:",
    keyPoints: [
      "`private`: Accessible only within the immediate enclosing declaration and extensions within the same file.",
      "`fileprivate`: Accessible from any code within the same source file.",
      "`internal` (Default): Accessible from any source file within the same module/target, but hidden outside.",
      "`public`: Accessible from any module that imports it. Cannot be subclassed or overridden outside the defining module.",
      "`open`: Accessible from any module and can be subclassed and overridden outside the defining module (classes and class members only).",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 31,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "31. Why does dispatching synchronously to the main thread from the main thread deadlock?",
    overview: "Senior Answer: `DispatchQueue.main.sync { ... }` dispatched from the main thread causes an instant deadlock:",
    keyPoints: [
      "The main queue is a serial queue that executes tasks sequentially on the main thread.",
      "Calling `sync` blocks the calling thread (main thread) until the submitted block finishes executing.",
      "However, the block submitted to the serial queue cannot start executing because the main thread is blocked waiting for it.",
      "Both the caller and the block wait on each other indefinitely, freezing the process until watchdog kills it with crash code `0x8badf00d` (\"ate bad food\").",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 32,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "32. What is an autoreleasepool and when do you need it in modern Swift?",
    overview: "Senior Answer: Although Swift uses ARC instead of manual retain/release, Objective-C APIs and Core Foundation toll-free bridging still place return values into an autorelease pool to be drained at the end of the current run loop iteration. In tight loops allocating hundreds of thousands of objects (e.g. processing large images or CSV records), the autorelease pool grows rapidly and exhausts memory before the run loop iteration ends. Wrapping the loop body in `autoreleasepool { ... }` drains memory on every iteration, keeping memory usage flat.",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 33,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "33. What is SSL Pinning and how do you implement it (Certificate vs Public Key)?",
    overview: "Senior Answer: SSL/TLS pinning prevents Man-In-The-Middle (MITM) attacks by validating the server's cryptographic identity against a pinned certificate or public key bundled into the app binary, bypassing compromised root Certificate Authorities (CAs):",
    keyPoints: [
      "Certificate Pinning: The exact `.cer` file is bundled in the app. Easy to implement, but when the certificate expires (every 1–2 years), the app breaks unless updated via App Store.",
      "Public Key Pinning (Recommended): Pins only the cryptographic Subject Public Key Info (SPKI) hash (SHA-256). When the certificate renews with the same private/public key pair, the pinned hash remains valid, preventing sudden service outages. Implemented via `URLSessionDelegate.urlSession(_:didReceive:completionHandler:)` checking `SecTrustEvaluateWithError`.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 34,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "34. What is DispatchWorkItem and how can it be cancelled?",
    overview: "Senior Answer: A `DispatchWorkItem` encapsulates a block of work that can be dispatched to any GCD queue. Unlike raw closures, it provides explicit APIs for cancellation (`item.cancel()`), notification completion (`item.notify(queue:)`), and synchronization (`item.wait()`). Real-world use case: Search debouncing. When the user types in a search field, cancel the previous pending `DispatchWorkItem` and schedule a new one with a 300ms delay.",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 35,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "35. What is the difference between Array, ContiguousArray, and ArraySlice?",
    overview: "Senior Answer:",
    keyPoints: [
      "`Array`: General-purpose collection that can bridge to Objective-C `NSArray` when storing class instances or bridged types.",
      "`ContiguousArray`: Guarantees contiguous memory storage regardless of element type. For classes or protocol existentials, it avoids indirect storage and bridging overhead, delivering maximum cache locality in tight loops.",
      "`ArraySlice`: A view onto a sub-range of an existing array that shares its backing storage buffer without copying. Warning: Holding onto an `ArraySlice` keeps the entire underlying array allocated in memory, which can lead to memory bloat unless converted back to `Array(slice)`.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 36,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "36. What is the difference between == and === in Swift?",
    overview: "Senior Answer:",
    keyPoints: [
      "`==` (Equality): Value equality defined by conforming to the `Equatable` protocol. Evaluates whether two instances contain equivalent data, regardless of where they are stored in memory.",
      "`===` (Identity): Pointer/reference identity operator. Checks whether two references point to the exact same memory address on the heap. Only valid for reference types (classes).",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 37,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "37. What is App ID vs Bundle ID in Apple Developer Portal?",
    overview: "Senior Answer:",
    keyPoints: [
      "Bundle Identifier (Bundle ID): The unique reverse-DNS string defined in Xcode (e.g. `com.company.myapp`) that identifies a single app target on iOS.",
      "App ID: A two-part string registered in the Apple Developer Portal consisting of `[Team ID].[Bundle ID]` (e.g. `A1B2C3D4E5.com.company.myapp`). It associates the app with Apple Services and capabilities (Push Notifications, Sign in with Apple, In-App Purchases, Associated Domains).",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 38,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "38. How does Method Swizzling work and why is it dangerous in Swift?",
    overview: "Senior Answer: Method swizzling uses the Objective-C runtime functions `class_getInstanceMethod` and `method_exchangeImplementations` to swap the `IMP` function pointers of two selectors at runtime. Dangerous in Swift because:",
    keyPoints: [
      "Swift functions use Static Dispatch or V-Table Dispatch by default, completely bypassing `objc_msgSend`. Swizzling will have zero effect on Swift methods unless explicitly annotated with `@objc dynamic`.",
      "It introduces unpredictable global side-effects, breaks assumptions made by third-party SDKs, and causes difficult-to-trace crashes across app lifecycle updates.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 39,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "39. What is the difference between Synchronous and Asynchronous tasks?",
    overview: "Senior Answer: Synchronous execution blocks the current thread until the task completes, preventing any other work from being scheduled on that thread. Asynchronous execution dispatches the task to be executed and returns immediately, allowing the calling thread to continue executing subsequent instructions without waiting.",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 40,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "40. How to pass data between View Controllers (Forward and Backward)?",
    overview: "Senior Answer:",
    keyPoints: [
      "Forward Passing: Initializer Injection (cleanest, promotes immutability), Property Injection, or Segue `prepare(for:sender:)`.",
      "Backward Passing:\n      \n        Delegate Pattern (Recommended): 1-to-1 decoupled communication via a `weak` delegate protocol.",
      "Closure Callbacks: Clean and concise for lightweight completion events. Must capture `[weak self]` to prevent retain cycles.",
      "NotificationCenter: 1-to-many broadcast communication. Loose coupling, but difficult to debug and trace.",
      "Combine / AsyncStream: Modern reactive streaming of state changes.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 41,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "41. Combine vs. AsyncSequence: When to use which in modern iOS?",
    overview: "Senior Answer:",
    keyPoints: [
      "Combine: Best for complex multi-stream reactive event transformations (e.g. `combineLatest`, `zip`, `debounce`, `throttle`) driving UI components, especially in codebases targeting iOS 13–16.",
      "AsyncSequence (Swift Concurrency): Native Swift language feature supporting standard control flow (`for await value in sequence`, `try/catch`, `break`). In iOS 17+, Apple models all new asynchronous streams (e.g. `Transaction.updates` in StoreKit 2, `CLLocationUpdate`) as `AsyncSequence`. It eliminates Combine subscription boilerplate and retains structured concurrency task cancellation.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 42,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "42. How does Combine handle Backpressure, and why does assign(to:on:) leak memory?",
    overview: "Senior Answer:",
    keyPoints: [
      "Backpressure: Combine uses `Subscribers.Demand` where the subscriber requests an initial demand (e.g. `.max(1)`) and requests subsequent items on each `receive(_:)` call, preventing publisher overwhelm.",
      "Retain Cycle in `assign(to:on:)`: `assign(to: \\.property, on: self)` creates a strong reference to `self` inside the returned `AnyCancellable`. If that cancellable is stored in an instance property of `self` (e.g. `cancellables`), a strong retain cycle is created. Fix in iOS 14+: Use `assign(to: &\$publishedProperty)` which safely manages lifecycle via the publisher without holding a strong reference to `self`.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 43,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "43. What is Actor Reentrancy in Swift Concurrency and how do you prevent bugs?",
    overview: "Senior Answer: An actor serializes access to its mutable state, guaranteeing no two threads execute its synchronous code simultaneously. However, when an actor calls an asynchronous function with `await`, it suspends execution and releases its lock, allowing other tasks to enter the actor and mutate its state before the first task resumes.",
    keyPoints: [
    ],
    codeSnippet: "actor ImageDownloadCache {\n    var cache: [URL: UIImage] = [:]\n    \n    func image(for url: URL) async throws -> UIImage {\n        if let cached = cache[url] { return cached }\n        // Suspension point: other tasks can enter here!\n        let (data, _) = try await URLSession.shared.data(from: url)\n        let img = UIImage(data: data)!\n        cache[url] = img // State may have changed during suspension!\n        return img\n    }\n}",
  ),
  PrepEncyclopediaTopic(
    id: 44,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "44. What is @MainActor internally and how does compile-time isolation work?",
    overview: "Senior Answer: `@MainActor` is a global actor that uses the main dispatch queue (`DispatchQueue.main`) as its serial executor. Annotating a class, method, or property with `@MainActor` enforces that all access to that declaration must take place on the main thread. In Swift 6 with strict concurrency enabled, attempting to call a `@MainActor` method from a background context without `await` triggers a compile-time error rather than a runtime crash.",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 45,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "45. Core Data Concurrency: Why is NSManagedObject thread-unsafe and how do you pass objects?",
    overview: "Senior Answer: `NSManagedObject` and `NSManagedObjectContext` are not thread-safe. Accessing a managed object's properties from a thread other than the context's owner queue causes memory corruption and crashes. Rules:",
    keyPoints: [
      "Never pass an `NSManagedObject` instance across threads.",
      "Pass its thread-safe identifier: `NSManagedObjectID`.",
      "On the receiving background context, resolve the object using `context.existingObject(with: objectID)` inside `context.perform { ... }` or `context.performAndWait { ... }`.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 46,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "46. What is Core Data Faulting and how do Batch Operations bypass the context?",
    overview: "Senior Answer:",
    keyPoints: [
      "Faulting: A fault is a placeholder object representing an entity whose data has not yet been fetched from SQLite into memory. Accessing any property \"fires the fault\", executing a lightweight SQL query to populate the attributes. This keeps memory usage low when fetching thousands of objects.",
      "Batch Operations (`NSBatchInsertRequest`, `NSBatchUpdateRequest`, `NSBatchDeleteRequest`): Execute directly on the SQLite persistent store at the coordinator level, bypassing the `NSManagedObjectContext`. This allows updating or deleting millions of records in milliseconds with minimal RAM. Caveat: You must notify the context to refresh or reset in-memory objects via `NSManagedObjectContext.mergeChanges(fromRemoteContextSave:into:)`.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 47,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "47. How does background persistence work in SwiftData using @ModelActor?",
    overview: "Senior Answer: SwiftData replaces Core Data's complex queue confinement with the `@ModelActor` macro. It creates an actor bound to its own private `ModelContext` and serial executor:",
    keyPoints: [
    ],
    codeSnippet: "@ModelActor\nactor DataSyncActor {\n    func syncFeed(items: [RemoteFeedItem]) async {\n        for item in items {\n            let entity = FeedEntity(id: item.id, title: item.title)\n            modelContext.insert(entity)\n        }\n        try? modelContext.save()\n    }\n}",
  ),
  PrepEncyclopediaTopic(
    id: 48,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "48. Instruments Diagnostic Workflow: Time Profiler, Allocations & Leaks",
    overview: "Senior Answer:",
    keyPoints: [
      "Time Profiler: Select \"Separate by Thread\", check \"Invert Call Tree\" and \"Hide System Libraries\" to pinpoint the exact line of app code consuming CPU cycles. Use System Trace to detect thread pool saturation and lock contention.",
      "Allocations: Use Generation Analysis (\"Mark Generation\"). Click \"Mark Generation\", perform a user action (e.g. open detail screen), dismiss it, and mark generation again. Any residual memory allocated between generations that was not deallocated indicates abandoned memory or retain cycles.",
      "Leaks: Detects unreferenced memory blocks with reference counts > 0 that can never be reached or freed. Use the Memory Graph Debugger to trace retain cycles visually.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 49,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "49. SwiftUI State Restoration & @SceneStorage",
    overview: "Senior Answer: `@SceneStorage` allows saving and restoring lightweight UI state (e.g. selected tab index, active scroll offset, draft search query) when the system terminates an app in the background. The state is saved per-scene (crucial for multi-window iPadOS/macOS). Unlike `@AppStorage` (which writes to persistent UserDefaults), `@SceneStorage` data is discarded if the user explicitly swipes the app away from the app switcher.",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 50,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "50. Architecture Comparison: MVVM vs. VIPER vs. Clean Swift",
    overview: "Senior Answer:",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 51,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "51. How does URLProtocol enable seamless network mocking?",
    overview: "Senior Answer: `URLProtocol` is an abstract class in URL Loading System that intercepts network requests before they leave the device. By registering a custom `URLProtocol` subclass with `URLSessionConfiguration.protocolClasses`, unit tests can intercept outgoing HTTP requests, assert request headers/bodies, and return stubbed responses or simulated errors without hitting a live backend or mocking high-level networking classes.",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 52,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "52. Keychain Data Protection Classes: When to use which?",
    overview: "Senior Answer:",
    keyPoints: [
      "`kSecAttrAccessibleWhenUnlocked`: Data accessible only when the device is unlocked by the user. Ideal for sensitive user secrets and credentials.",
      "`kSecAttrAccessibleAfterFirstUnlock` (Default): Data accessible after the user unlocks the device once after reboot. Remains accessible while device is locked. Mandatory for background syncing tasks and silent push handlers that need authentication tokens while the phone is locked in the user's pocket.",
      "`kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly`: Strictly requires a device passcode and is never synced to iCloud Keychain.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 53,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "53. How do you generate asymmetric keys in the hardware Secure Enclave?",
    overview: "Senior Answer: The Secure Enclave is a hardware-isolated coprocessor. Keys generated within it never enter the main application memory or kernel:",
    keyPoints: [
    ],
    codeSnippet: "let access = SecAccessControlCreateWithFlags(\n    kCFAllocatorDefault,\n    kSecAttrAccessibleWhenUnlockedThisDeviceOnly,\n    [.privateKeyUsage, .biometryAny],\n    nil\n)!\n\nlet attributes: [String: Any] = [\n    kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,\n    kSecAttrKeySizeInBits as String: 256,\n    kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,\n    kSecPrivateKeyAttrs as String: [\n        kSecAttrIsPermanent as String: true,\n        kSecAttrApplicationTag as String: \"com.app.biokey\".data(using: .utf8)!,\n        kSecAttrAccessControl as String: access\n    ]\n]\nvar error: Unmanaged?\nlet privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error)",
  ),
  PrepEncyclopediaTopic(
    id: 54,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "54. Jailbreak Detection: Comprehensive Anti-Tampering Defenses",
    overview: "Senior Answer: A resilient jailbreak detection strategy combines multiple non-linear checks:",
    keyPoints: [
      "Filesystem Checks: Check existence of jailbreak files (`/Applications/Cydia.app`, `/Library/MobileSubstrate/MobileSubstrate.dylib`, `/bin/bash`, `/usr/sbin/sshd`).",
      "Sandbox Integrity Check: Attempt to write a file outside the application sandbox directory (e.g. `/private/jailbreak_test.txt`). If write succeeds, device is compromised.",
      "Dyld Symbol Inspection: Inspect loaded dynamic libraries via `_dyld_get_image_name` for hooking frameworks (Frida, Substrate, Substitute, Cycript).",
      "Anti-Debugging Check: Call `sysctl` with `P_TRACED` or invoke `ptrace(PT_DENY_ATTACH, 0, 0, 0)` to prevent debugger attachment.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 55,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "55. Notification Service Extension vs. Notification Content Extension",
    overview: "Senior Answer:",
    keyPoints: [
      "UNNotificationServiceExtension: Runs in the background before the notification is displayed (limited to 30 seconds). Used to mutate the payload: decrypt end-to-end encrypted message text, download high-res images/media attachments, or increment badge count.",
      "UNNotificationContentExtension: Provides a custom user interface displayed when the user long-presses or expands the banner on the lock screen (e.g. custom interactive map, quick-reply chat interface).",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 56,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "56. Universal Links vs. Custom URL Schemes",
    overview: "Senior Answer:",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 57,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "57. MetricKit in Production: What metrics does it monitor?",
    overview: "Senior Answer: MetricKit delivers aggregated 24-hour diagnostic reports directly from the OS, including:",
    keyPoints: [
      "Performance: Launch time metrics, Hang rate (percentage of time main thread was unresponsive > 250ms), CPU instruction count, and GPU rendering time.",
      "Resource Consumption: Cellular/WiFi network transfer, Disk write bandwidth (vital for SSD health), and Thermal state throttling events.",
      "Diagnostics: MXCrashDiagnostic (uncaught exceptions, watchdog kills) and MXDiskWriteExceptionDiagnostic.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 58,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "58. How do you implement debouncing with Combine or Task?",
    overview: "Senior Answer:",
    keyPoints: [
      "Combine: `searchTermPublisher.debounce(for: .milliseconds(300), scheduler: DispatchQueue.main).sink { ... }`",
      "Swift Concurrency (Task):\n      `var searchTask: Task?\nfunc onSearchTextChanged(_ text: String) {\n    searchTask?.cancel()\n    searchTask = Task {\n        try? await Task.sleep(nanoseconds: 300_000_000)\n        guard !Task.isCancelled else { return }\n        await performSearch(query: text)\n    }\n}`",
    ],
    codeSnippet: "var searchTask: Task?\nfunc onSearchTextChanged(_ text: String) {\n    searchTask?.cancel()\n    searchTask = Task {\n        try? await Task.sleep(nanoseconds: 300_000_000)\n        guard !Task.isCancelled else { return }\n        await performSearch(query: text)\n    }\n}",
  ),
  PrepEncyclopediaTopic(
    id: 59,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "59. How does weak vs unowned work in memory layout and side tables?",
    overview: "Senior Answer: Every Swift object header contains a 64-bit reference count word. When an object has a `weak` reference, Swift allocates a separate Side Table. The weak reference points to the Side Table, not the object directly. When the object deinitializes, its strong count drops to 0, freeing the object memory immediately. The Side Table remains until all weak references are zeroed. An `unowned` reference points directly to the object header without allocating a side table, but leaves the memory allocated in a \"zombie\" deinitialized state until unowned counts reach 0.",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 60,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "60. What is Copy-on-Write (COW) and how do you implement it for custom data types?",
    overview: "Senior Answer: Copy-on-Write delays expensive memory allocations until mutation. Read operations share a single underlying buffer. When a mutating function is called, it checks `isKnownUniquelyReferenced(&ref)`:",
    keyPoints: [
    ],
    codeSnippet: "final class StorageBox {\n    var data: T\n    init(_ data: T) { self.data = data }\n}\n\nstruct CustomArray {\n    private var box: StorageBox\n    \n    init() { self.box = StorageBox([]) }\n    \n    mutating func append(_ element: T) {\n        if !isKnownUniquelyReferenced(&box) {\n            box = StorageBox(box.data) // Duplicate backing storage ONLY when shared!\n        }\n        box.data.append(element)\n    }\n}",
  ),
  PrepEncyclopediaTopic(
    id: 61,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "61. Apple Privacy Manifests (PrivacyInfo.xcprivacy) & Required Reason APIs",
    overview: "Senior Answer: Starting in Spring 2024 (enforced in Xcode 15 and Xcode 16 for all App Store submissions), Apple mandates that applications and third-party SDKs include a `PrivacyInfo.xcprivacy` property list declaring:",
    keyPoints: [
      "`NSPrivacyTracking` (Boolean): Declares whether the app uses data for tracking across third-party apps or websites (matching App Tracking Transparency rules).",
      "`NSPrivacyTrackingDomains` (Array): List of internet domains contacted by tracking code; blocked by iOS if user denies tracking.",
      "`NSPrivacyCollectedDataTypes` (Array of Dictionaries): Declares categories of collected data (Name, Email, Payment Info, Device ID, Analytics) and whether it is linked to user identity.",
      "`NSPrivacyAccessedAPITypes` (Required Reason APIs): Apple identified sensitive system APIs frequently abused for device fingerprinting. Any usage must declare an Apple-approved reason code:\n      \n        `NSPrivacyAccessedAPICategoryUserDefaults` (e.g. Reason `CA92.1`: Access within app container only).",
      "`NSPrivacyAccessedAPICategoryFileTimestamp` (e.g. Reason `0A2A.1`: Access file modification timestamps within sandbox).",
      "`NSPrivacyAccessedAPICategorySystemBootTime` (e.g. Reason `35F9.1`: Measure time elapsed between events).",
      "`NSPrivacyAccessedAPICategoryDiskSpace` (e.g. Reason `E174.1`: Check available space before file download).",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 62,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "62. Swift Macros Architecture: Freestanding vs. Attached & SwiftSyntax",
    overview: "Senior Answer: Swift Macros (introduced in Swift 5.9) provide type-safe, compile-time code generation that replaces fragile runtime reflection, code generator scripts, and pre-processors. Unlike C preprocessor macros (which perform dumb string substitution), Swift Macros parse and manipulate the Abstract Syntax Tree (AST) using Apple's `SwiftSyntax` library:",
    keyPoints: [
      "Compile-Time Sandboxing: Macros execute out-of-process in a secure sandbox during compilation. They cannot access the filesystem, network, or clock, guaranteeing deterministic builds.",
      "Freestanding Macros (prefixed with `#`):\n      \n        `#freestanding(expression)`: Produces an expression value (e.g. `#Predicate { \$0.age > 18 }`, `#colorLiteral`).",
      "`#freestanding(declaration)`: Produces one or more declarations (e.g. `#warning(\"Deprecated\")`).",
      "Attached Macros (prefixed with `@`): Attached directly to a type, variable, or function:\n      \n        `@attached(member)`: Adds new declarations inside the attached type (e.g. `@Model` adding backing storage properties in SwiftData).",
      "`@attached(peer)`: Adds new declarations alongside the attached type.",
      "`@attached(accessor)`: Transforms stored properties into computed properties with getters/setters (e.g. `@Observable` injecting change tracking accessors).",
      "`@attached(extension)`: Adds protocol conformances via extensions (e.g. conforming to `PersistentModel`).",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 63,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "63. The Composable Architecture (TCA) vs. MVVM-C: Comprehensive Evaluation",
    overview: "Senior Answer: TCA is an opinionated, unidirectional architecture inspired by Elm and Redux, developed by Point-Free. Core building blocks:",
    keyPoints: [
      "State: Pure value type (struct) representing the feature's data.",
      "Action: An enum of all possible user actions, lifecycle events, and API callbacks.",
      "Reducer: A pure function mutating `inout State` in response to an `Action`, returning an `Effect` for side-effects.",
      "Store: The runtime driving execution and UI bindings.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 64,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "64. Swift 6 Ownership Model: Non-Copyable Types (~Copyable), consuming & borrowing",
    overview: "Senior Answer: In Swift 5.9+, Swift introduced the ownership model to eliminate reference-counting overhead and guarantee single ownership of resources (file handles, cryptographic keys, hardware locks):",
    keyPoints: [
      "`~Copyable` (Non-Copyable Types): Suppresses the implicit `Copyable` conformance for structs or enums. Instances cannot be implicitly copied on assignment or passed by value:\n      `struct FileDescriptor: ~Copyable {\n    private let fd: Int32\n    \n    init(path: String) { self.fd = open(path, O_RDONLY) }\n    \n    // Deterministic deinit for value types!\n    deinit { close(fd) }\n}`",
      "Parameter Ownership Modifiers:\n      \n        `borrowing` (Default for methods): Grants read-only access to the instance without copying or taking ownership.",
      "`consuming`: Transfers complete ownership of the value to the function. Once passed, the caller can no longer use the variable. Essential for state machines (e.g. consuming a `PendingOrder` to produce a `CompletedOrder`).",
      "`mutating`: Grants temporary read/write access via exclusive borrow (equivalent to `inout`).",
    ],
    codeSnippet: "struct FileDescriptor: ~Copyable {\n    private let fd: Int32\n    \n    init(path: String) { self.fd = open(path, O_RDONLY) }\n    \n    // Deterministic deinit for value types!\n    deinit { close(fd) }\n}",
  ),
  PrepEncyclopediaTopic(
    id: 65,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "65. Cooperative Thread Pool Starvation in Swift Concurrency",
    overview: "Senior Answer: Swift Concurrency uses a Cooperative Thread Pool whose worker thread count matches the number of CPU cores on the device (e.g. 6 threads on an iPhone with 2 performance + 4 efficiency cores). This design prevents thread explosion and excessive context-switching overhead.",
    keyPoints: [
      "Never call synchronous blocking primitives (`wait()`, `sleep()`, synchronous file reads) inside `async` functions.",
      "Always use non-blocking cooperative alternatives: `Task.sleep(nanoseconds:)` and `Task.yield()`.",
      "If legacy blocking code must be executed, dispatch it onto a dedicated concurrent Grand Central Dispatch queue using `withCheckedContinuation` rather than running it directly inside the cooperative thread pool.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 66,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "66. Meta Round: Offline-First Feed with Optimistic UI & Sliding Window Prefetching",
    overview: "Senior Answer:",
    keyPoints: [
      "Optimistic UI: When a user likes or comments on a post, update the local in-memory state and UI immediately before the network request finishes. Append the action to an offline Operations Queue persisted in SQLite/CoreData. If the network request fails after 3 exponential backoff retries, rollback the UI state and present an unobtrusive retry banner.",
      "Sliding Window Prefetching: Using `UICollectionViewDataSourcePrefetching` or SwiftUI `onAppear` triggers 5 items ahead of the visible viewport, prefetch images and JSON payloads asynchronously into a LRU memory cache. Cancel in-flight download tasks if the user flings/scrolls past them rapidly.",
      "Memory Eviction: Monitor `UIApplication.didReceiveMemoryWarningNotification` to purge rendered image bitmaps from memory while keeping lightweight entity models intact in SQLite.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 67,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "67. Uber Round: Real-Time Driver Tracking, Kalman Filtering & Battery Optimization",
    overview: "Senior Answer:",
    keyPoints: [
      "Jitter Smoothing with Kalman Filter: Raw GPS coordinates from `CLLocationManager` suffer from multipath interference and noise in urban canyons. Pass raw coordinates through a 2D Kalman filter (state estimation tracking position and velocity) to smooth coordinate jitter before rendering vehicle annotations on the map.",
      "Battery Conservation Hierarchy:\n      \n        Passive/Idle: Significant-change location service (cell tower triangulation, zero GPS chip power).",
      "Approaching Pick-up: Geofencing around pick-up radius (500m).",
      "Active Trip: Full GPS with `kCLLocationAccuracyBestForNavigation` and `activityType = .automotiveNavigation`. Pause updates automatically when vehicle is stationary for > 2 minutes.",
      "Geospatial Indexing: Use Uber's open-source H3 hexagonal hierarchical spatial index or Geohashes to query nearby drivers within O(1) time complexity.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 68,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "68. Stripe Round: Idempotent Payment Flow & Mobile PCI-DSS Security",
    overview: "Senior Answer:",
    keyPoints: [
      "Idempotency Keys: Mobile network connections are inherently unreliable; a request can succeed on the server while the network times out before the client receives the 200 OK. Every payment creation request must include a client-generated UUID header: `Idempotency-Key: `. If retried, the server returns the original transaction receipt without double-charging the customer.",
      "PCI-DSS Compliance: The client never sends raw Credit Card PAN or CVV numbers to the application backend. Card details are transmitted directly to Stripe's tokenization endpoint from isolated SDK form fields, returning an ephemeral `PaymentMethod` token.",
      "Cryptographic Tamper-Proofing: Sign sensitive requests using a private key securely stored in the hardware Secure Enclave with biometric user authentication (FaceID/TouchID).",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 69,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "69. Netflix Round: Video Streaming Architecture, HLS ABR & FairPlay DRM",
    overview: "Senior Answer:",
    keyPoints: [
      "HTTP Live Streaming (HLS): Video is segmented into 6-second MPEG-4 / fMP4 chunks indexed by a master `.m3u8` playlist offering multiple bitrate variants (1080p, 720p, 480p).",
      "Adaptive Bitrate (ABR): `AVPlayerItem` continuously measures network throughput and buffer fill rate. When bandwidth drops, it switches dynamically to lower-bitrate segments without stalling playback.",
      "FairPlay DRM: Protected content streams require encrypted keys. Implement `AVAssetResourceLoaderDelegate` to intercept the `skd://` key request, fetch the Application Certificate, request a Server Playback Context (SPC) from the OS, and exchange it with the Key Server for a Content Key Context (CKC) to decrypt the video stream inside the hardware decoder.",
      "Background Audio & Now Playing: Configure `AVAudioSession.sharedInstance().setCategory(.playback)` and synchronize lock screen metadata with `MPNowPlayingInfoCenter` and `MPRemoteCommandCenter`.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 70,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "70. Apple Round: Low-Level Dyld Startup, Mach-O & Method Cache Hashing",
    overview: "Senior Answer:",
    keyPoints: [
      "dyld (Dynamic Linker) Optimization: Pre-main launch time is dominated by dyld loading dynamic dylibs, rebasing pointers, binding symbols, and running static initializers (+load). Senior optimization: Merge dynamic frameworks into static libraries or SPM packages to eliminate dylib loading overhead.",
      "Obj-C Method Cache: Every `objc_class` struct contains a `cache_t` bucket hash table. When `objc_msgSend` is invoked, it hashes the selector pointer using a bitwise mask (`selector & mask`) to look up the cached `IMP` in ~2 nanoseconds. If a collision occurs, it probes linearly. Only upon a cache miss does it traverse the class inheritance hierarchy.",
      "Existential Container Size: A protocol type variable is stored in a 5-word (40-byte) Existential Container (3 words for Value Buffer, 1 word for Value Witness Table, 1 word for Protocol Witness Table). If a conforming value exceeds 3 words (24 bytes), Swift dynamically allocates heap memory for the value and stores a pointer in the buffer.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 71,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "71. The Memory Lineage: Why did Apple create ARC instead of Garbage Collection?",
    overview: "Senior Answer: Apple actually shipped a Garbage Collector for Mac OS X (OS X Leopard 10.5 in 2007), but explicitly abandoned and deprecated it in OS X Mountain Lion (2012) and never brought it to iOS for 3 critical reasons:",
    keyPoints: [
      "Unpredictable Latency & Frame Drops: Garbage collection runs non-deterministic sweep cycles. On mobile devices with 60Hz/120Hz displays (16.6ms / 8.3ms per frame), a garbage collection pause causes immediate user-facing jank and dropped frames.",
      "High RAM Overhead: Mark-and-sweep garbage collectors require 2x–3x the memory footprint of active objects to operate efficiently without frequent collection pauses. Early iPhones had only 128MB–512MB of RAM.",
      "Deterministic Teardown: ARC executes `dealloc` / `deinit` the exact instant the reference count drops to 0, immediately releasing expensive OS resources (file descriptors, hardware camera locks, OpenGL/Metal buffers).",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 72,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "72. The Concurrency Lineage: From POSIX Threads to Swift 6 Structured Concurrency",
    overview: "Senior Answer:",
    keyPoints: [
      "2008–2010 (NSThread / POSIX Threads): Manual thread creation. Extremely expensive (each thread consumed 512KB–1MB stack memory) and caused severe lock contention and thread proliferation.",
      "2010–2021 (Grand Central Dispatch - GCD): Introduced worker thread pools managed by libdispatch. Solved manual thread allocation, but introduced Thread Explosion (blocking tasks forced GCD to spawn up to 64 kernel threads, exhausting memory) and complex callback pyramids (\"Callback Hell\").",
      "2021–2026 (Swift Concurrency): Introduces a fixed-width Cooperative Thread Pool limited strictly to hardware CPU core count. Uses async/await with compiler-checked suspension frames allocated on the heap rather than spawning kernel threads. Swift 6 enforces Data-Race Safety at compile-time via actors and `Sendable`.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 73,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "73. The Layout Lineage: Frame Math vs. Auto Layout vs. Declarative SwiftUI",
    overview: "Senior Answer:",
    keyPoints: [
      "Manual Frame Math (2008–2012): Subviews positioned imperatively via `CGRect(x, y, width, height)` inside `layoutSubviews`. Fast execution, but nightmare to maintain across multiple screen sizes (iPhone 4 vs 5 vs iPad).",
      "Auto Layout & Cassowary Engine (2012–2019): Declarative mathematical constraint equations solved by the Cassowary linear programming solver. Solved responsive layout, but algorithm ran in polynomial time (\$O(N^2)\$ to \$O(N^3)\$), causing severe CPU hangs when deep view hierarchies recalculated constraints during table view scrolling.",
      "SwiftUI Declarative Layout (2019–2026): Uses a pure 3-step negotiation algorithm: (1) Parent proposes a size, (2) Child chooses its size, (3) Parent positions the child. Runs in pure linear time \$O(N)\$, eliminating the exponential constraint solving cost of Auto Layout.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 74,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "74. The Architecture Lineage: Why did the industry abandon Apple MVC?",
    overview: "Senior Answer: In Apple's Cocoa MVC, the `UIViewController` owns both the view lifecycle and the controller business logic. Because views cannot communicate without controllers, developers placed networking, persistence, table view data sources, delegates, and formatters directly inside the View Controller, leading to the infamous \"Massive View Controller\" (2,000+ line un-testable files).",
    keyPoints: [
      "MVVM (Model-View-ViewModel): Extracted state and presentation logic into a pure ViewModel, enabling unit testing without UIKit dependencies.",
      "VIPER / Clean Architecture: Broke components into View, Interactor, Presenter, Entity, and Router. Provided extreme decoupling for 50+ dev enterprise teams, but collapsed under the weight of boilerplate for normal features.",
      "Modern MVVM-C & TCA (The Composable Architecture): Balances testability, unidirectional data flow, and lightweight coordination without enterprise boilerplate.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 75,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "75. The Dependency Management Lineage: Git Submodules -> CocoaPods -> Carthage -> SPM",
    overview: "Senior Answer:",
    keyPoints: [
      "CocoaPods (2011–2018): Ruby-based centralized package manager. It modified the Xcode project by generating a master `.xcworkspace` and `Pods.xcodeproj`. Drawback: Monopolized project configuration, caused messy Git merge conflicts in `.pbxproj`, and had high build overhead.",
      "Carthage (2014–2019): Decentralized manager that compiled dependencies into pre-built binary dynamic frameworks (`.framework`). Kept Xcode project clean, but required manual framework drag-and-drop and binary stripping scripts for App Store submissions.",
      "Swift Package Manager - SPM (2018–2026): Apple's native, official solution integrated directly into Xcode and the Swift compiler toolchain. Uses a pure declarative `Package.swift`, supports binary XCFrameworks, resolves dependencies in parallel, and requires zero Ruby/external tooling. Standard for 100% of modern iOS development.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 76,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mock Round 1: Swift Concurrency & Actor Reentrancy",
    overview: "Interviewer: \"How do Swift Actors protect state, and what is actor reentrancy?\"",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 77,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mock Round 2: SwiftUI Performance & View Body Invalidation",
    overview: "Interviewer: \"We have a complex SwiftUI screen that drops frames during scroll. What is your diagnostic and optimization strategy?\"",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 78,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mock Round 3: Offline-First Synchronization & Conflict Resolution",
    overview: "Interviewer: \"Design an offline-first data layer for an order management app where drivers can edit orders while in underground parking.\"",
    keyPoints: [
    ],
  ),
  PrepEncyclopediaTopic(
    id: 79,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Story 1: Resolving a Severe P0 Production Outage (Crash Spike on Launch)",
    overview: "",
    keyPoints: [
      "Situation: Following an app release to 5M+ daily active users, crash-free sessions plummeted from 99.85% to 92.10% within 45 minutes, with users experiencing an immediate fatal crash on launch.",
      "Task: As Lead Engineer, triage the incident, mitigate user impact immediately, identify the root cause, and establish preventative guardrails.",
      "Action:\n      \n        Halted the staged App Store rollout immediately and used Firebase Remote Config to flip a kill-switch disabling the offending new feature flag.",
      "Analyzed MetricKit and Crashlytics symbolicated logs, identifying a fatal `NSInvalidArgumentException`: a new backend JSON field returned an un-sanitized null value that failed a non-optional `Decodable` date parsing strategy on the main thread.",
      "Coordinated a hotfix release using Fastlane, adding safe fallbacks to the decoding initializer, and wrote a regression test suite validating unexpected null payloads.",
      "Requested an expedited App Store review from Apple, which was approved within 3 hours.",
      "Result: Restored crash-free rate to 99.92% within 4 hours. Conducted a blameless 5-Whys post-mortem and implemented a mandatory CI contract-testing pipeline validating mobile API contracts against backend staging schemas.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 80,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Story 2: Managing Technical Debt vs. Business Feature Pressure (The 20% Rule)",
    overview: "",
    keyPoints: [
      "Situation: The product management team demanded shipping 4 major client features in Q3, but the legacy Core Data persistence layer had accumulated technical debt, causing frequent database lockups and slowing down feature velocity by 35%.",
      "Task: Convince executive stakeholders to allocate engineering bandwidth for refactoring while maintaining steady product delivery.",
      "Action:\n      \n        Quantified the business cost of the technical debt: presented data showing that 28% of sprint engineering hours were spent patching recurring Core Data threading bugs and that customer onboarding drop-offs increased by 4% due to database deadlocks.",
      "Proposed the \"20% Debt Budget\" rule: instead of a risky multi-month rewrite freeze, reserved 20% of every sprint's story points to iteratively decouple database operations behind abstract Repository interfaces.",
      "Migrated background synchronization to an actor-based architecture incrementally, feature by feature.",
      "Result: Completed the persistence modernization across two quarters without missing a single product launch milestone. Reduced crash frequency by 70% and increased developer feature velocity by 40% in subsequent sprints.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 81,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Story 3: Pushing Back on Unrealistic Deadlines with Engineering Trade-Offs",
    overview: "",
    keyPoints: [
      "Situation: Product leadership announced a hard deadline to launch an offline-first video download feature in 4 weeks for an upcoming international marketing campaign, whereas engineering estimation was 10 weeks.",
      "Task: Manage stakeholder expectations professionally without burning out the team or delivering compromised, fragile code.",
      "Action:\n      \n        Avoided an emotional \"no\". Instead, presented an Engineering Trade-Off Matrix mapping Scope vs. Quality vs. Time.",
      "Deconstructed the feature into 3 milestones: MVP (single video offline playback with manual quality selection), Phase 2 (background downloads with paused-state recovery), and Phase 3 (smart automated storage eviction).",
      "Demonstrated that shipping the MVP in 4 weeks satisfied 85% of user use cases for the marketing campaign, while Phase 2 and 3 could follow in subsequent monthly releases.",
      "Result: Leadership enthusiastically approved the phased roadmap. The team delivered the MVP 2 days ahead of the campaign deadline with zero critical bugs, maintaining team morale and establishing strong trust with product leadership.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 82,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Story 4: Mentoring an Underperforming Engineer to High Performance",
    overview: "",
    keyPoints: [
      "Situation: A mid-level engineer repeatedly submitted massive, untestable 1,500-line pull requests with subtle concurrency bugs, causing sprint delays and frustration during code reviews.",
      "Task: Coach and elevate the engineer's technical execution without demoralizing them.",
      "Action:\n      \n        Scheduled bi-weekly 1-on-1 pair-programming sessions focused on modern Swift idioms, protocol abstraction, and atomic git commit practices.",
      "Introduced a PR Size Limit Guideline ( for the entire team, teaching the engineer how to use feature branches and stack pull requests using Git.",
      "Encouraged them to write unit tests before submitting PRs (TDD light) and assigned them ownership of an isolated feature module to build confidence.",
      "Result: Within 3 months, the engineer's average PR review cycle time dropped from 4 days to 4 hours. Six months later, they successfully led the migration of our authentication module and were promoted to Senior Engineer.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 83,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Story 5: Resolving Cross-Functional Conflict with Product & Design",
    overview: "",
    keyPoints: [
      "Situation: The design team created a customized interactive bottom sheet with complex multi-axis physics animations that violated iOS Human Interface Guidelines and caused severe frame rate drops on older iPhones. Product demanded 100% visual parity with the Figma prototype.",
      "Task: Align Design, Product, and Engineering on a solution that preserves aesthetic quality while guaranteeing 60/120fps performance and native accessibility.",
      "Action:\n      \n        Built an interactive prototype demonstrating the custom physics gesture alongside native UIKit/SwiftUI presentation detents (`.presentationDetents([.medium, .large])`).",
      "Ran Time Profiler on an iPhone 11, visually showing the designer and PM how the custom gesture triggered continuous layout calculations that pegged CPU at 95% and degraded battery life.",
      "Proposed a compromise: use Apple's native presentation detents (achieving smooth 120fps fluid gestures and automatic VoiceOver support) while applying custom brand styling, typography, and spring transition curves to the content inside.",
      "Result: Design and Product agreed. Implementation time dropped from 3 weeks to 3 days, frame rate remained at solid 60/120fps across all devices, and the feature shipped with full native VoiceOver accessibility out of the box.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 84,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Universal Mobile System Design Template Checklist",
    overview: "Run through this mental checklist during every mobile system design round:",
    keyPoints: [
      "Client API Contract: Are endpoints paginated with opaque cursors rather than offsets? Are errors returned with actionable domain codes?",
      "Offline Resilience: Can the user perform their primary task in airplane mode? Are mutations queued and persisted atomically?",
      "Image / Binary Asset Pipeline: Are images resized to the target display points before decoding to prevent bitmap memory bloat?",
      "Battery & Thermal Impact: Does the design avoid continuous background location polling or high-frequency timer loops?",
      "Security & Privacy: Are tokens stored in Keychain with `kSecAttrAccessibleAfterFirstUnlock`? Are sensitive payloads encrypted in transit via SSL Pinning?",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 85,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 1: Swift Fundamentals — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: Why are function parameters in Swift `let` constants by default?\n\n    Senior Answer: To prevent accidental side effects and enable the LLVM compiler to perform aggressive register allocation and dead-code elimination. Mutating an argument requires explicit `inout` semantics, which enforces copy-in copy-out memory mechanics at the call site.",
      "Q: What is the internal memory representation of an Optional?\n\n    Senior Answer: An Optional is an enum with `.none` and `.some(Wrapped)`. For reference types and certain value types, the Swift compiler optimizes memory layout using extra inhabitants (spare invalid bit patterns like `0x0`) to store the nil state with zero additional byte overhead.",
      "Q: What is the difference between `@autoclosure` and a standard closure?\n\n    Senior Answer: An `@autoclosure` automatically wraps an expression passed as an argument into a closure without requiring braces `{ }`. It enables lazy evaluation (e.g. `assert()` and nil-coalescing `??`), evaluating the expression only if needed.",
      "Q: What is the difference between an Opaque Type (`some`) and an Existential Type (`any`)?\n\n    Senior Answer: `some Protocol` resolves to a single, specific concrete type at compile time, enabling static dispatch and zero runtime overhead. `any Protocol` boxes the value into a dynamic 5-word Existential Container at runtime, requiring dynamic dispatch via a Protocol Witness Table.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 86,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 2: Swift Internals & Memory Layout — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: What is the difference between `MemoryLayout.size`, `stride`, and `alignment`?\n\n    Senior Answer: `size` is the exact number of bytes needed to store the data. `alignment` is the memory address multiple the type must be allocated on (e.g. 8 bytes for 64-bit pointers). `stride` is the total number of bytes between successive elements in an array, including padding bytes to satisfy alignment.",
      "Q: How does Swift implement Copy-on-Write (COW) under the hood?\n\n    Senior Answer: Swift value collections wrap a private heap-allocated reference type buffer. When a mutating method is called, it executes `isKnownUniquelyReferenced(&buffer)`. If the reference count is 1, it mutates in-place. If shared (count > 1), it clones the buffer before mutating.",
      "Q: What happens internally when an object allocates a Side Table?\n\n    Senior Answer: The 64-bit object header inline bits are replaced with a pointer to a separate heap-allocated `HeapObjectSideTableEntry`. This occurs when the object receives its first `weak` reference or when inline strong/unowned reference counts overflow.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 87,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 3: Objective-C Runtime — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: What is the complete lookup sequence of `objc_msgSend`?\n\n    Senior Answer: (1) Check class method cache (`cache_t` hash table); (2) Traverse class method list and superclass hierarchy; (3) Dynamic Method Resolution (`resolveInstanceMethod:`); (4) Fast Forwarding (`forwardingTargetForSelector:`); (5) Full Forwarding (`forwardInvocation:` + `methodSignatureForSelector:`); (6) Crash with `unrecognized selector sent to instance`.",
      "Q: When would you use Associated Objects in modern Swift?\n\n    Senior Answer: When adding stored state to an existing class within an extension (where stored properties are prohibited by the compiler), such as attaching a custom analytics tracking ID or gesture closure to a `UIView`.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 88,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 4: Concurrency — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: How does Swift Concurrency prevent Thread Explosion compared to GCD?\n\n    Senior Answer: GCD worker queues dynamically spawn new kernel threads (up to 64) whenever existing threads block, exhausting memory. Swift Concurrency uses a fixed-width Cooperative Thread Pool limited to the hardware CPU core count, suspending tasks via heap-allocated continuation frames without creating new kernel threads.",
      "Q: What is the difference between `Task` and `Task.detached`?\n\n    Senior Answer: `Task { }` inherits actor context, task-local values, priority, and cancellation from the parent scope. `Task.detached { }` completely breaks structured hierarchy: it inherits zero context, runs on the global concurrent executor, and must be manually cancelled.",
      "Q: What is a Continuation and how do you ensure safety?\n\n    Senior Answer: A continuation (`withCheckedContinuation`) bridges callback-based asynchronous code to async/await. Safety rule: The continuation MUST be resumed exactly once on every code path. Resuming zero times leaks the task; resuming twice crashes the process.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 89,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 5: UIKit — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: Why does Auto Layout constraint solving cause performance regressions in TableViews?\n\n    Senior Answer: Auto Layout uses the Cassowary linear programming solver which operates in polynomial time (\$O(N^2)\$ to \$O(N^3)\$). Recalculating complex constraint trees for deeply nested cells during rapid scrolling pegs the main thread CPU, exceeding the 16.6ms frame budget.",
      "Q: How does UICollectionViewDiffableDataSource compute updates?\n\n    Senior Answer: It computes differences between snapshot models on a background thread using Myers' diff algorithm, then dispatches batch updates and animations automatically to UIKit without calling `reloadData()` or triggering index-path collision crashes.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 90,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 6: SwiftUI — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: How does the iOS 17 `@Observable` macro outperform `@ObservedObject`?\n\n    Senior Answer: `@ObservedObject` relies on Combine's `objectWillChange`, which publishes whenever any property changes, re-evaluating all observing view bodies. `@Observable` injects field-level observation accessors—a view only re-renders when the specific property it reads inside its `body` changes.",
      "Q: When would you use PreferenceKey in SwiftUI?\n\n    Senior Answer: To pass data upwards from a child view to an ancestor view (e.g. reading a child view's size via `GeometryReader` and passing it up to coordinate a parent view's container layout).",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 91,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 7: Networking — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: How do you handle token expiration and refresh cleanly without race conditions?\n\n    Senior Answer: Use an Actor or a custom `URLSession` request interceptor. When an HTTP 401 is received, suspend pending requests, execute the token refresh asynchronously inside the isolated actor, update the stored token, and retry the queued requests with the new bearer header.",
      "Q: What is the advantage of HTTP/3 over HTTP/2 on mobile devices?\n\n    Senior Answer: HTTP/3 runs over QUIC (UDP) rather than TCP. It eliminates Head-of-Line (HoL) blocking across multiplexed streams (a dropped packet on one stream doesn't stall other streams) and supports Connection Migration (surviving seamless transitions between WiFi and Cellular without renegotiating handshakes).",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 92,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 8: Database & Persistence — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: What are the trade-offs of SQLite vs. Core Data vs. Realm?\n\n    Senior Answer: SQLite: Raw speed and cross-platform flexibility, but high manual mapping boilerplate. Core Data: Apple native, object-graph management, faulting, and undo support, but steep learning curve and thread-confinement rules. Realm: Fast zero-copy object mapping and simple multi-threading, but adds binary size and requires third-party dependency maintenance.",
      "Q: How do you perform a staged schema migration in SwiftData?\n\n    Senior Answer: Define explicit `VersionedSchema` models (e.g. `SchemaV1`, `SchemaV2`) and create a `SchemaMigrationPlan` with `MigrationStage.custom` or `MigrationStage.lightweight` mapping transformations between schema versions.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 93,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 9: Architecture & Modularization — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: How do you structure a multi-package SPM enterprise application?\n\n    Senior Answer: Decompose features into Interface and Implementation targets. Features depend only on abstract domain interfaces and repositories, never on other concrete feature implementations. A top-level Application Coordinator or Dependency Injection container wires concrete implementations at startup, minimizing incremental compile times.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 94,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 10: Design Patterns — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: When is the Singleton pattern acceptable, and when is it an anti-pattern?\n\n    Senior Answer: Acceptable when wrapping a truly unique physical hardware resource (e.g. `UIApplication.shared`, `CLLocationManager`). It becomes an anti-pattern when used for domain business logic or user state (e.g. `UserManager.shared`), because it introduces hidden shared mutable state, creates tight coupling, and prevents parallel unit testing.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 95,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 11: Performance Optimization — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: What is Dirty Memory vs. Clean Memory, and why does iOS kill apps?\n\n    Senior Answer: Clean Memory: Read-only memory that can be evicted and paged back in from disk (binary code, framework frameworks, mapped image files). Dirty Memory: Memory modified by the app (heap allocations, decoded image buffers, Core Data objects). iOS has no swap file; when combined dirty + compressed memory exceeds the system Jetsam limit, the OS forcibly terminates the app with an out-of-memory crash.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 96,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 12: App Size Optimization — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: How do you diagnose and reduce app download size?\n\n    Senior Answer: (1) Build an App Store release archive and export an App Thinning Size Report; (2) Convert PNG assets to Asset Catalogs (which compile into optimized `Assets.car` files); (3) Strip unnecessary symbols and enable Dead Code Stripping in Xcode build settings; (4) Move non-critical large assets to On-Demand Resources (ODR).",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 97,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 13: Security & Cryptography — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: What is the difference between AES-CBC and AES-GCM?\n\n    Senior Answer: AES-CBC provides confidentiality but is vulnerable to padding oracle attacks unless paired with a separate HMAC. AES-GCM is an Authenticated Encryption with Associated Data (AEAD) cipher that provides both confidentiality and integrity verification simultaneously, rejecting tampered ciphertexts automatically.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 98,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 14: Push Notifications & APNs — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: What are the payload size limits for APNs?\n\n    Senior Answer: Standard user-facing remote notifications have a maximum payload limit of 4 KB (4,096 bytes). VoIP push notifications using PushKit have a maximum limit of 5 KB (5,120 bytes). Payloads exceeding these limits are rejected by the APNs gateway.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 99,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 15: Background Execution — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: How does BGTaskScheduler manage execution budgets?\n\n    Senior Answer: The OS schedules `BGAppRefreshTask` and `BGProcessingTask` based on machine learning models evaluating user app usage patterns, device battery state, thermal pressure, and network connectivity. Apps that exceed execution budgets or fail to call `task.setTaskCompleted(success:)` promptly are penalized with fewer future background slots.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 100,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 16: Testing & Quality Engineering — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: What are the primary advantages of the new Swift Testing framework over XCTest?\n\n    Senior Answer: Uses native Swift macros (`@Test`, `#expect`, `#require`) providing detailed assertion failure breakdowns; supports parameterized testing across arguments; organizes suites using structs and tags; and executes asynchronous tests concurrently in parallel by default.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 101,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 17: CI/CD & Release Engineering — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: How does Fastlane Match eliminate code signing conflicts across teams?\n\n    Senior Answer: It centralizes code signing by storing Apple Developer certificates and provisioning profiles in a dedicated private Git repository encrypted with OpenSSL. All team members and CI runners share the identical provisioning profile deterministically, preventing revocation conflicts.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 102,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 18: Accessibility (a11y) — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: How do you support Dynamic Type without breaking custom UI layouts?\n\n    Senior Answer: Use `UIFontMetrics.default.scaledFont(for: customFont)` in UIKit or `@ScaledMetric` in SwiftUI. Allow multiline text rendering (`numberOfLines = 0`), avoid fixed height constraints on text containers, and switch layout axes dynamically (e.g. from HStack to VStack) when size category exceeds Accessibility Large.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 103,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 19: Analytics & Monitoring — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: How do you prevent PII leakage in application logs?\n\n    Senior Answer: Use Apple's Unified Logging System (`OSLog` / `Logger`). By default, interpolated strings are treated as `private` and masked as `` in production console logs. Only explicitly public data should be marked `privacy: .public`.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 104,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 20: DSA for iOS Interviews — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: Why is String indexing in Swift not integer-based (e.g. `str[0]`)?\n\n    Senior Answer: Swift strings are Unicode-compliant sequences of Extended Grapheme Clusters (which can consist of multiple Unicode scalar values, such as emoji skin tones and accent combinations). Determining the Nth character requires traversing the UTF-8 bytes sequentially, making random access \$O(N)\$ rather than \$O(1)\$.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 105,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 21: System Design — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: How do you design an efficient image caching pipeline for an infinite feed?\n\n    Senior Answer: Implement a two-tier cache: an in-memory NSCache for decoded bitmaps (bounded by cost/pixel count) and an on-disk URLCache / FileManager cache for raw compressed files. Use `CGImageSourceCreateThumbnailAtIndex` to downsample images to target point sizes off the main thread before rendering.",
    ],
  ),
  PrepEncyclopediaTopic(
    id: 106,
    part: "Part F: Specialized Slide Masterclasses & Cutting-Edge Engineering",
    title: "Mod 22: Leadership & Engineering Operations — Key Interview Questions",
    overview: "",
    keyPoints: [
      "Q: What makes a high-standard Code Review, and how do you enforce team velocity?\n\n    Senior Answer: Focus code reviews on architecture, correctness, race conditions, and test coverage; delegate style and formatting entirely to automated CI linters (SwiftFormat, SwiftLint). Enforce pull request size limits (< 350 lines) so reviews take under 15 minutes, preventing blocked sprint tickets.",
    ],
  ),

  // Part G: Advanced Concurrency, Persistence & Production
  PrepEncyclopediaTopic(
    id: 107,
    part: "Part G: Advanced Concurrency, Persistence & Production",
    title: "Part G: Swift 6 Strict Concurrency & Persistent Architecture",
    overview: "Master production-grade Swift 6 migration strategies, Core Data WAL optimization, and SwiftData schema versions.",
    keyPoints: [
      "Point: Swift 6 transforms concurrency data-race checking from runtime debugging into compile-time mathematical guarantees.",
      "Reason: Mutable shared state across thread boundaries without actor isolation causes race conditions and memory corruption. Swift 6 enforces Sendable invariants statically.",
      "Example: Annotating reference types crossing isolation domains with `@unchecked Sendable` only when protected by internal `os_unfair_lock` or serial dispatch queues.",
      "Conclusion: Migrate incrementally using Swift 5.10 with `-strict-concurrency=complete` before enabling `-swift-version 6`.",
      "Junior vs Senior vs Principal:\n• Junior: Adds `@MainActor` indiscriminately to silence compiler errors.\n• Senior: Structures data structures into value types (`Sendable` structs) and serial actors with synchronous eviction logic.\n• Principal: Architects modular package boundaries with strict interface isolation, isolating legacy non-Sendable third-party SDKs behind actor facades.",
      "Core Data & SQLite WAL: Enable Write-Ahead Logging (`PRAGMA journal_mode=WAL`) to allow concurrent reads during background writing without locking the SQLite database.",
    ],
  ),

  // Part H: 2025–2026 Cutting-Edge Technical Masterclass
  PrepEncyclopediaTopic(
    id: 108,
    part: "Part H: 2025–2026 Cutting-Edge Technical Masterclass",
    title: "Part H: Swift 6.2, Embedded Swift & Observation Internals",
    overview: "Comprehensive deep-dive into Apple's latest runtime evolutions: Observation framework, Embedded Swift, and C++20 interop.",
    keyPoints: [
      "Point: The Observation framework (`@Observable`) completely replaces Combine and `ObservableObject` with granular property-level dependency tracking.",
      "Reason: `ObservableObject` invalidates SwiftUI views upon ANY `@Published` property mutation. `@Observable` uses `withObservationTracking` to subscribe views ONLY to the specific properties read in `body`.",
      "Example: In a class with 20 properties, modifying `price` only redraws the PriceLabel, leaving the other 19 subviews untouched at zero layout cost.",
      "Conclusion: Upgrading to `@Observable` eliminates unneeded view re-evaluations, drastically reducing CPU cycles in high-frequency feeds.",
      "Embedded Swift: Strips the Swift runtime and reflection metadata to produce standalone, lightweight binaries for microcontrollers and performance-critical systems.",
      "Bidirectional C++20 Interop: Swift directly consumes templated C++ types, `std::vector`, and classes without requiring bridging Objective-C++ headers.",
    ],
  ),

  // Part I: Tier-1 FAANG & Production Scenarios
  PrepEncyclopediaTopic(
    id: 109,
    part: "Part I: Tier-1 FAANG & Production Scenarios",
    title: "Part I: P0 Crash Resolution, Binary Size & Launch Optimization",
    overview: "Tier-1 enterprise survival guide: mitigating P0 release blockers, dyld4 launch optimizations, and dirty memory management.",
    keyPoints: [
      "Point: App launch time is dominated by dyld dylib rebasing, ObjC class registration, and static initializers (`+load` methods).",
      "Reason: Pre-main execution executes synchronously on the CPU before `application(_:didFinishLaunchingWithOptions:)` can run.",
      "Example: Merging multiple dynamic frameworks into static libraries eliminates dyld fixup rebases, reducing launch latency from 1.8s to 420ms.",
      "Conclusion: Always defer non-critical SDK initialization (analytics, crash reporting) using background tasks or lazy instantiation after the initial frame renders.",
      "P0 Crisis Playbook: When a crash spike occurs on App Store release, utilize server-driven Feature Flag Kill-Switches to disable the failing module immediately without waiting 48 hours for App Store review.",
      "Dirty Memory vs Clean Memory: iOS terminates apps based on 'Dirty' memory footprint (allocated heap objects, modified data). Compressed clean pages (framework binaries, read-only images) are simply purged under memory pressure.",
    ],
  ),

  // Part J: 15-Year Historical Evolution of iOS Interviews (2010–2026)
  PrepEncyclopediaTopic(
    id: 110,
    part: "Part J: 15-Year Historical Evolution of iOS Interviews (2010–2026)",
    title: "Part J: The 15-Year Evolution of iOS Architecture (2010–2026)",
    overview: "Understand the historical architectural progression that top-tier interviewers test: MRC to Swift 6, UIKit to Declarative SwiftUI.",
    keyPoints: [
      "2010–2014 Era: Objective-C MRC (`retain`, `release`, `autoreleasepool`) transitioned to ARC. Memory leaks were tracked with Instruments Leaks and `dealloc` logging.",
      "2014–2019 Era: Swift 1 through 4 introduction. Strong type safety, Optionals, Generics, Protocol-Oriented Programming (POP). Massive View Controller problem tackled via MVVM and VIPER.",
      "2019–2023 Era: Declarative paradigm shift. SwiftUI introduced alongside Combine. Declarative UI = f(State). Structured Concurrency (`async/await`, TaskGroup, Actors).",
      "2024–2026 Era: Swift 6 compile-time data race safety, `@Observable` observation tracking, PrivacyInfo.xcprivacy enforcement, AI Foundation Models on-device.",
      "Interviewer Trap: Confusing legacy GCD paradigms (`DispatchQueue.global().async`) with Swift 6 structured concurrency cooperative thread pools (fixed thread pool matching CPU core count).",
    ],
  ),

  // Part K: Live Interview Simulation
  PrepEncyclopediaTopic(
    id: 111,
    part: "Part K: Live Interview Simulation",
    title: "Part K: Technical Screen & Live Coding Simulation Rubric",
    overview: "Detailed evaluation criteria top tech hiring committees use to grade candidate signals across Junior, Senior, and Staff bands.",
    keyPoints: [
      "The 4 Core Evaluation Pillars: 1) Problem Decomposition & Communication, 2) Idiomatic Swift & Architecture, 3) Edge Cases & Concurrency Safety, 4) Trade-offs & Production Defense.",
      "Step 1 (First 5 Mins): Never write code immediately. Ask clarifying questions regarding scale, pagination, offline behavior, error states, and memory constraints.",
      "Step 2 (Mins 5-15): Outline high-level architecture and protocols. Explain the mental model before writing the concrete implementation.",
      "Step 3 (Mins 15-35): Implement clean, compilable Swift code. Avoid force-unwrapping (`!`). Address race conditions and retain cycles in closures proactively.",
      "Step 4 (Mins 35-45): Proactively test edge cases: empty data, network failure, 10,000 rapid inputs, and discuss Big-O Time & Space complexity.",
    ],
  ),

  // Part L: Morning-of-the-Interview Rapid-Fire Cheat Sheet
  PrepEncyclopediaTopic(
    id: 112,
    part: "Part L: Morning-of-the-Interview Rapid-Fire Cheat Sheet (50 Flashcard Definitions)",
    title: "Part L: 50 Flashcard Rapid-Fire Definitions for Final Prep",
    overview: "Ultra-concentrated, high-yield definitions to review 30 minutes before your senior interview.",
    keyPoints: [
      "1. ARC Side Table: External reference count allocation created when an object exceeds 19 inline ref counts or receives its first `weak` pointer.",
      "2. Copy-on-Write (COW): Value semantics optimization where buffer data is shared among copies until a mutation occurs, at which point a clone is allocated.",
      "3. Method Swizzling: Exchanging the `IMP` (implementation pointer) of two Objective-C selectors at runtime using `class_replaceMethod`.",
      "4. RunLoop: Event processing loop coordinating incoming touches, timers, display links, and GCD main queue tasks.",
      "5. Actor Reentrancy: An actor method suspended at an `await` point yields execution, allowing another task to execute on the same actor and potentially mutate state before the first resumes.",
      "6. Frame vs Bounds: `frame` is view geometry relative to parent superview coordinate system; `bounds` is view geometry relative to its own internal coordinate system.",
      "7. Hit-Testing: Depth-first reverse pre-order traversal of the view hierarchy (`hitTest:withEvent:`) finding the deepest subview under a touch coordinate.",
      "8. dSYM: Debug Symbol file mapping compiled binary machine addresses back to original source code file names and line numbers for crash symbolication.",
    ],
  ),

  // Part M: Senior / Staff Behavioral STAR Stories Bank
  PrepEncyclopediaTopic(
    id: 113,
    part: "Part M: Senior / Staff Behavioral STAR Stories Bank (10 Battle-Tested Production Stories)",
    title: "Part M: 10 Battle-Tested Behavioral STAR Production Stories",
    overview: "Structured Situation, Task, Action, Result narratives demonstrating Staff-level leadership, crisis management, and technical depth.",
    keyPoints: [
      "Story 1 (P0 Crash Resolution): S: Memory spike crashed app for 18% of users on Black Friday. T: Isolate root cause under 2 hours without App Store update. A: Identified image caching memory leak; deployed cloud configuration kill-switch reducing image resolution from 4K to 1080p, resolving OOM crashes immediately. R: Zero revenue loss; added automated leak regression tests in CI.",
      "Story 2 (Technical Debt Payoff): S: 1.2M lines legacy Objective-C app blocking feature delivery. T: Architect 6-month migration to modular Swift architecture. A: Partitioned app into 14 SPM packages; established strict protocol boundaries and CI merge guards. R: Build times dropped from 18m to 3.5m; bug rate decreased by 42%.",
      "Story 3 (Cross-Functional Conflict): S: Product wanted instant push alerts; Security required end-to-end payload encryption. T: Bridge compliance and UX. A: Implemented iOS Notification Service Extension with background ephemeral key decryption. R: Both requirements met with zero latency penalty for end users.",
    ],
  ),

  // Part N: 45-Minute Mobile System Design Execution Blueprint
  PrepEncyclopediaTopic(
    id: 114,
    part: "Part N: 45-Minute Mobile System Design Execution Blueprint & Whiteboarding Template",
    title: "Part N: The 45-Minute Mobile System Design Blueprint",
    overview: "The exact timeboxed execution structure required to pass Meta, Apple, Google, and Amazon Mobile System Design rounds.",
    keyPoints: [
      "Minutes 00–05: Requirements & Scope. Clarify functional requirements (core flows), non-functional requirements (offline capability, 60fps scrolling, 50MB binary limit, low-bandwidth resilience).",
      "Minutes 05–15: High-Level Architecture. Diagram the 3 core layers: UI/Presentation (SwiftUI/UIKit), Business Logic / Use Cases, Data Layer (Repository, Local DB, Remote API client).",
      "Minutes 15–30: Deep-Dive Data Flow & Storage. Detail database schema (Core Data SQLite vs Key-Value), syncing protocol (optimistic UI updates, idempotency keys), cache eviction strategy (LRU bounded by bytes).",
      "Minutes 30–40: Network Optimization & Edge Cases. Exponential backoff retry policies, deduplicated network requests, push notification payload hydration, and battery/thermal mitigation.",
      "Minutes 40–45: Trade-offs & Wrap-Up. Proactively analyze what could break at 100M Daily Active Users (DAU) and how telemetry/crash reporting identifies regressions in production.",
    ],
  ),

  // Part O: Master Topic-by-Topic Question Catalog
  PrepEncyclopediaTopic(
    id: 115,
    part: "Part O: Master Topic-by-Topic Question Catalog (Modules 1–22)",
    title: "Part O: Complete 22-Module Master Question Index",
    overview: "The exhaustive universal index connecting all 22 interview modules with question mappings.",
    keyPoints: [
      "Modules 01–04: Swift Core & Memory Management (Value vs Ref, ARC Side Tables, COW, Generics, Existential Types).",
      "Modules 05–08: Swift Concurrency & Asynchronous Programming (Tasks, Actors, MainActor, Sendable, Continuation, GCD).",
      "Modules 09–12: Modern UI Architecture (SwiftUI vs UIKit, View Lifecycle, Diffing Engine, Layout Protocols, Gesture Chains).",
      "Modules 13–16: Networking, Security & Offline Persistence (URLSession, Certificate Pinning, Keychain, Core Data WAL, SQLite).",
      "Modules 17–19: Performance Engineering & Tooling (Instruments Time Profiler, Allocations, dyld4 Launch, App Slicing, ODR).",
      "Modules 20–22: System Design, Data Structures & Staff Leadership (Infinite Feed, Offline Sync, Cross-Platform Strategy, CI/CD).",
    ],
  ),
];
