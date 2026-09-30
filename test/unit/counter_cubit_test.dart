import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_learning_hub/features/cubit_and_state/cubit/counter_cubit.dart';
import 'package:flutter_learning_hub/features/cubit_and_state/cubit/counter_state.dart';

void main() {
  group('CounterCubit Unit Tests', () {
    late CounterCubit cubit;

    setUp(() {
      cubit = CounterCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('Initial state has count = 0', () {
      expect(cubit.state.count, equals(0));
    });

    test('increment() increases count by 1 and updates message', () {
      cubit.increment();
      expect(cubit.state.count, equals(1));
      expect(cubit.state.statusMessage, contains('1'));
    });

    test('decrement() decreases count by 1 and updates message', () {
      cubit.decrement();
      expect(cubit.state.count, equals(-1));
      expect(cubit.state.statusMessage, contains('-1'));
    });

    test('reset() returns count to initial 0', () {
      cubit.increment();
      cubit.increment();
      expect(cubit.state.count, equals(2));

      cubit.reset();
      expect(cubit.state.count, equals(0));
    });

    test('addCustom() adjusts count by specified delta', () {
      cubit.addCustom(10);
      expect(cubit.state.count, equals(10));
    });

    test('CounterState value equality with Equatable', () {
      final now = DateTime.now();
      final stateA = CounterState(count: 5, statusMessage: 'Test', timestamp: now);
      final stateB = CounterState(count: 5, statusMessage: 'Test', timestamp: now);
      final stateC = CounterState(count: 6, statusMessage: 'Test', timestamp: now);

      expect(stateA, equals(stateB));
      expect(stateA == stateC, isFalse);
    });
  });
}
