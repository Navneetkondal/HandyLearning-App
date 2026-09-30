import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/user_repository.dart';
import 'user_directory_state.dart';

/// Cubit orchestrating user directory logic and communicating with [UserRepository].
///
/// Demonstrates Dependency Inversion:
/// This Cubit depends on the abstract [UserRepository] interface, NOT the concrete
/// [UserRepositoryImpl] or [UserMockDataSource]. This makes testing effortless!
class UserDirectoryCubit extends Cubit<UserDirectoryState> {
  final UserRepository repository;

  UserDirectoryCubit({required this.repository}) : super(const UserDirectoryInitial());

  /// Loads users and transitions states: Initial -> Loading -> Loaded / Error
  Future<void> loadUsers() async {
    emit(const UserDirectoryLoading(message: 'Requesting users from Repository...'));

    try {
      final users = await repository.getUsers();
      emit(UserDirectoryLoaded(users: users));
    } catch (e) {
      emit(UserDirectoryError(message: e.toString()));
    }
  }

  /// Refreshes users (e.g. for Pull-to-refresh) without full whiteout
  Future<void> refreshUsers() async {
    try {
      final users = await repository.getUsers();
      emit(UserDirectoryLoaded(
        users: users,
        toastNotification: 'Refreshed ${users.length} users successfully!',
      ));
    } catch (e) {
      emit(UserDirectoryError(message: e.toString()));
    }
  }

  /// Adds a new user to the repository
  Future<void> addUser({
    required String name,
    required String email,
    required String role,
  }) async {
    emit(const UserDirectoryLoading(message: 'Sending user data to repository...'));

    try {
      await repository.addUser(name: name, email: email, role: role);
      final updatedList = await repository.getUsers();
      emit(UserDirectoryLoaded(
        users: updatedList,
        toastNotification: 'User "$name" created successfully!',
      ));
    } catch (e) {
      emit(UserDirectoryError(message: e.toString()));
    }
  }

  /// Deletes a user by id
  Future<void> deleteUser(String id) async {
    emit(const UserDirectoryLoading(message: 'Deleting user via repository...'));

    try {
      await repository.deleteUser(id);
      final updatedList = await repository.getUsers();
      emit(UserDirectoryLoaded(
        users: updatedList,
        toastNotification: 'User removed from repository.',
      ));
    } catch (e) {
      emit(UserDirectoryError(message: e.toString()));
    }
  }
}
