import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../models/user_info.dart';
import '../config/env_config.dart';

/// Service for communicating with the Auth API backend
class AuthApiService {
  /// Sign in with a provider (google, apple, linkedin, facebook)
  /// Opens the OAuth flow in a new window/url
  static Future<void> signInWithProvider(
    String provider, {
    VoidCallback? onLoading,
    VoidCallback? onSuccess,
    ValueChanged<String>? onError,
  }) async {
    onLoading?.call();

    try {
      final authUrl = Uri.parse('${EnvConfig.apiBaseUrl}/auth/$provider');

      // Launch the OAuth URL in a browser
      if (!await launchUrl(authUrl, mode: LaunchMode.externalApplication)) {
        onError?.call('Could not launch authentication URL');
        return;
      }

      // Note: In a real implementation, you would need to:
      // 1. Use a deep link or custom URL scheme to handle the callback
      // 2. Or use a webview with JavaScript message handlers
      // 3. Or poll the backend for the authentication result

      // For web platform, we can use the popup approach
      // For mobile/desktop, you need to implement deep link handling

      onError?.call(
        'Authentication initiated. Please implement deep link handling '
        'or use the web version for full OAuth flow support.',
      );
    } catch (e) {
      onError?.call('Failed to start authentication: $e');
    }
  }

  /// Exchange authorization code for user token
  static Future<AuthResponse> exchangeToken(
    String provider,
    String code, {
    String? name,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${EnvConfig.apiBaseUrl}/auth/token/$provider'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'code': code,
          'name': ?name,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return AuthResponse.fromJson(data);
      } else {
        return AuthResponse.failure(
          'Server error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      return AuthResponse.failure('Network error: $e');
    }
  }

  /// Check if the API server is running
  static Future<bool> checkApiHealth() async {
    try {
      final response = await http.get(
        Uri.parse('${EnvConfig.apiBaseUrl}/health'),
      ).timeout(
        const Duration(seconds: 5),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('API health check failed: $e');
      return false;
    }
  }

  /// Get API status and enabled providers
  static Future<Map<String, dynamic>> getApiStatus() async {
    try {
      final response = await http.get(
        Uri.parse(EnvConfig.apiBaseUrl),
      ).timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return {};
    } catch (e) {
      debugPrint('API status check failed: $e');
      return {};
    }
  }

  /// Mock sign in for testing (when no credentials are configured)
  static Future<AuthResponse> mockSignIn(String provider) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Return mock user data
    return AuthResponse(
      success: true,
      user: UserInfo(
        id: 'mock_${provider}_123',
        email: 'user@$provider.com',
        name: 'Test User',
        firstName: 'Test',
        lastName: 'User',
        pictureUrl: null,
        provider: provider,
        authenticatedAt: DateTime.now(),
      ),
    );
  }
}
