class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int tokenBalance;
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.tokenBalance,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      tokenBalance: json['token_balance'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'token_balance': tokenBalance,
      'is_active': isActive,
    };
  }
}

class AuthResponse {
  final bool success;
  final String token;
  final User user;

  AuthResponse({
    required this.success,
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] as bool,
      token: json['token'] as String,
      user: User.fromJson(json['user']),
    );
  }
}

class MeResponse {
  final bool success;
  final User user;

  MeResponse({required this.success, required this.user});

  factory MeResponse.fromJson(Map<String, dynamic> json) {
    return MeResponse(
      success: json['success'] as bool,
      user: User.fromJson(json['user']),
    );
  }
}
