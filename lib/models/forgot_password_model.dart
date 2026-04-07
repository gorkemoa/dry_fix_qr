class ForgotPasswordResponse {
  final bool success;
  final String message;
  final int? expiresInMinutes;
  final String? emailHint;
  final String? resetCode;

  ForgotPasswordResponse({
    required this.success,
    required this.message,
    this.expiresInMinutes,
    this.emailHint,
    this.resetCode,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      expiresInMinutes: json['expires_in_minutes'] as int?,
      emailHint: json['email_hint'] as String?,
      resetCode: json['reset_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'expires_in_minutes': expiresInMinutes,
        'email_hint': emailHint,
        'reset_code': resetCode,
      };
}

class ResetPasswordRequest {
  final String? email;
  final String? phone;
  final String code;
  final String password;
  final String passwordConfirmation;

  ResetPasswordRequest({
    this.email,
    this.phone,
    required this.code,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'code': code,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
    if (email != null) map['email'] = email;
    if (phone != null) map['phone'] = phone;
    return map;
  }
}

class ResetPasswordResponse {
  final bool success;
  final String message;

  ResetPasswordResponse({
    required this.success,
    required this.message,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
      };
}
