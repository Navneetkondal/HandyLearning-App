import 'package:equatable/equatable.dart';
import '../data/models/user_profile.dart';

/// Sealed class hierarchy representing the states of the User Directory screen.
///
/// Sealed classes provide compile-time exhaustive type checking when switching
/// on states in the UI.
sealed class UserDirectoryState extends Equatable {
  const UserDirectoryState();

  @override
  List<Object?> get props => [];
}

/// Initial state: No data requested yet
class UserDirectoryInitial extends UserDirectoryState {
  const UserDirectoryInitial();
}

/// Loading state: Async fetch in progress
class UserDirectoryLoading extends UserDirectoryState {
  final String message;
  const UserDirectoryLoading({this.message = 'Fetching directory from repository...'});

  @override
  List<Object?> get props => [message];
}

/// Loaded state: Successfully retrieved list of users
class UserDirectoryLoaded extends UserDirectoryState {
  final List<UserProfile> users;
  final String? toastNotification;

  const UserDirectoryLoaded({
    required this.users,
    this.toastNotification,
  });

  @override
  List<Object?> get props => [users, toastNotification];
}

/// Error state: Repository call threw an exception
class UserDirectoryError extends UserDirectoryState {
  final String message;

  const UserDirectoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
