import 'user_model.dart';

class GameResultRequest {
  final bool won;

  const GameResultRequest({required this.won});

  Map<String, dynamic> toJson() {
    return {'won': won};
  }
}

class GameResultModel {
  final bool success;
  final String result;
  final String message;
  final int earned;
  final int balance;
  final UserGameInfo game;

  const GameResultModel({
    required this.success,
    required this.result,
    required this.message,
    required this.earned,
    required this.balance,
    required this.game,
  });

  factory GameResultModel.fromJson(Map<String, dynamic> json) {
    return GameResultModel(
      success: json['success'] as bool? ?? false,
      result: json['result'] as String? ?? '',
      message: json['message'] as String? ?? '',
      earned: json['earned'] as int? ?? 0,
      balance: json['balance'] as int? ?? 0,
      game: UserGameInfo.fromJson(json['game'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'result': result,
      'message': message,
      'earned': earned,
      'balance': balance,
      'game': game.toJson(),
    };
  }
}
