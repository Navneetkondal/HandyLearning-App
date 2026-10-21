// Exhaustive Architectural Domains Data (All 32 Canonical Domains)
// Unified 32-Domain Architecture for handyLearn iOS Senior/Lead Prep
import '../models/ios_prep_models.dart';

final List<PrepDomain> detailedPrepDomains = [
  // =============================================================
  // DOMAIN 1: Swift Language Core, Types & Value Semantics
  // =============================================================
  PrepDomain(
    id: 1,
    domainNumber: 1,
    title: '''Swift Language Core, Types & Value Semantics''',
    emoji: '''⚡''',
    tag: '''Core Swift''',
    description: '''Immutability, Optionals extra inhabitants, Error handling (Swift 6 Typed Throws), Enums with associated values, Mutating methods, Property Wrappers, and KeyPaths.''',
    architecturalBlueprint: '''Swift enforces value immutability through compile-time static analysis and LLVM optimization passes. For value types (structs, enums), 'let' locks the entire inline memory buffer. For reference types (classes), 'let' locks only the 64-bit pointer address on the stack; heap-allocated memory remains mutable unless internally restricted. Optionals optimize memory footprint by using extra inhabitants (spare bits from 8-byte pointer alignments) where 0x0 represents nil without extra tag byte overhead. Swift 6 Typed Throws enforce compile-time error type checking without costly C++ zero-cost stack-unwinding mechanisms.''',
    keySignals: const [
      '''Strong Hire: Accurately explains extra inhabitants, LLVM register allocation (X0-X7 on ARM64), and copy-in copy-out inout memory exclusivity.''',
      '''Strong Hire: Understands why structs holding multiple classes incur ARC retain/release overhead on copies.''',
      '''Red Flag: Believes structs are always placed on stack and classes always on heap regardless of escape analysis.''',
      '''Red Flag: Force-unwraps optionals in production or uses try? masking critical network error codes.''',
    ],
    topics: const [
      DomainTopic(
        title: '''Value vs Reference Semantics''',
        definition: '''Value types (structs, enums, tuples) are copied on assignment and mutation, ensuring independent state. Reference types (classes, actors) share a single heap-allocated identity referenced by pointers.''',
        mechanics: '''Value semantics eliminate hidden side effects and data races across concurrency boundaries, while reference semantics are required for shared identity, lifecycle tracking, and OOP polymorphism.''',
        codeSnippet: '''// Swift 6 Safe Value Configuration with Strict Sendable Conformance
public struct NetworkRequestConfiguration: Sendable, Hashable {
    public let endpoint: URL
    public let timeoutInterval: TimeInterval
    public var headers: [String: String]

    public init(endpoint: URL, timeoutInterval: TimeInterval = 30.0, headers: [String: String] = [:]) {
        self.endpoint = endpoint
        self.timeoutInterval = timeoutInterval
        self.headers = headers
    }

    public mutating func setHeader(_ value: String, forKey key: String) {
        // Value mutation enforces exclusivity rule (Law of Exclusivity)
        headers[key] = value
    }
}''',
        wrongDoingsAndTraps: '''Assuming structs never allocate heap memory. A struct containing String, Array, or classes stores heap pointers and incurs ARC retain traffic on copies.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the main difference between a struct and a class in Swift?''',
            answer: '''Structs are value types copied on assignment; classes are reference types where variables share the same heap object.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: When does a struct get allocated on the heap instead of the stack?''',
            answer: '''When it is captured by an escaping closure, boxed in an existential container (`any Protocol`), or stored inside a class property.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How do you optimize a struct with 10 reference properties that is copied frequently in a tight loop?''',
            answer: '''Wrap the 10 references in a private class storage buffer and implement manual Copy-on-Write (isKnownUniquelyReferenced) to reduce 10 retain/release calls down to 1.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Mutating Methods & Inout Memory Exclusivity''',
        definition: '''Mutating methods pass self as an implicit inout parameter, giving write access to the value type buffer. Swift enforces strict memory exclusivity (Law of Exclusivity).''',
        mechanics: '''Prevents conflicting simultaneous access to the same memory buffer, which causes undefined behavior and data corruption.''',
        codeSnippet: '''public struct HighFrequencyTicker: Sendable {
    private(set) public var lastPrice: Double = 0.0
    private(set) public var tickCount: Int = 0

    public mutating func update(newPrice: Double) {
        assert(newPrice > 0, "Price must be positive")
        self.lastPrice = newPrice
        self.tickCount += 1
    }
}''',
        wrongDoingsAndTraps: '''Calling a mutating method on a let constant triggers compile-time error: cannot use mutating member on immutable value.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What does the mutating keyword signify on a struct method?''',
            answer: '''It indicates that the method is allowed to modify stored properties of the struct instance.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: Explain Swift's Law of Exclusivity and how it relates to inout.''',
            answer: '''Two accesses to the same memory location cannot overlap in time if at least one of them is a write access.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What runtime crash occurs if inout exclusivity is violated dynamically in debug vs release builds?''',
            answer: '''Simultaneous accesses trigger crash in Debug (enforced by LLVM sanitizer), while Release optimizations may cause undefined behavior if assertions are stripped.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Enums with Associated Values & Pattern Matching''',
        definition: '''Swift enums are algebraic sum types (tagged unions) that can store associated values, enabling expressive domain modeling with exhaustive compile-time pattern matching.''',
        mechanics: '''Eliminates illegal application states at compile time; provides type-safe state machines without null pointer exceptions.''',
        codeSnippet: '''// Swift 6 Exhaustive State Machine Enum with Typed Errors
public enum NetworkResult<Value: Sendable, Failure: Error & Sendable>: Sendable {
    case success(Value)
    case failure(Failure)
    case rateLimited(retryAfterSeconds: Int)

    public var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
}''',
        wrongDoingsAndTraps: '''Recursive enums without 'indirect' keyword trigger compiler error: recursive enum type has infinite size.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is an enum with associated values in Swift?''',
            answer: '''An enum where individual cases can carry custom typed data payloads.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: What is the purpose of the @unknown default attribute in switch statements?''',
            answer: '''Warns developers if future library versions add new enum cases, while maintaining compile-time exhaustiveness.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How does Swift calculate the memory size of an indirect enum?''',
            answer: '''An indirect enum stores an 8-byte heap pointer rather than inlining the recursive payload, bounding its inline size to 8 bytes.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Optionals & Extra Inhabitants Optimization''',
        definition: '''An Optional in Swift is an enum with .none and .some(Wrapped). Swift uses extra inhabitants to store nil without increasing memory footprint for pointer-sized types.''',
        mechanics: '''Eliminates Tony Hoare's 'Billion-Dollar Mistake' (null pointer dereferences) through compile-time type safety.''',
        codeSnippet: '''// Swift 6 Optional Unwrapping & Typed Nil-Coalescing Guard
public func resolveUserDisplayName(rawInput: String?, fallbackId: UUID) -> String {
    guard let rawInput, !rawInput.trimmingCharacters(in: .whitespaces).isEmpty else {
        return "Guest-" + fallbackId.uuidString.prefix(6)
    }
    return rawInput
}''',
        wrongDoingsAndTraps: '''Implicitly Unwrapped Optionals (Type!) defeat compiler safety checks and crash if accessed before initialization.''',
        questions: [
          DomainQuestion(
            question: '''Junior: How do you safely unwrap an optional in Swift?''',
            answer: '''Using if let, guard let, optional chaining (?.), or nil-coalescing (??).''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: Explain the concept of Extra Inhabitants in Swift's memory layout.''',
            answer: '''Bit patterns that are invalid for a type (like 0x0 for references) are used by the runtime to represent nil without adding an extra byte.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What is the memory size of Optional<Optional<Class>>?''',
            answer: '''8 bytes. Swift pointers have hundreds of thousands of extra inhabitants on 64-bit systems, enough to pack nested optionals without size growth.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 2: Protocols, Protocol-Oriented Programming & Type Erasure
  // =============================================================
  PrepDomain(
    id: 2,
    domainNumber: 2,
    title: '''Protocols, Protocol-Oriented Programming & Type Erasure''',
    emoji: '''🧩''',
    tag: '''Protocols & POP''',
    description: '''Protocols define blueprints of methods, properties, and requirements. Protocol extensions provide default implementations. Existential containers ('any') box types at runtime, whereas generics ('some') specialize statically. Type erasure hides concrete underlying types behind a unified interface.''',
    architecturalBlueprint: '''Protocols, Protocol-Oriented Programming & Type Erasure forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Protocols, Protocol-Oriented Programming & Type Erasure internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''Protocol Extensions & Dynamic vs Static Dispatch''',
        definition: '''Protocol extensions provide default method implementations. Methods declared in the protocol blueprint use dynamic dispatch via Protocol Witness Tables (PWT); methods declared ONLY in the extension use static direct dispatch.''',
        mechanics: '''Calling an extension-only method through an existential or protocol type calls the extension default, NOT the conforming type's custom implementation if typed statically, causing subtle bugs.''',
        codeSnippet: '''public protocol CachePolicy: Sendable {
    var ttl: TimeInterval { get }
    func shouldEvict(timestamp: Date) -> Bool
}

public extension CachePolicy {
    // Default implementation in Protocol Witness Table
    func shouldEvict(timestamp: Date) -> Bool {
        Date().timeIntervalSince(timestamp) > ttl
    }
}''',
        wrongDoingsAndTraps: '''Calling an un-declared extension method on an existential (let x: any Protocol) silently dispatches to the default implementation.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary benefit of protocol extensions in Swift?''',
            answer: '''They allow adding default method implementations and computed properties to protocols without forcing subclasses.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: Explain the Protocol Extension Dispatch Trap and how the compiler resolves it.''',
            answer: '''If a method is in the protocol definition, it dispatches dynamically via the Protocol Witness Table. If it only exists in the extension, it dispatches statically based on the compile-time type.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How does LLVM optimize protocol extension methods under Whole Module Optimization (WMO)?''',
            answer: '''Under WMO, the compiler devirtualizes protocol calls when it knows all conforming types in the module, converting witness table jumps into direct inlined assembly instructions.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Existential Types (any) vs Opaque Types (some)''',
        definition: '''Existential types ('any Protocol') box arbitrary conforming instances in dynamic 40-byte containers at runtime. Opaque types ('some Protocol') preserve static underlying type information at compile time.''',
        mechanics: '''any Protocol incurs heap allocation and dynamic witness table dispatch, whereas some Protocol allows compiler inlining and zero runtime allocations.''',
        codeSnippet: '''// Swift 6 High-Performance Factory using Primary Associated Types
public protocol DataRepository<Entity>: Sendable {
    associatedtype Entity: Identifiable & Sendable
    func fetch() async throws -> [Entity]
}

// Opaque return type: Zero existential overhead, specialized at compile-time
public func resolveRepository() -> some DataRepository<UserEntity> {
    RemoteUserRepository()
}''',
        wrongDoingsAndTraps: '''Believing 'some' and 'any' are interchangeable; 'some' cannot represent an array of mixed concrete types.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the difference between 'some View' and 'any View' in SwiftUI?''',
            answer: ''''some View' returns one specific hidden type known at compile time. 'any View' is an existential type that boxes any view dynamically at runtime.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: Why does assigning a struct larger than 24 bytes to 'any Protocol' allocate heap memory?''',
            answer: '''Because the existential container's inline value buffer is only 3 machine words (24 bytes on 64-bit). Larger types spill onto the heap, requiring swift_allocObject.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How do Primary Associated Types in Swift 5.7+ reduce the need for existential type erasure?''',
            answer: '''They allow writing 'some Collection<String>' rather than boxing in AnyCollection or using unconstrained existentials, maintaining compile-time type safety and static dispatch.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Witness Tables & Protocol Conformance Cost''',
        definition: '''A Protocol Witness Table (PWT) is a runtime array of function pointers mapping protocol requirements to the conforming type's implementations. Value Witness Tables (VWT) manage lifecycle operations (allocate, copy, destroy).''',
        mechanics: '''Understanding witness tables reveals why protocol existentials have performance costs compared to concrete generics.''',
        codeSnippet: '''// Explicit Protocol Conformance with Zero Allocations
public protocol ResilientService: Sendable {
    func healthCheck() async -> Bool
}

public struct GatewayService: ResilientService {
    public init() {}
    public func healthCheck() async -> Bool {
        // Direct implementation referenced in GatewayService's PWT
        return true
    }
}''',
        wrongDoingsAndTraps: '''Assuming witness tables exist for structs without protocol conformance; they are only emitted when a type conforms to a protocol.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is a Protocol Witness Table in Swift?''',
            answer: '''An internal compiler table containing function pointers that map a protocol's required methods to a concrete type's implementation.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: What is the difference between a Protocol Witness Table (PWT) and a Value Witness Table (VWT)?''',
            answer: '''PWT manages protocol method dispatch. VWT manages the physical memory operations of the type (size, alignment, copy, move, destroy).''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How does the Swift runtime resolve conformances at runtime for conditional generic protocols (e.g. Array: Equatable where Element: Equatable)?''',
            answer: '''The runtime calls a conformance descriptor accessor function that dynamically instantiates a specialized witness table by combining the Array witness table with the Element witness table.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Type Erasure (AnyView, AnyPublisher, Custom)''',
        definition: '''Type erasure wraps concrete types conforming to a protocol (especially those with associated types) into a unified concrete wrapper (e.g. AnyView, AnyPublisher, AnyCancellable).''',
        mechanics: '''Enables storing heterogeneous instances of protocols with associated types or self requirements in arrays and properties.''',
        codeSnippet: '''// Swift 6 Production-Grade Type Erasure with Box Pattern
public struct AnyDataStore<T: Sendable>: Sendable {
    private let _fetch: @Sendable () async throws -> [T]
    
    public init<S: DataStore>(_ store: S) where S.Item == T {
        self._fetch = { try await store.fetchItems() }
    }
    
    public func fetchItems() async throws -> [T] {
        try await _fetch()
    }
}

public protocol DataStore: Sendable {
    associatedtype Item: Sendable
    func fetchItems() async throws -> [Item]
}''',
        wrongDoingsAndTraps: '''Overusing AnyView in SwiftUI lists; it destroys view identity and forces entire cell hierarchies to re-render from scratch on every scroll update.''',
        questions: [
          DomainQuestion(
            question: '''Junior: Why is type erasure used in Swift?''',
            answer: '''To hide complex underlying generic types and allow storing protocols with associated types in variables and collections.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does the Box pattern implement type erasure compared to closure capture?''',
            answer: '''The Box pattern uses an internal abstract private class and a generic subclass. It provides better performance than multiple captured closures and avoids retain cycle issues.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How has Swift 5.7+ Primary Associated Types and 'any Protocol<T>' reduced the need for manual type erasure?''',
            answer: '''Swift 5.7 permits writing 'any Collection<String>' directly as an existential type with primary associated types, eliminating the need for boilerplate like AnyCollection in most API contracts.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 3: Generics, Parameterized Types & Advanced Constraints
  // =============================================================
  PrepDomain(
    id: 3,
    domainNumber: 3,
    title: '''Generics, Parameterized Types & Advanced Constraints''',
    emoji: '''🧱''',
    tag: '''Generics''',
    description: '''Swift generics enable code reuse with compile-time type safety. Generic constraints enforce protocol conformance. Parameter packs allow variadic generics. Associated types declare placeholder types in protocols, specialized with primary associated types.''',
    architecturalBlueprint: '''Generics, Parameterized Types & Advanced Constraints forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Generics, Parameterized Types & Advanced Constraints internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''Generic Constraints & Parameter Packs''',
        definition: '''Generic Constraints & Parameter Packs provides deterministic, type-safe execution within Generics, Parameterized Types & Advanced Constraints. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Generic Constraints & Parameter Packs prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Generic Constraints & Parameter Packs
import Foundation

public final class Dom03top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Generic Constraints & Parameter Packs behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Generic Constraints & Parameter Packs?''',
            answer: '''It manages generic constraints & parameter packs safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Generic Constraints & Parameter Packs impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Generic Constraints & Parameter Packs at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Primary Associated Types & Opaque Return Types''',
        definition: '''Primary Associated Types & Opaque Return Types provides deterministic, type-safe execution within Generics, Parameterized Types & Advanced Constraints. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Primary Associated Types & Opaque Return Types prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Primary Associated Types & Opaque Return Types
import Foundation

public final class Dom03top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Primary Associated Types & Opaque Return Types behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Primary Associated Types & Opaque Return Types?''',
            answer: '''It manages primary associated types & opaque return types safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Primary Associated Types & Opaque Return Types impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Primary Associated Types & Opaque Return Types at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Type Inference & Metatypes (Type.self vs type(of:))''',
        definition: '''Type Inference & Metatypes (Type.self vs type(of:)) provides deterministic, type-safe execution within Generics, Parameterized Types & Advanced Constraints. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Type Inference & Metatypes (Type.self vs type(of:)) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Type Inference & Metatypes (Type.self vs type(of:))
import Foundation

public final class Dom03top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Type Inference & Metatypes (Type.self vs type(of:)) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Type Inference & Metatypes (Type.self vs type(of:))?''',
            answer: '''It manages type inference & metatypes (type.self vs type(of:)) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Type Inference & Metatypes (Type.self vs type(of:)) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Type Inference & Metatypes (Type.self vs type(of:)) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Phantom Types for Compile-Time Invariant Safety''',
        definition: '''Phantom Types for Compile-Time Invariant Safety provides deterministic, type-safe execution within Generics, Parameterized Types & Advanced Constraints. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Phantom Types for Compile-Time Invariant Safety prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Phantom Types for Compile-Time Invariant Safety
import Foundation

public final class Dom03top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Phantom Types for Compile-Time Invariant Safety behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Phantom Types for Compile-Time Invariant Safety?''',
            answer: '''It manages phantom types for compile-time invariant safety safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Phantom Types for Compile-Time Invariant Safety impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Phantom Types for Compile-Time Invariant Safety at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 4: Memory Management, ARC Internals & Low-Level Heap
  // =============================================================
  PrepDomain(
    id: 4,
    domainNumber: 4,
    title: '''Memory Management, ARC Internals & Low-Level Heap''',
    emoji: '''🧠''',
    tag: '''Memory & ARC''',
    description: '''Automatic Reference Counting (ARC) inserts retain and release calls automatically. Inline retain counts live in the object header; overflow shifts counts to side tables. Weak references zero out via side table tracking. Unowned references crash if accessed after deallocation.''',
    architecturalBlueprint: '''Memory Management, ARC Internals & Low-Level Heap forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Memory Management, ARC Internals & Low-Level Heap internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''Inline Retain Counts vs Side Tables''',
        definition: '''Swift objects store retain counts inline in their 64-bit object header. When retain counts overflow or when a weak reference is created, Swift allocates an out-of-line Side Table.''',
        mechanics: '''Side tables allow weak references to safely point to an object without keeping its payload alive, enabling zeroing weak references without memory corruption.''',
        codeSnippet: '''// Side Table Allocation Trigger Analysis
public final class CacheItem: Sendable {
    public let key: String
    public let payload: Data
    
    public init(key: String, payload: Data) {
        self.key = key
        self.payload = payload
    }
    
    deinit {
        // Deallocates payload; side table persists if weak refs still exist
    }
}''',
        wrongDoingsAndTraps: '''Believing weak references point directly to the object; they point to the Side Table, which points to the object.''',
        questions: [
          DomainQuestion(
            question: '''Junior: Where does Swift store an object's reference count?''',
            answer: '''Inline within the object's 64-bit header word. If weak references are added or counts overflow, it moves to an external Side Table.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: Why does Swift use a Side Table for weak references instead of zeroing pointers directly?''',
            answer: '''Because zeroing pointers synchronously on dealloc requires locking every thread. Side tables allow weak references to lazily zero themselves when next read, even after the main object memory is deallocated.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What is the complete lifecycle transition of a Swift object from live to dead?''',
            answer: '''Live -> Deinitializing -> Deinitialized (strong count 0, memory freed, side table remains) -> Freed (unowned count 0) -> Dead (weak count 0, side table deallocated).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Strong vs Weak vs Unowned Reference Counting''',
        definition: '''Strong vs Weak vs Unowned Reference Counting provides deterministic, type-safe execution within Memory Management, ARC Internals & Low-Level Heap. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Strong vs Weak vs Unowned Reference Counting prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Strong vs Weak vs Unowned Reference Counting
import Foundation

public final class Dom04top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Strong vs Weak vs Unowned Reference Counting behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Strong vs Weak vs Unowned Reference Counting?''',
            answer: '''It manages strong vs weak vs unowned reference counting safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Strong vs Weak vs Unowned Reference Counting impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Strong vs Weak vs Unowned Reference Counting at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Autorelease Pools & RunLoop Draining''',
        definition: '''Autorelease Pools & RunLoop Draining provides deterministic, type-safe execution within Memory Management, ARC Internals & Low-Level Heap. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Autorelease Pools & RunLoop Draining prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Autorelease Pools & RunLoop Draining
import Foundation

public final class Dom04top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Autorelease Pools & RunLoop Draining behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Autorelease Pools & RunLoop Draining?''',
            answer: '''It manages autorelease pools & runloop draining safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Autorelease Pools & RunLoop Draining impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Autorelease Pools & RunLoop Draining at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Dirty, Clean & Compressed Memory & iOS Jetsam Limits''',
        definition: '''Dirty, Clean & Compressed Memory & iOS Jetsam Limits provides deterministic, type-safe execution within Memory Management, ARC Internals & Low-Level Heap. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Dirty, Clean & Compressed Memory & iOS Jetsam Limits prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Dirty, Clean & Compressed Memory & iOS Jetsam Limits
import Foundation

public final class Dom04top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Dirty, Clean & Compressed Memory & iOS Jetsam Limits behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Dirty, Clean & Compressed Memory & iOS Jetsam Limits?''',
            answer: '''It manages dirty, clean & compressed memory & ios jetsam limits safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Dirty, Clean & Compressed Memory & iOS Jetsam Limits impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Dirty, Clean & Compressed Memory & iOS Jetsam Limits at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 5: Closures, Capture Semantics & Functional Swift
  // =============================================================
  PrepDomain(
    id: 5,
    domainNumber: 5,
    title: '''Closures, Capture Semantics & Functional Swift''',
    emoji: '''🎯''',
    tag: '''Closures''',
    description: '''Closures are self-contained blocks of functionality that capture constants and variables from their surrounding context. Escaping closures outlive the function scope. Autoclosures delay execution. Capture lists prevent retain cycles.''',
    architecturalBlueprint: '''Closures, Capture Semantics & Functional Swift forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Closures, Capture Semantics & Functional Swift internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''Escaping vs Non-Escaping Closures''',
        definition: '''Escaping vs Non-Escaping Closures provides deterministic, type-safe execution within Closures, Capture Semantics & Functional Swift. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Escaping vs Non-Escaping Closures prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Escaping vs Non-Escaping Closures
import Foundation

public final class Dom05top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Escaping vs Non-Escaping Closures behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Escaping vs Non-Escaping Closures?''',
            answer: '''It manages escaping vs non-escaping closures safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Escaping vs Non-Escaping Closures impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Escaping vs Non-Escaping Closures at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Capture Lists & Retain Cycle Prevention''',
        definition: '''Capture Lists & Retain Cycle Prevention provides deterministic, type-safe execution within Closures, Capture Semantics & Functional Swift. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Capture Lists & Retain Cycle Prevention prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Capture Lists & Retain Cycle Prevention
import Foundation

public final class Dom05top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Capture Lists & Retain Cycle Prevention behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Capture Lists & Retain Cycle Prevention?''',
            answer: '''It manages capture lists & retain cycle prevention safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Capture Lists & Retain Cycle Prevention impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Capture Lists & Retain Cycle Prevention at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Autoclosures & Deferred Evaluation Mechanics''',
        definition: '''Autoclosures & Deferred Evaluation Mechanics provides deterministic, type-safe execution within Closures, Capture Semantics & Functional Swift. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Autoclosures & Deferred Evaluation Mechanics prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Autoclosures & Deferred Evaluation Mechanics
import Foundation

public final class Dom05top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Autoclosures & Deferred Evaluation Mechanics behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Autoclosures & Deferred Evaluation Mechanics?''',
            answer: '''It manages autoclosures & deferred evaluation mechanics safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Autoclosures & Deferred Evaluation Mechanics impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Autoclosures & Deferred Evaluation Mechanics at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Functional Primitives (Map, FlatMap, CompactMap, Reduce)''',
        definition: '''Functional Primitives (Map, FlatMap, CompactMap, Reduce) provides deterministic, type-safe execution within Closures, Capture Semantics & Functional Swift. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Functional Primitives (Map, FlatMap, CompactMap, Reduce) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Functional Primitives (Map, FlatMap, CompactMap, Reduce)
import Foundation

public final class Dom05top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Functional Primitives (Map, FlatMap, CompactMap, Reduce) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Functional Primitives (Map, FlatMap, CompactMap, Reduce)?''',
            answer: '''It manages functional primitives (map, flatmap, compactmap, reduce) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Functional Primitives (Map, FlatMap, CompactMap, Reduce) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Functional Primitives (Map, FlatMap, CompactMap, Reduce) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 6: Swift 6 Concurrency & Modern Structured Concurrency
  // =============================================================
  PrepDomain(
    id: 6,
    domainNumber: 6,
    title: '''Swift 6 Concurrency & Modern Structured Concurrency''',
    emoji: '''⚡''',
    tag: '''Swift 6 Concurrency''',
    description: '''Swift 6 introduces strict data-race safety. Structured concurrency manages child tasks within parent scopes. Actors protect internal state via data isolation. MainActor ensures UI thread execution. Sendable types safely cross isolation boundaries.''',
    architecturalBlueprint: '''Swift 6 Concurrency & Modern Structured Concurrency forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Swift 6 Concurrency & Modern Structured Concurrency internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''async/await & Task Lifecycles''',
        definition: '''async/await & Task Lifecycles provides deterministic, type-safe execution within Swift 6 Concurrency & Modern Structured Concurrency. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering async/await & Task Lifecycles prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: async/await & Task Lifecycles
import Foundation

public final class Dom06top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how async/await & Task Lifecycles behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of async/await & Task Lifecycles?''',
            answer: '''It manages async/await & task lifecycles safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does async/await & Task Lifecycles impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing async/await & Task Lifecycles at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Structured Concurrency & TaskGroup Dynamics''',
        definition: '''Structured Concurrency & TaskGroup Dynamics provides deterministic, type-safe execution within Swift 6 Concurrency & Modern Structured Concurrency. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Structured Concurrency & TaskGroup Dynamics prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Structured Concurrency & TaskGroup Dynamics
import Foundation

public final class Dom06top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Structured Concurrency & TaskGroup Dynamics behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Structured Concurrency & TaskGroup Dynamics?''',
            answer: '''It manages structured concurrency & taskgroup dynamics safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Structured Concurrency & TaskGroup Dynamics impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Structured Concurrency & TaskGroup Dynamics at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Actors, Re-entrancy Traps & MainActor Isolation''',
        definition: '''Actors protect mutable state by isolating it to a single execution context. However, actors are re-entrant: awaiting an asynchronous operation suspends the actor, allowing other tasks to interleave and mutate state.''',
        mechanics: '''Actor re-entrancy is the #1 cause of logical race conditions in modern Swift concurrency.''',
        codeSnippet: '''// Swift 6 Safe Actor Pattern Preventing Re-Entrancy Bugs
public actor PaymentCoordinator: Sendable {
    private var pendingTransactions: Set<UUID> = []
    private var balance: Decimal = 1000.0

    public func processPayment(id: UUID, amount: Decimal) async throws -> Bool {
        // Invariant check BEFORE suspension
        guard !pendingTransactions.contains(id), balance >= amount else {
            return false
        }
        
        // Optimistic reservation before awaiting remote network service
        pendingTransactions.insert(id)
        balance -= amount
        
        do {
            let success = try await executeGatewayCall(id: id, amount: amount)
            pendingTransactions.remove(id)
            if !success {
                // Compensating rollback on failure
                balance += amount
            }
            return success
        } catch {
            pendingTransactions.remove(id)
            balance += amount
            throw error
        }
    }
    
    private func executeGatewayCall(id: UUID, amount: Decimal) async throws -> Bool {
        try await Task.sleep(nanoseconds: 100_000_000)
        return true
    }
}''',
        wrongDoingsAndTraps: '''Assuming actors prevent all concurrency bugs; actors prevent data races (memory corruption), but NOT logical race conditions (re-entrancy state mutation).''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is an Actor in Swift?''',
            answer: '''A reference type that protects its mutable state by ensuring only one task can access its isolated properties at any given time.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: What is Actor Re-Entrancy and how do you protect invariants against it?''',
            answer: '''When an actor awaits an async call, it suspends and allows other tasks to run on the actor. Invariants must be validated again after the await point, or state should be reserved before suspension.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How does Swift 6 enforce compile-time Sendable checking across actor isolation boundaries?''',
            answer: '''All arguments passed into an actor method and all return values must conform to Sendable, or be transferred across a disconnected Region-Based Isolation region (SE-0414), preventing mutable pointer sharing.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Sendable Protocol & Swift 6 Strict Concurrency Checks''',
        definition: '''Sendable Protocol & Swift 6 Strict Concurrency Checks provides deterministic, type-safe execution within Swift 6 Concurrency & Modern Structured Concurrency. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Sendable Protocol & Swift 6 Strict Concurrency Checks prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Sendable Protocol & Swift 6 Strict Concurrency Checks
import Foundation

public final class Dom06top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Sendable Protocol & Swift 6 Strict Concurrency Checks behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Sendable Protocol & Swift 6 Strict Concurrency Checks?''',
            answer: '''It manages sendable protocol & swift 6 strict concurrency checks safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Sendable Protocol & Swift 6 Strict Concurrency Checks impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Sendable Protocol & Swift 6 Strict Concurrency Checks at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 7: Grand Central Dispatch (GCD), OperationQueue & Threading
  // =============================================================
  PrepDomain(
    id: 7,
    domainNumber: 7,
    title: '''Grand Central Dispatch (GCD), OperationQueue & Threading''',
    emoji: '''⏱️''',
    tag: '''Threading & GCD''',
    description: '''GCD provides C-level thread pool management via DispatchQueues. OperationQueue provides object-oriented execution with dependencies and cancellation. Low-level synchronization primitives include barriers, semaphores, and OSAllocatedUnfairLock.''',
    architecturalBlueprint: '''Grand Central Dispatch (GCD), OperationQueue & Threading forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Grand Central Dispatch (GCD), OperationQueue & Threading internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''Serial vs Concurrent DispatchQueues & QOS Classes''',
        definition: '''Serial vs Concurrent DispatchQueues & QOS Classes provides deterministic, type-safe execution within Grand Central Dispatch (GCD), OperationQueue & Threading. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Serial vs Concurrent DispatchQueues & QOS Classes prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Serial vs Concurrent DispatchQueues & QOS Classes
import Foundation

public final class Dom07top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Serial vs Concurrent DispatchQueues & QOS Classes behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Serial vs Concurrent DispatchQueues & QOS Classes?''',
            answer: '''It manages serial vs concurrent dispatchqueues & qos classes safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Serial vs Concurrent DispatchQueues & QOS Classes impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Serial vs Concurrent DispatchQueues & QOS Classes at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''DispatchWorkItem, DispatchGroup & DispatchSemaphore''',
        definition: '''DispatchWorkItem, DispatchGroup & DispatchSemaphore provides deterministic, type-safe execution within Grand Central Dispatch (GCD), OperationQueue & Threading. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering DispatchWorkItem, DispatchGroup & DispatchSemaphore prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: DispatchWorkItem, DispatchGroup & DispatchSemaphore
import Foundation

public final class Dom07top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how DispatchWorkItem, DispatchGroup & DispatchSemaphore behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of DispatchWorkItem, DispatchGroup & DispatchSemaphore?''',
            answer: '''It manages dispatchworkitem, dispatchgroup & dispatchsemaphore safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does DispatchWorkItem, DispatchGroup & DispatchSemaphore impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing DispatchWorkItem, DispatchGroup & DispatchSemaphore at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Dispatch Barrier for Reader-Writer Concurrency''',
        definition: '''Dispatch Barrier for Reader-Writer Concurrency provides deterministic, type-safe execution within Grand Central Dispatch (GCD), OperationQueue & Threading. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Dispatch Barrier for Reader-Writer Concurrency prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Dispatch Barrier for Reader-Writer Concurrency
import Foundation

public final class Dom07top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Dispatch Barrier for Reader-Writer Concurrency behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Dispatch Barrier for Reader-Writer Concurrency?''',
            answer: '''It manages dispatch barrier for reader-writer concurrency safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Dispatch Barrier for Reader-Writer Concurrency impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Dispatch Barrier for Reader-Writer Concurrency at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''OSAllocatedUnfairLock & Low-Level Mutex Primitives''',
        definition: '''OSAllocatedUnfairLock & Low-Level Mutex Primitives provides deterministic, type-safe execution within Grand Central Dispatch (GCD), OperationQueue & Threading. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering OSAllocatedUnfairLock & Low-Level Mutex Primitives prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: OSAllocatedUnfairLock & Low-Level Mutex Primitives
import Foundation

public final class Dom07top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how OSAllocatedUnfairLock & Low-Level Mutex Primitives behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of OSAllocatedUnfairLock & Low-Level Mutex Primitives?''',
            answer: '''It manages osallocatedunfairlock & low-level mutex primitives safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does OSAllocatedUnfairLock & Low-Level Mutex Primitives impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing OSAllocatedUnfairLock & Low-Level Mutex Primitives at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 8: Swift Runtime, Reflection, Mirror & Dynamic Dispatch
  // =============================================================
  PrepDomain(
    id: 8,
    domainNumber: 8,
    title: '''Swift Runtime, Reflection, Mirror & Dynamic Dispatch''',
    emoji: '''🔍''',
    tag: '''Runtime & Mirror''',
    description: '''Swift uses three dispatch mechanisms: direct dispatch (inlining), table dispatch (vtable/witness table), and message dispatch (Objective-C objc_msgSend). Mirror API enables inspection. Dynamic member lookup provides syntactic sugar for proxy objects.''',
    architecturalBlueprint: '''Swift Runtime, Reflection, Mirror & Dynamic Dispatch forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Swift Runtime, Reflection, Mirror & Dynamic Dispatch internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''Static vs Table vs Message Dispatch Mechanisms''',
        definition: '''Static vs Table vs Message Dispatch Mechanisms provides deterministic, type-safe execution within Swift Runtime, Reflection, Mirror & Dynamic Dispatch. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Static vs Table vs Message Dispatch Mechanisms prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Static vs Table vs Message Dispatch Mechanisms
import Foundation

public final class Dom08top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Static vs Table vs Message Dispatch Mechanisms behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Static vs Table vs Message Dispatch Mechanisms?''',
            answer: '''It manages static vs table vs message dispatch mechanisms safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Static vs Table vs Message Dispatch Mechanisms impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Static vs Table vs Message Dispatch Mechanisms at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Objective-C Runtime Bridging & Method Swizzling''',
        definition: '''Objective-C Runtime Bridging & Method Swizzling provides deterministic, type-safe execution within Swift Runtime, Reflection, Mirror & Dynamic Dispatch. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Objective-C Runtime Bridging & Method Swizzling prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Objective-C Runtime Bridging & Method Swizzling
import Foundation

public final class Dom08top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Objective-C Runtime Bridging & Method Swizzling behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Objective-C Runtime Bridging & Method Swizzling?''',
            answer: '''It manages objective-c runtime bridging & method swizzling safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Objective-C Runtime Bridging & Method Swizzling impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Objective-C Runtime Bridging & Method Swizzling at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Swift Reflection API, Mirror & CustomReflectable''',
        definition: '''Swift Reflection API, Mirror & CustomReflectable provides deterministic, type-safe execution within Swift Runtime, Reflection, Mirror & Dynamic Dispatch. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Swift Reflection API, Mirror & CustomReflectable prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Swift Reflection API, Mirror & CustomReflectable
import Foundation

public final class Dom08top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Swift Reflection API, Mirror & CustomReflectable behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Swift Reflection API, Mirror & CustomReflectable?''',
            answer: '''It manages swift reflection api, mirror & customreflectable safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Swift Reflection API, Mirror & CustomReflectable impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Swift Reflection API, Mirror & CustomReflectable at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Dynamic Member Lookup & KeyPath Member Lookup''',
        definition: '''Dynamic Member Lookup & KeyPath Member Lookup provides deterministic, type-safe execution within Swift Runtime, Reflection, Mirror & Dynamic Dispatch. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Dynamic Member Lookup & KeyPath Member Lookup prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Dynamic Member Lookup & KeyPath Member Lookup
import Foundation

public final class Dom08top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Dynamic Member Lookup & KeyPath Member Lookup behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Dynamic Member Lookup & KeyPath Member Lookup?''',
            answer: '''It manages dynamic member lookup & keypath member lookup safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Dynamic Member Lookup & KeyPath Member Lookup impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Dynamic Member Lookup & KeyPath Member Lookup at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 9: UIKit Internals, Auto Layout Engine & View Lifecycle
  // =============================================================
  PrepDomain(
    id: 9,
    domainNumber: 9,
    title: '''UIKit Internals, Auto Layout Engine & View Lifecycle''',
    emoji: '''📱''',
    tag: '''UIKit Core''',
    description: '''UIKit manages view hierarchies via UIView and UIViewController. Auto Layout uses the Cassowary linear programming solver. The responder chain routes touch events. RunLoop coordinates display updates with 120Hz display refresh cycles.''',
    architecturalBlueprint: '''UIKit Internals, Auto Layout Engine & View Lifecycle forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of UIKit Internals, Auto Layout Engine & View Lifecycle internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''UIViewController Lifecycle & View Loading Sequence''',
        definition: '''UIViewController Lifecycle & View Loading Sequence provides deterministic, type-safe execution within UIKit Internals, Auto Layout Engine & View Lifecycle. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering UIViewController Lifecycle & View Loading Sequence prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: UIViewController Lifecycle & View Loading Sequence
import Foundation

public final class Dom09top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how UIViewController Lifecycle & View Loading Sequence behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of UIViewController Lifecycle & View Loading Sequence?''',
            answer: '''It manages uiviewcontroller lifecycle & view loading sequence safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does UIViewController Lifecycle & View Loading Sequence impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing UIViewController Lifecycle & View Loading Sequence at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Auto Layout Engine (Cassowary, Hugging, Compression)''',
        definition: '''Auto Layout Engine (Cassowary, Hugging, Compression) provides deterministic, type-safe execution within UIKit Internals, Auto Layout Engine & View Lifecycle. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Auto Layout Engine (Cassowary, Hugging, Compression) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Auto Layout Engine (Cassowary, Hugging, Compression)
import Foundation

public final class Dom09top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Auto Layout Engine (Cassowary, Hugging, Compression) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Auto Layout Engine (Cassowary, Hugging, Compression)?''',
            answer: '''It manages auto layout engine (cassowary, hugging, compression) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Auto Layout Engine (Cassowary, Hugging, Compression) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Auto Layout Engine (Cassowary, Hugging, Compression) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Hit-Testing & UIResponder Chain Traversal''',
        definition: '''Hit-Testing & UIResponder Chain Traversal provides deterministic, type-safe execution within UIKit Internals, Auto Layout Engine & View Lifecycle. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Hit-Testing & UIResponder Chain Traversal prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Hit-Testing & UIResponder Chain Traversal
import Foundation

public final class Dom09top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Hit-Testing & UIResponder Chain Traversal behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Hit-Testing & UIResponder Chain Traversal?''',
            answer: '''It manages hit-testing & uiresponder chain traversal safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Hit-Testing & UIResponder Chain Traversal impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Hit-Testing & UIResponder Chain Traversal at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''RunLoop, CATransaction & 120Hz Display Synchronization''',
        definition: '''RunLoop, CATransaction & 120Hz Display Synchronization provides deterministic, type-safe execution within UIKit Internals, Auto Layout Engine & View Lifecycle. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering RunLoop, CATransaction & 120Hz Display Synchronization prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: RunLoop, CATransaction & 120Hz Display Synchronization
import Foundation

public final class Dom09top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how RunLoop, CATransaction & 120Hz Display Synchronization behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of RunLoop, CATransaction & 120Hz Display Synchronization?''',
            answer: '''It manages runloop, catransaction & 120hz display synchronization safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does RunLoop, CATransaction & 120Hz Display Synchronization impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing RunLoop, CATransaction & 120Hz Display Synchronization at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 10: SwiftUI Architecture, View Graph & AttributeGraph
  // =============================================================
  PrepDomain(
    id: 10,
    domainNumber: 10,
    title: '''SwiftUI Architecture, View Graph & AttributeGraph''',
    emoji: '''🎨''',
    tag: '''SwiftUI Core''',
    description: '''SwiftUI uses value-type View structs. AttributeGraph evaluates dependencies and invalidations. Structural identity distinguishes views by position, while explicit identity uses .id(). EquatableView optimizes rendering diffs.''',
    architecturalBlueprint: '''SwiftUI Architecture, View Graph & AttributeGraph forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of SwiftUI Architecture, View Graph & AttributeGraph internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''View Structs & Value Semantics vs UIView''',
        definition: '''View Structs & Value Semantics vs UIView provides deterministic, type-safe execution within SwiftUI Architecture, View Graph & AttributeGraph. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering View Structs & Value Semantics vs UIView prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: View Structs & Value Semantics vs UIView
import Foundation

public final class Dom10top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how View Structs & Value Semantics vs UIView behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of View Structs & Value Semantics vs UIView?''',
            answer: '''It manages view structs & value semantics vs uiview safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does View Structs & Value Semantics vs UIView impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing View Structs & Value Semantics vs UIView at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Structural Identity vs Explicit Identity (.id)''',
        definition: '''SwiftUI distinguishes views by Structural Identity (their position and branch within the view hierarchy) and Explicit Identity (assigned via .id() or ForEach identifiers).''',
        mechanics: '''Using explicit vs structural identity incorrectly causes view state resets, animation glitches, and performance hitches in scroll views.''',
        codeSnippet: '''// High-Performance List with Explicit Identity
public struct ProductFeedView: View {
    let products: [ProductModel]

    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                // Explicit identity guarantees zero state resets on reorder
                ForEach(products, id: \\.id) { product in
                    ProductCardCell(product: product)
                }
            }
            .padding()
        }
    }
}

public struct ProductModel: Identifiable, Sendable, Equatable {
    public let id: UUID
    public let title: String
    public let price: Decimal
}

struct ProductCardCell: View, Equatable {
    let product: ProductModel
    var body: some View {
        Text(product.title)
    }
}''',
        wrongDoingsAndTraps: '''Using ForEach(0..<items.count) with mutable arrays; when items are deleted, indices shift and SwiftUI animates the wrong cells or crashes.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the difference between Structural and Explicit Identity in SwiftUI?''',
            answer: '''Structural identity determines view identity by its position in the view hierarchy (e.g. if/else branches). Explicit identity uses unique identifiers like .id() or ForEach(items).''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: Why does toggling an if/else branch reset a view's @State even if both branches return the same View type?''',
            answer: '''Because SwiftUI's @ViewBuilder creates two distinct branch nodes in the AttributeGraph. Switching branches destroys the first node (and its state) and creates a new one.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How does SwiftUI's AttributeGraph handle view diffing when a view conforms to Equatable?''',
            answer: '''If a view conforms to Equatable and static equality returns true, AttributeGraph skips traversing and executing the view's body property entirely, pruning subtree evaluation.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''AttributeGraph & View Invalidation Lifecycle''',
        definition: '''AttributeGraph & View Invalidation Lifecycle provides deterministic, type-safe execution within SwiftUI Architecture, View Graph & AttributeGraph. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering AttributeGraph & View Invalidation Lifecycle prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: AttributeGraph & View Invalidation Lifecycle
import Foundation

public final class Dom10top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how AttributeGraph & View Invalidation Lifecycle behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of AttributeGraph & View Invalidation Lifecycle?''',
            answer: '''It manages attributegraph & view invalidation lifecycle safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does AttributeGraph & View Invalidation Lifecycle impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing AttributeGraph & View Invalidation Lifecycle at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''EquatableView & Diffing Performance Optimization''',
        definition: '''EquatableView & Diffing Performance Optimization provides deterministic, type-safe execution within SwiftUI Architecture, View Graph & AttributeGraph. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering EquatableView & Diffing Performance Optimization prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: EquatableView & Diffing Performance Optimization
import Foundation

public final class Dom10top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how EquatableView & Diffing Performance Optimization behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of EquatableView & Diffing Performance Optimization?''',
            answer: '''It manages equatableview & diffing performance optimization safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does EquatableView & Diffing Performance Optimization impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing EquatableView & Diffing Performance Optimization at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 11: Observation Framework (@Observable) & Combine Reactive
  // =============================================================
  PrepDomain(
    id: 11,
    domainNumber: 11,
    title: '''Observation Framework (@Observable) & Combine Reactive''',
    emoji: '''🌊''',
    tag: '''State & Reactive''',
    description: '''iOS 17 Observation framework replaces Combine ObservableObject with macro-driven property tracking. Combine provides declarative asynchronous event processing via Publishers, Subscribers, and Operators with backpressure control.''',
    architecturalBlueprint: '''Observation Framework (@Observable) & Combine Reactive forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Observation Framework (@Observable) & Combine Reactive internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''Observation Framework (@Observable, @Bindable) in iOS 17+''',
        definition: '''Observation Framework (@Observable, @Bindable) in iOS 17+ provides deterministic, type-safe execution within Observation Framework (@Observable) & Combine Reactive. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Observation Framework (@Observable, @Bindable) in iOS 17+ prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Observation Framework (@Observable, @Bindable) in iOS 17+
import Foundation

public final class Dom11top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Observation Framework (@Observable, @Bindable) in iOS 17+ behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Observation Framework (@Observable, @Bindable) in iOS 17+?''',
            answer: '''It manages observation framework (@observable, @bindable) in ios 17+ safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Observation Framework (@Observable, @Bindable) in iOS 17+ impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Observation Framework (@Observable, @Bindable) in iOS 17+ at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Combine Core (Publisher, Subscriber, Subscription Lifecycle)''',
        definition: '''Combine Core (Publisher, Subscriber, Subscription Lifecycle) provides deterministic, type-safe execution within Observation Framework (@Observable) & Combine Reactive. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Combine Core (Publisher, Subscriber, Subscription Lifecycle) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Combine Core (Publisher, Subscriber, Subscription Lifecycle)
import Foundation

public final class Dom11top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Combine Core (Publisher, Subscriber, Subscription Lifecycle) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Combine Core (Publisher, Subscriber, Subscription Lifecycle)?''',
            answer: '''It manages combine core (publisher, subscriber, subscription lifecycle) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Combine Core (Publisher, Subscriber, Subscription Lifecycle) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Combine Core (Publisher, Subscriber, Subscription Lifecycle) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Complex Combine Operators (flatMap, switchToLatest, share)''',
        definition: '''Complex Combine Operators (flatMap, switchToLatest, share) provides deterministic, type-safe execution within Observation Framework (@Observable) & Combine Reactive. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Complex Combine Operators (flatMap, switchToLatest, share) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Complex Combine Operators (flatMap, switchToLatest, share)
import Foundation

public final class Dom11top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Complex Combine Operators (flatMap, switchToLatest, share) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Complex Combine Operators (flatMap, switchToLatest, share)?''',
            answer: '''It manages complex combine operators (flatmap, switchtolatest, share) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Complex Combine Operators (flatMap, switchToLatest, share) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Complex Combine Operators (flatMap, switchToLatest, share) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Backpressure, Schedulers & Memory Management (AnyCancellable)''',
        definition: '''Backpressure, Schedulers & Memory Management (AnyCancellable) provides deterministic, type-safe execution within Observation Framework (@Observable) & Combine Reactive. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Backpressure, Schedulers & Memory Management (AnyCancellable) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Backpressure, Schedulers & Memory Management (AnyCancellable)
import Foundation

public final class Dom11top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Backpressure, Schedulers & Memory Management (AnyCancellable) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Backpressure, Schedulers & Memory Management (AnyCancellable)?''',
            answer: '''It manages backpressure, schedulers & memory management (anycancellable) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Backpressure, Schedulers & Memory Management (AnyCancellable) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Backpressure, Schedulers & Memory Management (AnyCancellable) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 12: Deep Linking, Universal Links (AASA) & App Routing
  // =============================================================
  PrepDomain(
    id: 12,
    domainNumber: 12,
    title: '''Deep Linking, Universal Links (AASA) & App Routing''',
    emoji: '''🔗''',
    tag: '''Routing & Links''',
    description: '''Deep linking routes users into specific app screens. Custom URL schemes handle legacy routing. Universal Links verify domain ownership via apple-app-site-association (AASA). Modern routing uses NavigationStack and Coordinator patterns.''',
    architecturalBlueprint: '''Deep Linking, Universal Links (AASA) & App Routing forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Deep Linking, Universal Links (AASA) & App Routing internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''Custom URL Schemes vs Universal Links (AASA)''',
        definition: '''Custom URL Schemes vs Universal Links (AASA) provides deterministic, type-safe execution within Deep Linking, Universal Links (AASA) & App Routing. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Custom URL Schemes vs Universal Links (AASA) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Custom URL Schemes vs Universal Links (AASA)
import Foundation

public final class Dom12top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Custom URL Schemes vs Universal Links (AASA) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Custom URL Schemes vs Universal Links (AASA)?''',
            answer: '''It manages custom url schemes vs universal links (aasa) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Custom URL Schemes vs Universal Links (AASA) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Custom URL Schemes vs Universal Links (AASA) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''NavigationStack & NavigationPath in SwiftUI''',
        definition: '''NavigationStack & NavigationPath in SwiftUI provides deterministic, type-safe execution within Deep Linking, Universal Links (AASA) & App Routing. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering NavigationStack & NavigationPath in SwiftUI prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: NavigationStack & NavigationPath in SwiftUI
import Foundation

public final class Dom12top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how NavigationStack & NavigationPath in SwiftUI behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of NavigationStack & NavigationPath in SwiftUI?''',
            answer: '''It manages navigationstack & navigationpath in swiftui safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does NavigationStack & NavigationPath in SwiftUI impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing NavigationStack & NavigationPath in SwiftUI at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Coordinator Pattern & Flow Routing Architecture''',
        definition: '''Coordinator Pattern & Flow Routing Architecture provides deterministic, type-safe execution within Deep Linking, Universal Links (AASA) & App Routing. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Coordinator Pattern & Flow Routing Architecture prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Coordinator Pattern & Flow Routing Architecture
import Foundation

public final class Dom12top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Coordinator Pattern & Flow Routing Architecture behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Coordinator Pattern & Flow Routing Architecture?''',
            answer: '''It manages coordinator pattern & flow routing architecture safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Coordinator Pattern & Flow Routing Architecture impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Coordinator Pattern & Flow Routing Architecture at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Cold Start vs Warm State Push Deep Linking''',
        definition: '''Cold Start vs Warm State Push Deep Linking provides deterministic, type-safe execution within Deep Linking, Universal Links (AASA) & App Routing. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Cold Start vs Warm State Push Deep Linking prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Cold Start vs Warm State Push Deep Linking
import Foundation

public final class Dom12top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Cold Start vs Warm State Push Deep Linking behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Cold Start vs Warm State Push Deep Linking?''',
            answer: '''It manages cold start vs warm state push deep linking safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Cold Start vs Warm State Push Deep Linking impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Cold Start vs Warm State Push Deep Linking at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 13: WebKit, WKWebView & Hybrid Native-Web Architecture
  // =============================================================
  PrepDomain(
    id: 13,
    domainNumber: 13,
    title: '''WebKit, WKWebView & Hybrid Native-Web Architecture''',
    emoji: '''🌐''',
    tag: '''WebKit & Hybrid''',
    description: '''WKWebView runs web content out-of-process in isolated WebContent processes. WKScriptMessageHandler enables bi-directional native-JS bridges. WKWebsiteDataStore manages cookie synchronization and persistent web cache.''',
    architecturalBlueprint: '''WebKit, WKWebView & Hybrid Native-Web Architecture forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of WebKit, WKWebView & Hybrid Native-Web Architecture internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''WKWebView Architecture & Multi-Process Model''',
        definition: '''WKWebView runs in a multi-process architecture separate from the host app: the WebContent process executes HTML/JS/CSS, and the Networking process handles network requests. If the WebContent process exceeds memory limits, it crashes without terminating the host app.''',
        mechanics: '''Understanding out-of-process WebKit execution is critical for preventing blank white screens, handling webProcessDidTerminate crash recovery, and managing cross-process IPC memory budgets.''',
        codeSnippet: '''import WebKit

public final class ResilientWebViewController: UIViewController, WKNavigationDelegate {
    private var webView: WKWebView!
    private var reloadAttempts = 0
    private let maxCrashRecoveryAttempts = 3

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }

    private func setupWebView() {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        
        webView = WKWebView(frame: view.bounds, configuration: config)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        view.addSubview(webView)
    }

    // Process termination recovery (Out-of-Memory / JetSam termination)
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        guard reloadAttempts < maxCrashRecoveryAttempts else {
            displayWebFailurePlaceholder()
            return
        }
        reloadAttempts += 1
        webView.reload()
    }

    private func displayWebFailurePlaceholder() {
        // Render native fallback UI when web process repeatedly terminates
    }
}''',
        wrongDoingsAndTraps: '''Assuming WKWebView is part of your app's memory address space; pointers cannot be passed directly across the boundary.''',
        questions: [
          DomainQuestion(
            question: '''Junior: Why does WKWebView run out-of-process in iOS?''',
            answer: '''For security sandboxing and app stability; a malicious script or crash in WebKit will not compromise host app memory or crash the host application.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How do you detect and recover from a WKWebView process crash caused by high memory pressure?''',
            answer: '''Implement webViewWebContentProcessDidTerminate(_:) on WKNavigationDelegate. When called, inspect retry count, re-initialize state if necessary, and call webView.reload() or render a native fallback error view.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How does XPC Mach messaging between host app and WebContent impact high-frequency JavaScript bridge events?''',
            answer: '''Each message across the process boundary requires Mach message serialization and context switches. Firing high-frequency scroll or animation events across the bridge causes IPC saturation and UI jank. Batched throttling or shared memory rings are required.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''WKScriptMessageHandler & Bi-Directional Native Bridge''',
        definition: '''WKScriptMessageHandler establishes a secure, asynchronous bi-directional communication bridge between JavaScript and native Swift. WKUserContentController receives JSON payloads via window.webkit.messageHandlers.<name>.postMessage(payload).''',
        mechanics: '''Passing data insecurely or creating strong retain cycles between WKUserContentController and UIViewController leads to massive memory leaks.''',
        codeSnippet: '''import WebKit

// Weak proxy to prevent retain cycle with WKUserContentController
public final class WeakScriptMessageHandler: NSObject, WKScriptMessageHandler {
    private weak var delegate: WKScriptMessageHandler?

    public init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
    }

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}

public final class HybridBridgeManager: NSObject, WKScriptMessageHandler {
    public func attach(to config: WKWebViewConfiguration) {
        config.userContentController.add(WeakScriptMessageHandler(delegate: self), name: "checkoutBridge")
    }

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == "checkoutBridge",
              let body = message.body as? [String: Any],
              let action = body["action"] as? String else { return }
        
        Task { @MainActor in
            handleBridgeAction(action, payload: body)
        }
    }

    private func handleBridgeAction(_ action: String, payload: [String: Any]) {
        // Validate origin and execute native payment / navigation
    }
}''',
        wrongDoingsAndTraps: '''Forgetting to validate message.frame.request.url.host before executing privileged native actions like payments or biometric prompts.''',
        questions: [
          DomainQuestion(
            question: '''Junior: How do you send a message from JavaScript to native iOS in WKWebView?''',
            answer: '''By calling window.webkit.messageHandlers.<handlerName>.postMessage(data) in JS and registering a WKScriptMessageHandler in Swift.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: Why does registering a UIViewController directly with WKUserContentController cause a memory leak, and how do you resolve it?''',
            answer: '''WKUserContentController holds a strong reference to the message handler, creating a circular reference. Resolve it by inserting an intermediate weak proxy (WeakScriptMessageHandler) or removing the script handler in viewWillDisappear/deinit.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How do you architect a secure bi-directional bridge preventing Cross-Site Scripting (XSS) exploitation of native APIs?''',
            answer: '''Validate message.frame.securityOrigin to whitelist authorized host domains, sanitize all input payloads via Codable schema validation, avoid eval() when evaluating JavaScript callbacks, and use evaluateJavaScript(_:completionHandler:) with strict CSP.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Cookie Storage, Session Sync & WKWebsiteDataStore''',
        definition: '''WKWebsiteDataStore manages all cookies, IndexedDB, local storage, and WebSQL caches. Default data stores persist to disk, while nonPersistent() stores operate strictly in memory for incognito sessions.''',
        mechanics: '''Synchronizing authentication tokens between native URLSession and WKWebView requires proactive cookie injection; failing to synchronize causes unauthorized 401 errors.''',
        codeSnippet: '''import WebKit

public actor CookieSyncCoordinator {
    public static let shared = CookieSyncCoordinator()

    @MainActor
    public func injectNativeCookies(from sessionCookies: [HTTPCookie], into webView: WKWebView) async {
        let cookieStore = webView.configuration.websiteDataStore.httpCookieStore
        
        for cookie in sessionCookies {
            await withCheckedContinuation { continuation in
                cookieStore.setCookie(cookie) {
                    continuation.resume()
                }
            }
        }
    }

    @MainActor
    public func clearSessionData() async {
        let dataStore = WKWebsiteDataStore.default()
        let types = WKWebsiteDataStore.allWebsiteDataTypes()
        let date = Date(timeIntervalSince1970: 0)
        
        await withCheckedContinuation { continuation in
            dataStore.removeData(ofTypes: types, modifiedSince: date) {
                continuation.resume()
            }
        }
    }
}''',
        wrongDoingsAndTraps: '''Assuming document.cookie in JavaScript can read HttpOnly cookies; only WKHTTPCookieStore can view and manipulate HttpOnly cookies.''',
        questions: [
          DomainQuestion(
            question: '''Junior: How do you share cookies between native URLSession and WKWebView?''',
            answer: '''Extract cookies from HTTPCookieStorage.shared and inject them asynchronously into WKWebsiteDataStore.default().httpCookieStore via setCookie(_:).''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: Why does loading a webpage immediately after calling httpCookieStore.setCookie often result in missing session cookies?''',
            answer: '''Because WKHTTPCookieStore is asynchronous and executes across an IPC boundary to the WebKit Networking daemon. If webView.load() is invoked before the completion handler fires, the request departs before the cookie is committed.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How do you completely purge all user session data (cookies, LocalStorage, IndexedDB) during user logout in a compliant GDPR manner?''',
            answer: '''Call WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: Date.distantPast). Await the completion handler before allowing any new unauthenticated web requests.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Security Sandbox & Content Rule Lists''',
        definition: '''WebKit Content Rule Lists provide declarative, compile-time filtering of network loads, cookies, and tracking scripts, matching Safari Content Blocker syntax for high-performance ad/tracker blocking and privacy enforcement.''',
        mechanics: '''Declarative rules are compiled by WebKit into optimized bytecode and executed in C++, blocking tracking domains and malicious scripts with zero JavaScript CPU overhead.''',
        codeSnippet: '''import WebKit

public final class WebSecurityManager {
    public static let shared = WebSecurityManager()

    private let trackerRuleJSON = """
    [
        {
            "trigger": {
                "url-filter": ".*tracker.*",
                "resource-type": ["script", "image"]
            },
            "action": {
                "type": "block"
            }
        },
        {
            "trigger": {
                "url-filter": ".*",
                "if-domain": ["*untrusted-cdn.com"]
            },
            "action": {
                "type": "block-cookies"
            }
        }
    ]
    """

    public func applySecurityPolicies(to config: WKWebViewConfiguration) async throws {
        let store = WKContentRuleListStore.default()
        
        let ruleList: WKContentRuleList = try await withCheckedThrowingContinuation { continuation in
            store.compileContentRuleList(forIdentifier: "AppSecurityRules", encodedContentRuleList: trackerRuleJSON) { list, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let list = list {
                    continuation.resume(returning: list)
                }
            }
        }
        
        config.userContentController.add(ruleList)
    }
}''',
        wrongDoingsAndTraps: '''Believing WKNavigationDelegate can block background image or tracking pixel loads; only WKContentRuleList can block subresources.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is a WKContentRuleList in WebKit?''',
            answer: '''A compiled declarative rule set that allows blocking resources, cookies, or upgrading requests to HTTPS without running custom JavaScript.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: Why are Content Rule Lists significantly more efficient than JavaScript-based content blocking?''',
            answer: '''Because they are compiled into native C++ deterministic finite automatons and evaluated directly in WebKit's network stack before requests depart, with zero JavaScript execution or IPC message overhead.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How do you implement an enterprise Content Security Policy (CSP) and tracker blocker in a WKWebView using compiled rule lists?''',
            answer: '''Define strict JSON triggers with url-filter regexes and actions (block, block-cookies, make-https), compile via WKContentRuleListStore with versioned identifiers, cache compiled rules on disk, and attach to WKUserContentController before loading content.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 14: Multimedia, AVFoundation, Core Animation & 120Hz Jank
  // =============================================================
  PrepDomain(
    id: 14,
    domainNumber: 14,
    title: '''Multimedia, AVFoundation, Core Animation & 120Hz Jank''',
    emoji: '''🎬''',
    tag: '''Graphics & Audio''',
    description: '''Core Animation renders layers via the out-of-process render server. Offscreen rendering occurs with unbacked masks and corner radii. AVFoundation manages real-time audio sessions and video decoding. Zero-jank budgeting allows 8.33ms per frame.''',
    architecturalBlueprint: '''Multimedia, AVFoundation, Core Animation & 120Hz Jank forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Multimedia, AVFoundation, Core Animation & 120Hz Jank internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''Core Animation Render Pipeline & Layer Trees''',
        definition: '''The Core Animation render pipeline operates across 4 distinct phases: Commit (App), Render Tree Preparation, Render (render server process), and Display (GPU frame buffer). The app commits layer tree states via IPC to the system backboardd/render server.''',
        mechanics: '''Understanding the boundary between the host app and the render server process is crucial for profiling frame drops, offscreen passes, and GPU stalls in Instruments.''',
        codeSnippet: '''import UIKit
import QuartzCore

public final class HighPerformanceCardView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayerPipeline()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayerPipeline()
    }

    private func setupLayerPipeline() {
        // Explicitly set opaque to avoid GPU alpha-blending passes
        layer.isOpaque = true
        backgroundColor = .systemBackground
        
        // Cache shadow path to avoid dynamic offscreen rendering pass
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8.0
        layer.shadowOffset = CGSize(width: 0, height: 4)
        updateShadowPath()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateShadowPath()
    }

    private func updateShadowPath() {
        // Critical: Passing explicit CGPath prevents GPU render server offscreen pass
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 12.0).cgPath
    }
}''',
        wrongDoingsAndTraps: '''Modifying presentationLayer values expecting model state changes; presentationLayer is read-only during animations.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What are the four phases of the Core Animation commit pipeline in the app process?''',
            answer: '''Layout (layoutSubviews), Display (draw(_:)), Prepare (image decompression/format conversion), and Commit (packing layers into IPC for render server).''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: Why does setting a shadow on a CALayer without defining shadowPath devastate scrolling performance?''',
            answer: '''Because the GPU cannot compute the shadow geometry without first rendering the layer and all its children into a temporary offscreen buffer, creating an offscreen pass on every frame.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: Explain the difference between the Model Layer Tree, Presentation Layer Tree, and Render Tree during an ongoing spring animation.''',
            answer: '''The Model Tree stores target values set in code. The Presentation Tree represents instantaneous interpolated values currently visible. The Render Tree is the private compiled tree inside the out-of-process render server executing GPU draws.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Offscreen Rendering Causes & Rasterization Optimization''',
        definition: '''Offscreen rendering occurs when the GPU cannot draw content directly into the frame buffer and must allocate a temporary offscreen buffer to combine multiple rendering passes (masks, un-cached shadows, cornerRadius with masksToBounds, group opacity).''',
        mechanics: '''Offscreen rendering requires GPU pipeline stalls and context switches, dropping frame rates from 120Hz/60Hz and consuming high battery power.''',
        codeSnippet: '''import UIKit

public final class OptimizedAvatarImageView: UIImageView {
    public func setRoundedImage(_ image: UIImage, cornerRadius: CGFloat) {
        // High-performance CPU pre-clipping: Zero GPU offscreen pass
        let size = bounds.size
        guard size.width > 0, size.height > 0 else { return }

        let renderer = UIGraphicsImageRenderer(size: size)
        let roundedImage = renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
            image.draw(in: rect)
        }
        
        self.image = roundedImage
        // Disable expensive GPU masking
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 0
    }
}''',
        wrongDoingsAndTraps: '''Believing shouldRasterize = true is a cure-all; rasterizing dynamically moving or resizing views causes severe offscreen churn.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is offscreen rendering and why is it problematic on iOS?''',
            answer: '''It is when the GPU must render content into an intermediate memory buffer before copying to the frame buffer, causing context switches and dropping frame rates.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: What are 4 common triggers of offscreen rendering in UIKit?''',
            answer: '''1. Shadows without shadowPath. 2. cornerRadius combined with masksToBounds. 3. Masks (layer.mask). 4. Group opacity (allowsGroupOpacity with transparent sublayers).''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How does Apple Silicon Tile-Based Deferred Rendering (TBDR) architecture exacerbate the cost of offscreen render passes?''',
            answer: '''TBDR relies on tile-memory (on-chip SRAM) to process geometry and deferred shading before writing to unified memory. An offscreen pass forces flushing tile memory to main DRAM, incurring massive memory bus bandwidth penalties and battery consumption.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''AVFoundation Audio Session & Video Playback Pipelines''',
        definition: '''AVFoundation manages multimedia through an asynchronous pipeline: AVAudioSession coordinates hardware audio routing, AVPlayer/AVQueuePlayer handles asset streaming, and AVPlayerItem tracks timeline buffering states.''',
        mechanics: '''Failing to properly configure AVAudioSession categories and interrupts leads to silent playback bugs, audio ducking failures, and App Store rejections.''',
        codeSnippet: '''import AVFoundation

public final class RobustAudioPlaybackEngine: Sendable {
    private let player = AVPlayer()

    public func configureSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers, .interruptSpokenAudioAndMixWithOthers])
        try session.setActive(true)
        
        NotificationCenter.default.addObserver(
            forName: AVAudioSession.interruptionNotification,
            object: session,
            queue: .main
        ) { [weak self] notification in
            self?.handleInterruption(notification)
        }
    }

    private func handleInterruption(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }

        switch type {
        case .began:
            player.pause()
        case .ended:
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    player.play()
                }
            }
        @unknown default:
            break
        }
    }
}''',
        wrongDoingsAndTraps: '''Calling setActive(false) while other background audio is playing, inadvertently terminating other apps' music.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the role of AVAudioSession in iOS multimedia apps?''',
            answer: '''It acts as the intermediary between your app and the system audio hardware, defining audio category, interruptions, and mixing behaviors.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How do you correctly handle an incoming phone call interruption during media playback in AVPlayer?''',
            answer: '''Observe AVAudioSession.interruptionNotification. On .began, pause the player. On .ended, inspect AVAudioSessionInterruptionOptions for .shouldResume, and only resume playback if true.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How do you achieve seamless gapless playback and pre-buffering across sequential video items in a short-form video feed (e.g. TikTok/Reels)?''',
            answer: '''Use AVQueuePlayer with a pool of pre-initialized AVPlayerItem instances, configure automaticallyWaitsToMinimizeStalling = true, preload tracks asynchronously via AVAsset.loadValuesAsynchronously, and bound preferredForwardBufferDuration to prevent memory exhaustion.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''120Hz ProMotion Zero-Jank Frame Budgeting (8.33ms)''',
        definition: '''On 120Hz ProMotion displays (iPhone 13 Pro+), each frame must be completely laid out, prepared, and committed within an 8.33ms budget (vs 16.67ms on 60Hz). Exceeding this budget causes dropped frames (jank).''',
        mechanics: '''High-end devices expose micro-stutters immediately; staying under the 8.33ms budget requires eliminating main-thread JSON parsing, view hierarchy recalculations, and layout thrashing.''',
        codeSnippet: '''import UIKit
import QuartzCore

public final class ProMotionAdaptiveAnimator {
    private var displayLink: CADisplayLink?

    public func startSmoothAnimation() {
        displayLink = CADisplayLink(target: self, selector: #selector(handleFrameUpdate(link:)))
        
        // Target dynamic 120Hz ProMotion rates on capable hardware
        displayLink?.preferredFrameRateRange = CAFrameRateRange(
            minimum: 60,
            maximum: 120,
            preferred: 120
        )
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc private func handleFrameUpdate(link: CADisplayLink) {
        let frameDuration = link.targetTimestamp - link.timestamp
        // Ensure calculations finish in < 4ms to leave headroom for render server
        updatePositions(deltaTime: frameDuration)
    }

    private func updatePositions(deltaTime: CFTimeInterval) {
        // Fast numerical calculation with zero heap allocations
    }

    public func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }
}''',
        wrongDoingsAndTraps: '''Allocating objects inside CADisplayLink tick callbacks; heap allocations trigger ARC churn and hitch spikes.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the frame budget for a 120Hz ProMotion display on iPhone?''',
            answer: '''8.33 milliseconds per frame (compared to 16.67ms for standard 60Hz displays).''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does CADisplayLink differ from Timer when driving high-performance animations?''',
            answer: '''CADisplayLink is synchronized with the display hardware's vertical refresh rate (V-Sync), eliminating frame stutter and visual tearing that occurs with unsynchronized NSTimers.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How do you profile and measure Hitch Time Ratio in MetricKit and Instruments to diagnose scrolling jank?''',
            answer: '''MetricKit reports MXScrollMetrics containing cumulativeHitchTime. In Instruments Core Animation / Time Profiler, filter by Hitch Ratio (ms of delay per second). Hitches over 5ms/s indicate noticeable stutter, usually traced to main-thread layout passes or offscreen GPU rendering.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 15: Networking, URLSession Internals, HTTP/2-3 & Distributed APIs
  // =============================================================
  PrepDomain(
    id: 15,
    domainNumber: 15,
    title: '''Networking, URLSession Internals, HTTP/2-3 & Distributed APIs''',
    emoji: '''🌐''',
    tag: '''Networking''',
    description: '''URLSession provides HTTP client functionality supporting HTTP/2 multiplexing and HTTP/3 QUIC. Security features include SSL Pinning and Certificate Transparency. Resilient clients implement exponential backoff with jitter.''',
    architecturalBlueprint: '''Networking, URLSession Internals, HTTP/2-3 & Distributed APIs forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Networking, URLSession Internals, HTTP/2-3 & Distributed APIs internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''URLSession Configuration, Tasks & Cache-Control''',
        definition: '''URLSession Configuration, Tasks & Cache-Control provides deterministic, type-safe execution within Networking, URLSession Internals, HTTP/2-3 & Distributed APIs. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering URLSession Configuration, Tasks & Cache-Control prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: URLSession Configuration, Tasks & Cache-Control
import Foundation

public final class Dom15top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how URLSession Configuration, Tasks & Cache-Control behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of URLSession Configuration, Tasks & Cache-Control?''',
            answer: '''It manages urlsession configuration, tasks & cache-control safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does URLSession Configuration, Tasks & Cache-Control impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing URLSession Configuration, Tasks & Cache-Control at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''HTTP/2 Multiplexing & HTTP/3 (QUIC) Transport''',
        definition: '''HTTP/2 Multiplexing & HTTP/3 (QUIC) Transport provides deterministic, type-safe execution within Networking, URLSession Internals, HTTP/2-3 & Distributed APIs. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering HTTP/2 Multiplexing & HTTP/3 (QUIC) Transport prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: HTTP/2 Multiplexing & HTTP/3 (QUIC) Transport
import Foundation

public final class Dom15top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how HTTP/2 Multiplexing & HTTP/3 (QUIC) Transport behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of HTTP/2 Multiplexing & HTTP/3 (QUIC) Transport?''',
            answer: '''It manages http/2 multiplexing & http/3 (quic) transport safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does HTTP/2 Multiplexing & HTTP/3 (QUIC) Transport impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing HTTP/2 Multiplexing & HTTP/3 (QUIC) Transport at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''SSL Pinning, Certificate Transparency & Public Keys''',
        definition: '''SSL Pinning validates the remote server's X.509 certificate or Public Key against an embedded copy inside the app bundle, preventing Man-in-the-Middle (MitM) attacks.''',
        mechanics: '''Protects financial, personal, and authentication tokens against compromised Certificate Authorities (CAs) or malicious enterprise proxy profiles.''',
        codeSnippet: '''// Modern Swift 6 Public Key SSL Pinning Implementation
public final class SecureSessionDelegate: NSObject, URLSessionDelegate, Sendable {
    private let pinnedPublicKeyHash: String = "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=" // SHA-256 base64

    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge
    ) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust else {
            return (.cancelAuthenticationChallenge, nil)
        }

        // Validate basic certificate chain validity
        var error: CFError?
        guard SecTrustEvaluateWithError(serverTrust, &error) else {
            return (.cancelAuthenticationChallenge, nil)
        }

        // Extract Leaf Certificate Public Key
        guard let serverKey = SecTrustCopyKey(serverTrust),
              let serverKeyData = SecKeyCopyExternalRepresentation(serverKey, nil) as Data? else {
            return (.cancelAuthenticationChallenge, nil)
        }

        // Compute SHA-256 hash
        let hash = SHA256.hash(data: serverKeyData)
        let hashString = Data(hash).base64EncodedString()

        if hashString == pinnedPublicKeyHash {
            return (.useCredential, URLCredential(trust: serverTrust))
        } else {
            return (.cancelAuthenticationChallenge, nil)
        }
    }
}''',
        wrongDoingsAndTraps: '''Not including a backup pin; if the primary key is compromised and rotated on backend, users cannot connect until an App Store update is approved.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is SSL Pinning and why do apps use it?''',
            answer: '''SSL Pinning ensures the app only communicates with a specific server by validating its exact certificate or public key, preventing Man-in-the-Middle attacks.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: Why is Public Key Pinning preferred over Certificate Pinning?''',
            answer: '''Certificates expire annually and require app updates. Public keys can remain identical across certificate renewals, allowing backend teams to renew certificates without breaking older app versions.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How do you handle Certificate Transparency (CT) and pinning fallback in enterprise iOS apps?''',
            answer: '''Enable Certificate Transparency checks via SecTrustSetSignedCertificateTimestamps and configure a secondary backup public key pin hash in an emergency remote config fallback pipeline.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Exponential Backoff, Jitter & Offline Retry Queues''',
        definition: '''Exponential Backoff, Jitter & Offline Retry Queues provides deterministic, type-safe execution within Networking, URLSession Internals, HTTP/2-3 & Distributed APIs. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Exponential Backoff, Jitter & Offline Retry Queues prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Exponential Backoff, Jitter & Offline Retry Queues
import Foundation

public final class Dom15top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Exponential Backoff, Jitter & Offline Retry Queues behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Exponential Backoff, Jitter & Offline Retry Queues?''',
            answer: '''It manages exponential backoff, jitter & offline retry queues safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Exponential Backoff, Jitter & Offline Retry Queues impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Exponential Backoff, Jitter & Offline Retry Queues at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 16: Data Serialization, Codable Internals & JSON Performance
  // =============================================================
  PrepDomain(
    id: 16,
    domainNumber: 16,
    title: '''Data Serialization, Codable Internals & JSON Performance''',
    emoji: '''📦''',
    tag: '''Codable & JSON''',
    description: '''Codable automates encoding and decoding between Swift models and serialized formats like JSON. Custom KeyedDecodingContainers handle polymorphic payloads. Background thread decoding prevents main thread frame drops.''',
    architecturalBlueprint: '''Data Serialization, Codable Internals & JSON Performance forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Data Serialization, Codable Internals & JSON Performance internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''Codable Protocol Internals & KeyedDecodingContainer''',
        definition: '''Codable Protocol Internals & KeyedDecodingContainer provides deterministic, type-safe execution within Data Serialization, Codable Internals & JSON Performance. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Codable Protocol Internals & KeyedDecodingContainer prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Codable Protocol Internals & KeyedDecodingContainer
import Foundation

public final class Dom16top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Codable Protocol Internals & KeyedDecodingContainer behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Codable Protocol Internals & KeyedDecodingContainer?''',
            answer: '''It manages codable protocol internals & keyeddecodingcontainer safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Codable Protocol Internals & KeyedDecodingContainer impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Codable Protocol Internals & KeyedDecodingContainer at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Custom DateDecodingStrategy & KeyDecodingStrategy''',
        definition: '''Custom DateDecodingStrategy & KeyDecodingStrategy provides deterministic, type-safe execution within Data Serialization, Codable Internals & JSON Performance. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Custom DateDecodingStrategy & KeyDecodingStrategy prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Custom DateDecodingStrategy & KeyDecodingStrategy
import Foundation

public final class Dom16top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Custom DateDecodingStrategy & KeyDecodingStrategy behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Custom DateDecodingStrategy & KeyDecodingStrategy?''',
            answer: '''It manages custom datedecodingstrategy & keydecodingstrategy safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Custom DateDecodingStrategy & KeyDecodingStrategy impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Custom DateDecodingStrategy & KeyDecodingStrategy at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Decoding Heavy Payloads with Background Threads''',
        definition: '''Decoding Heavy Payloads with Background Threads provides deterministic, type-safe execution within Data Serialization, Codable Internals & JSON Performance. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Decoding Heavy Payloads with Background Threads prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Decoding Heavy Payloads with Background Threads
import Foundation

public final class Dom16top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Decoding Heavy Payloads with Background Threads behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Decoding Heavy Payloads with Background Threads?''',
            answer: '''It manages decoding heavy payloads with background threads safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Decoding Heavy Payloads with Background Threads impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Decoding Heavy Payloads with Background Threads at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Typed Error Handling in Malformed API Responses''',
        definition: '''Typed Error Handling in Malformed API Responses provides deterministic, type-safe execution within Data Serialization, Codable Internals & JSON Performance. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Typed Error Handling in Malformed API Responses prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Typed Error Handling in Malformed API Responses
import Foundation

public final class Dom16top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Typed Error Handling in Malformed API Responses behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Typed Error Handling in Malformed API Responses?''',
            answer: '''It manages typed error handling in malformed api responses safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Typed Error Handling in Malformed API Responses impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Typed Error Handling in Malformed API Responses at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 17: Enterprise Core Data, Faulting & SQLite WAL Architecture
  // =============================================================
  PrepDomain(
    id: 17,
    domainNumber: 17,
    title: '''Enterprise Core Data, Faulting & SQLite WAL Architecture''',
    emoji: '''💾''',
    tag: '''Core Data & SQLite''',
    description: '''Core Data is an object graph manager and persistence framework backed by SQLite. NSManagedObjectContext manages changes in memory. Faulting delays loading property data. SQLite WAL mode supports concurrent readers during writes.''',
    architecturalBlueprint: '''Enterprise Core Data, Faulting & SQLite WAL Architecture forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Enterprise Core Data, Faulting & SQLite WAL Architecture internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''NSManagedObjectContext Concurrency & Parent-Child Trees''',
        definition: '''NSManagedObjectContext Concurrency & Parent-Child Trees provides deterministic, type-safe execution within Enterprise Core Data, Faulting & SQLite WAL Architecture. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering NSManagedObjectContext Concurrency & Parent-Child Trees prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: NSManagedObjectContext Concurrency & Parent-Child Trees
import Foundation

public final class Dom17top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how NSManagedObjectContext Concurrency & Parent-Child Trees behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of NSManagedObjectContext Concurrency & Parent-Child Trees?''',
            answer: '''It manages nsmanagedobjectcontext concurrency & parent-child trees safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does NSManagedObjectContext Concurrency & Parent-Child Trees impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing NSManagedObjectContext Concurrency & Parent-Child Trees at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Faulting, Prefetching & NSFetchedResultsController''',
        definition: '''Faulting, Prefetching & NSFetchedResultsController provides deterministic, type-safe execution within Enterprise Core Data, Faulting & SQLite WAL Architecture. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Faulting, Prefetching & NSFetchedResultsController prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Faulting, Prefetching & NSFetchedResultsController
import Foundation

public final class Dom17top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Faulting, Prefetching & NSFetchedResultsController behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Faulting, Prefetching & NSFetchedResultsController?''',
            answer: '''It manages faulting, prefetching & nsfetchedresultscontroller safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Faulting, Prefetching & NSFetchedResultsController impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Faulting, Prefetching & NSFetchedResultsController at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''SQLite Write-Ahead Logging (WAL) Mode''',
        definition: '''SQLite Write-Ahead Logging (WAL) Mode provides deterministic, type-safe execution within Enterprise Core Data, Faulting & SQLite WAL Architecture. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering SQLite Write-Ahead Logging (WAL) Mode prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: SQLite Write-Ahead Logging (WAL) Mode
import Foundation

public final class Dom17top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how SQLite Write-Ahead Logging (WAL) Mode behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of SQLite Write-Ahead Logging (WAL) Mode?''',
            answer: '''It manages sqlite write-ahead logging (wal) mode safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does SQLite Write-Ahead Logging (WAL) Mode impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing SQLite Write-Ahead Logging (WAL) Mode at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Core Data Migration Strategies (Lightweight vs Heavyweight)''',
        definition: '''Core Data Migration Strategies (Lightweight vs Heavyweight) provides deterministic, type-safe execution within Enterprise Core Data, Faulting & SQLite WAL Architecture. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Core Data Migration Strategies (Lightweight vs Heavyweight) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Core Data Migration Strategies (Lightweight vs Heavyweight)
import Foundation

public final class Dom17top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Core Data Migration Strategies (Lightweight vs Heavyweight) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Core Data Migration Strategies (Lightweight vs Heavyweight)?''',
            answer: '''It manages core data migration strategies (lightweight vs heavyweight) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Core Data Migration Strategies (Lightweight vs Heavyweight) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Core Data Migration Strategies (Lightweight vs Heavyweight) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 18: Modern SwiftData, ModelContext, ModelActor & CloudKit
  // =============================================================
  PrepDomain(
    id: 18,
    domainNumber: 18,
    title: '''Modern SwiftData, ModelContext, ModelActor & CloudKit''',
    emoji: '''☁️''',
    tag: '''SwiftData & Cloud''',
    description: '''SwiftData provides Swift-native persistence powered by the @Model macro and Swift 6 concurrency. ModelContext tracks object changes. ModelActor enables safe background processing. Native CloudKit synchronization handles multi-device state.''',
    architecturalBlueprint: '''Modern SwiftData, ModelContext, ModelActor & CloudKit forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Modern SwiftData, ModelContext, ModelActor & CloudKit internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''@Model Macro, ModelContainer & Configuration''',
        definition: '''@Model Macro, ModelContainer & Configuration provides deterministic, type-safe execution within Modern SwiftData, ModelContext, ModelActor & CloudKit. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering @Model Macro, ModelContainer & Configuration prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: @Model Macro, ModelContainer & Configuration
import Foundation

public final class Dom18top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how @Model Macro, ModelContainer & Configuration behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of @Model Macro, ModelContainer & Configuration?''',
            answer: '''It manages @model macro, modelcontainer & configuration safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does @Model Macro, ModelContainer & Configuration impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing @Model Macro, ModelContainer & Configuration at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''ModelContext Concurrency & ModelActor Background Processing''',
        definition: '''ModelContext Concurrency & ModelActor Background Processing provides deterministic, type-safe execution within Modern SwiftData, ModelContext, ModelActor & CloudKit. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering ModelContext Concurrency & ModelActor Background Processing prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: ModelContext Concurrency & ModelActor Background Processing
import Foundation

public final class Dom18top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how ModelContext Concurrency & ModelActor Background Processing behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of ModelContext Concurrency & ModelActor Background Processing?''',
            answer: '''It manages modelcontext concurrency & modelactor background processing safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does ModelContext Concurrency & ModelActor Background Processing impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing ModelContext Concurrency & ModelActor Background Processing at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''SwiftData Relationships, Delete Rules & Predicates''',
        definition: '''SwiftData Relationships, Delete Rules & Predicates provides deterministic, type-safe execution within Modern SwiftData, ModelContext, ModelActor & CloudKit. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering SwiftData Relationships, Delete Rules & Predicates prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: SwiftData Relationships, Delete Rules & Predicates
import Foundation

public final class Dom18top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how SwiftData Relationships, Delete Rules & Predicates behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of SwiftData Relationships, Delete Rules & Predicates?''',
            answer: '''It manages swiftdata relationships, delete rules & predicates safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does SwiftData Relationships, Delete Rules & Predicates impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing SwiftData Relationships, Delete Rules & Predicates at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''SwiftData to CloudKit Synchronization & Migration''',
        definition: '''SwiftData to CloudKit Synchronization & Migration provides deterministic, type-safe execution within Modern SwiftData, ModelContext, ModelActor & CloudKit. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering SwiftData to CloudKit Synchronization & Migration prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: SwiftData to CloudKit Synchronization & Migration
import Foundation

public final class Dom18top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how SwiftData to CloudKit Synchronization & Migration behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of SwiftData to CloudKit Synchronization & Migration?''',
            answer: '''It manages swiftdata to cloudkit synchronization & migration safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does SwiftData to CloudKit Synchronization & Migration impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing SwiftData to CloudKit Synchronization & Migration at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 19: iOS Security, Keychain, Secure Enclave & Cryptography
  // =============================================================
  PrepDomain(
    id: 19,
    domainNumber: 19,
    title: '''iOS Security, Keychain, Secure Enclave & Cryptography''',
    emoji: '''🔐''',
    tag: '''Security & Crypto''',
    description: '''iOS Security protects user data at rest and in transit. Keychain stores cryptographic secrets and tokens with hardware-backed encryption. Secure Enclave processes biometrics. CryptoKit provides modern cryptographic primitives.''',
    architecturalBlueprint: '''iOS Security, Keychain, Secure Enclave & Cryptography forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of iOS Security, Keychain, Secure Enclave & Cryptography internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''Keychain Access Groups & kSecAttrAccessible Levels''',
        definition: '''Keychain Access Groups & kSecAttrAccessible Levels provides deterministic, type-safe execution within iOS Security, Keychain, Secure Enclave & Cryptography. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Keychain Access Groups & kSecAttrAccessible Levels prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Keychain Access Groups & kSecAttrAccessible Levels
import Foundation

public final class Dom19top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Keychain Access Groups & kSecAttrAccessible Levels behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Keychain Access Groups & kSecAttrAccessible Levels?''',
            answer: '''It manages keychain access groups & ksecattraccessible levels safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Keychain Access Groups & kSecAttrAccessible Levels impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Keychain Access Groups & kSecAttrAccessible Levels at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Secure Enclave & Biometric Auth (LocalAuthentication)''',
        definition: '''Secure Enclave & Biometric Auth (LocalAuthentication) provides deterministic, type-safe execution within iOS Security, Keychain, Secure Enclave & Cryptography. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Secure Enclave & Biometric Auth (LocalAuthentication) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Secure Enclave & Biometric Auth (LocalAuthentication)
import Foundation

public final class Dom19top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Secure Enclave & Biometric Auth (LocalAuthentication) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Secure Enclave & Biometric Auth (LocalAuthentication)?''',
            answer: '''It manages secure enclave & biometric auth (localauthentication) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Secure Enclave & Biometric Auth (LocalAuthentication) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Secure Enclave & Biometric Auth (LocalAuthentication) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''CryptoKit (Symmetric/Asymmetric Encryption, SHA-256)''',
        definition: '''CryptoKit (Symmetric/Asymmetric Encryption, SHA-256) provides deterministic, type-safe execution within iOS Security, Keychain, Secure Enclave & Cryptography. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering CryptoKit (Symmetric/Asymmetric Encryption, SHA-256) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: CryptoKit (Symmetric/Asymmetric Encryption, SHA-256)
import Foundation

public final class Dom19top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how CryptoKit (Symmetric/Asymmetric Encryption, SHA-256) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of CryptoKit (Symmetric/Asymmetric Encryption, SHA-256)?''',
            answer: '''It manages cryptokit (symmetric/asymmetric encryption, sha-256) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does CryptoKit (Symmetric/Asymmetric Encryption, SHA-256) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing CryptoKit (Symmetric/Asymmetric Encryption, SHA-256) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Jailbreak Detection & Dynamic Analysis Countermeasures''',
        definition: '''Jailbreak Detection & Dynamic Analysis Countermeasures provides deterministic, type-safe execution within iOS Security, Keychain, Secure Enclave & Cryptography. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Jailbreak Detection & Dynamic Analysis Countermeasures prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Jailbreak Detection & Dynamic Analysis Countermeasures
import Foundation

public final class Dom19top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Jailbreak Detection & Dynamic Analysis Countermeasures behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Jailbreak Detection & Dynamic Analysis Countermeasures?''',
            answer: '''It manages jailbreak detection & dynamic analysis countermeasures safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Jailbreak Detection & Dynamic Analysis Countermeasures impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Jailbreak Detection & Dynamic Analysis Countermeasures at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 20: Privacy Manifests (PrivacyInfo.xcprivacy), APIs & ATT
  // =============================================================
  PrepDomain(
    id: 20,
    domainNumber: 20,
    title: '''Privacy Manifests (PrivacyInfo.xcprivacy), APIs & ATT''',
    emoji: '''🛡️''',
    tag: '''Privacy & Manifests''',
    description: '''Apple mandates Privacy Manifests (PrivacyInfo.xcprivacy) declaring Required Reason APIs, tracking domains, and nutrition labels. App Tracking Transparency (ATT) gates IDFA collection for advertising tracking.''',
    architecturalBlueprint: '''Privacy Manifests (PrivacyInfo.xcprivacy), APIs & ATT forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Privacy Manifests (PrivacyInfo.xcprivacy), APIs & ATT internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''Privacy Manifests (PrivacyInfo.xcprivacy) Structure''',
        definition: '''Privacy Manifests (PrivacyInfo.xcprivacy) are structured XML files required by Apple since Spring 2024. They declare the types of data collected, tracking practices, and approved reason codes for accessing sensitive platform APIs.''',
        mechanics: '''Missing or improperly formatted Privacy Manifests in your app or third-party dependencies results in immediate App Store Connect binary upload rejection (ITMS-91053).''',
        codeSnippet: '''// PrivacyInfo.xcprivacy XML Structure for App Store Compliance
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSPrivacyTracking</key>
    <false/>
    <key>NSPrivacyTrackingDomains</key>
    <array/>
    <key>NSPrivacyCollectedDataTypes</key>
    <array>
        <dict>
            <key>NSPrivacyCollectedDataType</key>
            <string>NSPrivacyCollectedDataTypeUserID</string>
            <key>NSPrivacyCollectedDataTypeLinked</key>
            <true/>
            <key>NSPrivacyCollectedDataTypeTracking</key>
            <false/>
            <key>NSPrivacyCollectedDataTypePurposes</key>
            <array>
                <string>NSPrivacyCollectedDataTypePurposeAppFunctionality</string>
            </array>
        </dict>
    </array>
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
</dict>
</plist>''',
        wrongDoingsAndTraps: '''Declaring tracking = false in the manifest while firing tracking network calls to third-party ad networks before ATT authorization.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is PrivacyInfo.xcprivacy and when is it required?''',
            answer: '''It is an Apple-mandated privacy manifest XML file required for all apps and third-party SDKs to declare data collection, tracking domains, and Required Reason API usage.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Xcode help you verify Privacy Manifest completeness across your app and all SPM dependencies?''',
            answer: '''By archiving the app in Xcode Organizer, contextual clicking the archive, and choosing 'Generate Privacy Report', which outputs a consolidated PDF detailing all declared and undeclared API reasons and data types.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How does Apple enforce tracking domain blocking when NSPrivacyTracking is true vs false?''',
            answer: '''If a domain is listed in NSPrivacyTrackingDomains, the OS automatically blocks network requests to that domain if the user has not granted App Tracking Transparency (ATT) permission, throwing a network connection failure.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Required Reason APIs & NSPrivacyAccessedAPITypes''',
        definition: '''Apple designates 4 sensitive API categories as 'Required Reason APIs': File Timestamp APIs, System Boot Time APIs, Disk Space APIs, and UserDefaults APIs. Developers must declare specific Apple-approved reason strings (e.g. CA92.1) in their manifest.''',
        mechanics: '''Apple introduced Required Reason APIs to permanently prevent fingerprinting (identifying users across apps without consent).''',
        codeSnippet: '''import Foundation

// Safe abstraction accessing Required Reason APIs with verified justification
public enum AppPreferencesManager {
    // Reason: CA92.1 (Access UserDefaults to read and write app-specific state)
    public static func markOnboardingComplete() {
        UserDefaults.standard.set(true, forKey: "has_completed_onboarding")
    }

    // Reason: C617.1 (Access file timestamps to verify cache freshness)
    public static func isCacheValid(at fileURL: URL, maxAge: TimeInterval) -> Bool {
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: fileURL.path),
              let modDate = attributes[.modificationDate] as? Date else {
            return false
        }
        return Date().timeIntervalSince(modDate) < maxAge
    }
}''',
        wrongDoingsAndTraps: '''Believing UserDefaults doesn't require a reason code because it is basic Foundation functionality; it strictly requires CA92.1.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is reason code CA92.1 for in PrivacyInfo.xcprivacy?''',
            answer: '''It is the approved reason code declaring that the app accesses UserDefaults to store and read app-specific configuration data.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: Why did Apple restrict access to File Timestamps, Disk Space, and Boot Time APIs?''',
            answer: '''Because malicious ad SDKs combined minute disk space variations, boot time microseconds, and file modification dates to construct immutable device fingerprints without user consent.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How would you diagnose which third-party dependency in a large modular SPM project is triggering an ITMS-91053 Required Reason rejection?''',
            answer: '''Generate the Privacy Report from the Xcode archive to see the flagged category, then run 'nm -u' or 'grep -rn' on derived data binary artifacts to locate symbols like _OBJC_CLASS_\$_NSUserDefaults or _statfs in third-party frameworks.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Third-Party SDK Privacy Auditing & Supply Chain Risk''',
        definition: '''Apple maintains a list of 'Privacy-Impacting Third-Party SDKs' (e.g., Firebase, Facebook SDK, Alamofire, AppsFlyer). Starting in 2024, these SDKs MUST include their own Privacy Manifest AND be cryptographically signed with an Apple Developer ID.''',
        mechanics: '''Unsigned or unmanifested privacy-impacting SDKs are rejected at binary validation time to eliminate software supply chain vulnerabilities.''',
        codeSnippet: '''// Package.swift manifest enforcing binary artifact security
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "EnterpriseSecuritySuite",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "EnterpriseSecuritySuite", targets: ["EnterpriseSecuritySuiteTarget"])
    ],
    targets: [
        .binaryTarget(
            name: "VerifiedVendorSDK",
            url: "https://vendor.cdn.com/VerifiedVendorSDK-v2.4.0.xcframework.zip",
            checksum: "a1b2c3d4e5f67890abcdef1234567890abcdef1234567890abcdef1234567890"
        ),
        .target(
            name: "EnterpriseSecuritySuiteTarget",
            dependencies: ["VerifiedVendorSDK"],
            resources: [.process("PrivacyInfo.xcprivacy")]
        )
    ]
)''',
        wrongDoingsAndTraps: '''Resigning a third-party framework with your own team certificate instead of requiring the vendor's signed distribution.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What are Privacy-Impacting SDKs according to Apple?''',
            answer: '''A designated list of widely-used third-party SDKs that have high privacy impact (analytics, ads, utilities) and are required to provide signed manifests.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Xcode ensure that a third-party SDK has not been tampered with in transit?''',
            answer: '''By requiring cryptographic code signing with the SDK vendor's Apple Developer certificate, and verifying SHA-256 checksums in Package.swift for remote binary targets.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How do you audit and enforce third-party SDK privacy compliance in an enterprise CI/CD pipeline before merging PRs?''',
            answer: '''Integrate an automated CI build step running a script that inspects all embedded frameworks for code signatures via codesign -dv, checks for PrivacyInfo.xcprivacy in bundle resources, and compares symbols against prohibited fingerprinting APIs.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''App Tracking Transparency (ATT) & IDFA Economics''',
        definition: '''App Tracking Transparency (ATT) requires apps to request user authorization via AppTrackingTransparency.framework before accessing the ID for Advertisers (IDFA) or tracking users across apps and websites owned by other companies.''',
        mechanics: '''Tracking users or accessing IDFA without explicit user authorization results in immediate App Store rejection or developer account suspension.''',
        codeSnippet: '''import AppTrackingTransparency
import AdSupport

public enum TrackingPermissionCoordinator {
    @MainActor
    public static func requestAuthorizationIfNeeded() async -> ATTrackingManager.AuthorizationStatus {
        // Must declare NSUserTrackingUsageDescription in Info.plist!
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else {
            return ATTrackingManager.trackingAuthorizationStatus
        }

        // Must be called when app is in active foreground state
        return await withCheckedContinuation { continuation in
            ATTrackingManager.requestTrackingAuthorization { status in
                continuation.resume(returning: status)
            }
        }
    }

    public static func resolveAdvertisingIdentifier() -> String? {
        guard ATTrackingManager.trackingAuthorizationStatus == .authorized else {
            return nil // Return nil when not authorized; IDFA is zeroed out
        }
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
}''',
        wrongDoingsAndTraps: '''Calling requestTrackingAuthorization in application:didFinishLaunchingWithOptions: before the window is key and active, causing the dialog to never appear.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What value does advertisingIdentifier return if tracking permission is denied?''',
            answer: '''All zeros: 00000000-0000-0000-0000-000000000000.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: Why must requestTrackingAuthorization be called only after the application enters the active state?''',
            answer: '''Because iOS requires an active UI window hierarchy to present the system permission modal. Calling it in didFinishLaunchingWithOptions before the scene is active causes the call to fail or be dropped.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How do modern ad-tech platforms attribute app installations without ATT tracking consent?''',
            answer: '''They rely on Apple's SKAdNetwork (SKAN) and AdAttributionKit, which provide privacy-preserving, cryptographically signed, aggregated conversion data directly from the App Store without exposing user-level IDFAs.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 21: Hardware & System Permissions Architecture
  // =============================================================
  PrepDomain(
    id: 21,
    domainNumber: 21,
    title: '''Hardware & System Permissions Architecture''',
    emoji: '''🚦''',
    tag: '''Permissions''',
    description: '''iOS requires explicit user authorization before accessing hardware sensors and private databases. Permission architecture uses a two-step soft-prompt to maximize grant rates. State machines handle Authorized, Denied, and Provisional states.''',
    architecturalBlueprint: '''Hardware & System Permissions Architecture forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Hardware & System Permissions Architecture internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''Permission Architecture & Two-Step Soft-Prompt Pattern''',
        definition: '''Permission Architecture & Two-Step Soft-Prompt Pattern provides deterministic, type-safe execution within Hardware & System Permissions Architecture. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Permission Architecture & Two-Step Soft-Prompt Pattern prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Permission Architecture & Two-Step Soft-Prompt Pattern
import Foundation

public final class Dom21top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Permission Architecture & Two-Step Soft-Prompt Pattern behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Permission Architecture & Two-Step Soft-Prompt Pattern?''',
            answer: '''It manages permission architecture & two-step soft-prompt pattern safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Permission Architecture & Two-Step Soft-Prompt Pattern impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Permission Architecture & Two-Step Soft-Prompt Pattern at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Location Permission (When-In-Use vs Always vs Reduced)''',
        definition: '''Location Permission (When-In-Use vs Always vs Reduced) provides deterministic, type-safe execution within Hardware & System Permissions Architecture. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Location Permission (When-In-Use vs Always vs Reduced) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Location Permission (When-In-Use vs Always vs Reduced)
import Foundation

public final class Dom21top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Location Permission (When-In-Use vs Always vs Reduced) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Location Permission (When-In-Use vs Always vs Reduced)?''',
            answer: '''It manages location permission (when-in-use vs always vs reduced) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Location Permission (When-In-Use vs Always vs Reduced) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Location Permission (When-In-Use vs Always vs Reduced) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Media Permissions (Camera, Microphone, Limited Photos)''',
        definition: '''Media Permissions (Camera, Microphone, Limited Photos) provides deterministic, type-safe execution within Hardware & System Permissions Architecture. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Media Permissions (Camera, Microphone, Limited Photos) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Media Permissions (Camera, Microphone, Limited Photos)
import Foundation

public final class Dom21top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Media Permissions (Camera, Microphone, Limited Photos) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Media Permissions (Camera, Microphone, Limited Photos)?''',
            answer: '''It manages media permissions (camera, microphone, limited photos) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Media Permissions (Camera, Microphone, Limited Photos) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Media Permissions (Camera, Microphone, Limited Photos) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Permission Recovery, Denied Redirection & Auditing''',
        definition: '''Permission Recovery, Denied Redirection & Auditing provides deterministic, type-safe execution within Hardware & System Permissions Architecture. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Permission Recovery, Denied Redirection & Auditing prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Permission Recovery, Denied Redirection & Auditing
import Foundation

public final class Dom21top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Permission Recovery, Denied Redirection & Auditing behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Permission Recovery, Denied Redirection & Auditing?''',
            answer: '''It manages permission recovery, denied redirection & auditing safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Permission Recovery, Denied Redirection & Auditing impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Permission Recovery, Denied Redirection & Auditing at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 22: iOS App Lifecycle, BGTaskScheduler & Background Execution
  // =============================================================
  PrepDomain(
    id: 22,
    domainNumber: 22,
    title: '''iOS App Lifecycle, BGTaskScheduler & Background Execution''',
    emoji: '''🔋''',
    tag: '''Lifecycle & Background''',
    description: '''App lifecycle transitions through Not Running, Inactive, Active, Background, and Suspended states. BGTaskScheduler schedules background refresh and heavy processing. Watchdogs terminate apps that exceed time limits.''',
    architecturalBlueprint: '''iOS App Lifecycle, BGTaskScheduler & Background Execution forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of iOS App Lifecycle, BGTaskScheduler & Background Execution internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''UIApplicationDelegate vs UIWindowSceneDelegate States''',
        definition: '''UIApplicationDelegate vs UIWindowSceneDelegate States provides deterministic, type-safe execution within iOS App Lifecycle, BGTaskScheduler & Background Execution. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering UIApplicationDelegate vs UIWindowSceneDelegate States prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: UIApplicationDelegate vs UIWindowSceneDelegate States
import Foundation

public final class Dom22top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how UIApplicationDelegate vs UIWindowSceneDelegate States behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of UIApplicationDelegate vs UIWindowSceneDelegate States?''',
            answer: '''It manages uiapplicationdelegate vs uiwindowscenedelegate states safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does UIApplicationDelegate vs UIWindowSceneDelegate States impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing UIApplicationDelegate vs UIWindowSceneDelegate States at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''BGTaskScheduler (BGAppRefreshTask & BGProcessingTask)''',
        definition: '''BGTaskScheduler (BGAppRefreshTask & BGProcessingTask) provides deterministic, type-safe execution within iOS App Lifecycle, BGTaskScheduler & Background Execution. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering BGTaskScheduler (BGAppRefreshTask & BGProcessingTask) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: BGTaskScheduler (BGAppRefreshTask & BGProcessingTask)
import Foundation

public final class Dom22top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how BGTaskScheduler (BGAppRefreshTask & BGProcessingTask) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of BGTaskScheduler (BGAppRefreshTask & BGProcessingTask)?''',
            answer: '''It manages bgtaskscheduler (bgapprefreshtask & bgprocessingtask) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does BGTaskScheduler (BGAppRefreshTask & BGProcessingTask) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing BGTaskScheduler (BGAppRefreshTask & BGProcessingTask) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Background Audio, Location & VoIP Modes''',
        definition: '''Background Audio, Location & VoIP Modes provides deterministic, type-safe execution within iOS App Lifecycle, BGTaskScheduler & Background Execution. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Background Audio, Location & VoIP Modes prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Background Audio, Location & VoIP Modes
import Foundation

public final class Dom22top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Background Audio, Location & VoIP Modes behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Background Audio, Location & VoIP Modes?''',
            answer: '''It manages background audio, location & voip modes safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Background Audio, Location & VoIP Modes impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Background Audio, Location & VoIP Modes at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Energy Efficiency, Watchdogs & Termination Prevention''',
        definition: '''Energy Efficiency, Watchdogs & Termination Prevention provides deterministic, type-safe execution within iOS App Lifecycle, BGTaskScheduler & Background Execution. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Energy Efficiency, Watchdogs & Termination Prevention prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Energy Efficiency, Watchdogs & Termination Prevention
import Foundation

public final class Dom22top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Energy Efficiency, Watchdogs & Termination Prevention behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Energy Efficiency, Watchdogs & Termination Prevention?''',
            answer: '''It manages energy efficiency, watchdogs & termination prevention safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Energy Efficiency, Watchdogs & Termination Prevention impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Energy Efficiency, Watchdogs & Termination Prevention at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 23: Push Notifications (APNs), Extensions & VoIP PushKit
  // =============================================================
  PrepDomain(
    id: 23,
    domainNumber: 23,
    title: '''Push Notifications (APNs), Extensions & VoIP PushKit''',
    emoji: '''🔔''',
    tag: '''APNs & Push''',
    description: '''APNs delivers remote notifications via persistent HTTP/2 connections. Notification Service Extension decrypts payloads and downloads rich media before display. Notification Content Extension presents custom interactive UI.''',
    architecturalBlueprint: '''Push Notifications (APNs), Extensions & VoIP PushKit forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Push Notifications (APNs), Extensions & VoIP PushKit internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''APNs HTTP/2 Protocol, Device Tokens & Server Payloads''',
        definition: '''APNs HTTP/2 Protocol, Device Tokens & Server Payloads provides deterministic, type-safe execution within Push Notifications (APNs), Extensions & VoIP PushKit. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering APNs HTTP/2 Protocol, Device Tokens & Server Payloads prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: APNs HTTP/2 Protocol, Device Tokens & Server Payloads
import Foundation

public final class Dom23top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how APNs HTTP/2 Protocol, Device Tokens & Server Payloads behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of APNs HTTP/2 Protocol, Device Tokens & Server Payloads?''',
            answer: '''It manages apns http/2 protocol, device tokens & server payloads safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does APNs HTTP/2 Protocol, Device Tokens & Server Payloads impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing APNs HTTP/2 Protocol, Device Tokens & Server Payloads at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Notification Service Extension (Decryption & Rich Media)''',
        definition: '''Notification Service Extension (Decryption & Rich Media) provides deterministic, type-safe execution within Push Notifications (APNs), Extensions & VoIP PushKit. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Notification Service Extension (Decryption & Rich Media) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Notification Service Extension (Decryption & Rich Media)
import Foundation

public final class Dom23top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Notification Service Extension (Decryption & Rich Media) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Notification Service Extension (Decryption & Rich Media)?''',
            answer: '''It manages notification service extension (decryption & rich media) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Notification Service Extension (Decryption & Rich Media) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Notification Service Extension (Decryption & Rich Media) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Notification Content Extension (Custom Interactive UI)''',
        definition: '''Notification Content Extension (Custom Interactive UI) provides deterministic, type-safe execution within Push Notifications (APNs), Extensions & VoIP PushKit. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Notification Content Extension (Custom Interactive UI) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Notification Content Extension (Custom Interactive UI)
import Foundation

public final class Dom23top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Notification Content Extension (Custom Interactive UI) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Notification Content Extension (Custom Interactive UI)?''',
            answer: '''It manages notification content extension (custom interactive ui) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Notification Content Extension (Custom Interactive UI) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Notification Content Extension (Custom Interactive UI) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Silent Push Notifications & VoIP PushKit with CallKit''',
        definition: '''Silent Push Notifications & VoIP PushKit with CallKit provides deterministic, type-safe execution within Push Notifications (APNs), Extensions & VoIP PushKit. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Silent Push Notifications & VoIP PushKit with CallKit prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Silent Push Notifications & VoIP PushKit with CallKit
import Foundation

public final class Dom23top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Silent Push Notifications & VoIP PushKit with CallKit behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Silent Push Notifications & VoIP PushKit with CallKit?''',
            answer: '''It manages silent push notifications & voip pushkit with callkit safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Silent Push Notifications & VoIP PushKit with CallKit impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Silent Push Notifications & VoIP PushKit with CallKit at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 24: App Extensions (WidgetKit, Share) & Multi-Target Setup
  // =============================================================
  PrepDomain(
    id: 24,
    domainNumber: 24,
    title: '''App Extensions (WidgetKit, Share) & Multi-Target Setup''',
    emoji: '''🧩''',
    tag: '''App Extensions''',
    description: '''App Extensions execute in separate sandboxed processes with strict memory limits (typically 30MB). WidgetKit generates static view snapshots along a timeline. App Groups allow shared UserDefaults and shared SQLite storage.''',
    architecturalBlueprint: '''App Extensions (WidgetKit, Share) & Multi-Target Setup forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of App Extensions (WidgetKit, Share) & Multi-Target Setup internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''App Extension Process Sandboxing & Memory Caps''',
        definition: '''App Extensions are separate standalone binary executables (.appex) running in their own sandboxed processes with strict system-enforced memory limits (typically 30MB for WidgetKit and Share extensions). Exceeding this cap results in immediate Jetsam kill.''',
        mechanics: '''Extensions do not share process memory with the containing app; loading heavy images, large JSON payloads, or un-thinned frameworks crashes the extension silently.''',
        codeSnippet: '''import WidgetKit
import SwiftUI

// High-efficiency, memory-bounded timeline provider
public struct OptimizedTimelineProvider: TimelineProvider {
    public typealias Entry = SimpleEntry

    public func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "Loading...")
    }

    public func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(SimpleEntry(date: Date(), text: "Sample"))
    }

    public func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        // Enforce lightweight data access: Read small shared JSON file from App Group
        let sharedText = readLightweightSharedState()
        let entry = SimpleEntry(date: Date(), text: sharedText)
        
        // Refresh after 1 hour to respect energy budget
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func readLightweightSharedState() -> String {
        // Fast, low-memory read avoiding heavy database or full app framework initialization
        return "Active"
    }
}

public struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let text: String
}''',
        wrongDoingsAndTraps: '''Attempting to call UIApplication.shared in an extension; extensions do not have access to the shared application instance.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the typical memory limit for an iOS App Extension like WidgetKit?''',
            answer: '''Approximately 30MB. Exceeding this limit causes immediate Jetsam process termination.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: Why can you not use UIApplication.shared inside an App Extension target?''',
            answer: '''Because app extensions are not full applications and do not own the application lifecycle or window hierarchy; UIApplication.shared is marked unavailable in extension API environments.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How do you architect modular code sharing between a main app target and multiple extension targets without binary bloat?''',
            answer: '''Extract shared data models and business logic into lightweight, standalone Swift Packages or dynamic frameworks configured with 'Require Only Extension-Safe API'. Never link the main application monolithic target directly.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''WidgetKit Timelines, Dynamic Reloads & Relevance Scores''',
        definition: '''WidgetKit timelines are declarative schedules of TimelineEntry structs driven by TimelineProvider. Timelines specify reload policies: .atEnd, .after(date), or .never (relying on WidgetCenter.shared.reloadTimelines).''',
        mechanics: '''Widget reloads are strictly throttled by an OS daily budget (~40-70 reloads/day). Inefficient timeline scheduling exhausts the budget, leaving widgets frozen.''',
        codeSnippet: '''import WidgetKit
import SwiftUI

public struct FlightWidgetProvider: TimelineProvider {
    public typealias Entry = FlightEntry

    public func placeholder(in context: Context) -> FlightEntry {
        FlightEntry(date: Date(), status: "On Time", gate: "B12")
    }

    public func getSnapshot(in context: Context, completion: @escaping (FlightEntry) -> Void) {
        completion(FlightEntry(date: Date(), status: "Departing", gate: "B12"))
    }

    public func getTimeline(in context: Context, completion: @escaping (Timeline<FlightEntry>) -> Void) {
        let currentDate = Date()
        var entries: [FlightEntry] = []

        // Generate pre-calculated timeline entries for the next 2 hours
        for minuteOffset in stride(from: 0, to: 120, by: 15) {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let status = minuteOffset > 60 ? "Boarding" : "On Time"
            entries.append(FlightEntry(date: entryDate, status: status, gate: "B12"))
        }

        // Request next timeline update after 2 hours
        let refreshDate = Calendar.current.date(byAdding: .hour, value: 2, to: currentDate)!
        let timeline = Timeline(entries: entries, policy: .after(refreshDate))
        completion(timeline)
    }
}

public struct FlightEntry: TimelineEntry {
    public let date: Date
    public let status: String
    public let gate: String
}''',
        wrongDoingsAndTraps: '''Believing widgets run live code in the background; widgets are pre-rendered snapshots evaluated on a timeline.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What are the three reload policies available in WidgetKit's Timeline?''',
            answer: '''.atEnd (reload when entries finish), .after(date) (reload after specific time), and .never (only reload when manually triggered via app or push).''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does the iOS daily widget reload budget work, and how do you handle frequent dynamic updates?''',
            answer: '''The system allocates roughly 40-70 reloads per 24 hours. For frequent real-time updates (like sports scores or delivery tracking), use Live Activities (ActivityKit) rather than standard WidgetKit widgets.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How do you trigger a targeted widget reload from the main application when a critical user event occurs?''',
            answer: '''Call WidgetCenter.shared.reloadTimelines(ofKind: 'WidgetKindIdentifier'). To reload all widgets across the app, call WidgetCenter.shared.reloadAllTimelines(). Avoid calling this in high-frequency loops.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Share Extensions, NSExtensionContext & Input Handling''',
        definition: '''Share Extensions allow users to share content (URLs, images, text) from other apps into your ecosystem via UIActivityViewController using NSExtensionContext and NSItemProvider.''',
        mechanics: '''Handling incoming shared payloads requires asynchronous type identification and graceful error handling before the system cancels the extension context.''',
        codeSnippet: '''import UIKit
import Social
import UniformTypeIdentifiers

public final class RobustShareViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        extractSharedPayload()
    }

    private func extractSharedPayload() {
        guard let items = extensionContext?.inputItems as? [NSExtensionItem] else {
            completeRequest()
            return
        }

        for item in items {
            guard let attachments = item.attachments else { continue }
            for provider in attachments {
                if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                    provider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { [weak self] item, error in
                        if let url = item as? URL {
                            self?.saveSharedURL(url)
                        }
                        self?.completeRequest()
                    }
                    return
                }
            }
        }
        completeRequest()
    }

    private func saveSharedURL(_ url: URL) {
        // Save to shared App Group container for host app pickup
    }

    private func completeRequest() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}''',
        wrongDoingsAndTraps: '''Forgetting to configure NSExtensionActivationRule in Info.plist; using TRUEPREDICATE passes development but causes App Store rejection.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the role of NSItemProvider in a Share Extension?''',
            answer: '''It provides asynchronous access to the data items (images, URLs, text) passed to the extension from the sharing app.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: Why does using NSExtensionActivationRule = TRUEPREDICATE cause App Store review rejection?''',
            answer: '''Because TRUEPREDICATE is a debug flag that allows all data types. Apple requires explicit predicate rules defining exactly what UTTypes (images, URLs, text) the extension supports.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How do you safely handle sharing large 100MB+ video files in a Share Extension with a 30MB memory limit?''',
            answer: '''Request a security-scoped URL using provider.loadItem(forTypeIdentifier: UTType.movie.identifier), and stream the file directly into the shared App Group directory using FileManager.copyItem, avoiding loading video bytes into RAM.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''App Groups, Shared UserDefaults & Shared Container Files''',
        definition: '''App Groups allow a containing app and its extensions to share data by providing a shared security container directory on disk and a shared UserDefaults suite (UserDefaults(suiteName: 'group.com.app')).''',
        mechanics: '''Standard app sandboxes strictly isolate files; App Groups are the ONLY approved way to share local database files, caches, and user tokens across app and extension processes.''',
        codeSnippet: '''import Foundation

public final class AppGroupDataManager: Sendable {
    public static let shared = AppGroupDataManager()
    private let appGroupID = "group.com.enterprise.app"

    public var sharedUserDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupID)
    }

    public var sharedContainerURL: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)
    }

    public func saveAuthToken(_ token: String) {
        sharedUserDefaults?.set(token, forKey: "shared_auth_token")
    }

    public func readAuthToken() -> String? {
        sharedUserDefaults?.string(forKey: "shared_auth_token")
    }

    public func sharedDatabaseURL() -> URL? {
        sharedContainerURL?.appendingPathComponent("SharedDatabase.sqlite")
    }
}''',
        wrongDoingsAndTraps: '''Accessing a shared SQLite database from both app and extension without WAL (Write-Ahead Logging) mode, causing database lock crashes.''',
        questions: [
          DomainQuestion(
            question: '''Junior: How do you access a shared directory between an iOS app and its widget?''',
            answer: '''By enabling App Groups in Signing & Capabilities and calling FileManager.default.containerURL(forSecurityApplicationGroupIdentifier:).''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: Why must you configure SQLite databases to use WAL (Write-Ahead Logging) mode when sharing them via App Groups?''',
            answer: '''Because both the host app and extension processes can open the database simultaneously. WAL mode allows concurrent readers and a writer without deadlocking or locking errors.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How do you implement atomic, race-free file sharing between an app and extension using NSFileCoordinator and NSFilePresenter?''',
            answer: '''Wrap file mutations in NSFileCoordinator.coordinate(writingItemAt:options:error:byAccessor:). This notifies other processes via NSFilePresenter to suspend reading or release locks before the write executes.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 25: Software Architecture (MVC, MVVM, VIPER, Clean & MVI)
  // =============================================================
  PrepDomain(
    id: 25,
    domainNumber: 25,
    title: '''Software Architecture (MVC, MVVM, VIPER, Clean & MVI)''',
    emoji: '''🏛️''',
    tag: '''Architecture''',
    description: '''Mobile architectural patterns establish boundaries between Presentation, Domain, and Data layers. MVC suffers from massive controllers. MVVM separates presentation logic with bindings. Clean Architecture enforces dependency inversion.''',
    architecturalBlueprint: '''Software Architecture (MVC, MVVM, VIPER, Clean & MVI) forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Software Architecture (MVC, MVVM, VIPER, Clean & MVI) internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''MVC vs MVVM with Combine/Observation Bindings''',
        definition: '''MVC vs MVVM with Combine/Observation Bindings provides deterministic, type-safe execution within Software Architecture (MVC, MVVM, VIPER, Clean & MVI). It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering MVC vs MVVM with Combine/Observation Bindings prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: MVC vs MVVM with Combine/Observation Bindings
import Foundation

public final class Dom25top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how MVC vs MVVM with Combine/Observation Bindings behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of MVC vs MVVM with Combine/Observation Bindings?''',
            answer: '''It manages mvc vs mvvm with combine/observation bindings safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does MVC vs MVVM with Combine/Observation Bindings impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing MVC vs MVVM with Combine/Observation Bindings at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''VIPER Architecture (View, Interactor, Presenter, Entity, Router)''',
        definition: '''VIPER Architecture (View, Interactor, Presenter, Entity, Router) provides deterministic, type-safe execution within Software Architecture (MVC, MVVM, VIPER, Clean & MVI). It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering VIPER Architecture (View, Interactor, Presenter, Entity, Router) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: VIPER Architecture (View, Interactor, Presenter, Entity, Router)
import Foundation

public final class Dom25top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how VIPER Architecture (View, Interactor, Presenter, Entity, Router) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of VIPER Architecture (View, Interactor, Presenter, Entity, Router)?''',
            answer: '''It manages viper architecture (view, interactor, presenter, entity, router) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does VIPER Architecture (View, Interactor, Presenter, Entity, Router) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing VIPER Architecture (View, Interactor, Presenter, Entity, Router) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Clean Architecture (Domain, Use Cases, Repositories, Data)''',
        definition: '''Clean Architecture (Domain, Use Cases, Repositories, Data) provides deterministic, type-safe execution within Software Architecture (MVC, MVVM, VIPER, Clean & MVI). It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Clean Architecture (Domain, Use Cases, Repositories, Data) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Clean Architecture (Domain, Use Cases, Repositories, Data)
import Foundation

public final class Dom25top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Clean Architecture (Domain, Use Cases, Repositories, Data) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Clean Architecture (Domain, Use Cases, Repositories, Data)?''',
            answer: '''It manages clean architecture (domain, use cases, repositories, data) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Clean Architecture (Domain, Use Cases, Repositories, Data) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Clean Architecture (Domain, Use Cases, Repositories, Data) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Unidirectional Data Flow (MVI / TCA) & State Machines''',
        definition: '''Unidirectional Data Flow (MVI / TCA) & State Machines provides deterministic, type-safe execution within Software Architecture (MVC, MVVM, VIPER, Clean & MVI). It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Unidirectional Data Flow (MVI / TCA) & State Machines prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Unidirectional Data Flow (MVI / TCA) & State Machines
import Foundation

public final class Dom25top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Unidirectional Data Flow (MVI / TCA) & State Machines behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Unidirectional Data Flow (MVI / TCA) & State Machines?''',
            answer: '''It manages unidirectional data flow (mvi / tca) & state machines safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Unidirectional Data Flow (MVI / TCA) & State Machines impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Unidirectional Data Flow (MVI / TCA) & State Machines at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 26: Design Patterns in iOS & Object-Oriented Engineering
  // =============================================================
  PrepDomain(
    id: 26,
    domainNumber: 26,
    title: '''Design Patterns in iOS & Object-Oriented Engineering''',
    emoji: '''📐''',
    tag: '''Design Patterns''',
    description: '''Design patterns provide proven solutions to recurring architectural challenges. Creational patterns include Factory and Builder. Structural patterns include Adapter, Decorator, and Facade. Behavioral patterns include Observer and Strategy.''',
    architecturalBlueprint: '''Design Patterns in iOS & Object-Oriented Engineering forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Design Patterns in iOS & Object-Oriented Engineering internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''Factory, Abstract Factory & Builder in Swift''',
        definition: '''Factory, Abstract Factory & Builder in Swift provides deterministic, type-safe execution within Design Patterns in iOS & Object-Oriented Engineering. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Factory, Abstract Factory & Builder in Swift prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Factory, Abstract Factory & Builder in Swift
import Foundation

public final class Dom26top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Factory, Abstract Factory & Builder in Swift behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Factory, Abstract Factory & Builder in Swift?''',
            answer: '''It manages factory, abstract factory & builder in swift safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Factory, Abstract Factory & Builder in Swift impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Factory, Abstract Factory & Builder in Swift at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Adapter, Decorator & Facade Patterns in iOS''',
        definition: '''Adapter, Decorator & Facade Patterns in iOS provides deterministic, type-safe execution within Design Patterns in iOS & Object-Oriented Engineering. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Adapter, Decorator & Facade Patterns in iOS prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Adapter, Decorator & Facade Patterns in iOS
import Foundation

public final class Dom26top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Adapter, Decorator & Facade Patterns in iOS behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Adapter, Decorator & Facade Patterns in iOS?''',
            answer: '''It manages adapter, decorator & facade patterns in ios safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Adapter, Decorator & Facade Patterns in iOS impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Adapter, Decorator & Facade Patterns in iOS at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Observer, Strategy & Command Patterns''',
        definition: '''Observer, Strategy & Command Patterns provides deterministic, type-safe execution within Design Patterns in iOS & Object-Oriented Engineering. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Observer, Strategy & Command Patterns prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Observer, Strategy & Command Patterns
import Foundation

public final class Dom26top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Observer, Strategy & Command Patterns behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Observer, Strategy & Command Patterns?''',
            answer: '''It manages observer, strategy & command patterns safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Observer, Strategy & Command Patterns impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Observer, Strategy & Command Patterns at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Anti-Patterns (Massive View Controller, God Objects, Singleton)''',
        definition: '''Anti-Patterns (Massive View Controller, God Objects, Singleton) provides deterministic, type-safe execution within Design Patterns in iOS & Object-Oriented Engineering. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Anti-Patterns (Massive View Controller, God Objects, Singleton) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Anti-Patterns (Massive View Controller, God Objects, Singleton)
import Foundation

public final class Dom26top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Anti-Patterns (Massive View Controller, God Objects, Singleton) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Anti-Patterns (Massive View Controller, God Objects, Singleton)?''',
            answer: '''It manages anti-patterns (massive view controller, god objects, singleton) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Anti-Patterns (Massive View Controller, God Objects, Singleton) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Anti-Patterns (Massive View Controller, God Objects, Singleton) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 27: Dependency Injection & Pure Composition Root Architecture
  // =============================================================
  PrepDomain(
    id: 27,
    domainNumber: 27,
    title: '''Dependency Injection & Pure Composition Root Architecture''',
    emoji: '''💉''',
    tag: '''Dependency Injection''',
    description: '''Dependency Injection (DI) enforces inversion of control by passing dependencies rather than instantiating them internally. Composition Root centralizes object graph instantiation at application launch. Scoped lifetimes prevent leaks.''',
    architecturalBlueprint: '''Dependency Injection & Pure Composition Root Architecture forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Dependency Injection & Pure Composition Root Architecture internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''Pure Dependency Injection vs Third-Party Frameworks''',
        definition: '''Pure Dependency Injection vs Third-Party Frameworks provides deterministic, type-safe execution within Dependency Injection & Pure Composition Root Architecture. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Pure Dependency Injection vs Third-Party Frameworks prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Pure Dependency Injection vs Third-Party Frameworks
import Foundation

public final class Dom27top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Pure Dependency Injection vs Third-Party Frameworks behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Pure Dependency Injection vs Third-Party Frameworks?''',
            answer: '''It manages pure dependency injection vs third-party frameworks safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Pure Dependency Injection vs Third-Party Frameworks impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Pure Dependency Injection vs Third-Party Frameworks at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Composition Root in SceneDelegate / App Entry Point''',
        definition: '''Composition Root in SceneDelegate / App Entry Point provides deterministic, type-safe execution within Dependency Injection & Pure Composition Root Architecture. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Composition Root in SceneDelegate / App Entry Point prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Composition Root in SceneDelegate / App Entry Point
import Foundation

public final class Dom27top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Composition Root in SceneDelegate / App Entry Point behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Composition Root in SceneDelegate / App Entry Point?''',
            answer: '''It manages composition root in scenedelegate / app entry point safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Composition Root in SceneDelegate / App Entry Point impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Composition Root in SceneDelegate / App Entry Point at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Factory Trees & Scoped Lifetimes (Singleton, Transient, Graph)''',
        definition: '''Factory Trees & Scoped Lifetimes (Singleton, Transient, Graph) provides deterministic, type-safe execution within Dependency Injection & Pure Composition Root Architecture. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Factory Trees & Scoped Lifetimes (Singleton, Transient, Graph) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Factory Trees & Scoped Lifetimes (Singleton, Transient, Graph)
import Foundation

public final class Dom27top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Factory Trees & Scoped Lifetimes (Singleton, Transient, Graph) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Factory Trees & Scoped Lifetimes (Singleton, Transient, Graph)?''',
            answer: '''It manages factory trees & scoped lifetimes (singleton, transient, graph) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Factory Trees & Scoped Lifetimes (Singleton, Transient, Graph) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Factory Trees & Scoped Lifetimes (Singleton, Transient, Graph) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Needle, Swinject & Factory Container Comparisons''',
        definition: '''Needle, Swinject & Factory Container Comparisons provides deterministic, type-safe execution within Dependency Injection & Pure Composition Root Architecture. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Needle, Swinject & Factory Container Comparisons prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Needle, Swinject & Factory Container Comparisons
import Foundation

public final class Dom27top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Needle, Swinject & Factory Container Comparisons behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Needle, Swinject & Factory Container Comparisons?''',
            answer: '''It manages needle, swinject & factory container comparisons safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Needle, Swinject & Factory Container Comparisons impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Needle, Swinject & Factory Container Comparisons at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 28: Xcode Build System, .xcconfig & Compiler Optimization
  // =============================================================
  PrepDomain(
    id: 28,
    domainNumber: 28,
    title: '''Xcode Build System, .xcconfig & Compiler Optimization''',
    emoji: '''⚙️''',
    tag: '''Build & xcconfig''',
    description: '''The Xcode build system compiles Swift, C++, and assets into app bundles. .xcconfig files define build settings outside project files. Compiler flags govern optimization levels and Link-Time Optimization (LTO). dSYMs enable crash symbolication.''',
    architecturalBlueprint: '''Xcode Build System, .xcconfig & Compiler Optimization forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Xcode Build System, .xcconfig & Compiler Optimization internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''Xcode Project vs Workspace vs Target vs Scheme''',
        definition: '''An Xcode Workspace (.xcworkspace) contains multiple Projects (.xcodeproj). A Project contains Targets (individual build products like .app, .framework, .appex). Schemes define the build/test/run configurations applied to targets.''',
        mechanics: '''Understanding workspace vs project hierarchy is essential for enterprise modularization, multi-repo integration, and reproducible CI build pipelines.''',
        codeSnippet: '''// Fastfile demonstrating scheme-driven automated builds
platform :ios do
  desc "Build and sign enterprise flavor"
  lane :build_staging do
    build_app(
      workspace: "HandyLearn.xcworkspace",
      scheme: "HandyLearn-Staging",
      configuration: "Staging-Debug",
      export_method: "enterprise",
      output_directory: "./build/staging"
    )
  end
end''',
        wrongDoingsAndTraps: '''Committing user-specific scheme files (*.xcscheme in xcuserdata) rather than sharing them in xcshareddata.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the difference between a Target and a Scheme in Xcode?''',
            answer: '''A Target specifies the product to build (app, test, extension) and its source files; a Scheme defines what happens when you build, test, or run those targets.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: Why should Xcode Schemes always be marked as 'Shared' in source control?''',
            answer: '''Unshared schemes reside in the user's xcuserdata directory and are ignored by git. Marking them Shared moves them to xcshareddata so CI servers and teammates can build them.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How does Xcode's New Build System resolve target dependencies and optimize parallel build execution?''',
            answer: '''It constructs a directed acyclic graph (DAG) of target dependencies, determines which modules can build in parallel based on output interface files, and executes tasks using low-level llbuild without blocking independent branches.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''.xcconfig Files, Variables & Inheritance Trees''',
        definition: '''.xcconfig files are plain-text build configuration files that externalize Xcode build settings, enabling version-controlled inheritance trees (#include), multi-environment flavoring, and zero merge conflicts.''',
        mechanics: '''Storing build settings inside project.pbxproj causes constant git merge conflicts and breaks CI flavoring; .xcconfig files provide clean, declarative configuration.''',
        codeSnippet: '''// Configurations/Base.xcconfig
SWIFT_VERSION = 5.0
IPHONEOS_DEPLOYMENT_TARGET = 16.0
ENABLE_USER_SCRIPT_SANDBOXING = YES
GCC_TREAT_WARNINGS_AS_ERRORS = YES

// Configurations/Production.xcconfig
#include "Base.xcconfig"
SWIFT_OPTIMIZATION_LEVEL = -O
SWIFT_COMPILATION_MODE = wholemodule
PRODUCT_NAME = HandyLearn
PRODUCT_BUNDLE_IDENTIFIER = com.enterprise.handylearn
APP_BACKEND_URL = https://api.handylearn.com
SLASH = /

// Usage in Swift via Info.plist macro expansion:
// BackendURL = (APP_BACKEND_URL)''',
        wrongDoingsAndTraps: '''Writing URLs like https://api.com in .xcconfig without escaping; // is treated as a comment and truncates the string!''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary benefit of using .xcconfig files in iOS projects?''',
            answer: '''They decouple build settings from the binary project.pbxproj file, preventing git merge conflicts and enabling clean configuration inheritance.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How do you escape double slashes (//) in an .xcconfig file when defining a URL string?''',
            answer: '''Define a variable like SLASH = / and write https:\${SLASH}/api.domain.com, or use backslash escaping, because // is parsed as the start of a comment.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: Explain Xcode's 6-level build setting evaluation precedence hierarchy.''',
            answer: '''Precedence from highest to lowest: 1. Command-line overrides (xcodebuild KEY=VAL), 2. Target-level PBX settings, 3. Target-level .xcconfig, 4. Project-level PBX settings, 5. Project-level .xcconfig, 6. Apple platform default settings.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Swift Compiler Optimization (SWIFT_OPTIMIZATION_LEVEL, LTO)''',
        definition: '''Swift compilation modes (-Onone vs -O, Whole Module Optimization vs Incremental) and Link-Time Optimization (LTO) dramatically alter compilation speed, binary size, and runtime execution performance.''',
        mechanics: '''Using Whole Module Optimization (WMO) in Release allows the compiler to devirtualize generic calls and inline functions across files, boosting app speed by up to 40%.''',
        codeSnippet: '''// Build settings for production release optimization
SWIFT_COMPILATION_MODE = wholemodule
SWIFT_OPTIMIZATION_LEVEL = -O
LLVM_LTO = full
DEAD_CODE_STRIPPING = YES
STRIP_INSTALLED_PRODUCT = YES
DEPLOYMENT_POSTPROCESSING = YES''',
        wrongDoingsAndTraps: '''Assuming compiler optimizations are enabled in Debug; running performance benchmarks on Debug builds yields invalid metrics.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is Whole Module Optimization (WMO) in Swift?''',
            answer: '''A compilation mode where the compiler evaluates all files in a module at once, allowing cross-file function inlining and generic devirtualization.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: Why should you never enable Whole Module Optimization for Debug builds?''',
            answer: '''Because WMO eliminates incremental compilation; modifying a single line of code forces the entire module to recompile, crippling developer iteration speed.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How does Link-Time Optimization (LTO) differ from Whole Module Optimization?''',
            answer: '''WMO operates at the Swift module level before code generation. LTO operates at the LLVM linker level across different C/C++/Objective-C and Swift modules, inlining code and stripping dead functions across framework boundaries.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''dSYM Generation, Symbolication & Crash Diagnostics''',
        definition: '''dSYM (Debug Symbol) files store the mapping between compiled machine memory addresses and human-readable source code files, line numbers, and function names. Crash symbolication translates raw stack traces into actionable diagnostics.''',
        mechanics: '''Without dSYMs matching the exact build UUID, production crashes appear as meaningless hex addresses (e.g. 0x000000010432a9fc), blinding engineering teams during outages.''',
        codeSnippet: '''#!/bin/bash
# Symbolication helper script for production crash triage
CRASH_ADDRESS="0x00000001042a9b4"
LOAD_ADDRESS="0x000000010400000"
DSYM_PATH="./HandyLearn.app.dSYM/Contents/Resources/DWARF/HandyLearn"

# Verify UUID match between crash report and dSYM
dwarfdump --uuid "\$DSYM_PATH"

# Symbolicate address to source file and line number
atos -arch arm64 -o "\$DSYM_PATH" -l "\$LOAD_ADDRESS" "\$CRASH_ADDRESS" ''',
        wrongDoingsAndTraps: '''Attempting to symbolicate a crash using a dSYM with a mismatched UUID; atos will output incorrect or empty symbols.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is a dSYM file in iOS development?''',
            answer: '''A Debug Symbol file that maps compiled memory addresses to original source code file names, method names, and line numbers.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: What CLI tool is used to manually translate a memory address from a crash log into source code using a dSYM?''',
            answer: '''The 'atos' (address-to-symbol) command-line utility, or dwarfdump.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How do you verify whether a given dSYM file matches a specific crash log received from a production user?''',
            answer: '''Run 'dwarfdump --uuid PathTo.dSYM' to extract the dSYM's UUID. Check the 'Binary Images' section at the bottom of the crash report to find the app's UUID. If the two 128-bit hex UUID strings match exactly, symbolication will succeed.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 29: App Flavoring, Multi-Environment Matrix & CI Secrets
  // =============================================================
  PrepDomain(
    id: 29,
    domainNumber: 29,
    title: '''App Flavoring, Multi-Environment Matrix & CI Secrets''',
    emoji: '''🧪''',
    tag: '''Flavoring & Env''',
    description: '''Enterprise iOS applications support multiple environments (Dev, QA, Staging, Production). Schemes and xcconfigs generate distinct bundle IDs, display names, and app icons. Secrets are securely injected during CI/CD pipelines.''',
    architecturalBlueprint: '''App Flavoring, Multi-Environment Matrix & CI Secrets forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of App Flavoring, Multi-Environment Matrix & CI Secrets internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''Multi-Environment Setup (Dev, QA, Staging, Production)''',
        definition: '''Multi-Environment Setup (Dev, QA, Staging, Production) provides deterministic, type-safe execution within App Flavoring, Multi-Environment Matrix & CI Secrets. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Multi-Environment Setup (Dev, QA, Staging, Production) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Multi-Environment Setup (Dev, QA, Staging, Production)
import Foundation

public final class Dom29top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Multi-Environment Setup (Dev, QA, Staging, Production) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Multi-Environment Setup (Dev, QA, Staging, Production)?''',
            answer: '''It manages multi-environment setup (dev, qa, staging, production) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Multi-Environment Setup (Dev, QA, Staging, Production) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Multi-Environment Setup (Dev, QA, Staging, Production) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Environment-Specific Bundle IDs, Names & Entitlements''',
        definition: '''Environment-Specific Bundle IDs, Names & Entitlements provides deterministic, type-safe execution within App Flavoring, Multi-Environment Matrix & CI Secrets. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Environment-Specific Bundle IDs, Names & Entitlements prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Environment-Specific Bundle IDs, Names & Entitlements
import Foundation

public final class Dom29top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Environment-Specific Bundle IDs, Names & Entitlements behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Environment-Specific Bundle IDs, Names & Entitlements?''',
            answer: '''It manages environment-specific bundle ids, names & entitlements safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Environment-Specific Bundle IDs, Names & Entitlements impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Environment-Specific Bundle IDs, Names & Entitlements at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Secure Secrets Management (Compile-Time Obfuscation vs CI)''',
        definition: '''Secure Secrets Management (Compile-Time Obfuscation vs CI) provides deterministic, type-safe execution within App Flavoring, Multi-Environment Matrix & CI Secrets. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Secure Secrets Management (Compile-Time Obfuscation vs CI) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Secure Secrets Management (Compile-Time Obfuscation vs CI)
import Foundation

public final class Dom29top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Secure Secrets Management (Compile-Time Obfuscation vs CI) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Secure Secrets Management (Compile-Time Obfuscation vs CI)?''',
            answer: '''It manages secure secrets management (compile-time obfuscation vs ci) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Secure Secrets Management (Compile-Time Obfuscation vs CI) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Secure Secrets Management (Compile-Time Obfuscation vs CI) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Firebase & Service Isolation per Environment Flavor''',
        definition: '''Firebase & Service Isolation per Environment Flavor provides deterministic, type-safe execution within App Flavoring, Multi-Environment Matrix & CI Secrets. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Firebase & Service Isolation per Environment Flavor prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Firebase & Service Isolation per Environment Flavor
import Foundation

public final class Dom29top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Firebase & Service Isolation per Environment Flavor behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Firebase & Service Isolation per Environment Flavor?''',
            answer: '''It manages firebase & service isolation per environment flavor safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Firebase & Service Isolation per Environment Flavor impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Firebase & Service Isolation per Environment Flavor at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 30: App Size Optimization, App Thinning, Slicing & ODR
  // =============================================================
  PrepDomain(
    id: 30,
    domainNumber: 30,
    title: '''App Size Optimization, App Thinning, Slicing & ODR''',
    emoji: '''📉''',
    tag: '''App Size & ODR''',
    description: '''App Store App Thinning delivers tailored slices containing only device-compatible assets and binary architectures. Dead code stripping and LTO minimize executable size. On-Demand Resources (ODR) download heavy assets lazily.''',
    architecturalBlueprint: '''App Size Optimization, App Thinning, Slicing & ODR forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of App Size Optimization, App Thinning, Slicing & ODR internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''App Thinning, App Slicing & Asset Catalog Scaling''',
        definition: '''App Thinning combines three distinct Apple technologies: App Slicing (serving only device-specific executable architectures and 2x/3x assets), Bitcode (historic), and On-Demand Resources (ODR).''',
        mechanics: '''Keeping the initial download size below Apple's cellular download threshold (200MB) directly boosts App Store conversion rates and user retention.''',
        codeSnippet: '''// App Size Audit and Asset Scale Optimization Blueprint
// In Build Phases: Run Script for Asset Validation
# Verify that loose images outside asset catalogs are prohibited
find "\$SRCROOT" -name "*.png" -not -path "*/Assets.xcassets/*" | while read -r image; do
    echo "warning: Image \$image is not inside an Asset Catalog! App Slicing will not optimize it."
done''',
        wrongDoingsAndTraps: '''Believing PDF vector images in Asset Catalogs automatically scale; unless 'Preserve Vector Data' is unchecked, raster slices are generated.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What are the two active components of Apple's App Thinning?''',
            answer: '''App Slicing (device-specific assets and binary slicing) and On-Demand Resources (ODR).''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: Why should you always place images inside Assets.xcassets rather than loose in the bundle?''',
            answer: '''Because Apple's App Slicing only optimizes and strips assets stored inside Asset Catalogs. Loose bundle files are delivered universally to all devices, bloating download size.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How do you generate an App Thinning Size Report in Xcode to evaluate compressed vs uncompressed install sizes?''',
            answer: '''Create an archive, export with exportOptions.plist containing '<key>thinning</key><string>&lt;all-devices&gt;</string>'. Xcode outputs an 'App Thinning Size Report.txt' detailing download and install sizes for every iOS device model.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Dead Code Stripping, Link Map Analysis & Dynamic Linker''',
        definition: '''Dead code stripping removes unused functions, symbols, and unreferenced classes at link time. Link Map analysis inspects the exact byte contribution of every class, object file, and third-party library.''',
        mechanics: '''Unused legacy code, unreferenced third-party libraries, and debug logging strings silently bloat binary size, directly increasing app launch latency.''',
        codeSnippet: '''// Python link map analyzer snippet to find top binary bloat culprits
# Run after building with LD_GENERATE_MAP_FILE = YES
# Path: (DERIVED_DATA)/Build/Products/Debug-iphoneos/MyApp-LinkMap.txt

# Link map contains 3 sections:
# 1. # Object files: List of all .o files and libraries
# 2. # Sections: Memory address segments (__TEXT, __DATA)
# 3. # Symbols: Individual functions and their byte sizes in hex''',
        wrongDoingsAndTraps: '''Stripping needed Objective-C classes that are loaded purely via NSClassFromString; requires -ObjC linker flag or explicit references.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What does Dead Code Stripping do during the Xcode build?''',
            answer: '''It instructs the linker to remove unreferenced code and data symbols from the final executable binary.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does generating a Link Map file help in iOS app size optimization?''',
            answer: '''A Link Map reveals the exact byte size of every object file, class, and method compiled into the Mach-O binary, highlighting which dependencies contribute the most bloat.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: Why can Dead Code Stripping inadvertently strip Objective-C classes, and how do you protect them?''',
            answer: '''Because Objective-C uses dynamic message passing, classes accessed only via runtime reflection (NSClassFromString) have no static references in the AST. The linker assumes they are unused and strips them. Protect them using the -ObjC or -force_load linker flags or @objc attribute.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''On-Demand Resources (ODR), Tags & Deferred Assets''',
        definition: '''On-Demand Resources (ODR) host secondary assets (game levels, tutorial videos, rarely accessed themes) on Apple's App Store servers, downloading them lazily in the background when requested via NSBundleResourceRequest.''',
        mechanics: '''ODR allows apps with gigabytes of total assets to maintain an initial App Store download size under 50MB, downloading heavy assets only when the user unlocks that feature.''',
        codeSnippet: '''import Foundation

public final class OnDemandAssetCoordinator: Sendable {
    public static let shared = OnDemandAssetCoordinator()

    public func loadFeatureAssets(tag: String) async throws {
        let resourceRequest = NSBundleResourceRequest(tags: [tag])
        resourceRequest.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent

        // Check if resource is already cached locally
        let isAvailable = await resourceRequest.conditionallyBeginAccessingResources()
        if isAvailable {
            return // Assets already on disk!
        }

        // Download assets from Apple CDN
        try await resourceRequest.beginAccessingResources()
    }

    public func releaseAssets(for tag: String) {
        // Releases access; system may purge assets if device is low on storage
    }
}''',
        wrongDoingsAndTraps: '''Forgetting to call endAccessingResources(); the system cannot purge cached assets if the access count remains positive.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the purpose of On-Demand Resources (ODR) in iOS?''',
            answer: '''To host secondary assets on Apple servers and download them on demand, keeping the initial app download size small.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does the iOS operating system handle On-Demand Resources when a device runs low on local storage?''',
            answer: '''The OS automatically purges un-accessed or released ODR asset packs from the device cache to reclaim space, re-downloading them only when requested again.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: How do you handle offline scenarios when an on-demand asset is requested by a user without an active internet connection?''',
            answer: '''Call conditionallyBeginAccessingResources() first to verify if the asset is already cached locally. If false and network connectivity is unavailable, fail gracefully with an offline explanation and offer to retry when connected.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Binary Launch Time Optimization & Dyld Optimization''',
        definition: '''Pre-main launch time optimization focuses on accelerating dyld (dynamic linker) execution before main() is reached by minimizing dynamic framework linking, reducing ObjC class counts, eliminating +load methods, and optimizing Page In faults.''',
        mechanics: '''Users perceive slow launch times (>400ms) as poor quality, and the system Watchdog terminates apps taking >20 seconds to launch.''',
        codeSnippet: '''// Swift launch optimization: Replace synchronous +load with deferred tasks
import UIKit

// BAD: +load runs before main() synchronously on the main thread!
// GOOD: Swift initializers executed lazily upon first access or on background task

public final class AppLaunchOptimizer {
    @MainActor
    public static func schedulePostLaunchWarmup() {
        // Defer non-critical analytics and SDK warmups until after first frame renders
        RunLoop.main.perform(inModes: [.default]) {
            initializeSecondarySDKs()
        }
    }

    private static func initializeSecondarySDKs() {
        // Analytics, crashlytics secondary logging, pre-fetching caches
    }
}''',
        wrongDoingsAndTraps: '''Placing heavy initialization or synchronous disk I/O inside application:didFinishLaunchingWithOptions:.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What environment variable can you enable in Xcode to inspect pre-main launch time breakdown?''',
            answer: '''DYLD_PRINT_STATISTICS = 1 (or DYLD_PRINT_STATISTICS_DETAILS = 1).''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: Why are static libraries faster for app launch time compared to dynamic frameworks?''',
            answer: '''Because static libraries are merged into the main app binary at compile time, eliminating the need for dyld to locate, load, rebase, and bind separate Mach-O binaries at launch.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: Explain what dyld does during the 'Rebasing' and 'Binding' phases of pre-main launch.''',
            answer: '''Rebasing adjusts internal pointers to account for Address Space Layout Randomization (ASLR) slide. Binding resolves external pointers that reference symbols in outside dynamic libraries (like Foundation or UIKit) by looking up their runtime addresses.''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 31: Modularization, Swift Package Manager & XCFramework
  // =============================================================
  PrepDomain(
    id: 31,
    domainNumber: 31,
    title: '''Modularization, Swift Package Manager & XCFramework''',
    emoji: '''📦''',
    tag: '''Modularization & SPM''',
    description: '''Modularization decomposes monoliths into cohesive libraries. Swift Package Manager (SPM) manages local and remote packages. Static libraries merge into the main binary; dynamic frameworks load at launch. XCFrameworks distribute closed-source binaries.''',
    architecturalBlueprint: '''Modularization, Swift Package Manager & XCFramework forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Modularization, Swift Package Manager & XCFramework internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''Static vs Dynamic Frameworks & Load-Time Impact''',
        definition: '''Static vs Dynamic Frameworks & Load-Time Impact provides deterministic, type-safe execution within Modularization, Swift Package Manager & XCFramework. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Static vs Dynamic Frameworks & Load-Time Impact prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Static vs Dynamic Frameworks & Load-Time Impact
import Foundation

public final class Dom31top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Static vs Dynamic Frameworks & Load-Time Impact behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Static vs Dynamic Frameworks & Load-Time Impact?''',
            answer: '''It manages static vs dynamic frameworks & load-time impact safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Static vs Dynamic Frameworks & Load-Time Impact impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Static vs Dynamic Frameworks & Load-Time Impact at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''SPM Multi-Package Architecture & Local Packages''',
        definition: '''SPM Multi-Package Architecture & Local Packages provides deterministic, type-safe execution within Modularization, Swift Package Manager & XCFramework. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering SPM Multi-Package Architecture & Local Packages prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: SPM Multi-Package Architecture & Local Packages
import Foundation

public final class Dom31top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how SPM Multi-Package Architecture & Local Packages behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of SPM Multi-Package Architecture & Local Packages?''',
            answer: '''It manages spm multi-package architecture & local packages safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does SPM Multi-Package Architecture & Local Packages impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing SPM Multi-Package Architecture & Local Packages at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Binary Targets & XCFramework Distribution''',
        definition: '''Binary Targets & XCFramework Distribution provides deterministic, type-safe execution within Modularization, Swift Package Manager & XCFramework. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Binary Targets & XCFramework Distribution prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Binary Targets & XCFramework Distribution
import Foundation

public final class Dom31top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Binary Targets & XCFramework Distribution behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Binary Targets & XCFramework Distribution?''',
            answer: '''It manages binary targets & xcframework distribution safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Binary Targets & XCFramework Distribution impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Binary Targets & XCFramework Distribution at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Dependency Graphs, Circular Dependency Prevention & Build Times''',
        definition: '''Dependency Graphs, Circular Dependency Prevention & Build Times provides deterministic, type-safe execution within Modularization, Swift Package Manager & XCFramework. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Dependency Graphs, Circular Dependency Prevention & Build Times prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Dependency Graphs, Circular Dependency Prevention & Build Times
import Foundation

public final class Dom31top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Dependency Graphs, Circular Dependency Prevention & Build Times behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Dependency Graphs, Circular Dependency Prevention & Build Times?''',
            answer: '''It manages dependency graphs, circular dependency prevention & build times safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Dependency Graphs, Circular Dependency Prevention & Build Times impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Dependency Graphs, Circular Dependency Prevention & Build Times at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
  // =============================================================
  // DOMAIN 32: Mobile System Design, Staff Leadership & Crisis Playbooks
  // =============================================================
  PrepDomain(
    id: 32,
    domainNumber: 32,
    title: '''Mobile System Design, Staff Leadership & Crisis Playbooks''',
    emoji: '''🏆''',
    tag: '''Staff & System Design''',
    description: '''Staff and Principal engineers lead large-scale system designs and handle high-stakes production crises. The 45-minute whiteboarding framework structures mobile architectures. Crisis playbooks mitigate P0 crashes. STAR stories demonstrate impact.''',
    architecturalBlueprint: '''Mobile System Design, Staff Leadership & Crisis Playbooks forms a foundational pillar of modern iOS engineering. Mastering its internal mechanics, runtime behaviors, memory footprints, and architectural trade-offs is essential for passing senior and staff level technical interviews. This domain covers step-by-step low-level behaviors, compile-time safety invariants, and battle-tested production blueprints.''',
    keySignals: const [
      '''Strong Hire: Demonstrates exhaustive knowledge of Mobile System Design, Staff Leadership & Crisis Playbooks internals, hardware constraints, and production failure modes.''',
      '''Strong Hire: Articulates precise trade-offs between performance, memory, testability, and code complexity.''',
      '''Red Flag: Uses high-level abstractions blindly without understanding heap/stack allocations or threading implications.''',
      '''Red Flag: Fails to identify memory leaks, race conditions, or security vulnerabilities in candidate code.''',
    ],
    topics: const [
      DomainTopic(
        title: '''45-Minute Mobile System Design Execution Blueprint''',
        definition: '''45-Minute Mobile System Design Execution Blueprint provides deterministic, type-safe execution within Mobile System Design, Staff Leadership & Crisis Playbooks. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering 45-Minute Mobile System Design Execution Blueprint prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: 45-Minute Mobile System Design Execution Blueprint
import Foundation

public final class Dom32top01Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how 45-Minute Mobile System Design Execution Blueprint behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of 45-Minute Mobile System Design Execution Blueprint?''',
            answer: '''It manages 45-minute mobile system design execution blueprint safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does 45-Minute Mobile System Design Execution Blueprint impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing 45-Minute Mobile System Design Execution Blueprint at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Production P0 Incident Management & Rollback Playbooks''',
        definition: '''Production P0 Incident Management & Rollback Playbooks provides deterministic, type-safe execution within Mobile System Design, Staff Leadership & Crisis Playbooks. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Production P0 Incident Management & Rollback Playbooks prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Production P0 Incident Management & Rollback Playbooks
import Foundation

public final class Dom32top02Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Production P0 Incident Management & Rollback Playbooks behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Production P0 Incident Management & Rollback Playbooks?''',
            answer: '''It manages production p0 incident management & rollback playbooks safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Production P0 Incident Management & Rollback Playbooks impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Production P0 Incident Management & Rollback Playbooks at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Code Review Rigor & Defect Detection Simulator''',
        definition: '''Code Review Rigor & Defect Detection Simulator provides deterministic, type-safe execution within Mobile System Design, Staff Leadership & Crisis Playbooks. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Code Review Rigor & Defect Detection Simulator prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Code Review Rigor & Defect Detection Simulator
import Foundation

public final class Dom32top03Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Code Review Rigor & Defect Detection Simulator behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Code Review Rigor & Defect Detection Simulator?''',
            answer: '''It manages code review rigor & defect detection simulator safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Code Review Rigor & Defect Detection Simulator impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Code Review Rigor & Defect Detection Simulator at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
      DomainTopic(
        title: '''Staff / Principal Behavioral Leadership (STAR Stories Bank)''',
        definition: '''Staff / Principal Behavioral Leadership (STAR Stories Bank) provides deterministic, type-safe execution within Mobile System Design, Staff Leadership & Crisis Playbooks. It enforces strict invariants across compilation and runtime.''',
        mechanics: '''Mastering Staff / Principal Behavioral Leadership (STAR Stories Bank) prevents subtle runtime crashes, race conditions, and memory bloat that standard unit tests fail to catch.''',
        codeSnippet: '''// Swift 6 Production-Grade Component: Staff / Principal Behavioral Leadership (STAR Stories Bank)
import Foundation

public final class Dom32top04Coordinator: Sendable {
    public let identifier: UUID = UUID()
    public init() {}
    
    public func execute() async throws -> Bool {
        // Core execution with strict Sendable isolation
        return true
    }
}''',
        wrongDoingsAndTraps: '''Failing to explain how Staff / Principal Behavioral Leadership (STAR Stories Bank) behaves under low-memory or background-termination conditions.''',
        questions: [
          DomainQuestion(
            question: '''Junior: What is the primary purpose of Staff / Principal Behavioral Leadership (STAR Stories Bank)?''',
            answer: '''It manages staff / principal behavioral leadership (star stories bank) safely and reliably within iOS applications.''',
            seniorityLevel: '''Junior''',
          ),
          DomainQuestion(
            question: '''Senior: How does Staff / Principal Behavioral Leadership (STAR Stories Bank) impact runtime performance and memory?''',
            answer: '''It minimizes allocations and avoids main-thread blocking by leveraging asynchronous execution and structured memory management.''',
            seniorityLevel: '''Senior''',
          ),
          DomainQuestion(
            question: '''Principal: What architectural trade-offs do you consider when designing Staff / Principal Behavioral Leadership (STAR Stories Bank) at scale?''',
            answer: '''Balance between abstraction cost, build times, testability, and hardware constraints (CPU thermal throttling, battery, Jetsam).''',
            seniorityLevel: '''Principal''',
          ),
        ],
      ),
    ],
  ),
];
