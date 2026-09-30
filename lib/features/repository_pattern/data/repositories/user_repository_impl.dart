import '../../domain/repositories/user_repository.dart';
import '../datasources/user_mock_datasource.dart';
import '../models/user_profile.dart';

/// Concrete implementation of [UserRepository].
///
/// Responsibilities:
/// 1. Calls data source ([UserMockDataSource] or real HTTP client).
/// 2. Maps raw JSON maps to strongly-typed [UserProfile] domain models.
/// 3. Catches low-level network/serialization exceptions and rethrows them
///    as clean, user-facing [UserOperationException]s.
class UserRepositoryImpl implements UserRepository {
  final UserMockDataSource dataSource;

  UserRepositoryImpl({required this.dataSource});

  @override
  Future<List<UserProfile>> getUsers() async {
    try {
      final rawList = await dataSource.fetchRawUsers();
      // Data mapping: JSON List -> Domain Entity List
      return rawList.map((map) => UserProfile.fromJson(map)).toList();
    } catch (e) {
      // Exception translation: raw network error -> domain exception
      throw UserOperationException('Failed to retrieve user directory: ${e.toString()}');
    }
  }

  @override
  Future<UserProfile> addUser({
    required String name,
    required String email,
    required String role,
  }) async {
    try {
      final newId = 'u_${DateTime.now().millisecondsSinceEpoch % 10000}';
      final json = {
        'id': newId,
        'name': name,
        'email': email,
        'role': role,
        'isActive': true,
      };

      final createdRaw = await dataSource.createRawUser(json);
      return UserProfile.fromJson(createdRaw);
    } catch (e) {
      throw UserOperationException('Failed to create new user: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      await dataSource.deleteRawUser(id);
    } catch (e) {
      throw UserOperationException('Failed to delete user $id: ${e.toString()}');
    }
  }
}
