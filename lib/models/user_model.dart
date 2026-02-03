class User {
  final int id;
  final String name;
  final int tokenBalance;

  User({required this.id, required this.name, required this.tokenBalance});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      tokenBalance: json['token_balance'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'token_balance': tokenBalance};
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
