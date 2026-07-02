import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/supabase/supabase_client.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );

    if (response.user == null) {
      throw Exception('Registration failed');
    }

    // Wait for trigger to create profile, then fetch it
    await Future.delayed(const Duration(milliseconds: 500));

    final profile = await supabase
        .from('profiles')
        .select()
        .eq('id', response.user!.id)
        .single();

    return UserModel.fromJson(profile);
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Login failed');
    }

    final profile = await supabase
        .from('profiles')
        .select()
        .eq('id', response.user!.id)
        .single();

    return UserModel.fromJson(profile);
  }

  @override
  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  @override
  Future<void> loginWithPhone({
    required String phone,
    required String password,
  }) async {
    // Supabase phone login: sign in with phone + password
    final response = await supabase.auth.signInWithPassword(
      phone: phone,
      password: password,
    );
    if (response.user == null) {
      throw Exception('Connexion échouée');
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await supabase.auth.resetPasswordForEmail(email);
  }

  @override
  Future<void> forgotPasswordWithPhone({required String phone}) async {
    // Send OTP to phone number for password reset
    await supabase.auth.signInWithOtp(phone: phone);
  }

  @override
  Future<void> resetPassword({required String newPassword}) async {
    await supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final profile = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    return UserModel.fromJson(profile);
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return supabase.auth.onAuthStateChange.asyncMap((event) async {
      final user = event.session?.user;
      if (user == null) return null;

      final profile = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(profile);
    });
  }
}