import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../core/network/api_result.dart';
import '../core/utils/logger.dart';
import '../models/game_result_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/game_service.dart';

enum GameState { idle, playing, success, failed }

class GameCard {
  final int id;
  final int pairId;
  final IconData icon;
  final Color color;
  bool isFlipped;
  bool isMatched;

  GameCard({
    required this.id,
    required this.pairId,
    required this.icon,
    required this.color,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

class _CardTemplate {
  final IconData icon;
  final Color color;
  const _CardTemplate(this.icon, this.color);
}

class GameViewModel extends ChangeNotifier {
  static const int _totalSeconds = 60;

  static const List<_CardTemplate> _cardTemplates = [
    _CardTemplate(Icons.format_paint_rounded, Color(0xFFE53935)),
    _CardTemplate(Icons.brush_rounded, Color(0xFFF4511E)),
    _CardTemplate(Icons.home_rounded, Color(0xFF43A047)),
    _CardTemplate(Icons.star_rounded, Color(0xFFFFB300)),
    _CardTemplate(Icons.favorite_rounded, Color(0xFFE91E63)),
    _CardTemplate(Icons.auto_awesome_rounded, Color(0xFF8E24AA)),
    _CardTemplate(Icons.emoji_events_rounded, Color(0xFF00ACC1)),
    _CardTemplate(Icons.bolt_rounded, Color(0xFF3949AB)),
  ];

  // State
  bool isLoading = false;
  String? errorMessage;
  GameState gameState = GameState.idle;
  bool isPlayable = false;
  DateTime? nextPlayableAt;
  UserGameInfo? currentGameInfo;
  int rewardAmount = 0;
  int cooldownDays = 0;
  int currentBalance = 0;
  int? lastEarnedAmount;
  List<GameCard> cards = [];
  int timeLeft = _totalSeconds;
  int? _firstFlippedIndex;
  bool _isChecking = false;
  bool _isInitializing = false;
  bool? _submittedOutcome;

  Timer? _gameTimer;
  Timer? _availabilityTimer;
  Future<void>? _submitResultFuture;

  final AuthService _authService;
  final GameService _gameService;

  GameViewModel(this._authService, this._gameService);

  int get displayEarnedAmount => lastEarnedAmount ?? rewardAmount;

  Future<void> init() async {
    if (_isInitializing) {
      return;
    }

    _isInitializing = true;
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _authService.fetchMe();

    if (result is Success<MeResponse>) {
      final user = result.data.user;
      currentBalance = user.tokenBalance;
      _applyGameInfo(user.games?.memoryMatch);
    } else if (result is Failure<MeResponse>) {
      errorMessage = result.errorMessage;
      Logger.error(
        'GameViewModel.init failed',
        errorMessage ?? 'Unknown error',
      );
    }

    isLoading = false;
    _isInitializing = false;
    notifyListeners();
  }

  void _applyGameInfo(UserGameInfo? gameInfo) {
    currentGameInfo = gameInfo;
    rewardAmount = gameInfo?.rewardAmount ?? 0;
    cooldownDays = gameInfo?.cooldownDays ?? 0;
    isPlayable = gameInfo?.isPlayable ?? false;
    nextPlayableAt = gameInfo?.nextPlayableAt != null
        ? DateTime.tryParse(gameInfo!.nextPlayableAt!)
        : null;
    _setupAvailabilityTimer();
    Logger.debug(
      'GameViewModel: isPlayable=$isPlayable, nextPlayableAt=$nextPlayableAt, rewardAmount=$rewardAmount',
    );
  }

  void _setupAvailabilityTimer() {
    _availabilityTimer?.cancel();
    if (isPlayable || nextPlayableAt == null) {
      return;
    }

    _availabilityTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final availableAt = nextPlayableAt;
      if (availableAt == null) {
        timer.cancel();
        return;
      }

      if (!DateTime.now().isBefore(availableAt)) {
        isPlayable = true;
        nextPlayableAt = null;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  void startGame() {
    if (isLoading || !isPlayable) {
      return;
    }

    _buildCards();
    timeLeft = _totalSeconds;
    _firstFlippedIndex = null;
    _isChecking = false;
    lastEarnedAmount = null;
    _submittedOutcome = null;
    _submitResultFuture = null;
    gameState = GameState.playing;
    notifyListeners();
    _startTimer();
  }

  void _buildCards() {
    final rng = Random();
    final templates = List<_CardTemplate>.from(_cardTemplates)..shuffle(rng);
    final selected = templates.take(8).toList();

    final rawCards = <GameCard>[];
    for (int i = 0; i < selected.length; i++) {
      final t = selected[i];
      rawCards.add(
        GameCard(id: i * 2, pairId: i, icon: t.icon, color: t.color),
      );
      rawCards.add(
        GameCard(id: i * 2 + 1, pairId: i, icon: t.icon, color: t.color),
      );
    }
    rawCards.shuffle(rng);
    cards = rawCards;
  }

  void _startTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      timeLeft--;
      if (timeLeft <= 0) {
        timeLeft = 0;
        _onGameFailed();
      } else {
        notifyListeners();
      }
    });
  }

  void flipCard(int index) {
    if (gameState != GameState.playing) return;
    if (_isChecking) return;
    final card = cards[index];
    if (card.isFlipped || card.isMatched) return;

    card.isFlipped = true;
    notifyListeners();

    if (_firstFlippedIndex == null) {
      _firstFlippedIndex = index;
    } else {
      _isChecking = true;
      _checkPair(index);
    }
  }

  Future<void> _checkPair(int secondIndex) async {
    final firstIndex = _firstFlippedIndex!;
    final first = cards[firstIndex];
    final second = cards[secondIndex];

    await Future.delayed(const Duration(milliseconds: 700));

    if (first.pairId == second.pairId) {
      first.isMatched = true;
      second.isMatched = true;
      Logger.debug('GameViewModel: pair matched pairId=${first.pairId}');

      final allMatched = cards.every((c) => c.isMatched);
      if (allMatched) {
        _firstFlippedIndex = null;
        _isChecking = false;
        _onGameComplete();
        return;
      }
    } else {
      first.isFlipped = false;
      second.isFlipped = false;
    }

    _firstFlippedIndex = null;
    _isChecking = false;
    notifyListeners();
  }

  void _onGameComplete() {
    _gameTimer?.cancel();
    gameState = GameState.success;
    Logger.info(
      'GameViewModel: Game completed in ${_totalSeconds - timeLeft}s',
    );
    notifyListeners();
    unawaited(submitResultIfNeeded(true));
  }

  void _onGameFailed() {
    _gameTimer?.cancel();
    gameState = GameState.failed;
    Logger.info('GameViewModel: Game failed');
    notifyListeners();
    unawaited(submitResultIfNeeded(false));
  }

  Future<void> submitResultIfNeeded(bool won) {
    if (_submittedOutcome != null) {
      return _submitResultFuture ?? Future.value();
    }

    _submittedOutcome = won;
    _submitResultFuture = _submitGameResult(won);
    return _submitResultFuture!;
  }

  Future<void> _submitGameResult(bool won) async {
    final result = await _gameService.finishMemoryMatch(
      GameResultRequest(won: won),
    );

    if (result is Success<GameResultModel>) {
      final data = result.data;
      lastEarnedAmount = data.earned;
      currentBalance = data.balance;
      _applyGameInfo(data.game);
      errorMessage = null;
      Logger.info(
        'GameViewModel: Memory Match result submitted as ${data.result}',
      );
    } else if (result is Failure<GameResultModel>) {
      errorMessage = result.errorMessage;
      Logger.error(
        'GameViewModel: Memory Match result submit failed',
        errorMessage ?? 'Unknown error',
      );
    }

    notifyListeners();
  }

  void resetToIdle() {
    _gameTimer?.cancel();
    cards = [];
    timeLeft = _totalSeconds;
    _firstFlippedIndex = null;
    _isChecking = false;
    _submittedOutcome = null;
    _submitResultFuture = null;
    gameState = GameState.idle;
    // notifyListeners() intentionally omitted — called only from dispose()
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _availabilityTimer?.cancel();
    super.dispose();
  }
}
