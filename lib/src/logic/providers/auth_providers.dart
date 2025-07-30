import 'package:bookmark_bites/src/data/repositories/auth_repository.dart';
import 'package:bookmark_bites/src/data/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

// 1. A provider to expose the FirebaseAuth instance
@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

// 2. A provider to expose our AuthRepository implementation
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return FirebaseAuthService(ref.watch(firebaseAuthProvider));
}

// 3. A stream provider to listen to the auth state changes
@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}

// 4. A Notifier provider to handle the auth logic (login, logout, register)
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<void> build() async {
    // This notifier doesn't hold any state itself, but handles actions.
    // The build method is required, but we can leave it empty.
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => authRepository.signInWithEmailAndPassword(email: email, password: password),
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => authRepository.createUserWithEmailAndPassword(email: email, password: password),
    );
  }

  Future<void> signOut() async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(authRepository.signOut);
  }
}