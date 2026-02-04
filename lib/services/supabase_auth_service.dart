import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../config/env_config.dart';
import '../models/user_info.dart';

/// Service for Supabase authentication
class SupabaseAuthService {
  static final sb.SupabaseClient _client = EnvConfig.supabase;

  /// Sign in with Google OAuth
  static Future<AuthResponse> signInWithGoogle() async {
    try {
      final launched = await _client.auth.signInWithOAuth(
        sb.OAuthProvider.google,
        redirectTo: EnvConfig.oauthRedirectTo,
      );

      if (!launched) {
        return AuthResponse.failure('Failed to start Google sign in');
      }

      // Note: The OAuth flow will complete via deep link
      // This returns success to indicate the flow was initiated
      return AuthResponse(
        success: true,
        user: null, // Will be set after callback
      );
    } on sb.AuthException catch (e) {
      return AuthResponse.failure(e.message);
    } catch (e) {
      return AuthResponse.failure('An error occurred: $e');
    }
  }

  /// Sign in with email and password
  static Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final sb.AuthResponse response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return AuthResponse.failure('Sign in failed');
      }

      return AuthResponse.success(_userInfoFromUser(response.user!));
    } on sb.AuthException catch (e) {
      return AuthResponse.failure('${e.message} (code: ${e.statusCode})');
    } catch (e) {
      return AuthResponse.failure('An error occurred: $e');
    }
  }

  /// Sign up with email and password
  static Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final sb.AuthResponse response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          if (name != null) 'name': name,
        },
      );

      if (response.user == null) {
        return AuthResponse.failure('Sign up failed');
      }

      return AuthResponse.success(_userInfoFromUser(response.user!));
    } on sb.AuthException catch (e) {
      return AuthResponse.failure('${e.message} (code: ${e.statusCode})');
    } catch (e) {
      return AuthResponse.failure('An error occurred: $e');
    }
  }

  /// Sign out
  static Future<AuthResponse> signOut() async {
    try {
      await _client.auth.signOut();
      return AuthResponse(
        success: true,
        user: null,
      );
    } on sb.AuthException catch (e) {
      return AuthResponse.failure(e.message);
    } catch (e) {
      return AuthResponse.failure('An error occurred: $e');
    }
  }

  /// Get current user
  static UserInfo? getCurrentUser() {
    final user = _client.auth.currentSession?.user;
    if (user == null) return null;
    return _userInfoFromUser(user);
  }

  /// Listen to auth state changes
  static Stream<sb.AuthState> authStateChanges() => _client.auth.onAuthStateChange;

  /// Convert Supabase User to UserInfo
  static UserInfo _userInfoFromUser(sb.User user) {
    final metadata = user.userMetadata ?? const <String, dynamic>{};
    return UserInfo(
      id: user.id,
      email: user.email ?? '',
      name: metadata['name'] ?? metadata['full_name'] ?? user.email,
      firstName: metadata['given_name'] ?? metadata['first_name'],
      lastName: metadata['family_name'] ?? metadata['last_name'],
      pictureUrl: metadata['avatar_url'] ?? metadata['picture'],
      provider: user.appMetadata['provider'] ?? 'email',
      authenticatedAt: DateTime.tryParse(user.createdAt) ?? DateTime.now(),
    );
  }

  /// Reset password
  static Future<AuthResponse> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return AuthResponse(
        success: true,
        user: null,
      );
    } on sb.AuthException catch (e) {
      return AuthResponse.failure(e.message);
    } catch (e) {
      return AuthResponse.failure('An error occurred: $e');
    }
  }

  /// Check if email is confirmed
  static bool get isEmailConfirmed {
    final user = _client.auth.currentSession?.user;
    return user?.emailConfirmedAt != null;
  }
}
