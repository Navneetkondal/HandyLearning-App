import 'package:equatable/equatable.dart';

/// An immutable state class representing the counter's state.
///
/// Extends [Equatable] so Flutter BLoC can evaluate value equality.
/// If `stateA == stateB`, BlocBuilder avoids redundant widget rebuilds.
class CounterState extends Equatable {
  final int count;
  final String statusMessage;
  final DateTime timestamp;

  const CounterState({
    required this.count,
    required this.statusMessage,
    required this.timestamp,
  });

  /// Factory for the initial baseline state
  factory CounterState.initial() {
    return CounterState(
      count: 0,
      statusMessage: 'Initial state (count: 0)',
      timestamp: DateTime.now(),
    );
  }

  /// Implements copyWith for immutable transformations
  CounterState copyWith({
    int? count,
    String? statusMessage,
    DateTime? timestamp,
  }) {
    return CounterState(
      count: count ?? this.count,
      statusMessage: statusMessage ?? this.statusMessage,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// Equatable props list: Flutter BLoC compares these properties
  /// to decide if a new state was actually emitted.
  @override
  List<Object?> get props => [count, statusMessage];

  @override
  String toString() => 'CounterState(count: $count, message: "$statusMessage")';
}
