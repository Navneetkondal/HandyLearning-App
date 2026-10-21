import 'package:flutter_test/flutter_test.dart';
import 'package:handy_learn/features/repository_pattern/cubit/user_directory_cubit.dart';
import 'package:handy_learn/features/repository_pattern/cubit/user_directory_state.dart';
import 'package:handy_learn/features/repository_pattern/data/datasources/user_mock_datasource.dart';
import 'package:handy_learn/features/repository_pattern/data/repositories/user_repository_impl.dart';

void main() {
  group('Repository Pattern & UserDirectoryCubit Tests', () {
    late UserMockDataSource dataSource;
    late UserRepositoryImpl repository;
    late UserDirectoryCubit cubit;

    setUp(() {
      dataSource = UserMockDataSource()..latencyMs = 10;
      repository = UserRepositoryImpl(dataSource: dataSource);
      cubit = UserDirectoryCubit(repository: repository);
    });

    tearDown(() {
      cubit.close();
    });

    test('Initial state is UserDirectoryInitial', () {
      expect(cubit.state, isA<UserDirectoryInitial>());
    });

    test('loadUsers() emits [Loading, Loaded] on success', () async {
      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<UserDirectoryLoading>(),
          isA<UserDirectoryLoaded>().having(
            (s) => s.users.first.name,
            'first user name',
            equals('Aarav Sharma'),
          ),
        ]),
      );

      await cubit.loadUsers();
    });

    test('loadUsers() emits [Loading, Error] when datasource fails', () async {
      dataSource.simulateFailure = true;

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<UserDirectoryLoading>(),
          isA<UserDirectoryError>().having(
            (s) => s.message,
            'error message',
            contains('Simulated network connection timeout'),
          ),
        ]),
      );

      await cubit.loadUsers();
    });

    test('addUser() adds new profile and refreshes list', () async {
      await cubit.addUser(
        name: 'Dev Student',
        email: 'student@example.com',
        role: 'Learner',
      );

      expect(cubit.state, isA<UserDirectoryLoaded>());
      final loaded = cubit.state as UserDirectoryLoaded;
      expect(loaded.users.any((u) => u.name == 'Dev Student'), isTrue);
    });
  });
}
