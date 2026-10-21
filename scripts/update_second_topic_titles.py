dart_file = 'lib/features/ios_senior_prep/data/ios_prep_master_hierarchy_data.dart'

with open(dart_file, 'r', encoding='utf-8') as f:
    content = f.read()

replacements = [
    ("Advanced Security & Cryptography Patterns", "Privacy Manifests (PrivacyInfo.xcprivacy) & Required Reason APIs"),
    ("Advanced CI/CD & Release Engineering Patterns", "App Flavoring, Multi-Environment Architecture & Code Signing"),
    ("Advanced App Size & Distribution Patterns", "App Thinning, App Slicing & On-Demand Resources (ODR)"),
    ("Advanced Design Patterns in iOS Patterns", "DI Container vs Service Locator Anti-Pattern & Object Graph"),
    ("Advanced Architecture & Design Patterns Patterns", "Static Libraries vs Dynamic Frameworks & Module Boundaries"),
    ("Advanced Testing & Code Quality Patterns", "Test Doubles, Mocking Architecture & AAA Pattern"),
    ("Advanced Memory Management & ARC Patterns", "Move Semantics, ~Copyable & Noncopyable Types (consuming / borrowing)"),
    ("Advanced Generics, Constraints & Type Erasure Patterns", "Protocol Witness Tables, Dynamic Dispatch & Type Erasure"),
    ("Advanced SwiftUI Architecture & Rendering Patterns", "SwiftUI View Identity (Structural vs Explicit) & Lifecycle"),
    ("Advanced UIKit Architecture & Lifecycle Patterns", "Responder Chain, Hit Testing & Event Dispatch Mechanism"),
    ("Advanced Networking & API Layer Patterns", "Request Deduplication, Idempotency & Exponential Backoff"),
    ("Advanced Swift Concurrency Patterns", "Structured Concurrency (TaskGroup, async let) vs Unstructured Tasks"),
    ("Advanced Data Persistence & Core Data Patterns", "Persistent History Tracking, Batch Operations & SwiftData"),
    ("Advanced System Design for iOS Patterns", "Offline-First Synchronization & Delta Sync Conflict Resolution"),
    ("Advanced GCD & OperationQueue Patterns", "Priority Inversion, QoS Inversion & DispatchGroup Synchronization"),
    ("Advanced Bluetooth Low Energy (CoreBluetooth) Patterns", "CBCentralManager State Restoration & MTU Optimization"),
    ("Advanced Push Notifications & APNs Patterns", "Notification Service Extensions, Content Extensions & Badging"),
]

for old, new in replacements:
    if old in content:
        content = content.replace(old, new)
        print(f"Replaced: {old} -> {new}")
    else:
        print(f"Not found: {old}")

with open(dart_file, 'w', encoding='utf-8') as f:
    f.write(content)

print("Finished updating second topic titles.")
