import 'dart:async';

/// Simulated remote API datasource.
///
/// Mimics an HTTP network client (Dio / http) with simulated network latency,
/// in-memory storage, and a togglable failure switch for testing error states.
class UserMockDataSource {
  /// Toggle this to simulate a network outage or 500 Internal Server Error
  bool simulateFailure = false;

  /// Artificial latency in milliseconds
  int latencyMs = 700;

  final List<Map<String, dynamic>> _database = [
    {
      'id': 'u_101',
      'name': 'Aarav Sharma',
      'email': 'aarav.sharma@example.com',
      'role': 'Senior Flutter Architect',
      'isActive': true,
    },
    {
      'id': 'u_102',
      'name': 'Priya Patel',
      'email': 'priya.patel@example.com',
      'role': 'Mobile UI/UX Designer',
      'isActive': true,
    },
    {
      'id': 'u_103',
      'name': 'Rohan Gupta',
      'email': 'rohan.gupta@example.com',
      'role': 'Backend & Cloud Engineer',
      'isActive': true,
    },
    {
      'id': 'u_104',
      'name': 'Ananya Iyer',
      'email': 'ananya.iyer@example.com',
      'role': 'DevOps & CI/CD Lead',
      'isActive': true,
    },
  ];

  /// Simulates GET /api/v1/users
  Future<List<Map<String, dynamic>>> fetchRawUsers() async {
    await Future.delayed(Duration(milliseconds: latencyMs));

    if (simulateFailure) {
      throw Exception('503 Service Unavailable: Simulated network connection timeout.');
    }

    // Return defensive copy of raw JSON maps
    return List<Map<String, dynamic>>.from(_database);
  }

  /// Simulates POST /api/v1/users
  Future<Map<String, dynamic>> createRawUser(Map<String, dynamic> json) async {
    await Future.delayed(Duration(milliseconds: latencyMs));

    if (simulateFailure) {
      throw Exception('500 Internal Server Error: Failed to write to mock database.');
    }

    _database.insert(0, json);
    return json;
  }

  /// Simulates DELETE /api/v1/users/:id
  Future<void> deleteRawUser(String id) async {
    await Future.delayed(Duration(milliseconds: latencyMs));

    if (simulateFailure) {
      throw Exception('404 Not Found: Simulated deletion error.');
    }

    _database.removeWhere((item) => item['id'] == id);
  }
}
