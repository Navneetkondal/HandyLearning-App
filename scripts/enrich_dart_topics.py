import re

dart_file = 'lib/features/ios_senior_prep/data/ios_prep_master_hierarchy_data.dart'

with open(dart_file, 'r', encoding='utf-8') as f:
    content = f.read()

# Let's inspect the domains and replace their placeholder titles and descriptions with the exact deep-dive topics from the conversation.
# We will verify flutter analyze afterwards.

replacements = [
    # Domain 17: Build Systems, Xcode & Release
    (
        '''title: 'CI/CD & Release Engineering Fundamentals',''',
        '''title: 'Xcode Build System, .xcconfig & Build Settings Inheritance','''
    ),
    (
        '''title: 'CI/CD & Release Engineering Advanced Architecture',''',
        '''title: 'App Flavoring, Multi-Environment Architecture & Code Signing','''
    ),
    # Domain 22: Security, Privacy & Permissions
    (
        '''title: 'Security & Cryptography Fundamentals',''',
        '''title: 'iOS Permissions Architecture, Manager State Machine & ATT','''
    ),
    (
        '''title: 'Security & Cryptography Advanced Architecture',''',
        '''title: 'Privacy Manifests (PrivacyInfo.xcprivacy) & Required Reason APIs','''
    ),
    # Domain 16: App Size & Extensions
    (
        '''title: 'App Size & Distribution Fundamentals',''',
        '''title: 'App Extensions (.appex) Architecture, IPC & App Groups','''
    ),
    (
        '''title: 'App Size & Distribution Advanced Architecture',''',
        '''title: 'App Thinning, App Slicing & On-Demand Resources (ODR)','''
    ),
    # Domain 12: Design Patterns & DI
    (
        '''title: 'Design Patterns in iOS Fundamentals',''',
        '''title: 'Composition Root & Pure Dependency Injection Architecture','''
    ),
    (
        '''title: 'Design Patterns in iOS Advanced Architecture',''',
        '''title: 'DI Container vs Service Locator Anti-Pattern & Object Graph','''
    ),
    # Domain 10: Architecture & Modularization
    (
        '''title: 'Architecture & Design Patterns Fundamentals',''',
        '''title: 'Modular Monorepo Architecture & Swift Package Manager (SPM)','''
    ),
    (
        '''title: 'Architecture & Design Patterns Advanced Architecture',''',
        '''title: 'Static Libraries vs Dynamic Frameworks & Module Boundaries','''
    ),
    # Domain 18: Testing & Code Quality
    (
        '''title: 'Testing & Code Quality Fundamentals',''',
        '''title: 'Swift Testing Framework (@Test, #expect) vs XCTest','''
    ),
    (
        '''title: 'Testing & Code Quality Advanced Architecture',''',
        '''title: 'Test Doubles, Mocking Architecture & AAA Pattern','''
    ),
    # Domain 4: Memory Management, ARC & Move Semantics
    (
        '''title: 'Memory Management & ARC Advanced Architecture',''',
        '''title: 'Move Semantics, ~Copyable & Noncopyable Types (consuming / borrowing)','''
    ),
    # Domain 3: Generics, Constraints & Type Erasure
    (
        '''title: 'Generics, Constraints & Type Erasure Fundamentals',''',
        '''title: 'Existential Types (any Protocol) vs Opaque Types (some Protocol)','''
    ),
    (
        '''title: 'Generics, Constraints & Type Erasure Advanced Architecture',''',
        '''title: 'Protocol Witness Tables, Dynamic Dispatch & Type Erasure','''
    ),
    # Domain 8: SwiftUI Architecture & Rendering
    (
        '''title: 'SwiftUI Architecture & Rendering Fundamentals',''',
        '''title: 'SwiftUI AttributeGraph & View Dependency Graph Internals','''
    ),
    (
        '''title: 'SwiftUI Architecture & Rendering Advanced Architecture',''',
        '''title: 'SwiftUI View Identity (Structural vs Explicit) & Lifecycle','''
    ),
    # Domain 7: UIKit Architecture & Lifecycle
    (
        '''title: 'UIKit Architecture & Lifecycle Fundamentals',''',
        '''title: 'UIKit Render Loop, layoutSubviews & CATransaction Internals','''
    ),
    (
        '''title: 'UIKit Architecture & Lifecycle Advanced Architecture',''',
        '''title: 'Responder Chain, Hit Testing & Event Dispatch Mechanism','''
    ),
    # Domain 9: Networking & API Layer
    (
        '''title: 'Networking & API Layer Fundamentals',''',
        '''title: 'URLSession Architecture, URLProtocol & Custom Network Stacks','''
    ),
    (
        '''title: 'Networking & API Layer Advanced Architecture',''',
        '''title: 'Request Deduplication, Idempotency & Exponential Backoff','''
    ),
    # Domain 5: Swift Concurrency
    (
        '''title: 'Swift Concurrency Fundamentals',''',
        '''title: 'Actor Isolation, Reentrancy & Data Race Elimination','''
    ),
    (
        '''title: 'Swift Concurrency Advanced Architecture',''',
        '''title: 'Structured Concurrency (TaskGroup, async let) vs Unstructured Tasks','''
    ),
    # Domain 13: Data Persistence & Core Data
    (
        '''title: 'Data Persistence & Core Data Fundamentals',''',
        '''title: 'Core Data Concurrency Architecture & Parent/Child Contexts','''
    ),
    (
        '''title: 'Data Persistence & Core Data Advanced Architecture',''',
        '''title: 'Persistent History Tracking, Batch Operations & SwiftData','''
    ),
    # Domain 23: System Design for iOS
    (
        '''title: 'System Design for iOS Fundamentals',''',
        '''title: 'Large-Scale iOS Feed Architecture & Multi-Tier Caching','''
    ),
    (
        '''title: 'System Design for iOS Advanced Architecture',''',
        '''title: 'Offline-First Synchronization & Delta Sync Conflict Resolution','''
    ),
]

updated_count = 0
for old, new in replacements:
    if old in content:
        content = content.replace(old, new)
        updated_count += 1
    else:
        print(f"Warning: pattern not found: {old[:50]}")

with open(dart_file, 'w', encoding='utf-8') as f:
    f.write(content)

print(f"Replaced {updated_count}/{len(replacements)} topic titles in {dart_file}")
