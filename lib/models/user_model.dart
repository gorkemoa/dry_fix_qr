class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int tokenBalance;
  final bool isActive;
  final String? birthDate;
  final int welcomeBonusClaimed;
  final UserGames? games;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.tokenBalance,
    required this.isActive,
    this.birthDate,
    this.welcomeBonusClaimed = 0,
    this.games,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      tokenBalance: json['token_balance'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? false,
      birthDate: json['birth_date'] as String?,
      welcomeBonusClaimed: json['welcome_bonus_claimed'] as int? ?? 0,
      games: json['games'] is Map<String, dynamic>
          ? UserGames.fromJson(json['games'] as Map<String, dynamic>)
          : null,
    );
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    int? tokenBalance,
    bool? isActive,
    String? birthDate,
    int? welcomeBonusClaimed,
    UserGames? games,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      tokenBalance: tokenBalance ?? this.tokenBalance,
      isActive: isActive ?? this.isActive,
      birthDate: birthDate ?? this.birthDate,
      welcomeBonusClaimed: welcomeBonusClaimed ?? this.welcomeBonusClaimed,
      games: games ?? this.games,
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
      'birth_date': birthDate,
      'welcome_bonus_claimed': welcomeBonusClaimed,
      'games': games?.toJson(),
    };
  }
}

class UserGames {
  final UserGameInfo? memoryMatch;

  const UserGames({this.memoryMatch});

  factory UserGames.fromJson(Map<String, dynamic> json) {
    return UserGames(
      memoryMatch: json['memory_match'] is Map<String, dynamic>
          ? UserGameInfo.fromJson(json['memory_match'] as Map<String, dynamic>)
          : null,
    );
  }

  UserGames copyWith({UserGameInfo? memoryMatch}) {
    return UserGames(memoryMatch: memoryMatch ?? this.memoryMatch);
  }

  Map<String, dynamic> toJson() {
    return {'memory_match': memoryMatch?.toJson()};
  }
}

class UserGameInfo {
  final String key;
  final String name;
  final int rewardAmount;
  final int cooldownDays;
  final String? lastPlayedAt;
  final String? nextPlayableAt;
  final bool isPlayable;

  const UserGameInfo({
    required this.key,
    required this.name,
    required this.rewardAmount,
    required this.cooldownDays,
    required this.lastPlayedAt,
    required this.nextPlayableAt,
    required this.isPlayable,
  });

  factory UserGameInfo.fromJson(Map<String, dynamic> json) {
    return UserGameInfo(
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      rewardAmount: json['reward_amount'] as int? ?? 0,
      cooldownDays: json['cooldown_days'] as int? ?? 0,
      lastPlayedAt: json['last_played_at'] as String?,
      nextPlayableAt: json['next_playable_at'] as String?,
      isPlayable: json['is_playable'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
      'reward_amount': rewardAmount,
      'cooldown_days': cooldownDays,
      'last_played_at': lastPlayedAt,
      'next_playable_at': nextPlayableAt,
      'is_playable': isPlayable,
    };
  }
}

class AuthResponse {
  final bool success;
  final String? message;
  final String token;
  final User user;

  AuthResponse({
    required this.success,
    this.message,
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      token: json['token'] as String,
      user: User.fromJson(json['user']),
    );
  }
}

class RegisterRequest {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}

class UpdatePasswordRequest {
  final String currentPassword;
  final String password;
  final String passwordConfirmation;

  UpdatePasswordRequest({
    required this.currentPassword,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'current_password': currentPassword,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}

class UpdateProfileRequest {
  final String name;
  final String email;
  final String phone;
  final String? birthDate;

  UpdateProfileRequest({
    required this.name,
    required this.email,
    required this.phone,
    this.birthDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      if (birthDate != null) 'birth_date': birthDate,
    };
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
