/// User information model from OAuth providers
class UserInfo {
  final String id;
  final String email;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? pictureUrl;
  final String provider;
  final DateTime authenticatedAt;

  UserInfo({
    required this.id,
    required this.email,
    this.name,
    this.firstName,
    this.lastName,
    this.pictureUrl,
    required this.provider,
    required this.authenticatedAt,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      pictureUrl: json['pictureUrl'] as String?,
      provider: json['provider'] as String,
      authenticatedAt: DateTime.parse(json['authenticatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
      'pictureUrl': pictureUrl,
      'provider': provider,
      'authenticatedAt': authenticatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'UserInfo(id: $id, email: $email, name: $name, provider: $provider)';
  }
}

/// Auth response model
class AuthResponse {
  final bool success;
  final UserInfo? user;
  final String? error;

  AuthResponse({
    required this.success,
    this.user,
    this.error,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] as bool,
      user: json['user'] != null ? UserInfo.fromJson(json['user'] as Map<String, dynamic>) : null,
      error: json['error'] as String?,
    );
  }

  factory AuthResponse.success(UserInfo user) {
    return AuthResponse(success: true, user: user);
  }

  factory AuthResponse.failure(String error) {
    return AuthResponse(success: false, error: error);
  }

  @override
  String toString() {
    return 'AuthResponse(success: $success, user: $user, error: $error)';
  }
}
