import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/entities/user_entity.dart';
import '../domain/repositories/auth_repository.dart';

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

// Auth state provider
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

// Current user provider
final currentUserProvider = FutureProvider<UserEntity?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.getCurrentUser();
});

// Auth actions state
class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final UserEntity? user;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    UserEntity? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      user: user ?? this.user,
    );
  }
}


class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState());

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.register(
        email: email,
        password: password,
        fullName: fullName,
      );
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.login(
        email: email,
        password: password,
      );
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loginWithPhone({
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.loginWithPhone(phone: phone, password: password);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.logout();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> forgotPassword({required String email}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.forgotPassword(email: email);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> forgotPasswordWithPhone({required String phone}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.forgotPasswordWithPhone(phone: phone);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> resetPassword({required String newPassword}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.resetPassword(newPassword: newPassword);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

// Auth notifier provider
final authNotifierProvider =
StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});