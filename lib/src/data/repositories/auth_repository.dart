import 'package:firebase_auth/firebase_auth.dart';

// Abstract class defining the contract for authentication services.
abstract class AuthRepository {
  /// Stream of [User] which will emit the current user when the
  /// authentication state changes.
  Stream<User?> get authStateChanges;

  /// Signs in with the given [email] and [password].
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Creates a new user with the given [email] and [password].
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Signs out the current user.
  Future<void> signOut();
}