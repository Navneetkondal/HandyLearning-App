import '../../data/models/user_profile.dart';

/// Abstract contract for User Data Operations.
///
/// In Clean Architecture:
/// - The domain layer defines the interface (abstract class).
/// - The presentation layer (Cubit) depends ONLY on this interface.
/// - The data layer implements this interface.
///
/// Benefit: We can swap the implementation (e.g. from MockDataSource
/// to HttpDataSource or Firebase) without altering a single line of UI or Cubit code!
abstract class UserRepository {
  /// Fetches the list of all active user profiles
  Future<List<UserProfile>> getUsers();

  /// Adds a new user profile
  Future<UserProfile> addUser({
    required String name,
    required String email,
    required String role,
  });

  /// Deletes a user by ID
  Future<void> deleteUser(String id);
}

/// Domain-specific custom exception
class UserOperationException implements Exception {
  final String message;
  final int? statusCode;

  const UserOperationException(this.message, [this.statusCode]);

  @override
  String toString() => 'UserOperationException: $message (Status: $statusCode)';
}
