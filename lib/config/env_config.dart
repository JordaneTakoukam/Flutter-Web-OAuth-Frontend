import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Environment configuration for the app
class EnvConfig {
  static bool _initialized = false;

  /// Initialize environment variables from .env file
  static Future<void> init() async {
    if (_initialized) return;
    try {
      await dotenv.load(fileName: '.env');
      _initialized = true;
    } catch (e) {
      // Use default values if .env file is not found
      _initialized = true;
    }
  }

  /// Get the Supabase URL from environment
  static String get supabaseUrl =>
      dotenv.env['SUPABASE_URL'] ?? '';

  /// Get the Supabase Anon Key from environment
  static String get supabaseAnonKey =>
      dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  /// Check if Supabase is configured
  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Get the API base URL from environment (optional, for additional proxy endpoints)
  static String get apiBaseUrl =>
      dotenv.env['AUTH_API_URL'] ?? 'http://localhost:8080';

  /// Get the app name
  static String get appName => dotenv.env['APP_NAME'] ?? 'Auth Sandbox';

  /// OAuth redirect URL for Supabase (must be allowed in Supabase Auth settings)
  /// For Flutter web with go_router default hash strategy this is typically:
  /// http://localhost:3000/#/auth/callback
  static String get oauthRedirectTo =>
      dotenv.env['OAUTH_REDIRECT_TO'] ?? '${Uri.base.origin}/#/auth/callback';

  /// Initialize Supabase
  static Future<void> initSupabase() async {
    if (!isSupabaseConfigured) {
      throw Exception(
        'Supabase is not configured. Please set SUPABASE_URL and SUPABASE_ANON_KEY in .env',
      );
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: true,
    );
  }

  /// Get the Supabase client instance
  static SupabaseClient get supabase => Supabase.instance.client;

  /// Get current authenticated user
  static User? get currentUser => supabase.auth.currentSession?.user;

  /// Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;

  @override
  String toString() => 'EnvConfig(supabaseUrl: $supabaseUrl, configured: $isSupabaseConfigured)';
}
