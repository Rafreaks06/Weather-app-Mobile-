import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  Future<void> signInWithGoogle() async {
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.flutter://login-callback',

    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? get currentUser => _supabase.auth.currentUser;

  Future<void> upsertUserProfile({
    required String email,
    required String username,
    String? avatarUrl,
  }) async {
    await _supabase.from('users').upsert({
      'email': email,
      'username': username,
      'avatar_url': avatarUrl,
    });
  }
}
