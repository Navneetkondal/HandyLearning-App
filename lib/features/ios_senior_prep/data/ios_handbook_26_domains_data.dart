/// Supplementary iOS Master Interview Handbook Data (All 26 Domains)
/// Cleanly extracted from iOS_Master_Interview_Handbook_26_Domains.html
library;

class HandbookTopic {
  final String title;
  final String content;
  final String? codeSnippet;
  final List<String> keyPoints;

  const HandbookTopic({
    required this.title,
    required this.content,
    this.codeSnippet,
    this.keyPoints = const [],
  });
}

class HandbookDomain {
  final int domainNumber;
  final String title;
  final List<HandbookTopic> topics;

  const HandbookDomain({
    required this.domainNumber,
    required this.title,
    required this.topics,
  });
}

const List<HandbookDomain> handbook26Domains = [
  HandbookDomain(
    domainNumber: 1,
    title: "Swift Fundamentals & Language Core",
    topics: [
      HandbookTopic(
        title: "Contrast with Generics",
        content: "Here T is one concrete type. The compiler knows exactly what T is at compile time. With an existential: The compiler only knows: \"Some type conforming to Payment.\" The actual type is determined at runtime.",
        codeSnippet: "func process<T: Payment>(_ payment: T) {     payment.pay() }",
      ),
      HandbookTopic(
        title: "Opaque Type (some Payment)",
        content: "The caller only knows it returns some Payment, but the compiler knows it's always CreditCard. This cannot return different concrete types: because some must represent a single concrete type.",
        codeSnippet: "func makePayment() -> some Payment {     CreditCard() }",
      ),
      HandbookTopic(
        title: "Summary",
        content: "For your example: Here are concise interview-style definitions of the core Object-Oriented Programming (OOP) concepts. These definitions are concise, technically accurate, and well suited for iOS/Swift interviews. In Swift interviews, object and instance are closely related, but there is a subtle distinction. An instance is a concrete occurrence of",
        codeSnippet: "T: Payment",
        keyPoints: ["In current Swift, both represent an array of existential Payment values.", "The modern, explicit, and recommended spelling is [any Payment], because it makes it clear you're using an existential type rather than a generic or opaque type.", "Instance → Created from any type (class, struct, enum)."],
      ),
      HandbookTopic(
        title: "Copy on Write (CoW)",
        content: "Copy on Write is an optimization used by Swift value types (such as Array, Dictionary, Set, and String) where multiple variables share the same storage until one of them is modified. A copy is created only when a write occurs. Example: Before modification: After append(4):",
        codeSnippet: "Array",
        keyPoints: ["Improves performance.", "Reduces unnecessary memory allocation.", "Preserves value semantics."],
      ),
      HandbookTopic(
        title: "Shallow Copy",
        content: "A shallow copy copies the top-level object, but nested reference-type objects are shared between the original and the copy. Example: Memory: Both share the same Address.",
        codeSnippet: "class Address {     var city = \"Delhi\" }  class Person {     var address = Address() }  let p1 = Person() let p2 = p1   // Shallow copy (same reference)  p2.address.city = \"Noida\"  print(p1.address.city)   // Noida",
      ),
      HandbookTopic(
        title: "Deep Copy",
        content: "A deep copy creates a completely independent copy, including all nested reference-type objects. Example: Memory: Both are completely independent.",
        codeSnippet: "class Address {     var city: String      init(city: String) {         self.city = city     }      func copy() -> Address {         Address(city: city)     } }  class Person {     var address: Address      init(address: Address) {         self.address = address     }      func copy() -> Person {         Person(address: address.copy())     } }  let p1 = Person(address: Address(city: \"Delhi\")) let p2 = p1.copy()  p2.address.city = \"Noida\"  print(p1.address.city) // Delhi",
      ),
      HandbookTopic(
        title: "Interview Definitions",
        content: "A common follow-up question is: Does struct perform shallow copy or deep copy? The best answer is: Structs are value types, so assignment creates a value copy. If a struct contains only value types, the copy is effectively deep. If it contains reference types, the struct is copied but the referenced objects are shared unless you explicitly deep-cop",
        codeSnippet: "Copy on Write (CoW) → An optimization where Swift value types share storage until one copy is modified, at which point a new copy is created.  Shallow Copy → Copies the top-level object while sharing nested reference-type objects.  Deep Copy → Creates a completely independent copy of an object and all of its nested reference-type objects.",
      ),
      HandbookTopic(
        title: "Swift Type System",
        content: "Swift's type system is statically typed and strongly typed with type inference. It cleanly separates value types (structs, enums, tuples) from reference types (classes, actors). Value types are copied on assignment (COW for collections), eliminating thread safety hazards. Reference types share a single heap identity via 64-bit stack pointers. Generics (<T>) provide compile-time specialization and static dispatch, opaque types ('some Protocol') hide concrete types while maintaining static type identity, and existential types ('any Protocol') box instances in dynamic 40-byte containers at runtime.",
        codeSnippet: "// Swift 6 Static Type System Specialization\nfunc processItem<T: Identifiable & Sendable>(_ item: T) -> some View {\n    Text(\"ID: \\(item.id)\")\n}",
        keyPoints: [
          "Value types (structs, enums) vs Reference types (classes, actors).",
          "Generics (<T>) compile down to specialized direct machine instructions.",
          "Opaque types (some) provide reverse generics with single static identity.",
          "Existential types (any) box arbitrary types at the cost of heap allocation and witness table lookup."
        ],

      ),
      HandbookTopic(
        title: "OOP Concepts",
        content: "Core Object-Oriented Programming (OOP) paradigms in Swift:\n• Encapsulation: Restricting direct access to state via private/internal access modifiers, exposing safe mutating methods.\n• Inheritance: Single inheritance supported only by classes, establishing 'is-a' relationships and V-Table method dispatch.\n• Polymorphism: Subtype polymorphism via class overriding, and ad-hoc/parametric polymorphism via protocols and generics.\n• Abstraction: Modeling interfaces via protocols without coupling clients to concrete classes.",
        codeSnippet: "public class Vehicle {\n    public func startEngine() { print(\"Vroom\") }\n}\npublic final class ElectricCar: Vehicle {\n    public override func startEngine() { print(\"Silent Start\") }\n}",
        keyPoints: [
          "Encapsulation protects invariants and enforces memory safety.",
          "Inheritance is restricted to classes; prefer composition via protocols.",
          "Polymorphism is achieved through Protocol Witness Tables and V-Tables.",
          "Abstraction decouples high-level policy from low-level implementation."
        ],
        ),
      HandbookTopic(
        title: "Memory Management",
        content: "Memory in iOS is divided into Stack and Heap:\n• Stack: Extremely fast LIFO allocation (adjusting stack pointer SP on ARM64). Stores local value types and pointer addresses.\n• Heap: Dynamic memory allocated via swift_allocObject (malloc). Stores class instances, actor states, and escaping closures.\n• ARC (Automatic Reference Counting) tracks heap allocations at compile time, inserting retain and release instructions.\n• Weak references point to out-of-line Side Tables to allow lazy zeroing when the target is deallocated, preventing dangling pointers.",
        codeSnippet: "final class DataStore {\n    weak var delegate: StoreDelegate?\n    deinit { print(\"Deallocated cleanly without retain cycle\") }\n}",
        keyPoints: [
          "Stack allocation requires zero locking; heap allocation acquires mutex locks on memory arenas.",
          "ARC operates at compile time without non-deterministic garbage collection pauses.",
          "Weak references must always be optional (var) and automatically zero upon dealloc.",
          "Unowned references assume the object is never nil; accessing a deallocated unowned object traps at runtime."
        ],
                ),
      HandbookTopic(
        title: "Copying Concepts",
        content: "Copying semantics determine how data is duplicated in memory:\n• Value Copy: Value types (structs, enums) are copied entirely on assignment. If they contain only value types, it is effectively a deep copy.\n• Reference Copy: Assigning a class instance copies only the 64-bit stack pointer; both variables point to the same heap object.\n• Shallow Copy: Copies top-level object structure while sharing nested reference pointers.\n• Deep Copy: Recursively clones all nested objects so the new graph is completely independent in memory.\n• Copy-on-Write (CoW): Collections (Array, Dictionary, String) share the same underlying heap buffer until a mutating operation occurs, at which point a clone is allocated.",
        codeSnippet: "// Manual Copy-on-Write using isKnownUniquelyReferenced\nstruct CustomBuffer<T> {\n    private var storage = StorageClass<T>()\n    mutating func append(_ item: T) {\n        if !isKnownUniquelyReferenced(&storage) {\n            storage = storage.clone()\n        }\n        storage.items.append(item)\n    }\n}",
        keyPoints: [
          "Value copies ensure independence and thread safety.",
          "Shallow copies share nested reference state, creating shared mutation bugs.",
          "CoW delays allocation until write, minimizing memory churn in loops.",
          "Use isKnownUniquelyReferenced(&ref) to implement custom COW buffers."
        ],
        ),
      HandbookTopic(
        title: "Protocol Concepts",
        content: "Protocols define a contract of methods, properties, and requirements without implementation. Protocol-Oriented Programming (POP) favors protocol composition over deep class inheritance hierarchies.\n• Protocol Extensions provide default implementations and mix-in functionality.\n• Associated Types declare generic placeholders in protocol definitions.\n• Primary Associated Types (e.g. Protocol<Entity>) enable lightweight type constraints without existential boxes.\n• Protocols with AnyObject constraint (class-bound) are required for weak delegate references.",
        codeSnippet: "public protocol PaymentProcessor: AnyObject, Sendable {\n    associatedtype Token: Sendable\n    func authorize(token: Token) async throws -> Bool\n}",
        keyPoints: [
          "Favor composition over inheritance: 'class Car: Vehicle' vs 'struct Car: Drivable, Electric'.",
          "Class-bound protocols (AnyObject) participate in ARC side-table tracking for weak references.",
          "Methods in protocol definitions use witness table dispatch; extension-only methods use static direct dispatch.",
          "Primary associated types allow writing 'some PaymentProcessor<StripeToken>' cleanly."
        ],
                ),
    ],
  ),
  HandbookDomain(
    domainNumber: 2,
    title: "Swift Type System, Generics & Protocols",
    topics: [
      HandbookTopic(
        title: "Example",
        content: "The same variable can hold different concrete types.",
        codeSnippet: "struct CreditCard: Payment {     func pay() {         print(\"Credit Card\")     } }  struct UPI: Payment {     func pay() {         print(\"UPI\")     } }  var payment: any Payment  payment = CreditCard() payment.pay()  payment = UPI() payment.pay()",
      ),
      HandbookTopic(
        title: "Why is it called \"Existential\"?",
        content: "Think of it as saying: There exists some type that conforms to Payment. Instead of saying: \"It is definitely a CreditCard.\" you say: \"There exists some type that implements Payment; I don't know which one.\"",
        codeSnippet: "Payment",
      ),
      HandbookTopic(
        title: "1. Store different types in one collection (Most Common)",
        content: "Without existential: ❌ Error because arrays require one element type. With existential: Now both types can coexist.",
        codeSnippet: "let payments = [     CreditCard(),     UPI() ]",
      ),
      HandbookTopic(
        title: "2. Dependency Injection",
        content: "Suppose you have: Implementations: ViewModel: Production: Testing: The ViewModel doesn't care about the concrete type.",
        codeSnippet: "protocol NetworkService {     func fetch() }",
      ),
      HandbookTopic(
        title: "3. Runtime Polymorphism",
        content: "Call with different implementations:",
        codeSnippet: "func process(_ payment: any Payment) {     payment.pay() }",
      ),
      HandbookTopic(
        title: "4. Plugin Architecture",
        content: "Imagine different authentication providers. Implementations: Store them together:",
        codeSnippet: "protocol LoginProvider {     func login() }",
        keyPoints: ["GoogleLogin", "AppleLogin", "FacebookLogin"],
      ),
      HandbookTopic(
        title: "5. Strategy Pattern",
        content: "Different strategies: At runtime:",
        codeSnippet: "protocol SortingStrategy {     func sort() }",
        keyPoints: ["BubbleSort", "QuickSort", "MergeSort"],
      ),
      HandbookTopic(
        title: "Existential vs Generic",
        content: "Compiler knows: or Only one concrete type per specialization. Compiler knows only: Actual type is determined at runtime.",
        codeSnippet: "func process<T: Payment>(_ payment: T)",
      ),
      HandbookTopic(
        title: "Existential vs Opaque (some)",
        content: "The caller doesn't know the type. The compiler does know it's always CreditCard. With any: Even the compiler doesn't know the concrete type stored at compile time—it could change.",
        codeSnippet: "func makePayment() -> some Payment {     CreditCard() }",
      ),
      HandbookTopic(
        title: "Performance",
        content: "Existentials have a small runtime cost because Swift performs dynamic dispatch through a protocol witness table. Generics are usually faster because they are specialized at compile time.",
      ),
      HandbookTopic(
        title: "Rule of Thumb",
        content: "An existential type (any Protocol) is a type that can hold a value of any concrete type conforming to a protocol. The concrete type is hidden behind the protocol interface, enabling runtime polymorphism, heterogeneous collections, dependency injection, and flexible APIs, at the cost of some runtime overhead compared to generics. Let's look at your ",
        codeSnippet: "T",
        keyPoints: ["Use generics (T) when the concrete type should be preserved and you want maximum performance.", "Use some when you're hiding the return type but it is always the same concrete type.", "Use any when you genuinely need to work with multiple different conforming types at runtime."],
      ),
      HandbookTopic(
        title: "some vs any",
        content: "Most important distinction: some hides one specific type; any can represent different conforming types.",
        codeSnippet: "some Payment",
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 3,
    title: "Swift Memory, Ownership, ARC & Runtime Lifetime",
    topics: [
      HandbookTopic(
        title: "1. Memory Management",
        content: "→ Memory management is the process of allocating, using, tracking, and releasing memory used by an application.",
      ),
      HandbookTopic(
        title: "2. ARC",
        content: "→ Automatic Reference Counting (ARC) automatically manages the lifetime of class instances by tracking strong references to them. ```text id=\"9z8b2c\" Strong References       ↓ Object Lifetime       ↓ Reference Count = 0       ↓ Deallocated Here user strongly references the User instance by default.",
        codeSnippet: "---  ### 3. Reference Counting  → Reference counting tracks how many strong references point to a class instance and deallocates the instance when the strong reference count reaches zero.  ---  ### 4. Strong Reference  → A strong reference keeps a class instance alive as long as the reference exists.  ```swift id=\"8q1qj4\" var user = User()",
      ),
      HandbookTopic(
        title: "5. Weak Reference",
        content: "→ A weak reference does not keep an object alive and automatically becomes nil when the referenced object is deallocated. ```swift id=\"n0j4xs\" weak var delegate: MyDelegate?",
        codeSnippet: "nil",
      ),
      HandbookTopic(
        title: "6. Unowned Reference",
        content: "→ An unowned reference does not retain the referenced object and assumes the object will remain alive for the lifetime of the reference. ```swift id=\"m3p8wy\" unowned let owner: Owner",
        codeSnippet: "Unlike `weak`:  ```text id=\"t7b6hs\" weak → Becomes nil safely.  unowned → Does not become nil. → Access after deallocation causes a runtime crash.",
      ),
      HandbookTopic(
        title: "7. Retain Cycle",
        content: "→ A retain cycle occurs when two or more objects strongly reference each other, preventing their reference counts from reaching zero. ```text id=\"3bq7kp\" Object A    ↓ strong Object B    ↓ strong Object A",
        codeSnippet: "Result:  ```text ❌ Objects cannot be deallocated ❌ Memory leak",
      ),
      HandbookTopic(
        title: "8. Memory Leak",
        content: "→ A memory leak occurs when memory remains allocated because an object or resource is unintentionally kept alive and cannot be released.",
      ),
      HandbookTopic(
        title: "9. deinit",
        content: "→ deinit is called immediately before a class instance is deallocated, allowing cleanup of resources owned by the instance. ```swift id=\"2e8d7v\" deinit {     print(\"Object deallocated\") }",
        codeSnippet: "deinit",
      ),
      HandbookTopic(
        title: "10. Closure Capture",
        content: "→ Closure capture allows a closure to retain or reference values from its surrounding scope. ```swift id=\"k0h6zx\" class ViewModel {     var name = \"Navneet\" }",
        codeSnippet: "lazy var closure: () -> Void = {     print(self.name) }",
      ),
      HandbookTopic(
        title: "12. [weak self]",
        content: "→ [weak self] captures self weakly so the closure does not keep the object alive. Commonly used for asynchronous callbacks: ```swift id=\"6dy9fa\" service.fetch { [weak self] result in     self?.handle(result) } Use only when the lifetime relationship is guaranteed.",
        codeSnippet: "[weak self]",
      ),
      HandbookTopic(
        title: "⭐ [weak self] vs [unowned self]",
        content: "```text id=\"4u0m2r\" weak self → Object may disappear. → self becomes nil. → Safer. unowned self → Object must remain alive. → Access after deallocation crashes.",
        codeSnippet: "---  ## Common Retain Cycles  ### 14. Delegate Retain Cycle  → A delegate retain cycle occurs when an object strongly retains its delegate while the delegate also strongly retains the object.  Typical solution:  ```swift id=\"7w7f7p\" weak var delegate: SomeDelegate?",
      ),
      HandbookTopic(
        title: "15. Closure Retain Cycle",
        content: "→ A closure retain cycle occurs when an object strongly retains a closure and that closure strongly captures the same object. ```text id=\"6f3b0c\" ViewModel    ↓ strong Closure    ↓ strong ViewModel",
        codeSnippet: "Solution:  ```swift id=\"0z7x1v\" [weak self]",
      ),
      HandbookTopic(
        title: "16. Timer Retain Cycle",
        content: "→ A timer can create a retain cycle when the timer strongly retains its target or closure while the owner strongly retains the timer. Example relationship: ```text id=\"c1v3b4\" ViewController       ↓ strong     Timer       ↓ strong ViewController When all strong ownership disappears:",
        codeSnippet: "---  ### 17. Notification Retain Cycle  → Notification-related memory issues can occur when observers or callback closures remain registered or strongly capture their owner beyond the intended lifetime.  ---  ## ARC Behavior  ### 18. ARC Does Not Manage Value Types  → ARC primarily manages the lifetime of class instances because classes are reference types; structs and enums use value semantics and do not participate in ARC in the same way.  ---  ### 19. Strong Reference Count  → A strong refere",
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 4,
    title: "Swift Concurrency, Actors, Multithreading & Swift 6 Safety",
    topics: [
      HandbookTopic(
        title: "Swift Concurrency — Interview Definitions",
        content: "Example: The result can be unpredictable because the read/write operations can overlap. Example: Access from outside requires await:",
        codeSnippet: "Data Race → A data race occurs when multiple concurrent tasks access the same mutable memory at the same time, with at least one access being a write, and the access is not properly synchronized.",
      ),
      HandbookTopic(
        title: "Actor Isolation",
        content: "Example: From outside: Because crossing into the actor's isolation domain is potentially asynchronous. Example: You don't need await: A nonisolated method cannot directly access isolated mutable state.",
        codeSnippet: "Actor Isolation → Actor isolation restricts access to an actor's isolated state so that it can only be accessed safely within the actor's isolation domain.",
      ),
      HandbookTopic(
        title: "MainActor",
        content: "Example: Calling it from another isolation context may require: Don't say: @MainActor means \"this always runs on the main thread.\" Better: @MainActor provides actor isolation for UI-related code. Its executor is associated with the main thread, so main-actor-isolated work is normally executed on the main thread.",
        codeSnippet: "MainActor → MainActor is a global actor that isolates code to the main actor, making it suitable for UI-related state and operations.",
      ),
      HandbookTopic(
        title: "Global Actor",
        content: "Swift provides: as a built-in global actor. You can also define your own: Then:",
        codeSnippet: "Global Actor → A global actor is a uniquely shared actor that can be used to isolate declarations across different types and instances to the same actor.",
      ),
      HandbookTopic(
        title: "Sendable",
        content: "Example: Because Int and String are Sendable, User can safely conform to Sendable.",
        codeSnippet: "Sendable → Sendable is a protocol that indicates a value can be safely transferred across concurrency domains, such as between tasks or actors, without causing data races.",
      ),
      HandbookTopic(
        title: "@Sendable",
        content: "Example: The compiler applies additional restrictions to what the closure can capture. For example, capturing mutable non-Sendable state can produce concurrency-safety errors.",
        codeSnippet: "@Sendable → @Sendable marks a closure as safe to transfer and execute across concurrency domains.",
      ),
      HandbookTopic(
        title: "@unchecked Sendable",
        content: "Example: You are effectively saying: \"Compiler, don't verify this. I guarantee that this type is concurrency-safe.\" Therefore, it should be used carefully.",
        codeSnippet: "@unchecked Sendable → @unchecked Sendable tells the compiler to trust that a type is safe to transfer across concurrency domains, without requiring the compiler to verify that safety.",
      ),
      HandbookTopic(
        title: "Sendable vs @Sendable",
        content: "This is an important interview distinction: Example: versus:",
        codeSnippet: "Sendable → Applies to TYPES.  @Sendable → Applies to CLOSURES.",
      ),
      HandbookTopic(
        title: "Complete Interview Cheat Sheet",
        content: "Comprehensive architectural principles, thread-safety invariants, and production engineering best practices for senior iOS interviews.",
        codeSnippet: "Data Race → Multiple concurrent accesses to the same mutable state, with at least one write, without proper synchronization.  Actor → A reference type that protects mutable state through actor isolation.  Isolated → A declaration that belongs to an actor's isolation domain and can safely access its isolated state.  Nonisolated → A declaration that is outside the actor's isolation domain and cannot directly access isolated actor state.  MainActor → A predefined global actor used to isolate UI-rel",
      ),
      HandbookTopic(
        title: "⭐ Easy Mental Model",
        content: "And the most important interview relationship: Actor → protects mutable state Isolation → controls who can access that state Sendable → controls what data can safely cross concurrency boundaries @Sendable → applies that concept to closures MainActor → global actor primarily used for UI isolation",
        codeSnippet: "Swift Concurrency                            │              ┌─────────────┴─────────────┐              │                           │           Isolation                    Safety              │                           │           Actor                       Sendable              │                           │       ┌──────┴──────┐              ┌─────┴─────┐       │             │              │           │   isolated    nonisolated       Sendable   @Sendable                                      ",
      ),
      HandbookTopic(
        title: "Swift / iOS Concurrency — Interview Definitions",
        content: "Here is the clean distinction between GCD, Dispatch types, OperationQueue, and Swift Concurrency.",
      ),
      HandbookTopic(
        title: "1. GCD",
        content: "Main building block: Example:",
        codeSnippet: "GCD (Grand Central Dispatch) → GCD is Apple's low-level concurrency API that manages the execution of tasks using dispatch queues and system-managed threads.",
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 5,
    title: "UIKit Architecture, Rendering Engine & Auto Layout",
    topics: [
      HandbookTopic(
        title: "Content Hugging Priority",
        content: "Result: Higher Content Hugging = Less likely to grow.",
        codeSnippet: "Content Hugging Priority → Content Hugging determines how strongly a view resists growing larger than its intrinsic content size.",
        keyPoints: ["Prevents a view from stretching.", "The view with the lower hugging priority expands first.", "Label keeps its natural width."],
      ),
      HandbookTopic(
        title: "Compression Resistance Priority",
        content: "Result: Higher Compression Resistance = Less likely to shrink.",
        codeSnippet: "Compression Resistance Priority → Compression Resistance determines how strongly a view resists shrinking below its intrinsic content size.",
        keyPoints: ["Prevents text or views from being compressed.", "The view with the lower compression resistance shrinks first.", "Label keeps its full text."],
      ),
      HandbookTopic(
        title: "Content Hugging vs Compression Resistance",
        content: "Cassowary Auto Layout priority system for intrinsic content sizes:\n• Intrinsic Content Size: The natural dimensions a view requires to display its content without clipping (e.g. UILabel text metrics).\n• Content Hugging Priority (Resists Growing): Determines how strongly a view resists being stretched larger than its intrinsic content size. (Higher priority = hugs tightly; lower priority = expands first).\n• Content Compression Resistance Priority (Resists Shrinking): Determines how strongly a view resists being squeezed smaller than its intrinsic content size. (Higher priority = resists clipping/truncation; lower priority = gets clipped first).",
        codeSnippet: "// Give label higher compression resistance so it never truncates before button\nnameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)\nsubtitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal) // Expands to fill space",
        keyPoints: [
          "Content Hugging: 'Who expands?' -> Lower priority expands to fill available space.",
          "Compression Resistance: 'Who shrinks?' -> Lower priority shrinks and gets clipped.",
          "Default priority values: .required (1000), .defaultHigh (750), .defaultLow (250).",
          "Ambiguous layout warnings occur when two competing views have identical hugging/compression priorities."
        ],

      ),
      HandbookTopic(
        title: "Size Classes",
        content: "Instead of checking: Use adaptive constraints based on size classes. Examples:",
        codeSnippet: "Size Classes → Size Classes define groups of screen sizes (Compact or Regular) that help create adaptive layouts across different devices and orientations.",
        keyPoints: ["Compact (C)", "Regular (R)", "Compact (C)"],
      ),
      HandbookTopic(
        title: "Intrinsic Content Size (Bonus)",
        content: "Examples: Views like UIView generally have no intrinsic content size.",
        codeSnippet: "Intrinsic Content Size → The natural size of a view based on its content, without requiring explicit width or height constraints.",
        keyPoints: ["UILabel", "UIButton", "UIImageView"],
      ),
      HandbookTopic(
        title: "Auto Layout (Bonus)",
        content: "Comprehensive architectural principles, thread-safety invariants, and production engineering best practices for senior iOS interviews.",
        codeSnippet: "Auto Layout → Auto Layout is Apple's constraint-based layout system that automatically positions and sizes views based on constraints, making interfaces adaptive across different screen sizes and orientations.",
      ),
      HandbookTopic(
        title: "Interview Cheat Sheet",
        content: "Comprehensive architectural principles, thread-safety invariants, and production engineering best practices for senior iOS interviews.",
        keyPoints: ["Content Hugging → \"Who should expand?\"", "Compression Resistance → \"Who should shrink?\"", "Intrinsic Content Size → \"What size does the view want to be?\""],
      ),
      HandbookTopic(
        title: "iOS Runtime & UIKit Internals — Interview Definitions",
        content: "These are the next concepts after Swift language fundamentals. I’ll keep the same one-line interview definition + key distinction format.",
      ),
      HandbookTopic(
        title: "1. App Lifecycle",
        content: "```text id=\"2h0m4j\" App Lifecycle → The app lifecycle describes the different states an iOS application can move through, such as not running, inactive, active, background, and suspended.",
        codeSnippet: "#### Main states  ```text Not Running → App is not running.  Inactive → App is running but temporarily not receiving events.  Active → App is running in the foreground and receiving events.  Background → App is running in the background and may perform limited work.  Suspended → App remains in memory but is not executing code until resumed or terminated.",
      ),
      HandbookTopic(
        title: "2. Scene Lifecycle",
        content: "```text id=\"3k0q7m\" Scene Lifecycle → The scene lifecycle manages the lifecycle of an individual UI instance or window, especially in applications supporting multiple windows.",
        codeSnippet: "Important callbacks include:  ```text scene(_:willConnectTo:) sceneDidBecomeActive(_:) sceneWillResignActive(_:) sceneDidEnterBackground(_:) sceneWillEnterForeground(_:)",
      ),
      HandbookTopic(
        title: "3. UIViewController Lifecycle",
        content: "```text id=\"4tq8zs\" UIViewController Lifecycle → The UIViewController lifecycle defines the sequence of methods called as a view controller is created, loaded, displayed, removed, and destroyed.",
        codeSnippet: "Main methods:  ```text loadView() viewDidLoad() viewWillAppear() viewIsAppearing() viewDidAppear() viewWillDisappear() viewDidDisappear() deinit",
      ),
      HandbookTopic(
        title: "4. loadView()",
        content: "```text id=\"x1b8ny\" loadView() → Creates or loads the view managed by the view controller when the view is requested and not already loaded. Common usage:",
        codeSnippet: "Usually you don't override it when using Storyboards/XIBs.  ---  ## 5. `viewDidLoad()`  ```text id=\"u3k5zn\" viewDidLoad() → Called after the view controller's view has been loaded into memory and is the primary place for one-time view setup.",
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 6,
    title: "SwiftUI Architecture, State Management & Observation Engine",
    topics: [
      HandbookTopic(
        title: "1. Combine",
        content: "→ Combine is Apple's reactive framework for processing asynchronous events and data streams using publishers and subscribers. Basic flow:",
        codeSnippet: "Publisher    ↓ Operators    ↓ Subscriber",
      ),
      HandbookTopic(
        title: "2. Publisher",
        content: "→ A Publisher produces a sequence of values over time and can also terminate with a completion event. A publisher can emit:",
        codeSnippet: "Publisher",
      ),
      HandbookTopic(
        title: "3. Subscriber",
        content: "→ A Subscriber receives values and completion events produced by a Publisher. Common subscriber APIs:",
        codeSnippet: "Subscriber",
      ),
      HandbookTopic(
        title: "4. Subscription",
        content: "→ A subscription represents the connection between a publisher and subscriber and controls the lifetime of that relationship.",
      ),
      HandbookTopic(
        title: "5. AnyCancellable",
        content: "→ AnyCancellable represents a cancellable Combine subscription and automatically cancels the subscription when it is deallocated. Common pattern:",
        codeSnippet: "AnyCancellable",
      ),
      HandbookTopic(
        title: "6. Subject",
        content: "→ A Subject is both a Publisher and a mechanism for manually sending values or completion events.",
        codeSnippet: "Subject",
      ),
      HandbookTopic(
        title: "7. PassthroughSubject",
        content: "→ PassthroughSubject broadcasts values to current subscribers but does not store the latest value for future subscribers. If there are no subscribers when \"Hello\" is sent, that value is not replayed.",
        codeSnippet: "PassthroughSubject",
      ),
      HandbookTopic(
        title: "8. CurrentValueSubject",
        content: "→ CurrentValueSubject stores its current value and immediately sends that value to a new subscriber. A new subscriber receives:",
        codeSnippet: "CurrentValueSubject",
      ),
      HandbookTopic(
        title: "⭐ Passthrough vs CurrentValueSubject",
        content: "Memory trick:",
        codeSnippet: "PassthroughSubject → Event stream → No stored value  CurrentValueSubject → State stream → Stores latest value",
      ),
      HandbookTopic(
        title: "9. Operator",
        content: "→ A Combine operator transforms, filters, combines, or controls values flowing through a publisher. Example:",
        codeSnippet: "publisher     .map { \$0 * 2 }     .filter { \$0 > 10 }",
      ),
      HandbookTopic(
        title: "10. map",
        content: "→ Transforms every published value into another value.",
        codeSnippet: "publisher     .map { \$0.name }",
      ),
      HandbookTopic(
        title: "11. compactMap",
        content: "→ Transforms published values and removes nil results.",
        codeSnippet: "nil",
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 7,
    title: "Networking Architecture, API Client Design & Protocols",
    topics: [
      HandbookTopic(
        title: "1. Networking",
        content: "→ Networking is the process of exchanging data between an iOS app and a remote server over a network.",
      ),
      HandbookTopic(
        title: "2. HTTP",
        content: "→ HTTP is an application-layer protocol used for communication between clients and servers. Common methods:",
        codeSnippet: "GET    → Fetch data POST   → Create/send data PUT    → Replace existing data PATCH  → Partially update data DELETE → Delete data",
      ),
      HandbookTopic(
        title: "3. HTTPS",
        content: "→ HTTPS is HTTP secured using TLS encryption to protect data transmitted between the client and server.",
      ),
      HandbookTopic(
        title: "4. URL",
        content: "→ A URL identifies the location of a resource on a network. Example:",
        codeSnippet: "https://api.example.com/users/123",
      ),
      HandbookTopic(
        title: "5. URLSession",
        content: "→ URLSession is Apple's API for performing network requests and transferring data between an app and a server.",
      ),
      HandbookTopic(
        title: "6. URLSessionDataTask",
        content: "→ URLSessionDataTask performs HTTP requests and returns response data directly to the app.",
        codeSnippet: "let task = URLSession.shared.dataTask(with: request) { data, response, error in     // Handle response }  task.resume()",
      ),
      HandbookTopic(
        title: "7. URLSessionUploadTask",
        content: "→ URLSessionUploadTask is designed for uploading data or files to a server.",
      ),
      HandbookTopic(
        title: "8. URLSessionDownloadTask",
        content: "→ URLSessionDownloadTask downloads data to a temporary file and is useful for large files.",
      ),
      HandbookTopic(
        title: "9. URLRequest",
        content: "→ URLRequest represents the configuration of an HTTP request, including URL, method, headers, body, and caching policy.",
        codeSnippet: "var request = URLRequest(url: url) request.httpMethod = \"POST\" request.setValue(\"application/json\", forHTTPHeaderField: \"Content-Type\")",
      ),
      HandbookTopic(
        title: "10. HTTP Headers",
        content: "→ HTTP headers provide additional metadata about a request or response. Examples:",
        codeSnippet: "Authorization Content-Type Accept Cache-Control User-Agent",
      ),
      HandbookTopic(
        title: "11. HTTP Status Code",
        content: "→ An HTTP status code indicates the result of an HTTP request. Common codes:",
        codeSnippet: "2xx → Success 3xx → Redirection 4xx → Client error 5xx → Server error",
      ),
      HandbookTopic(
        title: "12. Codable Networking",
        content: "→ Codable allows Swift models to be encoded to and decoded from formats such as JSON.",
        codeSnippet: "struct User: Codable {     let id: Int     let name: String }",
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 8,
    title: "Persistence, Core Data, SwiftData & Distributed Data Sync",
    topics: [
      HandbookTopic(
        title: "1. Persistence",
        content: "→ Persistence is the ability to store application data so it survives beyond the current app execution.",
      ),
      HandbookTopic(
        title: "2. Core Data",
        content: "→ Core Data is Apple's framework for managing an application's object graph and persisting model data, including querying, tracking changes, relationships, and faulting. Important: Core Data is not just a database. It is an object-graph and persistence framework.",
      ),
      HandbookTopic(
        title: "3. NSManagedObject",
        content: "→ NSManagedObject is the base class used for Core Data-managed model objects whose lifecycle and persistence are controlled by Core Data.",
        codeSnippet: "NSManagedObject",
      ),
      HandbookTopic(
        title: "4. NSManagedObjectModel",
        content: "→ NSManagedObjectModel describes the entities, attributes, relationships, and constraints of the Core Data data model. Usually represented by:",
        codeSnippet: "NSManagedObjectModel",
      ),
      HandbookTopic(
        title: "5. NSPersistentContainer",
        content: "→ NSPersistentContainer simplifies Core Data stack setup by managing the model, persistent store coordinator, and managed object contexts. Typical setup:",
        codeSnippet: "NSPersistentContainer",
      ),
      HandbookTopic(
        title: "6. NSManagedObjectContext",
        content: "→ NSManagedObjectContext is an in-memory working environment used to create, fetch, modify, track, and delete managed objects. Think:",
        codeSnippet: "NSManagedObjectContext",
      ),
      HandbookTopic(
        title: "7. NSPersistentStoreCoordinator",
        content: "→ NSPersistentStoreCoordinator coordinates between managed object contexts and the underlying persistent stores. Architecture:",
        codeSnippet: "NSPersistentStoreCoordinator",
      ),
      HandbookTopic(
        title: "8. NSPersistentStore",
        content: "→ NSPersistentStore represents the actual persistent storage used by Core Data, such as SQLite, binary, or in-memory storage.",
        codeSnippet: "NSPersistentStore",
      ),
      HandbookTopic(
        title: "9. Core Data Stack",
        content: "→ The Core Data stack is the collection of objects responsible for defining the model, managing objects, coordinating stores, and persisting data. Modern simplified architecture:",
        codeSnippet: "NSPersistentContainer        ↓  ┌──────────────┐  │ Model        │  │ Coordinator  │  │ Context      │  └──────────────┘        ↓ Persistent Store",
      ),
      HandbookTopic(
        title: "10. Fetch Request",
        content: "→ NSFetchRequest describes what objects Core Data should retrieve from the persistent store.",
        codeSnippet: "NSFetchRequest",
      ),
      HandbookTopic(
        title: "11. Predicate",
        content: "→ NSPredicate defines filtering conditions for Core Data fetch requests.",
        codeSnippet: "NSPredicate",
      ),
      HandbookTopic(
        title: "12. Sort Descriptor",
        content: "→ NSSortDescriptor defines the ordering of fetched objects.",
        codeSnippet: "NSSortDescriptor",
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 9,
    title: "Software Architecture, SOLID Principles & Large-Scale App Design",
    topics: [
      HandbookTopic(
        title: "S — Single Responsibility Principle (SRP)",
        content: "Bad Example This class has multiple responsibilities. Good Example",
        codeSnippet: "Single Responsibility Principle (SRP) → A class should have only one responsibility and one reason to change.",
      ),
      HandbookTopic(
        title: "O — Open/Closed Principle (OCP)",
        content: "Instead of modifying existing code, extend it. Example: You can add: without changing existing code.",
        codeSnippet: "Open/Closed Principle (OCP) → Software entities should be open for extension but closed for modification.",
      ),
      HandbookTopic(
        title: "L — Liskov Substitution Principle (LSP)",
        content: "Example: Works with: Every implementation behaves correctly.",
        codeSnippet: "Liskov Substitution Principle (LSP) → A subclass or conforming type should be replaceable with its base type without changing the correctness of the program.",
      ),
      HandbookTopic(
        title: "I — Interface Segregation Principle (ISP)",
        content: "❌ Bad A robot doesn't eat. ✅ Good Classes conform only to what they need.",
        codeSnippet: "Interface Segregation Principle (ISP) → Clients should not be forced to depend on methods they do not use.",
      ),
      HandbookTopic(
        title: "D — Dependency Inversion Principle (DIP)",
        content: "❌ Bad The ViewModel is tightly coupled. ✅ Good Now you can inject:",
        codeSnippet: "Dependency Inversion Principle (DIP) → High-level modules should depend on abstractions (protocols), not concrete implementations.",
      ),
      HandbookTopic(
        title: "Interview Definitions",
        content: "Comprehensive architectural principles, thread-safety invariants, and production engineering best practices for senior iOS interviews.",
        codeSnippet: "S - Single Responsibility Principle (SRP) → A class should have only one responsibility and one reason to change.  O - Open/Closed Principle (OCP) → Software entities should be open for extension but closed for modification.  L - Liskov Substitution Principle (LSP) → Subtypes should be replaceable for their base types without affecting program correctness.  I - Interface Segregation Principle (ISP) → Clients should not be forced to depend on methods they do not use.  D - Dependency Inversion Pri",
      ),
      HandbookTopic(
        title: "One-Line Memory Trick",
        content: "Excellent interview question. Interviewers often ask: \"Which design patterns or architectures follow each SOLID principle?\" Here's the mapping. Let's understand each one.",
        codeSnippet: "Payment",
        keyPoints: ["SRP → One ViewModel, one service, one responsibility.", "OCP → Add new implementations (e.g., new Payment types) via protocols instead of changing existing code.", "LSP → Any conforming type (CreditCard, UPI) should work wherever Payment is expected."],
      ),
      HandbookTopic(
        title: "1. SRP (Single Responsibility Principle)",
        content: "One class → One responsibility. Instead of Split responsibilities Each class has one reason to change. ViewController ❌ Navigation ❌ API ❌ UI Coordinator ✅ Navigation only ViewController ✅ UI only Perfect SRP. Each layer has one job.",
        codeSnippet: "class UserManager {     func fetchUsers() {}     func saveUser() {}     func deleteUser() {}     func sendEmail() {} }",
      ),
      HandbookTopic(
        title: "2. OCP (Open Closed Principle)",
        content: "Extend, don't modify. Need GooglePay? Just create No existing code changes. Perfect OCP. Adding features without changing Coffee. Decorator is one of the best OCP examples. Instead of Factory creates new objects. Need ApplePay? Only add Existing code untouched.",
        codeSnippet: "protocol PaymentStrategy{     func pay() }",
      ),
      HandbookTopic(
        title: "3. LSP (Liskov Substitution)",
        content: "Child should replace parent. ↓ Every implementation should work here No special cases. Superclass defines Subclasses override Still works. Any Repository should work.",
        codeSnippet: "Payment",
      ),
      HandbookTopic(
        title: "4. ISP (Interface Segregation)",
        content: "Small protocols. Instead of Create Small protocols. Instead of Use Much better.",
        codeSnippet: "protocol ViewControllerDelegate{  save()  delete()  share()  logout()  print() }",
      ),
      HandbookTopic(
        title: "5. DIP (Dependency Inversion)",
        content: "Depend on abstractions. ViewModel Instead of ViewModel ↓ Repository Protocol ↓ Database/API ViewModel doesn't know implementation. Perfect DIP. Instead of Use Depends on abstraction.",
        codeSnippet: "protocol NetworkService{ }",
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 10,
    title: "Design Patterns & Dependency Injection Architecture",
    topics: [
      HandbookTopic(
        title: "Repository Pattern",
        content: "The Repository Pattern mediates between the Domain/Business layer and the Data Storage/Network layer. It presents a clean, collection-like protocol interface for querying and mutating entities, hiding whether data originates from local SQLite, CoreData, SwiftData, in-memory cache, or remote REST/GraphQL APIs.",
        codeSnippet: "public protocol UserRepositoryProtocol: Sendable {\n    func getUser(id: UUID) async throws -> UserEntity\n    func saveUser(_ user: UserEntity) async throws\n}\n\npublic final class UserRepository: UserRepositoryProtocol {\n    private let localStore: LocalDatabaseClient\n    private let remoteApi: RemoteApiClient\n    // Hides offline caching, delta sync, and network fetching from ViewModel\n}",
        keyPoints: [
          "Decouples UI and Domain logic from raw network clients or SQLite queries.",
          "Enables easy unit testing by mocking the repository protocol with fake in-memory stores.",
          "Centralizes caching, fallback logic, and network request deduplication."
        ],
                ),
      HandbookTopic(
        title: "Coordinator Pattern",
        content: "The Coordinator Pattern removes navigation and presentation logic from UIViewControllers or SwiftUI Views. ViewControllers only handle UI rendering and user interactions, delegating screen transitions, push/pop operations, modal presentations, and deep link routing to standalone Coordinator objects.",
        codeSnippet: "public protocol Coordinator: AnyObject {\n    var navigationController: UINavigationController { get }\n    func start()\n}\n\npublic final class AuthCoordinator: Coordinator {\n    public let navigationController: UINavigationController\n    public func start() {\n        let vc = LoginViewController(coordinator: self)\n        navigationController.pushViewController(vc, animated: true)\n    }\n}",
        keyPoints: [
          "Eliminates Massive View Controller by decoupling navigation flow.",
          "Makes ViewControllers completely reusable across different user flows.",
          "Simplifies deep link handling by orchestrating coordinator child hierarchies."
        ],
                ),
      HandbookTopic(
        title: "Builder Pattern",
        content: "The Builder Pattern constructs complex objects step-by-step, separating parameter configuration from the final object representation. In Swift, this is implemented using fluent method chaining or Swift 5.4+ Result Builders (like @ViewBuilder).",
        codeSnippet: "public struct NetworkRequestBuilder {\n    private var url: URL\n    private var headers: [String: String] = [:]\n    private var timeout: TimeInterval = 30\n    \n    public init(url: URL) { self.url = url }\n    public func withHeader(_ k: String, _ v: String) -> Self { var copy = self; copy.headers[k] = v; return copy }\n    public func build() -> URLRequest { var req = URLRequest(url: url); req.allHTTPHeaderFields = headers; return req }\n}",
        keyPoints: [
          "Prevents massive multi-parameter initializers (telescoping constructor anti-pattern).",
          "Guarantees compile-time immutability by producing read-only objects upon build().",
          "Forms the foundation of SwiftUI's declarative view hierarchy via @ViewBuilder."
        ],
                ),
      HandbookTopic(
        title: "Strategy Pattern ⭐⭐⭐⭐⭐",
        content: "The Strategy Pattern defines a family of interchangeable algorithms conforming to a common protocol, allowing algorithms to vary independently from clients that use them. In iOS, it is frequently used for payment gateways, authentication providers, sorting rules, and caching algorithms.",
        codeSnippet: "public protocol PaymentStrategy: Sendable {\n    func processPayment(amount: Decimal) async throws -> Bool\n}\npublic struct ApplePayStrategy: PaymentStrategy { public func processPayment(amount: Decimal) async throws -> Bool { return true } }\npublic struct CreditCardStrategy: PaymentStrategy { public func processPayment(amount: Decimal) async throws -> Bool { return true } }",
        keyPoints: [
          "Eliminates giant switch/if-else statements when selecting algorithms.",
          "Adheres to the Open/Closed Principle (OCP): add new strategies without modifying caller code.",
          "Enables dynamic runtime switching based on user preference or feature flags."
        ],
                ),
      HandbookTopic(
        title: "Decorator Pattern",
        content: "The Decorator Pattern attaches additional responsibilities or behaviors to an object dynamically without modifying the underlying class code. In Swift, it is implemented via protocol conformance wrappers, Swift extensions, or Combine operator pipelines.",
        codeSnippet: "public protocol HTTPClient: Sendable { func execute(_ req: URLRequest) async throws -> Data }\n\npublic final class LoggingHTTPClientDecorator: HTTPClient {\n    private let client: HTTPClient\n    public init(client: HTTPClient) { self.client = client }\n    public func execute(_ req: URLRequest) async throws -> Data {\n        print(\"[OUTGOING]: \\(req.url?.absoluteString ?? \"\")\")\n        return try await client.execute(req)\n    }\n}",
        keyPoints: [
          "Provides flexible alternative to subclassing for extending functionality.",
          "Allows stacking multiple decorators (e.g. LoggingClient(AuthClient(BaseClient()))).",
          "Maintains Single Responsibility Principle by isolating cross-cutting concerns."
        ],
                ),
      HandbookTopic(
        title: "Factory Pattern",
        content: "Instead of",
        codeSnippet: "Factory Pattern → The Factory pattern creates objects without exposing the object creation logic to the client.",
        keyPoints: ["Encapsulate object creation.", "Reduce coupling.", "Support OCP."],
      ),
      HandbookTopic(
        title: "Adapter Pattern",
        content: "The Adapter Pattern converts the interface of a legacy, third-party, or external library into a domain interface expected by client code. It acts as a translator between incompatible APIs, shielding application code from vendor lock-in.",
        codeSnippet: "// Domain Interface\npublic protocol AnalyticsTracker: Sendable { func trackEvent(_ name: String) }\n\n// Third-Party Adapter\npublic final class FirebaseAnalyticsAdapter: AnalyticsTracker {\n    public func trackEvent(_ name: String) {\n        // Maps domain call to FirebaseAnalytics.Analytics.logEvent(name, parameters: nil)\n    }\n}",
        keyPoints: [
          "Shields application domain models from third-party SDK dependencies.",
          "Enables swapping out external libraries (e.g. Firebase -> Mixpanel) by updating only the adapter.",
          "Converts legacy Objective-C delegation into modern async/await Swift protocols."
        ],
                ),
      HandbookTopic(
        title: "Template Method Pattern",
        content: "Subclasses override only:",
        codeSnippet: "Template Method Pattern → The Template Method pattern defines the overall algorithm in a base class while allowing subclasses to customize specific steps.",
        keyPoints: ["Reuse common workflow.", "Allow customization.", "Reduce duplicate code."],
      ),
      HandbookTopic(
        title: "Delegate Pattern ⭐⭐⭐⭐⭐",
        content: "The Delegate Pattern is Apple's foundational 1-to-1 communication mechanism. It allows an object to communicate events or delegate control to another object via a protocol contract. The delegate reference must ALWAYS be declared 'weak' to prevent retain cycles.",
        codeSnippet: "public protocol AudioPlayerDelegate: AnyObject, Sendable {\n    func playerDidFinishPlayback(_ player: AudioPlayer)\n}\n\npublic final class AudioPlayer {\n    public weak var delegate: AudioPlayerDelegate?\n    public func finish() { delegate?.playerDidFinishPlayback(self) }\n}",
        keyPoints: [
          "Protocol must inherit from AnyObject (class-bound) to allow weak references.",
          "Always hold delegate as 'weak var' to avoid permanent parent-child retain cycles.",
          "Ideal for 1-to-1 two-way communication and customizable behavior (like UITableViewDelegate)."
        ],
                ),
      HandbookTopic(
        title: "Dependency Injection (DI)",
        content: "Instead of Use",
        codeSnippet: "Dependency Injection (DI) → Dependency Injection is a design pattern where dependencies are provided from outside a class instead of being created inside it.",
        keyPoints: ["Reduce coupling.", "Improve testability.", "Follows DIP."],
      ),
      HandbookTopic(
        title: "MVC (Bonus)",
        content: "Model-View-Controller (MVC) is Apple's classic architectural blueprint:\n• Model: Owns data entities, persistence, and core business rules.\n• View: UI elements (UIView, UILabel) that display state and capture touch events.\n• Controller: UIViewController acts as the intermediary, fetching data from models and updating views.\n• Pitfall: Massive View Controller (MVC) occurs when network calls, delegates, table view data sources, and formatting logic all live inside the controller.",
        codeSnippet: "// Clean MVC: Controller delegates business logic and data source to dedicated objects",
        keyPoints: [
          "Apple's default architectural design for UIKit applications.",
          "Prone to 'Massive View Controller' if business logic is not extracted.",
          "Solve MVC bloat by introducing ViewModels, Coordinators, and Services."
        ],
              ),
      HandbookTopic(
        title: "MVVM (Bonus)",
        content: "Model-View-ViewModel (MVVM) separates presentation logic from UI controls:\n• Model: Domain entities and repositories.\n• ViewModel: State holder that transforms model data into display-ready strings/booleans and handles user actions. Knows nothing of UIKit/SwiftUI views.\n• View: Observes the ViewModel via Combine, SwiftUI @Observable, or closures, rendering state reactively.",
        codeSnippet: "@Observable public final class ProfileViewModel {\n    private(set) public var displayName: String = \"\"\n    public func load(id: UUID) async {\n        displayName = \"User \\(id.uuidString.prefix(6))\"\n    }\n}",
        keyPoints: [
          "ViewModel has ZERO UIKit imports, making it 100% unit-testable.",
          "Two-way or unidirectional binding connects View to ViewModel.",
          "Standard architecture for modern SwiftUI and reactive UIKit apps."
        ],
              ),
    ],
  ),
  HandbookDomain(
    domainNumber: 11,
    title: "Modularization, Swift Package Manager & Feature Modules",
    topics: [
      HandbookTopic(
        title: "1. Swift Package",
        content: "Example: A package is primarily a distribution/modularization unit. It can produce libraries and, with appropriate package configuration, executable products.",
        codeSnippet: "Swift Package → A Swift Package is a reusable, modular unit of Swift code that can contain source code, resources, tests, and dependencies and can be shared across projects using Swift Package Manager.",
      ),
      HandbookTopic(
        title: "2. Framework",
        content: "Example: A framework can contain:",
        codeSnippet: "Framework → A framework is a bundle that packages reusable code and resources into a module that can be integrated into an application or another framework.",
        keyPoints: ["Swift/Objective-C code", "Resources", "Headers"],
      ),
      HandbookTopic(
        title: "3. Swift Package vs Framework",
        content: "A Swift Package is a source/distribution unit managed by Swift Package Manager, while a framework is a bundled reusable module containing code and potentially resources. A Swift Package can produce library products that are consumed by an app.",
        codeSnippet: "Package.swift",
      ),
      HandbookTopic(
        title: "4. Static Library",
        content: "Example: After linking, the required code becomes part of the application executable.",
        codeSnippet: "Static Library → A static library is a compiled collection of code that is copied into the application's executable during the final linking process.",
      ),
      HandbookTopic(
        title: "5. Dynamic Library",
        content: "Conceptually: The library isn't simply copied into the executable in the same way as a static library.",
        codeSnippet: "Dynamic Library → A dynamic library is compiled code that is linked and loaded separately from the application's executable, allowing the library to be shared or loaded independently.",
      ),
      HandbookTopic(
        title: "6. Static vs Dynamic Library",
        content: "Comparison of compiled library formats:\n• Static Library (.a): Merged directly into the app executable at compile time by the static linker (ld64). Increases binary size slightly but incurs ZERO launch time overhead.\n• Dynamic Framework (.dylib / .framework): Loaded into memory at runtime by the dynamic linker (dyld4). Can be shared across app extensions, but each additional dynamic framework adds ~1-2ms to cold launch time during dyld rebinding and loading.",
        codeSnippet: "// SPM Package.swift Static Library Definition\n.library(name: \"CoreDataKit\", type: .static, targets: [\"CoreDataKit\"])",
        keyPoints: [
          "Static libraries have zero dyld pre-main launch cost; code merges into main binary.",
          "Dynamic frameworks enable code sharing with App Extensions but slow down cold launch.",
          "Apple recommends keeping dynamic frameworks under 6; prefer static libraries in SPM."
        ],
              ),
      HandbookTopic(
        title: "7. Dispatch",
        content: "The major mechanisms you should know:",
        codeSnippet: "Dispatch → Dispatch is the mechanism Swift uses to determine which implementation of a method or property should be executed.",
      ),
      HandbookTopic(
        title: "8. Direct Dispatch",
        content: "Common with: Example: The compiler can generally resolve the call directly.",
        codeSnippet: "Direct Dispatch → The compiler knows the exact implementation to call and can directly invoke it without runtime lookup.",
        keyPoints: ["final methods/classes", "Structs", "Enums"],
      ),
      HandbookTopic(
        title: "9. V-Table Dispatch",
        content: "Example: The runtime can determine which implementation to call.",
        codeSnippet: "V-Table Dispatch → V-table dispatch uses a virtual method table to dynamically select an overridden class method at runtime.",
      ),
      HandbookTopic(
        title: "10. Witness Table Dispatch",
        content: "Example: Conceptually: The witness table tells Swift which concrete implementation satisfies each protocol requirement.",
        codeSnippet: "Witness Table Dispatch → Witness table dispatch is used for protocol requirements to map a protocol's methods to the concrete implementation provided by a conforming type.",
      ),
      HandbookTopic(
        title: "11. Message Dispatch",
        content: "Commonly associated with: and the Objective-C runtime. Conceptually:",
        codeSnippet: "Message Dispatch → Message dispatch dynamically sends a message to an object at runtime, allowing the runtime to determine which implementation should respond.",
      ),
      HandbookTopic(
        title: "12. Dispatch Comparison",
        content: "Swift Method Dispatch Mechanisms:\n• Direct (Static) Dispatch: Method calls compile down to direct assembly jumps (BL). Used by structs, enums, final classes, and protocol extensions. Inlining possible. (Fastest: ~1 CPU cycle).\n• Table (V-Table / PWT) Dispatch: Function pointers stored in class virtual method tables or protocol witness tables. Adds 1 pointer indirection. (~2-4 CPU cycles).\n• Message Dispatch: Objective-C runtime dynamic lookup (objc_msgSend) traversing class hierarchies and method caches. Enables swizzling and KVO. (~6-12 CPU cycles).",
        codeSnippet: "// Direct: final class / structs\n// V-Table: open class Vehicle { func drive() }\n// Message: @objc dynamic func track()",
        keyPoints: [
          "Direct dispatch is the fastest and allows compiler whole-module optimization (WMO).",
          "Table dispatch is used for class polymorphism and required protocol methods.",
          "Message dispatch powers Objective-C interop and dynamic features."
        ],
              ),
    ],
  ),
  HandbookDomain(
    domainNumber: 12,
    title: "Testing & Quality Engineering at Scale",
    topics: [
      HandbookTopic(
        title: "1. Software Testing",
        content: "→ Software testing verifies that an application's behavior matches its expected requirements and helps detect defects before release.",
      ),
      HandbookTopic(
        title: "2. Unit Testing",
        content: "→ Unit testing tests a small, isolated unit of code, such as a function, class, ViewModel, or use case.",
        codeSnippet: "ViewModel    ↓ Unit Test    ↓ Expected Output",
      ),
      HandbookTopic(
        title: "3. Integration Testing",
        content: "→ Integration testing verifies that multiple components work correctly together. Example:",
        codeSnippet: "ViewModel    ↓ Repository    ↓ API / Database",
      ),
      HandbookTopic(
        title: "4. UI Testing",
        content: "→ UI testing verifies application behavior by interacting with the actual user interface. Examples:",
        codeSnippet: "Launch app → Tap Login → Enter credentials → Tap Submit → Verify Home screen",
      ),
      HandbookTopic(
        title: "5. XCTest",
        content: "→ XCTest is Apple's framework for writing and running unit, integration, performance, and UI tests.",
      ),
      HandbookTopic(
        title: "6. XCTestCase",
        content: "→ XCTestCase is the base class used to define XCTest test methods and setup/teardown behavior.",
        codeSnippet: "XCTestCase",
      ),
      HandbookTopic(
        title: "7. Test Method",
        content: "→ A test method is a function whose name begins with test and verifies a specific expected behavior.",
        codeSnippet: "test",
      ),
      HandbookTopic(
        title: "8. Arrange",
        content: "→ Arrange prepares the test data, dependencies, and initial state.",
      ),
      HandbookTopic(
        title: "9. Act",
        content: "→ Act performs the operation being tested.",
      ),
      HandbookTopic(
        title: "10. Assert",
        content: "→ Assert verifies that the actual result matches the expected result. ```text id=\"d0b0y2\" Arrange    ↓ Act    ↓ Assert",
        codeSnippet: "---  ## Assertions  ### 11. `XCTAssertEqual`  → Verifies that two values are equal.  ```swift XCTAssertEqual(actual, expected)",
      ),
      HandbookTopic(
        title: "12. XCTAssertTrue",
        content: "→ Verifies that an expression evaluates to true.",
        codeSnippet: "true",
      ),
      HandbookTopic(
        title: "13. XCTAssertFalse",
        content: "→ Verifies that an expression evaluates to false.",
        codeSnippet: "false",
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 13,
    title: "Performance Engineering, Instruments & App Startup",
    topics: [
      HandbookTopic(
        title: "1. Performance Optimization",
        content: "→ Performance optimization is the process of reducing CPU, memory, rendering, I/O, network, and battery costs while maintaining correct application behavior.",
      ),
      HandbookTopic(
        title: "2. Instruments",
        content: "→ Instruments is Apple's profiling toolset for measuring and diagnosing runtime performance, memory usage, CPU activity, energy consumption, and other system behavior.",
      ),
      HandbookTopic(
        title: "3. CPU Usage",
        content: "→ CPU usage represents how much processor time an application consumes while performing work. High CPU usage can result from: ```text id=\"q4f7mk\" Heavy computation Infinite loops Excessive JSON processing Frequent layout Image processing Unnecessary work on main thread",
        codeSnippet: "---  ### 4. Time Profiler  → Time Profiler samples the application's call stacks over time to identify methods consuming significant CPU time.  Use it to answer:  > **Where is my app spending CPU time?**  ---  ### 5. Sampling  → Sampling periodically records the current call stack of running threads to identify where execution time is being spent without instrumenting every function call.  ---  ### 6. Main Thread Checker  → Main Thread Checker detects certain UI-related APIs being accessed from ",
      ),
      HandbookTopic(
        title: "7. Memory Usage",
        content: "→ Memory usage represents the amount of RAM currently consumed by the application. Excessive memory usage can cause: ```text id=\"w1n5mj\" Memory pressure Jetsam termination Slow performance Crashes It can improve performance for appropriate static content but can also hurt performance if used incorrectly.",
        codeSnippet: "---  ### 8. Allocations Instrument  → Allocations tracks memory allocations and object lifetimes to help identify excessive allocations and memory growth.  Use it to answer:  > **What objects are being allocated and how much memory are they using?**  ---  ### 9. Leaks Instrument  → Leaks detects memory that is no longer reachable but remains allocated.  ---  ### 10. Memory Graph Debugger  → Xcode's Memory Graph Debugger visualizes live objects and their references to help identify retain cycles ",
      ),
      HandbookTopic(
        title: "20. Layout Pass",
        content: "→ A layout pass calculates and updates the positions and sizes of views based on constraints and layout rules.",
      ),
      HandbookTopic(
        title: "21. Layout Thrashing",
        content: "→ Layout thrashing occurs when repeated layout invalidation and forced layout cause excessive layout calculations. Common problematic pattern: ```swift id=\"8ytrh3\" view.setNeedsLayout() view.layoutIfNeeded()",
        codeSnippet: "repeated unnecessarily.  ---  ### 22. Auto Layout Performance  → Auto Layout performance can degrade when there are excessively complex constraint hierarchies or frequent unnecessary layout passes.  Optimization strategies:  ```text id=\"8l4r1f\" Reduce unnecessary constraints Avoid repeated forced layout Simplify hierarchy Reuse cells",
      ),
      HandbookTopic(
        title: "23. App Launch Time",
        content: "→ App launch time is the time required for the application to become responsive after being launched.",
      ),
      HandbookTopic(
        title: "24. Cold Launch",
        content: "→ A cold launch occurs when the application is launched without its process already running.",
      ),
      HandbookTopic(
        title: "25. Warm Launch",
        content: "→ A warm launch occurs when the application process or relevant system state is already available, reducing startup work.",
      ),
      HandbookTopic(
        title: "26. Pre-main Time",
        content: "→ Pre-main time is the portion of application startup before the application's main execution begins, including loading and initialization work performed by the system.",
      ),
      HandbookTopic(
        title: "27. Post-main Time",
        content: "→ Post-main time is the startup work performed by the application after main execution begins until the UI becomes usable.",
      ),
      HandbookTopic(
        title: "28. Launch Optimization",
        content: "→ Launch optimization reduces unnecessary work during startup so the first usable screen appears quickly. Avoid doing heavy work during launch: ```text id=\"k3e6qb\" Large database fetch Heavy JSON processing Large image decoding Network requests Expensive initialization",
        codeSnippet: "---  ## Images  ### 29. Image Decoding  → Image decoding converts compressed image data into a pixel representation usable for rendering.  Large image decoding can consume significant CPU and memory.  ---  ### 30. Image Downsampling  → Image downsampling creates an image close to its displayed size instead of decoding a much larger source image, reducing memory and rendering cost.  ---  ### 31. Image Caching  → Image caching stores previously loaded or decoded images so they can be reused withou",
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 14,
    title: "iOS App Lifecycle & Background Execution Systems",
    topics: [
      HandbookTopic(
        title: "1. iOS App Lifecycle",
        content: "→ The app lifecycle describes how an iOS application transitions between active, inactive, background, and terminated states.",
      ),
      HandbookTopic(
        title: "2. App States",
        content: "```text id=\"9t3v2k\" Not Running      ↓ Inactive      ↓ Active      ↓ Background      ↓ Suspended",
        codeSnippet: "An app can also move from background → active or be terminated from background.  ---  ## Scene Lifecycle  ### 3. Scene  → A Scene represents an instance of an app's UI/session and manages its lifecycle independently.  ---  ### 4. SceneDelegate  → `SceneDelegate` manages the lifecycle and configuration of a scene in applications using UIKit scene-based lifecycle.  ---  ### 5. Scene States  ```text id=\"6k7w8p\" Unattached     ↓ Foreground Inactive     ↓ Foreground Active     ↓ Background     ↓ Disc",
      ),
      HandbookTopic(
        title: "6. scene(_:willConnectTo:)",
        content: "→ Called when a scene is being connected and is where initial UI/window configuration is commonly performed.",
      ),
      HandbookTopic(
        title: "7. sceneDidBecomeActive",
        content: "→ Called when the scene becomes active and can receive user interaction.",
      ),
      HandbookTopic(
        title: "8. sceneWillResignActive",
        content: "→ Called when the scene is about to become inactive, such as during interruptions.",
      ),
      HandbookTopic(
        title: "9. sceneDidEnterBackground",
        content: "→ Called when the scene moves into the background. Good place to: ```text id=\"q5g3y8\" Persist important state Stop unnecessary UI work Release temporary resources",
        codeSnippet: "---  ### 10. `sceneWillEnterForeground`  → Called when a background scene is about to return to the foreground.  ---  ## AppDelegate  ### 11. AppDelegate  → `AppDelegate` handles application-level events and configuration that are not specific to a single scene.  Common responsibilities:  ```text id=\"3q5r7m\" App launch Push notification registration Global services Background events Application configuration",
      ),
      HandbookTopic(
        title: "⭐ AppDelegate vs SceneDelegate",
        content: "```text id=\"0y9g1w\" AppDelegate → Application-level lifecycle SceneDelegate → UI/scene lifecycle",
        codeSnippet: "---  ## Application Launch  ### 12. Cold Launch  → A cold launch occurs when the app process is not running and must be started from scratch.  ---  ### 13. Warm Launch  → A warm launch occurs when the app process already exists and can return to the foreground without full process startup.  ---  ### 14. Pre-Main  → Pre-main time is the startup period before the application's `main` execution begins.  It can include:  ```text id=\"4c6y8v\" Dynamic library loading Rebasing Binding Runtime initializa",
      ),
      HandbookTopic(
        title: "15. Post-Main",
        content: "→ Post-main time is the startup work performed after the application begins executing application code and before the first useful frame.",
      ),
      HandbookTopic(
        title: "16. App Launch Optimization",
        content: "→ App launch optimization minimizes work required before the first interactive frame. Avoid during launch: ```text id=\"2j6k8n\" Large synchronous database fetches Heavy JSON processing Image decoding Unnecessary SDK initialization Network requests Large dependency initialization",
        codeSnippet: "---  ## Background Execution  ### 17. Background Execution  → Background execution allows an app to perform limited work when it is not in the foreground, subject to iOS system policies.  ---  ### 18. Background Task  → A background task gives an app limited time to finish important work after moving to the background.  UIKit:  ```swift id=\"8w2m3p\" UIApplication.shared.beginBackgroundTask",
      ),
      HandbookTopic(
        title: "19. BGTaskScheduler",
        content: "→ BGTaskScheduler schedules system-managed background work. Common task types: ```text id=\"p1j7s4\" BGAppRefreshTask BGProcessingTask",
        codeSnippet: "BGTaskScheduler",
      ),
      HandbookTopic(
        title: "24. Deep Link",
        content: "→ A deep link opens a specific screen or piece of content inside an app. Example: ```text id=\"8h6s2v\" myapp://product/123",
        codeSnippet: "---  ### 25. URL Scheme  → A custom URL scheme allows another application or system component to open your app using a custom URL.  Example:  ```text id=\"5x7v9k\" myapp://profile/123",
      ),
      HandbookTopic(
        title: "26. Universal Link",
        content: "→ A Universal Link uses an HTTPS URL to open associated content directly in the corresponding iOS app when configured. Example: ```text id=\"f7h2m4\" https://example.com/product/123",
        codeSnippet: "---  ### ⭐ URL Scheme vs Universal Link  ```text id=\"y2m8q4\" URL Scheme → Custom scheme → myapp://  Universal Link → HTTPS → https://example.com → Better web/app integration",
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 15,
    title: "Swift Runtime, Reflection, Mach-O & Dynamic Dispatch",
    topics: [
      HandbookTopic(
        title: "1. let vs var",
        content: "Immutable constants (let) vs mutable variables (var):\n• let: Assigns a constant whose binding cannot be changed. For value types (structs), locks the entire memory buffer. For reference types (classes), locks the 64-bit stack pointer while heap properties remain mutable.\n• var: Declares a mutable variable that can be reassigned or mutated in place.\n• Swift compiler enforces immutability at compile time, eliminating race conditions across threads.",
        codeSnippet: "let p1 = Point(x: 10, y: 20) // p1.x = 99 -> Compile Error!\nvar p2 = Point(x: 10, y: 20) // p2.x = 99 -> Allowed in-place mutation",
        keyPoints: [
          "Always prefer 'let' by default for compile-time safety and self-documenting code.",
          "let on a class prevents reassignment of the pointer, NOT mutation of internal state.",
          "Value types with 'let' guarantee complete deep thread safety."
        ],

      ),
      HandbookTopic(
        title: "2. static vs class",
        content: "Example: Memory:",
        codeSnippet: "static → Defines a type property or method that belongs to the type itself and cannot be overridden.  class → Defines a type property or method on a class that can be overridden by subclasses.",
      ),
      HandbookTopic(
        title: "3. mutating",
        content: "The 'mutating' keyword on struct and enum methods indicates that the method modifies stored properties of the instance. Under the hood, mutating methods pass 'self' as an implicit 'inout' parameter, governed by Swift's Law of Exclusivity (memory cannot be simultaneously read and written).",
        codeSnippet: "public struct Counter {\n    private(set) public var value = 0\n    public mutating func increment() { value += 1 }\n}",
        keyPoints: [
          "Calling a mutating method on a 'let' constant produces a compile-time error.",
          "mutating passes 'self' by copy-in, copy-out inout memory semantics.",
          "Only applicable to value types (structs and enums); classes are inherently mutable reference types."
        ],
              ),
      HandbookTopic(
        title: "4. inout",
        content: "inout parameter passing enables functions to modify variables passed by the caller. It operates via Copy-In, Copy-Out semantics:\n1. When the function is called, the argument value is copied.\n2. Inside the function body, mutations apply to the copy.\n3. When the function returns, the updated value is copied back to the original variable address.\n• Swift enforces the Law of Exclusivity: you cannot pass a variable as inout while simultaneously reading it elsewhere.",
        codeSnippet: "func swapValues<T>(_ a: inout T, _ b: inout T) {\n    let temp = a; a = b; b = temp\n}\nvar x = 10, y = 20; swapValues(&x, &y) // x is 20, y is 10",
        keyPoints: [
          "Call site requires explicit ampersand prefix (&x) to indicate mutation intent.",
          "Uses Copy-In, Copy-Out (not pass-by-reference), ensuring register optimization.",
          "Simultaneous inout access to the same variable triggers dynamic or static exclusivity traps."
        ],

      ),
      HandbookTopic(
        title: "5. final",
        content: "It can also enable more optimization opportunities because the compiler knows the implementation cannot be overridden.",
        codeSnippet: "final → Prevents a class from being subclassed or a class member from being overridden.",
      ),
      HandbookTopic(
        title: "6. override",
        content: "The 'override' keyword explicitly declares that a subclass method, property, or subscript replaces an inherited declaration from its superclass. The compiler verifies that the superclass actually defines matching signature, preventing typos and unexpected shadow methods.",
        codeSnippet: "open class BaseService {\n    open func start() { print(\"Base started\") }\n}\npublic final class CustomService: BaseService {\n    public override func start() {\n        super.start()\n        print(\"Custom started\")\n    }\n}",
        keyPoints: [
          "Enforces compiler validation: errors if superclass declaration does not exist.",
          "Methods marked 'final' cannot be overridden.",
          "Call super.method() when subclassing lifecycle methods in UIKit."
        ],
              ),
      HandbookTopic(
        title: "7. self vs Self",
        content: "Example: Here: Self is commonly used in protocols and generic APIs:",
        codeSnippet: "self → Refers to the current instance.  Self → Refers to the current type in a type-safe way.",
      ),
      HandbookTopic(
        title: "8. Any vs AnyObject",
        content: "Example: But: Int cannot be used as an AnyObject in the same direct sense because AnyObject is class-constrained.",
        codeSnippet: "Any → Can represent a value of any type, including structs, classes, enums, functions, and other value types.  AnyObject → Can represent an instance of any class type.",
      ),
      HandbookTopic(
        title: "9. Optional",
        content: "Conceptually:",
        codeSnippet: "Optional → An Optional represents either a value of a specific type or the absence of a value represented by nil.",
      ),
      HandbookTopic(
        title: "10. Optional Binding",
        content: "Optional Binding safely extracts the wrapped value from an Optional enum (.some vs .none) without runtime crashes:\n• if let: Unwraps the optional within a scoped curly-brace block.\n• guard let: Enforces early exit (return, break, throw) if unwrapping fails, keeping happy-path code un-nested and clean.\n• Nil-coalescing (??): Provides fallback default values for missing optionals.",
        codeSnippet: "guard let token = authToken, !token.isEmpty else {\n    throw AuthenticationError.invalidToken\n}\n// 'token' is safely unwrapped and accessible throughout the rest of the scope",
        keyPoints: [
          "Swift 5.7+ shorthand syntax: 'guard let name else { ... }' instead of 'guard let name = name'.",
          "guard let eliminates deep nested 'pyramid of doom' if statements.",
          "Avoid force unwrapping (!) in production codebases to prevent SIGTRAP crashes."
        ],
              ),
      HandbookTopic(
        title: "11. guard let",
        content: "The 'guard' statement enforces pre-conditions and early exits. If condition evaluates to false, the mandatory 'else' block executes, requiring a transfer of control (return, throw, break, or fatalError). Unwrapped variables remain in scope for the remainder of the enclosing function.",
        codeSnippet: "func processUser(input: String?) throws {\n    guard let input, !input.isEmpty else { throw ValidationError.emptyInput }\n    print(\"Processing: \\(input)\")\n}",
        keyPoints: [
          "Mandates an early exit in the else block at compile time.",
          "Variables unwrapped by guard let remain available in the outer function scope.",
          "Significantly improves readability and reduces cyclomatic complexity."
        ],
              ),
      HandbookTopic(
        title: "12. map",
        content: "Functional transformation primitives in Swift Collections:\n• map: Transforms each element into another value, returning an array of identical length.\n• compactMap: Transforms elements and automatically unwraps optionals, stripping out all nil values.\n• flatMap: Flattens nested collections (e.g. [[Int]] -> [Int]) or chains monadic optional transformations.\n• reduce: Combines all elements into a single aggregate value using an initial accumulator.",
        codeSnippet: 'let strings = ["1", "two", "3"]\nlet numbers = strings.compactMap { Int(\$0) }\nlet sum = numbers.reduce(0, +)',
        keyPoints: [
          "compactMap replaces deprecated flatMap for filtering out nil optionals.",
          "map maintains 1-to-1 collection length.",
          "Functional primitives are immutable and thread-safe by default."
        ],
              ),
    ],
  ),
  HandbookDomain(
    domainNumber: 16,
    title: "iOS Security Architecture, Keychain & Secure Enclave",
    topics: [
      HandbookTopic(
        title: "1. Security Fundamentals",
        content: "→ Verifies who the user is. → Verifies what an authenticated user is allowed to do. → Converts readable data into unreadable ciphertext using a key. → Converts ciphertext back into readable data using a key. → Converts data into a fixed-size one-way digest. → Converts data into another representation for transport/storage; it is not security. → Use",
      ),
      HandbookTopic(
        title: "2. Keychain",
        content: "→ Apple's secure storage mechanism for sensitive small pieces of data such as tokens, passwords, and keys. Typical data: Basic API: Read: Delete: Never store access/refresh tokens in UserDefaults.",
        codeSnippet: "Access Token Refresh Token Passwords API Secrets Encryption Keys Certificates",
      ),
      HandbookTopic(
        title: "3. Keychain Accessibility",
        content: "→ Item is accessible only while the device is unlocked. → Item becomes accessible after the first device unlock after boot. Useful for some background operations. → Prevents the item from being migrated/restored to another device. Example: Q: Which accessibility would you prefer for highly sensitive user credentials? → Usually WhenUnlockedThisDevic",
        codeSnippet: "kSecAttrAccessibleWhenUnlocked",
      ),
      HandbookTopic(
        title: "4. Secure Enclave",
        content: "→ Hardware-isolated security subsystem designed to protect cryptographic keys and sensitive operations. Important point: You generally don't store arbitrary application data inside Secure Enclave. Instead, you generate/protect cryptographic keys there. Conceptually:",
        codeSnippet: "App  │  ▼ CryptoKit / Security  │  ▼ Secure Enclave  │  └── Private Key",
      ),
      HandbookTopic(
        title: "5. CryptoKit",
        content: "→ Apple's modern framework for cryptographic operations. Examples: Common primitives: Don't implement your own cryptographic algorithms. Use:",
        codeSnippet: "SHA256.hash(data: data)",
        keyPoints: ["SHA-256", "SHA-384", "SHA-512"],
      ),
      HandbookTopic(
        title: "6. Data Protection",
        content: "→ iOS uses encryption and device state to protect files stored on the device. Example: → File is inaccessible while the device is locked. → File becomes accessible after the first unlock. → No additional file-level protection.",
        codeSnippet: "try data.write(     to: url,     options: [.completeFileProtection] )",
      ),
      HandbookTopic(
        title: "7. App Transport Security",
        content: "→ iOS security policy that encourages/enforces secure network communication using HTTPS. Preferred: Avoid: ATS exceptions should be minimized.",
        codeSnippet: "HTTPS TLS Certificate validation",
      ),
      HandbookTopic(
        title: "8. TLS",
        content: "→ Cryptographic protocol that protects data transmitted between client and server. Provides: Typical flow:",
        codeSnippet: "Encryption Integrity Server authentication",
      ),
      HandbookTopic(
        title: "9. Certificate Validation",
        content: "→ Client verifies that the server's TLS certificate is trusted and valid. Checks can include: Normally URLSession performs standard TLS validation automatically.",
        keyPoints: ["Certificate chain", "Trusted CA", "Hostname"],
      ),
      HandbookTopic(
        title: "10. Certificate Pinning",
        content: "→ App restricts trusted server identity to a known certificate or public key instead of relying only on the system trust store. Concept: Protects against certain: → Pins the server certificate. → Pins the public key rather than the entire certificate. Public-key pinning can be easier to maintain across certificate renewal. Pinning creates operation",
        codeSnippet: "Server Certificate         │         ▼ Expected Certificate/Public Key         │         ▼ Match?  ┌──────┴──────┐  YES           NO  │              │ Allow          Reject",
        keyPoints: ["Man-in-the-middle attacks", "Compromised CA scenarios", "Unexpected certificate substitution"],
      ),
      HandbookTopic(
        title: "11. URLSession + Secure Networking",
        content: "Recommended architecture: Security responsibilities should not be scattered throughout ViewControllers.",
        codeSnippet: "View  ↓ ViewModel  ↓ UseCase  ↓ Repository  ↓ APIClient  ↓ URLSession  ↓ HTTPS/TLS  ↓ Server",
      ),
      HandbookTopic(
        title: "12. Authentication Token Security",
        content: "→ Short-lived credential used to access protected APIs. → Longer-lived credential used to obtain a new access token. Typical flow: Prefer:",
        codeSnippet: "Login   ↓ Access Token + Refresh Token   ↓ Keychain   ↓ API Request   ↓ 401   ↓ Refresh Token   ↓ New Access Token   ↓ Retry Request",
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 17,
    title: "Push Notifications & APNs Architecture",
    topics: [
      HandbookTopic(
        title: "1. APNs",
        content: "→ Apple Push Notification service (APNs) is Apple's infrastructure for delivering remote notifications to Apple devices.",
        codeSnippet: "Your Server     ↓     APNs     ↓  iPhone / iPad     ↓    App",
      ),
      HandbookTopic(
        title: "2. APNs Provider",
        content: "→ The APNs provider is your backend service that sends notification requests to Apple's APNs servers.",
      ),
      HandbookTopic(
        title: "3. APNs Device Token",
        content: "→ A device token is an opaque identifier issued by APNs that your server uses to target an app installation on a device. Important: Don't hard-code or assume its format.",
      ),
      HandbookTopic(
        title: "4. APNs Environment",
        content: "→ APNs uses development/sandbox and production environments for notification delivery. Your provisioning/signing and APNs configuration determine the environment.",
      ),
      HandbookTopic(
        title: "5. Register for Remote Notifications",
        content: "→ registerForRemoteNotifications() asks iOS to register the app with APNs.",
        codeSnippet: "registerForRemoteNotifications()",
      ),
      HandbookTopic(
        title: "6. didRegisterForRemoteNotificationsWithDeviceToken",
        content: "→ Called when APNs successfully provides a device token.",
        codeSnippet: "func application(     _ application: UIApplication,     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data ) {     // Send token to backend }",
      ),
      HandbookTopic(
        title: "7. Token Refresh",
        content: "→ An app should register for remote notifications at launch and send the current token to its backend rather than assuming a token is permanently unchanged.",
      ),
      HandbookTopic(
        title: "8. UNUserNotificationCenter",
        content: "→ UNUserNotificationCenter manages notification authorization, scheduling, categories, and handling notification interactions.",
        codeSnippet: "UNUserNotificationCenter",
      ),
      HandbookTopic(
        title: "9. Authorization Request",
        content: "→ The app requests permission for notification capabilities such as alerts, sounds, and badges.",
        codeSnippet: "UNUserNotificationCenter.current()     .requestAuthorization(         options: [.alert, .sound, .badge]     )",
      ),
      HandbookTopic(
        title: "10. Authorization Status",
        content: "→ The notification authorization status indicates whether the user has allowed or denied notification permission. Common states include:",
        codeSnippet: ".notDetermined .denied .authorized .provisional .ephemeral",
      ),
      HandbookTopic(
        title: "11. Provisional Authorization",
        content: "→ Provisional authorization allows certain notifications to be delivered quietly without immediately asking the user for full notification permission.",
      ),
      HandbookTopic(
        title: "12. Notification Payload",
        content: "→ A notification payload contains the data APNs delivers to the app/device. Typical structure:",
        codeSnippet: "{   \"aps\": {     \"alert\": {       \"title\": \"New Message\",       \"body\": \"You received a message\"     },     \"badge\": 1,     \"sound\": \"default\"   } }",
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 18,
    title: "Navigation Architecture & Universal Deep Linking",
    topics: [
      HandbookTopic(
        title: "Advanced iOS Deep Linking, Universal Links & Navigation Architecture",
        content: "Deep linking is one of the most important topics for a Senior iOS Engineer, because it connects external events—web URLs, push notifications, widgets, emails, Siri, QR codes—to the correct screen and application state.",
      ),
      HandbookTopic(
        title: "1. Deep Link",
        content: "Deep Link → A URL or identifier that opens the app directly to a specific destination. Example: or: Instead of: the user can go directly to:",
        codeSnippet: "myapp://product/123",
      ),
      HandbookTopic(
        title: "2. Types of Deep Links",
        content: "There are two major approaches: Universal Links are generally preferred for production because they use normal HTTPS URLs.",
        codeSnippet: "Deep Linking                          │              ┌───────────┴───────────┐              │                       │         Custom URL Scheme       Universal Links              │                       │        myapp://product/123     https://example.com/product/123",
      ),
      HandbookTopic(
        title: "3. Custom URL Scheme",
        content: "Register a scheme: Then: can launch your application. In Xcode: Example:",
        codeSnippet: "myapp://",
      ),
      HandbookTopic(
        title: "4. Handling URL Schemes",
        content: "With scenes, URL delivery commonly arrives through: Example: Parse:",
        codeSnippet: "func scene(     _ scene: UIScene,     openURLContexts URLContexts: Set<UIOpenURLContext> ) {     for context in URLContexts {         let url = context.url          DeepLinkRouter.shared.handle(url)     } }",
      ),
      HandbookTopic(
        title: "5. Problem With Custom URL Schemes",
        content: "Custom schemes are not exclusive. Another application could theoretically register the same scheme. For example: doesn't provide the same ownership guarantee as: That's one reason Universal Links are preferred.",
        codeSnippet: "myapp://",
      ),
      HandbookTopic(
        title: "6. Universal Links",
        content: "Universal Link → An HTTPS URL that can open your app directly when the domain is associated with the app. Example: If the app is installed: If the app isn't installed: This graceful fallback is a major advantage.",
        codeSnippet: "https://example.com/product/123",
      ),
      HandbookTopic(
        title: "7. Associated Domains",
        content: "To support Universal Links, add the capability: Then: You can also have: depending on your architecture.",
        codeSnippet: "Associated Domains",
      ),
      HandbookTopic(
        title: "8. apple-app-site-association",
        content: "The website must publish an: file. Usually available at: The file tells iOS: This website trusts this application for these URL paths. Example conceptually: Now: can open:",
        codeSnippet: "apple-app-site-association",
      ),
      HandbookTopic(
        title: "9. Universal Link Architecture",
        content: "Universal Links provide secure, standard HTTP/HTTPS deep linking into iOS applications verified via two-way trust:\n• apple-app-site-association (AASA): A JSON file hosted on the website root (https://domain.com/.well-known/apple-app-site-association) declaring authorized app bundle IDs and path components.\n• Associated Domains: Xcode entitlement (applinks:domain.com) declaring domain ownership.\n• If the app is installed, iOS launches the app directly via scene(_:continue:) without opening Safari. If uninstalled, it seamlessly opens the web page in Safari.",
        codeSnippet: "// SceneDelegate Universal Link Handler\nfunc scene(_ scene: UIScene, continue userActivity: NSUserActivity) {\n    guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,\n          let url = userActivity.webpageURL else { return }\n    AppRouter.shared.route(to: url)\n}",
        keyPoints: [
          "Cannot be hijacked by competing apps, unlike custom URL schemes.",
          "Requires AASA file hosted over HTTPS with valid SSL certificate without redirects.",
          "Seamless fallback to web browser if app is not installed on the user device."
        ],
              ),
      HandbookTopic(
        title: "10. Handling Universal Links",
        content: "With scenes:",
        codeSnippet: "func scene(     _ scene: UIScene,     continue userActivity: NSUserActivity ) {     guard         userActivity.activityType ==             NSUserActivityTypeBrowsingWeb,         let url = userActivity.webpageURL     else {         return     }      DeepLinkRouter.shared.handle(url) }",
      ),
      HandbookTopic(
        title: "11. NSUserActivity",
        content: "Universal Links are delivered through: The important property is: Example:",
        codeSnippet: "NSUserActivity",
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 19,
    title: "Xcode Build Systems, Configurations & CI/CD Pipelines",
    topics: [
      HandbookTopic(
        title: "Advanced Xcode Build System & App Configuration",
        content: "This is a Senior iOS Engineer topic because large production apps rarely have just one target, one environment, and one configuration. The mental model:",
        codeSnippet: "Workspace    ↓ Project    ↓ Targets    ↓ Configurations    ↓ Schemes    ↓ Build Settings    ↓ Build Phases    ↓ Product",
      ),
      HandbookTopic(
        title: "1. Xcode Project",
        content: "Xcode Project (.xcodeproj) → Defines targets, build configurations, build settings, source files, resources, and dependencies for an application/library.",
        codeSnippet: ".xcodeproj",
      ),
      HandbookTopic(
        title: "2. Xcode Workspace",
        content: "Workspace (.xcworkspace) → Container that can hold multiple Xcode projects and coordinate them together. Common with: With Swift Package Manager, package dependencies can also participate in the workspace/build graph.",
        codeSnippet: ".xcworkspace",
      ),
      HandbookTopic(
        title: "3. Target",
        content: "Target → Defines a specific product that Xcode knows how to build. Examples: A project can contain multiple targets.",
        codeSnippet: "MyApp MyAppTests MyAppUITests ShareExtension NotificationService WidgetExtension",
      ),
      HandbookTopic(
        title: "4. Build Configuration",
        content: "Build Configuration → A named collection of build settings controlling how a target is built. Typical: You can create:",
        codeSnippet: "Debug Release",
      ),
      HandbookTopic(
        title: "5. Scheme",
        content: "Scheme → Defines how Xcode builds, runs, tests, profiles, archives, and analyzes one or more targets. Example: A scheme can select:",
        codeSnippet: "MyApp-Dev MyApp-QA MyApp-Production",
      ),
      HandbookTopic(
        title: "6. Target vs Configuration vs Scheme",
        content: "This is a common interview question. Think:",
        codeSnippet: "TARGET \"What am I building?\"  CONFIGURATION \"How am I building it?\"  SCHEME \"How should Xcode use that configuration?\"",
      ),
      HandbookTopic(
        title: "7. Build Setting",
        content: "Build Setting → A configuration value that controls compilation, linking, packaging, signing, or other build behavior. Examples:",
        codeSnippet: "PRODUCT_NAME PRODUCT_BUNDLE_IDENTIFIER SWIFT_VERSION SWIFT_OPTIMIZATION_LEVEL CODE_SIGN_STYLE DEVELOPMENT_TEAM MARKETING_VERSION CURRENT_PROJECT_VERSION",
      ),
      HandbookTopic(
        title: "8. Build Settings Hierarchy",
        content: "Build settings can come from multiple levels. Conceptually: The exact precedence can depend on the setting/source, so don't memorize it as a universal simple list. Senior principle: Always inspect the resolved build setting rather than assuming where its value came from.",
        codeSnippet: "Default    ↓ Project    ↓ Target    ↓ Configuration    ↓ .xcconfig    ↓ Command-line overrides",
      ),
      HandbookTopic(
        title: "9. .xcconfig",
        content: ".xcconfig → Text-based configuration file used to define Xcode build settings outside the project UI. Example:",
        codeSnippet: ".xcconfig",
      ),
      HandbookTopic(
        title: "10. Why Use .xcconfig?",
        content: "Without .xcconfig: With .xcconfig: It is especially useful for multi-environment applications.",
        codeSnippet: ".xcconfig",
      ),
      HandbookTopic(
        title: "11. Recommended Configuration Structure",
        content: "For example: You can use includes to compose configuration.",
        codeSnippet: "Config/ ├── Base.xcconfig ├── Debug.xcconfig ├── Release.xcconfig ├── Dev.xcconfig ├── Staging.xcconfig └── Production.xcconfig",
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 20,
    title: "Code Signing, App Store Connect & Phased Release Engineering",
    topics: [
      HandbookTopic(
        title: "1. CI — Continuous Integration",
        content: "→ Continuous Integration automatically builds and tests code whenever developers integrate changes into a shared repository. Typical flow:",
        codeSnippet: "Code Push    ↓ Build    ↓ Unit Tests    ↓ Lint / Static Analysis    ↓ Report",
      ),
      HandbookTopic(
        title: "2. CD — Continuous Delivery",
        content: "→ Continuous Delivery automatically prepares validated builds so they are always ready for release, usually requiring manual approval for production deployment.",
      ),
      HandbookTopic(
        title: "3. Continuous Deployment",
        content: "→ Continuous Deployment automatically releases validated builds to production without a manual deployment step.",
        codeSnippet: "CI → Build + Test  Continuous Delivery → Build + Test + Release-ready  Continuous Deployment → Build + Test + Automatically Deploy",
      ),
      HandbookTopic(
        title: "4. Git",
        content: "→ Git is a distributed version-control system used to track code changes and collaborate across development branches.",
      ),
      HandbookTopic(
        title: "5. Git Branch",
        content: "→ A Git branch is an independent line of development that allows changes to be developed without directly modifying another branch.",
      ),
      HandbookTopic(
        title: "6. Feature Branch",
        content: "→ A feature branch isolates development of a specific feature or task from the main development branch.",
        codeSnippet: "main  ├── feature/login  ├── feature/payment  └── feature/profile",
      ),
      HandbookTopic(
        title: "7. Pull Request",
        content: "→ A Pull Request proposes changes from one branch to another and provides a place for code review, discussion, and automated checks.",
      ),
      HandbookTopic(
        title: "8. Merge",
        content: "→ Merge combines changes from one Git branch into another branch.",
      ),
      HandbookTopic(
        title: "9. Rebase",
        content: "→ Rebase moves a branch's commits onto a new base commit, creating a cleaner linear history.",
        codeSnippet: "Merge → Combines histories.  Rebase → Rewrites branch history onto a new base.",
      ),
      HandbookTopic(
        title: "10. Pipeline",
        content: "→ A CI/CD pipeline is an automated sequence of steps that builds, tests, validates, packages, and optionally deploys an application. Typical iOS pipeline:",
        codeSnippet: "Git Push    ↓ Install Dependencies    ↓ Build    ↓ Unit Tests    ↓ Lint    ↓ Archive    ↓ Code Sign    ↓ Upload    ↓ TestFlight",
      ),
      HandbookTopic(
        title: "11. Pipeline Stage",
        content: "→ A stage is a logical group of related CI/CD jobs, such as build, test, archive, or deployment.",
      ),
      HandbookTopic(
        title: "12. CI/CD Job",
        content: "→ A job is an individual automated task executed by the CI/CD system. Examples:",
        codeSnippet: "Build Unit Test Lint Archive Deploy",
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 21,
    title: "Observability, Logging, MetricKit & Production Monitoring",
    topics: [
      HandbookTopic(
        title: "Advanced iOS Analytics, Observability & Production Monitoring",
        content: "At Senior/Lead level, analytics is not just: You need to design a system that answers: What are users doing, is the app working correctly, how fast is it, and why did something fail?",
        codeSnippet: "Analytics.logEvent(...)",
      ),
      HandbookTopic(
        title: "1. Analytics",
        content: "Analytics → Collection of product and user-behavior events used to understand how the application is being used. Examples: Analytics answers: What happened from the user's/product perspective?",
        codeSnippet: "Screen Viewed Button Tapped Search Performed Purchase Completed Onboarding Completed Feature Used",
      ),
      HandbookTopic(
        title: "2. Observability",
        content: "Observability → The ability to understand the internal state of a running system from its emitted telemetry. The three classic pillars are: Detailed events. Numerical measurements over time. A request/workflow across multiple components.",
        codeSnippet: "Observability                    │        ┌───────────┼───────────┐        │           │           │       Logs       Metrics     Traces",
      ),
      HandbookTopic(
        title: "3. Analytics vs Logging vs Metrics vs Tracing",
        content: "Example:",
        codeSnippet: "User taps \"Buy\"        │        ├── Analytics → purchase_started        │        ├── Log → request created        │        ├── Metric → API latency = 420ms        │        ├── Trace → checkout → payment → order        │        └── Crash report → crash during payment flow",
      ),
      HandbookTopic(
        title: "4. Why Analytics Should Be Abstracted",
        content: "Bad: inside 100 ViewControllers. This creates: everywhere. Instead: Then: Now the vendor is an implementation detail.",
        codeSnippet: "FirebaseAnalytics.logEvent(...)",
      ),
      HandbookTopic(
        title: "5. Analytics Event",
        content: "Avoid arbitrary strings: Prefer typed events: Then: Advantages:",
        codeSnippet: "track(\"button_clicked\")",
        keyPoints: ["compile-time safety", "discoverability", "consistent naming"],
      ),
      HandbookTopic(
        title: "6. Analytics Event Schema",
        content: "A production event should have a stable schema. Example: Avoid changing: to: randomly across releases. Analytics is effectively an API contract.",
        codeSnippet: "Event: product_viewed  Properties: product_id category source",
      ),
      HandbookTopic(
        title: "7. Analytics Naming",
        content: "Prefer consistent naming: rather than: Define conventions centrally.",
        codeSnippet: "product_viewed checkout_started payment_completed",
      ),
      HandbookTopic(
        title: "8. Analytics Context",
        content: "Some information is common across events: Conceptually: Then:",
        codeSnippet: "App Version OS Version Device Locale Environment Session ID User ID",
      ),
      HandbookTopic(
        title: "9. Session ID",
        content: "Session ID → An identifier used to group events belonging to a logical app session. Example: This helps analyze user journeys. Don't confuse: with: They serve completely different purposes.",
        codeSnippet: "Session A  ├── app_opened  ├── screen_viewed  ├── product_viewed  └── checkout_started",
      ),
      HandbookTopic(
        title: "10. User ID",
        content: "Analytics may associate events with a user identifier. But: Never send unnecessary personally identifiable information. Avoid: as analytics properties. Prefer an internal, non-sensitive identifier where appropriate.",
        codeSnippet: "email phone number password access token refresh token",
      ),
      HandbookTopic(
        title: "11. Privacy",
        content: "Analytics must follow: Don't collect something simply because: \"Maybe we'll need it later.\" Ask: Why do we need this data?",
        codeSnippet: "Data Minimization        + Purpose Limitation        + User Privacy        + Security",
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 22,
    title: "Accessibility (a11y), Localization & Inclusive UI Engineering",
    topics: [
      HandbookTopic(
        title: "Module 36: Advanced iOS Accessibility, Localization & Inclusive UI Engineering",
        content: "For a senior iOS engineer, building a screen that looks correct is only part of the job. The screen should also work for people using VoiceOver, larger text sizes, Switch Control, different languages, right-to-left layouts, and other accessibility features. Accessibility and localization are not last-minute UI polish. They affect view architecture,",
      ),
      HandbookTopic(
        title: "1. Understand the accessibility architecture",
        content: "Think of an interface as having two representations: A visually clear button might still be inaccessible if it has no meaningful label. Conversely, a screen reader may expose too many individual elements, making a simple task exhausting. Your UI     UIKit views or SwiftUI views              Accessibility semantics     Labels, values, traits, action",
        keyPoints: ["Visual representation: what sighted users see.", "Accessibility representation: the semantic elements assistive technologies can discover and operate."],
      ),
      HandbookTopic(
        title: "2. VoiceOver: make controls understandable",
        content: "VoiceOver reads accessibility information rather than simply describing pixels. Imagine a screen showing a magnifying-glass icon. Without an accessible label, VoiceOver might announce an ambiguous symbol or an unhelpful name. Why does this matter? Prefer semantic system controls over custom gestures when possible. A custom onTapGesture may not expo",
        codeSnippet: "import SwiftUI  struct SearchButton: View {     var action: () -> Void      var body: some View {         Button(action: action) {             Image(systemName: \"magnifyingglass\")         }         .accessibilityLabel(\"Search\")         .accessibilityHint(\"Search for topics\")     } }",
        keyPoints: ["The label tells the user what the control is.", "The hint can explain a less obvious consequence.", "A real Button provides built-in button semantics and activation behavior."],
      ),
      HandbookTopic(
        title: "3. Accessibility grouping and reading order",
        content: "Consider a learning-app card that shows a topic title, completion percentage, progress bar and an “Open topic” button. Should VoiceOver expose four separate elements or one combined element? It depends on the interaction. This design makes the card one interactive element. Because the progress bar and text are inside the button, verify that the res",
        codeSnippet: "struct TopicProgressCard: View {     let title: String     let completedPercent: Int     let openTopic: () -> Void      var body: some View {         Button(action: openTopic) {             VStack(alignment: .leading, spacing: 8) {                 Text(title)                     .font(.headline)                  ProgressView(                     value: Double(completedPercent),                     total: 100                 )                  Text(\"\\(completedPercent)% completed\")               ",
        keyPoints: ["If the entire card opens the topic, a single well-labelled button may be appropriate.", "If the card contains independent actions, preserve separate controls.", "If the progress bar conveys useful information, make sure that information is available in the accessible representation."],
      ),
      HandbookTopic(
        title: "4. Dynamic Type: support larger text without breaking layouts",
        content: "Dynamic Type allows users to choose text sizes that suit their needs. It is not enough to increase a font slightly; the entire layout must adapt. Common failures include: System text styles such as .headline and .subheadline adapt to Dynamic Type. Allowing the text to wrap and avoiding rigid heights helps the layout expand. For a custom font, use a",
        codeSnippet: "struct LessonRow: View {     let title: String     let subtitle: String      var body: some View {         VStack(alignment: .leading, spacing: 8) {             Text(title)                 .font(.headline)                 .fixedSize(horizontal: false, vertical: true)              Text(subtitle)                 .font(.subheadline)                 .foregroundStyle(.secondary)                 .fixedSize(horizontal: false, vertical: true)         }         .frame(maxWidth: .infinity, alignment: .lea",
        keyPoints: ["Text clipping inside fixed-height cells.", "Buttons whose labels disappear.", "Horizontal stacks overflowing."],
      ),
      HandbookTopic(
        title: "5. Touch targets, contrast and non-color cues",
        content: "Accessibility includes more than screen readers. Small icons can be visually attractive but difficult to activate. Apple recommends designing comfortably sized controls; the commonly cited baseline is approximately 44 × 44 points for iOS hit targets. A small visible icon can still have a larger interactive region. This example creates a larger cont",
        codeSnippet: "Button(action: dismiss) {     Image(systemName: \"xmark\")         .frame(width: 44, height: 44)         .contentShape(Rectangle()) } .accessibilityLabel(\"Close\")",
        keyPoints: ["A visible error message.", "An appropriate accessibility announcement or association.", "A meaningful visual indicator."],
      ),
      HandbookTopic(
        title: "6. Localization architecture: stop hardcoding user-facing strings",
        content: "Localization is the process of adapting an app's text and other user-facing content for different languages and regions. A common mistake is writing strings directly into views: This works for a single language, but it doesn't scale well. Some languages use different word order, grammatical gender, plural rules or longer text. Modern Xcode projects",
        codeSnippet: "Text(\"You have 3 lessons remaining\")",
      ),
      HandbookTopic(
        title: "7. Pluralization and formatted values",
        content: "Pluralization is more complex than choosing between a singular and plural English noun. Languages have different plural categories and grammatical rules. This hardcodes English grammar into application logic. Create a plural-aware string entry in your String Catalog and configure the appropriate plural variations for each language. Then use a local",
        codeSnippet: "let message = count == 1     ? \"1 lesson remaining\"     : \"\\(count) lessons remaining\"",
        keyPoints: ["Localize user-facing strings and accessibility labels.", "Support pluralization and grammatical variations.", "Use locale-aware date, time, number and currency formatting."],
      ),
      HandbookTopic(
        title: "8. Right-to-left (RTL) layouts",
        content: "Languages such as Arabic and Hebrew commonly use right-to-left reading direction. RTL support involves more than translating strings. It affects: In SwiftUI: Using .leading and .trailing allows the layout to follow the effective layout direction. Avoid hardcoding .left and .right unless the design genuinely refers to a physical side. In UIKit, pref",
        codeSnippet: "VStack(alignment: .leading) {     Text(\"Learning dashboard\")         .font(.headline)      Text(\"Continue your preparation\")         .foregroundStyle(.secondary) } .frame(maxWidth: .infinity, alignment: .leading)",
        keyPoints: ["Horizontal layout direction.", "Leading and trailing alignment.", "Navigation and directional icons."],
      ),
      HandbookTopic(
        title: "9. Accessible state changes and announcements",
        content: "A screen can be accessible at first render and still become confusing when its content changes. Imagine a user presses “Submit” and the app begins processing. If the button's state changes visually but VoiceOver receives no useful feedback, the user may not know whether the action worked. This example exposes a visible loading state and prevents re",
        codeSnippet: "struct SubmitButton: View {     @State private var isSubmitting = false      var body: some View {         Button {             guard !isSubmitting else { return }              Task {                 isSubmitting = true                 defer { isSubmitting = false }                  await submitForm()             }         } label: {             if isSubmitting {                 ProgressView(\"Submitting…\")             } else {                 Text(\"Submit\")             }         }         .disab",
      ),
      HandbookTopic(
        title: "10. Accessible custom controls",
        content: "Custom sliders, charts, drag-and-drop interfaces and other interactive views need more care than standard buttons and text fields. A custom control may need: If a rating is genuinely adjustable, expose its value and increment/decrement behavior. For many simple controls, a standard Slider or stepper is preferable to implementing custom behavior. Th",
        codeSnippet: "Slider",
        keyPoints: ["An accessible label.", "Its current value.", "Appropriate traits."],
      ),
      HandbookTopic(
        title: "11. Accessibility in reusable component architecture",
        content: "For a large application, avoid implementing accessibility independently in every feature. Create reusable components with consistent semantics. For example: A reusable form field should have a label, value, required-state information where relevant, and a meaningful way to discover validation errors. This is a starting point, not a complete validat",
        codeSnippet: "AccessibleIconButton",
        keyPoints: ["AccessibleIconButton", "FormField", "ValidationMessage"],
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 23,
    title: "iOS System Design — Senior & Lead Architecture Blueprints",
    topics: [
      HandbookTopic(
        title: "Advanced iOS System Design — Senior/Lead Module",
        content: "This module is about designing large-scale iOS applications, making architectural decisions, handling offline data, networking, concurrency, caching, scalability, and explaining trade-offs in interviews.",
      ),
      HandbookTopic(
        title: "1. System Design",
        content: "→ The process of defining how application components interact to satisfy functional, performance, scalability, reliability, and security requirements. For iOS:",
        codeSnippet: "UI  ↓ Presentation  ↓ Domain  ↓ Data  ├── Network  └── Local Storage",
      ),
      HandbookTopic(
        title: "2. Functional Requirements",
        content: "→ Describes what the system should do. Example:",
        codeSnippet: "User can: ✓ Login ✓ View products ✓ Search products ✓ Add to cart ✓ Place order",
      ),
      HandbookTopic(
        title: "3. Non-Functional Requirements",
        content: "→ Describes how well the system should operate. Examples: For iOS, also consider:",
        codeSnippet: "Performance Scalability Reliability Availability Security Maintainability Offline support Battery efficiency",
      ),
      HandbookTopic(
        title: "4. Scalability",
        content: "→ Ability of a system to handle increasing workload without unacceptable performance degradation. For mobile: Your app architecture should remain manageable.",
        codeSnippet: "10,000 users       ↓ 1,000,000 users",
      ),
      HandbookTopic(
        title: "5. Vertical vs Horizontal Scaling",
        content: "→ Increase resources of one server. → Add more servers. Backend concern, but mobile engineers should understand the implications.",
        codeSnippet: "Server  ↓ More CPU More RAM",
      ),
      HandbookTopic(
        title: "6. Availability",
        content: "→ Percentage of time a system remains operational and accessible. Example: Mobile apps should gracefully handle unavailable services.",
        codeSnippet: "99.9% availability",
      ),
      HandbookTopic(
        title: "7. Reliability",
        content: "→ Ability of the system to consistently perform correctly over time. Example:",
        codeSnippet: "Network failure       ↓ Retry       ↓ Fallback cache       ↓ User can continue",
      ),
      HandbookTopic(
        title: "8. Fault Tolerance",
        content: "→ Ability to continue functioning when some components fail. Example:",
        codeSnippet: "Network ❌    ↓ Local Cache    ↓ App still displays data",
      ),
      HandbookTopic(
        title: "9. Resilience",
        content: "→ Ability to recover from failures and continue providing useful behavior. Typical mechanisms:",
        codeSnippet: "Retry Timeout Fallback Cache Circuit Breaker Offline Mode",
      ),
      HandbookTopic(
        title: "11. Latency",
        content: "→ Time taken for an operation to produce a response. Example: Lower latency generally improves perceived performance.",
        codeSnippet: "Tap button    ↓ API request    ↓ 200 ms    ↓ Response",
      ),
      HandbookTopic(
        title: "12. Throughput",
        content: "→ Amount of work completed within a given time. Examples:",
        codeSnippet: "Requests/second Transactions/second Messages/second",
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 24,
    title: "Reliability, Resilience Engineering & Incident Management",
    topics: [
      HandbookTopic(
        title: "Offline-first architecture, retries, idempotency, circuit breakers, graceful degradation & failure recovery",
        content: "For a Senior/Lead iOS Engineer, building a feature that works when everything is healthy is only half the job. Production apps must also behave correctly when the network is unavailable, a server is overloaded, a request times out, a user taps twice, or the app is terminated halfway through an operation. Consider a food-delivery app: This is a reli",
        keyPoints: ["The user places an order, but the response times out.", "The app cannot tell whether the server created the order.", "The user taps “Place order” again."],
      ),
      HandbookTopic(
        title: "1. Reliability vs. availability vs. resilience",
        content: "These terms are related, but they describe different properties. A failed dependency should not automatically become a failed user experience. For example, if a news feed cannot refresh, you may still display cached articles and a “Last updated” timestamp. If a payment cannot be confirmed, however, you must not falsely report that it succeeded. Dif",
      ),
      HandbookTopic(
        title: "2. Classify failures before designing recovery",
        content: "Not all failures should be retried in the same way. Connectivity failure Timeout or ambiguous result Server failure Persistence failure Also distinguish transient failures from permanent ones: Senior-level rule: classify the failure first; select the recovery strategy second.",
        codeSnippet: "*The device has no usable route to the service, or a connection cannot be established.*   *Response: preserve local state, show cached data where appropriate, and retry when reasonable.* </box>",
        keyPoints: ["A temporary server error may recover.", "A malformed request usually won't succeed when repeated unchanged.", "An expired authentication token may require refreshing credentials."],
      ),
      HandbookTopic(
        title: "3. Retry policies: exponential backoff and jitter",
        content: "A retry repeats an operation after a failure. It is useful for transient errors, but uncontrolled retries can make an outage worse. Imagine 100,000 devices retrying a failing API every second. When the server begins recovering, all those clients hit it simultaneously. This creates a retry storm. A common policy increases the delay after each attemp",
        codeSnippet: "Retry-After",
        keyPoints: ["(d_0) is the initial delay.", "(n) is the retry number, starting at zero.", "(d_{\\max}) is the maximum delay."],
      ),
      HandbookTopic(
        title: "4. Idempotency: prevent duplicate operations",
        content: "Idempotency is one of the most important reliability concepts in mobile engineering. An operation is idempotent when repeating it produces the same intended effect as performing it once. Mathematically: [ f(f(x)) = f(x) ] For HTTP APIs, PUT and DELETE are defined as idempotent methods in terms of their intended server effect, while POST is not inhe",
        codeSnippet: "PUT",
        keyPoints: ["Accept an idempotency key.", "Associate it with the logical operation and relevant request data.", "Prevent concurrent duplicates from creating multiple effects."],
      ),
      HandbookTopic(
        title: "5. Request deduplication and single-flight execution",
        content: "Sometimes multiple parts of the app request the same resource simultaneously. For example: Request deduplication lets them share one in-flight operation when the requests are genuinely equivalent. A simple actor-based example for a single resource: This demonstrates the single-flight concept, but it is a simplified sketch, not a complete production",
        codeSnippet: "actor ProfileRepository {     private var inFlight: Task<Profile, Error>?      func profile(         load: @escaping @Sendable () async throws -> Profile     ) async throws -> Profile {         if let inFlight {             return try await inFlight.value         }          let task = Task {             try await load()         }          inFlight = task          do {             let profile = try await task.value             inFlight = nil             return profile         } catch {           ",
        keyPoints: ["A screen requests the current profile.", "A header requests the same profile.", "A settings component requests the same profile."],
      ),
      HandbookTopic(
        title: "6. Circuit breakers: stop calling a failing dependency",
        content: "A circuit breaker protects your app and backend from repeated requests to a dependency that is consistently failing. It commonly has three states. CLOSED       Normal operation          Requests are allowed. Failures are monitored, and the breaker opens when its configured failure policy is met.                Failure threshold reached             ",
        keyPoints: ["Retry: try an operation again because a failure may be transient.", "Circuit breaker: stop sending requests when repeated failures indicate a dependency is unhealthy.", "Timeout: stop waiting beyond an acceptable duration."],
      ),
      HandbookTopic(
        title: "7. Offline-first architecture",
        content: "An offline-first app treats local data as an important part of the user experience rather than merely a temporary network cache. Examples include notes, messaging, task management, document editing, and some browsing experiences. Offline-first does not mean every action can be completed offline. A bank transfer, for example, may require server auth",
        codeSnippet: "*Displays local state and pending/sync status*",
        keyPoints: ["Read available local data.", "Render it immediately.", "Refresh from the server when appropriate."],
      ),
      HandbookTopic(
        title: "8. Durable outbox pattern",
        content: "An outbox is a persistent queue of operations that need to be delivered to another system. It is useful when users must be able to make changes offline or when operations must survive process termination. Example schema: The exact schema depends on the domain. Avoid storing credentials or unnecessary sensitive data in queued payloads. Imagine a use",
        codeSnippet: "operationID",
      ),
      HandbookTopic(
        title: "9. Cache consistency and conflict resolution",
        content: "Offline edits introduce a harder question: what happens when both the server and the device change the same record? Suppose two devices edit a task title while offline. A naive last-write-wins policy may discard one user's work. Timestamps alone are not always a reliable conflict-resolution mechanism because clocks may differ and edits may be concu",
        codeSnippet: "ETag",
        keyPoints: ["Device A changes it to “Prepare release.”", "Device B changes it to “Fix launch crash.”", "Both later synchronize."],
      ),
      HandbookTopic(
        title: "10. Graceful degradation and user experience",
        content: "Graceful degradation means that when a feature or dependency fails, the app preserves as much useful functionality as possible without misrepresenting the outcome. Examples: The last case is particularly important. Don't convert an ambiguous result into a false success or failure. A Boolean such as isLoading cannot represent all the states of a rel",
        codeSnippet: "isLoading",
        keyPoints: ["Feed refresh fails → show cached content and a refresh warning.", "Avatar service fails → show a placeholder.", "Recommendations fail → show the core catalog without recommendations."],
      ),
      HandbookTopic(
        title: "11. Network reachability is not server health",
        content: "iOS provides NWPathMonitor through Network framework to observe changes in network path status. That can help the app decide when to update connectivity indicators or schedule an attempt, but there is an important distinction: A satisfied network path does not guarantee that your API is reachable or healthy. The device may have Wi-Fi connectivity w",
        codeSnippet: "NWPathMonitor",
        keyPoints: ["The internet connection is broken.", "DNS resolution fails.", "The server is unavailable."],
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 25,
    title: "Real-Time Communication (WebSockets, SSE) & Transport Security",
    topics: [
      HandbookTopic(
        title: "Advanced iOS Networking & Distributed Systems — Senior/Lead Module",
        content: "This module goes deeper into HTTP, URLSession, TLS, caching, distributed failures, retries, real-time communication, synchronization, and production API-client design.",
      ),
      HandbookTopic(
        title: "1. HTTP",
        content: "→ Application-layer protocol used for communication between clients and servers. Typical flow:",
        codeSnippet: "iOS App    ↓ HTTP Request    ↓ Server    ↓ HTTP Response    ↓ iOS App",
      ),
      HandbookTopic(
        title: "2. HTTP Request",
        content: "A request contains: Example:",
        codeSnippet: "Method URL Headers Query Parameters Body",
      ),
      HandbookTopic(
        title: "3. HTTP Response",
        content: "A response contains: Example:",
        codeSnippet: "Status Code Headers Body",
      ),
      HandbookTopic(
        title: "4. HTTP Methods",
        content: "→ Retrieves data. → Creates or triggers an operation. → Replaces a resource. → Partially updates a resource. → Deletes a resource.",
      ),
      HandbookTopic(
        title: "5. Safe HTTP Method",
        content: "→ Intended not to modify server state. GET is considered safe.",
      ),
      HandbookTopic(
        title: "6. Idempotent HTTP Method",
        content: "→ Repeating the same request has the same intended effect as performing it once. Generally: POST is generally not inherently idempotent.",
        codeSnippet: "GET      → idempotent PUT      → idempotent DELETE   → idempotent",
      ),
      HandbookTopic(
        title: "7. HTTP Status Codes",
        content: "Essential HTTP response status codes for mobile networking architectures:\n• 200 OK / 201 Created: Request succeeded.\n• 204 No Content: Successful request with no body (common in DELETE/PUT).\n• 304 Not Modified: Cache validation header match (ETag / If-None-Match); reuse local cache.\n• 400 Bad Request: Malformed request payload.\n• 401 Unauthorized: Access token missing or expired; trigger silent OAuth refresh flow.\n• 403 Forbidden: Valid credentials but insufficient user permissions.\n• 404 Not Found: Entity missing or deleted.\n• 429 Too Many Requests: Rate limited; read 'Retry-After' response header.\n• 500 / 502 / 503 / 504: Server errors; trigger exponential backoff retry queue.",
        codeSnippet: "guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }\nswitch httpResponse.statusCode {\ncase 200...299: return data\ncase 401: await AuthManager.shared.refreshToken()\ncase 429: /* Handle rate limiting */\ndefault: throw NetworkError.serverError(httpResponse.statusCode)\n}",
        keyPoints: [
          "401 triggers token refresh; 403 shows permission denied alert.",
          "304 saves mobile cellular bandwidth and battery consumption.",
          "5xx errors should never be retried instantly; use exponential backoff with jitter."
        ],
              ),
      HandbookTopic(
        title: "8. 401 vs 403",
        content: "→ Authentication is missing/invalid. Typical: → User is authenticated but doesn't have permission.",
        codeSnippet: "Access token expired",
      ),
      HandbookTopic(
        title: "9. HTTP Headers",
        content: "→ Metadata sent with an HTTP request or response. Examples:",
        codeSnippet: "Authorization Content-Type Accept Cache-Control ETag User-Agent Retry-After",
      ),
      HandbookTopic(
        title: "10. Content-Type",
        content: "→ Describes the format of the request/response body. Example:",
        codeSnippet: "Content-Type",
      ),
      HandbookTopic(
        title: "11. Accept",
        content: "→ Indicates which response formats the client can handle. Example:",
        codeSnippet: "Accept",
      ),
    ],
  ),
  HandbookDomain(
    domainNumber: 26,
    title: "Master Definition Lexicon, Core Bluetooth & Fast Revision Bank",
    topics: [
      HandbookTopic(
        title: "Swift Type System",
        content: "Swift's type system is statically typed and strongly typed with type inference. It cleanly separates value types (structs, enums, tuples) from reference types (classes, actors). Value types are copied on assignment (COW for collections), eliminating thread safety hazards. Reference types share a single heap identity via 64-bit stack pointers. Generics (<T>) provide compile-time specialization and static dispatch, opaque types ('some Protocol') hide concrete types while maintaining static type identity, and existential types ('any Protocol') box instances in dynamic 40-byte containers at runtime.",
        codeSnippet: "// Swift 6 Static Type System Specialization\nfunc processItem<T: Identifiable & Sendable>(_ item: T) -> some View {\n    Text(\"ID: \\(item.id)\")\n}",
        keyPoints: [
          "Value types (structs, enums) vs Reference types (classes, actors).",
          "Generics (<T>) compile down to specialized direct machine instructions.",
          "Opaque types (some) provide reverse generics with single static identity.",
          "Existential types (any) box arbitrary types at the cost of heap allocation and witness table lookup."
        ],
      ),
      HandbookTopic(
        title: "OOP Concepts",
        content: "Core Object-Oriented Programming (OOP) paradigms in Swift:\n• Encapsulation: Restricting direct access to state via private/internal access modifiers, exposing safe mutating methods.\n• Inheritance: Single inheritance supported only by classes, establishing 'is-a' relationships and V-Table method dispatch.\n• Polymorphism: Subtype polymorphism via class overriding, and ad-hoc/parametric polymorphism via protocols and generics.\n• Abstraction: Modeling interfaces via protocols without coupling clients to concrete classes.",
        codeSnippet: "public class Vehicle {\n    public func startEngine() { print(\"Vroom\") }\n}\npublic final class ElectricCar: Vehicle {\n    public override func startEngine() { print(\"Silent Start\") }\n}",
        keyPoints: [
          "Encapsulation protects invariants and enforces memory safety.",
          "Inheritance is restricted to classes; prefer composition via protocols.",
          "Polymorphism is achieved through Protocol Witness Tables and V-Tables.",
          "Abstraction decouples high-level policy from low-level implementation."
        ],
              ),
      HandbookTopic(
        title: "Memory Management",
        content: "Memory in iOS is divided into Stack and Heap:\n• Stack: Extremely fast LIFO allocation (adjusting stack pointer SP on ARM64). Stores local value types and pointer addresses.\n• Heap: Dynamic memory allocated via swift_allocObject (malloc). Stores class instances, actor states, and escaping closures.\n• ARC (Automatic Reference Counting) tracks heap allocations at compile time, inserting retain and release instructions.\n• Weak references point to out-of-line Side Tables to allow lazy zeroing when the target is deallocated, preventing dangling pointers.",
        codeSnippet: "final class DataStore {\n    weak var delegate: StoreDelegate?\n    deinit { print(\"Deallocated cleanly without retain cycle\") }\n}",
        keyPoints: [
          "Stack allocation requires zero locking; heap allocation acquires mutex locks on memory arenas.",
          "ARC operates at compile time without non-deterministic garbage collection pauses.",
          "Weak references must always be optional (var) and automatically zero upon dealloc.",
          "Unowned references assume the object is never nil; accessing a deallocated unowned object traps at runtime."
        ],
              ),
      HandbookTopic(
        title: "Copying",
        content: "Comprehensive architectural principles, thread-safety invariants, and production engineering best practices for senior iOS interviews.",
        codeSnippet: "Value Type → A value type creates a new independent copy when assigned or passed.  Reference Type → A reference type shares the same instance across multiple references.  Copy on Write (CoW) → An optimization where Swift value types share storage until one copy is modified, at which point a new copy is created.  Shallow Copy → A shallow copy copies the top-level object while sharing nested reference-type objects.  Deep Copy → A deep copy creates completely independent copies of an object and all",
      ),
      HandbookTopic(
        title: "Dispatch",
        content: "Comprehensive architectural principles, thread-safety invariants, and production engineering best practices for senior iOS interviews.",
        codeSnippet: "Static Dispatch → Method calls are resolved at compile time, resulting in faster performance.  Dynamic Dispatch → Method calls are resolved at runtime, providing flexibility at the cost of some performance.  Witness Table Dispatch → Swift uses witness tables to dynamically dispatch protocol method calls.  Message Dispatch → Objective-C runtime dispatch mechanism using message sending (objc_msgSend).",
      ),
      HandbookTopic(
        title: "Concurrency",
        content: "Comprehensive architectural principles, thread-safety invariants, and production engineering best practices for senior iOS interviews.",
        codeSnippet: "GCD (Grand Central Dispatch) → A low-level API for performing concurrent and asynchronous tasks using dispatch queues.  Async/Await → A modern concurrency model that allows asynchronous code to be written in a synchronous style.  Task → A unit of asynchronous work executed within Swift's structured concurrency.  TaskGroup → A construct that runs multiple asynchronous tasks concurrently and waits for their completion.  Actor → A reference type that protects mutable state by allowing only one task",
      ),
      HandbookTopic(
        title: "Closures",
        content: "Comprehensive architectural principles, thread-safety invariants, and production engineering best practices for senior iOS interviews.",
        codeSnippet: "Closure → A closure is a self-contained block of executable code that can capture and store references to values from its surrounding context.  Escaping Closure → An escaping closure can outlive the function in which it is passed.  Non-Escaping Closure → A non-escaping closure must be executed before the function returns.  Capture List → A capture list controls how external values are captured by a closure, helping prevent retain cycles.",
      ),
      HandbookTopic(
        title: "Properties",
        content: "Comprehensive architectural principles, thread-safety invariants, and production engineering best practices for senior iOS interviews.",
        codeSnippet: "Stored Property → A stored property holds a value in memory.  Computed Property → A computed property calculates and returns a value instead of storing it.  Lazy Property → A lazy property is initialized only when it is accessed for the first time.  Property Observer → Property observers (willSet and didSet) monitor changes to a property's value.  Property Wrapper → A property wrapper adds reusable behavior to property access using the @ syntax.",
      ),
      HandbookTopic(
        title: "Initialization",
        content: "Comprehensive architectural principles, thread-safety invariants, and production engineering best practices for senior iOS interviews.",
        codeSnippet: "Designated Initializer → The primary initializer responsible for fully initializing all stored properties.  Convenience Initializer → A secondary initializer that delegates initialization to another initializer in the same class.  Failable Initializer → An initializer that can fail and return nil if initialization is unsuccessful.  Required Initializer → An initializer that every subclass must implement.",
      ),
      HandbookTopic(
        title: "Error Handling",
        content: "Comprehensive architectural principles, thread-safety invariants, and production engineering best practices for senior iOS interviews.",
        codeSnippet: "throws → Indicates that a function can throw an error.  try → Executes a throwing function while handling potential errors.  try? → Converts a thrown error into nil.  try! → Executes a throwing function without handling errors and crashes if an error occurs.  defer → Executes code just before leaving the current scope, regardless of how the scope exits.",
      ),
      HandbookTopic(
        title: "Architecture",
        content: "Comprehensive architectural principles, thread-safety invariants, and production engineering best practices for senior iOS interviews.",
        codeSnippet: "MVC → Separates an application into Model, View, and Controller.  MVVM → Separates an application into Model, View, and ViewModel to improve testability and maintainability.  Dependency Injection → A design pattern where dependencies are provided from the outside instead of being created internally.  Coordinator Pattern → A navigation pattern that moves navigation logic out of view controllers.  Clean Architecture → Organizes code into independent layers with clear separation of responsibilities",
      ),
      HandbookTopic(
        title: "Design Patterns",
        content: "Comprehensive architectural principles, thread-safety invariants, and production engineering best practices for senior iOS interviews.",
        codeSnippet: "Singleton → Ensures only one instance of a class exists and provides a global access point.  Factory → Creates objects without exposing the object creation logic.  Builder → Constructs complex objects step by step.  Strategy → Defines interchangeable algorithms that can be selected at runtime.  Observer → Notifies subscribed objects when another object's state changes.  Delegate → A design pattern where one object communicates events or actions to another object through a protocol.  Repository →",
      ),
    ],
  ),
];
