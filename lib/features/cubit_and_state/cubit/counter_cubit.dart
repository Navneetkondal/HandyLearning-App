import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_state.dart';

/// Cubit managing Counter business logic.
///
/// Notice the core architectural simplicity of Cubit:
/// 1. We extend [Cubit<CounterState>].
/// 2. We pass the initial state via [super(CounterState.initial())].
/// 3. We define normal synchronous/asynchronous functions.
/// 4. We call [emit(newState)] to notify UI subscribers.
class CounterCubit extends Cubit<CounterState> {
  // Keeps an educational log of state transitions
  final List<String> transitionLogs = [];

  CounterCubit() : super(CounterState.initial()) {
    _log('Initialized CounterCubit at count: 0');
  }

  void increment() {
    final nextCount = state.count + 1;
    _log('increment() called -> count: ${state.count} to $nextCount');
    emit(state.copyWith(
      count: nextCount,
      statusMessage: 'Incremented to $nextCount',
      timestamp: DateTime.now(),
    ));
  }

  void decrement() {
    final nextCount = state.count - 1;
    _log('decrement() called -> count: ${state.count} to $nextCount');
    emit(state.copyWith(
      count: nextCount,
      statusMessage: 'Decremented to $nextCount',
      timestamp: DateTime.now(),
    ));
  }

  void reset() {
    _log('reset() called -> resetting count to 0');
    emit(CounterState.initial());
  }

  void addCustom(int delta) {
    final nextCount = state.count + delta;
    _log('addCustom($delta) -> count: ${state.count} to $nextCount');
    emit(state.copyWith(
      count: nextCount,
      statusMessage: 'Adjusted by $delta to $nextCount',
      timestamp: DateTime.now(),
    ));
  }

  void _log(String message) {
    final time = DateTime.now().toIso8601String().substring(11, 19);
    transitionLogs.insert(0, '[$time] $message');
    if (transitionLogs.length > 20) {
      transitionLogs.removeLast();
    }
  }

  @override
  void onChange(Change<CounterState> change) {
    super.onChange(change);
    // Cubit lifecycle hook called on every state transition
    // Useful for debugging, logging, or analytics
  }
}
