import 'package:flutter/material.dart';

class AuthProvider {
  final String name;
  final String iconPath;
  final Color primaryColor;
  final String redirectUrl;
  final String apiKey; // Used for API calls (google)

  const AuthProvider({
    required this.name,
    required this.iconPath,
    required this.primaryColor,
    required this.redirectUrl,
    required this.apiKey,
  });
}

class AuthProviders {
  static const List<AuthProvider> all = [
    AuthProvider(
      name: 'Google',
      iconPath: 'assets/icons/google.png',
      primaryColor: Color(0xFF4285F4),
      redirectUrl: 'https://accounts.google.com',
      apiKey: 'google',
    ),
  ];

  /// Find provider by API key
  static AuthProvider? findByApiKey(String apiKey) {
    for (final provider in all) {
      if (provider.apiKey == apiKey) {
        return provider;
      }
    }
    return null;
  }
}
