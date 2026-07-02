import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> register({
    required String email,
    required String password,
    required String fullName,
  });

  Future<UserEntity> login({
    required String email,
    required String password,
  });

  Future<void> loginWithPhone({required String phone, required String password});

  Future<void> logout();

  Future<void> forgotPassword({required String email});

  Future<void> forgotPasswordWithPhone({required String phone});

  Future<void> resetPassword({required String newPassword});

  Future<UserEntity?> getCurrentUser();

  Stream<UserEntity?> get authStateChanges;
}