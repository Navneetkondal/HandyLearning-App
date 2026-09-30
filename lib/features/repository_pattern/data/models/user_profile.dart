import 'package:equatable/equatable.dart';

/// Data Model representing a user profile entity.
class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final String avatarLetter;
  final bool isActive;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.avatarLetter,
    this.isActive = true,
  });

  /// Factory constructor for parsing JSON maps
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String;
    return UserProfile(
      id: json['id'] as String,
      name: name,
      email: json['email'] as String,
      role: json['role'] as String,
      avatarLetter: name.isNotEmpty ? name[0].toUpperCase() : '?',
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Serialization to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'isActive': isActive,
    };
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? avatarLetter,
    bool? isActive,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatarLetter: avatarLetter ?? this.avatarLetter,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, name, email, role, isActive];
}
