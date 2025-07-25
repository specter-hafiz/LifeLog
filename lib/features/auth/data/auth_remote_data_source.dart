import 'package:lifelog/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signup(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = response.user;
    print("User: ${response.user}");
    print("Session: ${response.session}");
    print("Response: $response");
    if (user == null) throw AuthException('Login failed');
    print("Login Response: $response");
    print("Email confirmed at: ${user.emailConfirmedAt}");
    if (user.emailConfirmedAt == null) {
      await client.auth.resend(type: OtpType.signup, email: user.email!);
      throw AuthException(
        'Email not confirmed. We’ve sent you a new verification email.',
      );
    }

    return UserModel(id: user.id, email: user.email ?? '');
  }

  @override
  Future<UserModel> signup(String email, String password) async {
    final response = await client.auth.signUp(email: email, password: password);
    print("Signup Response: $response");
    final user = response.user;
    if (user == null) throw AuthException('Signup failed');
    return UserModel(id: user.id, email: user.email ?? '');
  }

  @override
  Future<void> logout() async {
    await client.auth.signOut();
    await SharedPreferences.getInstance().then((prefs) => prefs.clear());
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = client.auth.currentUser;
    final session = client.auth.currentSession;
    final isSessionExpired = session?.isExpired;
    print("Is session expired: $isSessionExpired");
    if (isSessionExpired == true) {
      print("Session is expired, logging out...");
      await logout();
      return null;
    }

    print("Current Session: $session");
    if (user == null) {
      print("No user is currently logged in.");
      return null;
    }
    print("Current User: $user");
    return UserModel(id: user.id, email: user.email ?? '');
  }
}
