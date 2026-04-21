import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home_view_model.dart';
import '../../viewmodels/game_view_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../core/utils/date_utils.dart';
import '../../app/app_theme.dart';
import 'widgets/memory_game_result_overlay.dart';

class MemoryGameView extends StatefulWidget {
  const MemoryGameView({super.key});

  @override
  State<MemoryGameView> createState() => _MemoryGameViewState();
}

class _MemoryGameViewState extends State<MemoryGameView>
    with TickerProviderStateMixin {
  GameViewModel? _vm;
  bool _allowPop = false;

  // ── Flip animations ──────────────────────────────────────────────────────────
  final Map<int, AnimationController> _flipControllers = {};
  final Map<int, Animation<double>> _flipAnimations = {};

  // ── Card position keys (for fly-to-box) ──────────────────────────────────────
  final Map<int, GlobalKey> _cardKeys = {};

  // ── Box bounce ────────────────────────────────────────────────────────────────
  final GlobalKey _boxKey = GlobalKey();
  late AnimationController _boxBounceCtrl;
  late Animation<double> _boxBounceAnim;

  // ── Match tracking ────────────────────────────────────────────────────────────
  Set<int> _matchedIds = {};

  // ── Confetti ──────────────────────────────────────────────────────────────────
  late ConfettiController _confettiCtrl;

  @override
  void initState() {
    super.initState();
    _confettiCtrl = ConfettiController(duration: const Duration(seconds: 4));
    _boxBounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _boxBounceAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.22), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.22, end: 0.90), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.90, end: 1.07), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.07, end: 1.0), weight: 25),
    ]).animate(_boxBounceCtrl);
    _vm = context.read<GameViewModel>();
    _vm!.addListener(_onVmChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _vm!.init();
      if (mounted) {
        _vm!.startGame();
      }
    });
  }

  @override
  void dispose() {
    _vm!.removeListener(_onVmChanged);
    _vm!.resetToIdle();
    for (final ctrl in _flipControllers.values) {
      ctrl.dispose();
    }
    _boxBounceCtrl.dispose();
    _confettiCtrl.dispose();
    super.dispose();
  }

  void _syncControllers() {
    final vm = _vm!;
    final currentIds = {for (final c in vm.cards) c.id};

    final toRemove = _flipControllers.keys
        .where((id) => !currentIds.contains(id))
        .toList();
    for (final id in toRemove) {
      _flipControllers[id]!.dispose();
      _flipControllers.remove(id);
      _flipAnimations.remove(id);
      _cardKeys.remove(id);
    }

    for (final card in vm.cards) {
      if (!_flipControllers.containsKey(card.id)) {
        final ctrl = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 420),
        );
        _flipControllers[card.id] = ctrl;
        _flipAnimations[card.id] = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeInOut));
      }
      _cardKeys.putIfAbsent(card.id, () => GlobalKey());
    }
  }

  void _onVmChanged() {
    if (!mounted) return;
    _syncControllers();

    // Detect newly matched pair
    final currentMatched = _vm!.cards
        .where((c) => c.isMatched)
        .map((c) => c.id)
        .toSet();
    final newlyMatched = currentMatched.difference(_matchedIds);
    if (newlyMatched.length == 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _triggerFlyToBox(newlyMatched.toList());
      });
    }
    _matchedIds = currentMatched;

    // Trigger confetti on win
    if (_vm!.gameState == GameState.success &&
        _confettiCtrl.state != ConfettiControllerState.playing) {
      _confettiCtrl.play();
    }

    for (final card in _vm!.cards) {
      final ctrl = _flipControllers[card.id];
      if (ctrl == null) continue;
      final shouldBeOpen = card.isFlipped || card.isMatched;
      if (shouldBeOpen &&
          ctrl.status != AnimationStatus.completed &&
          ctrl.status != AnimationStatus.forward) {
        ctrl.forward();
      } else if (!shouldBeOpen &&
          ctrl.status != AnimationStatus.dismissed &&
          ctrl.status != AnimationStatus.reverse) {
        ctrl.reverse();
      }
    }
  }

  // ── Fly-to-box animation ─────────────────────────────────────────────────────
  void _triggerFlyToBox(List<int> ids) {
    final boxRender = _boxKey.currentContext?.findRenderObject() as RenderBox?;
    if (boxRender == null) return;
    final boxPos = boxRender.localToGlobal(Offset.zero);
    final boxSize = boxRender.size;
    final target = Offset(
      boxPos.dx + boxSize.width / 2,
      boxPos.dy + boxSize.height * 0.2,
    );

    int launched = 0;
    for (final id in ids) {
      final render =
          _cardKeys[id]?.currentContext?.findRenderObject() as RenderBox?;
      if (render == null) continue;
      final card = _vm!.cards.firstWhere((c) => c.id == id);
      _spawnFlyingCard(
        render.localToGlobal(Offset.zero),
        render.size,
        target,
        card,
      );
      launched++;
    }

    if (launched > 0) {
      Future.delayed(const Duration(milliseconds: 460), () {
        if (mounted) _boxBounceCtrl.forward(from: 0);
      });
    }
  }

  void _spawnFlyingCard(
    Offset start,
    Size cardSize,
    Offset target,
    GameCard card,
  ) {
    final ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _FlyingCardOverlay(
        start: start,
        target: target,
        cardSize: cardSize,
        icon: card.icon,
        color: card.color,
        animation: ctrl,
      ),
    );
    Overlay.of(context).insert(entry);
    ctrl.forward().then((_) {
      entry.remove();
      ctrl.dispose();
    });
  }

  Future<void> _closeView() async {
    if (_allowPop) {
      return;
    }

    await _vm?.submitResultIfNeeded(false);
    _syncHomeState();
    if (mounted) {
      setState(() {
        _allowPop = true;
      });
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleExitTap() async {
    if (!_shouldConfirmExit()) {
      await _closeView();
      return;
    }

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeTokens.r20),
          ),
          title: Text(
            'Oyundan çıkılsın mı?',
            style: TextStyle(
              fontSize: SizeTokens.f18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
            ),
          ),
          content: Text(
            'Çıkarsan oyun tamamlanmadı olarak kaydedilir.',
            style: TextStyle(
              fontSize: SizeTokens.f14,
              color: AppColors.gray,
              height: 1.5,
            ),
          ),
          actionsPadding: EdgeInsets.fromLTRB(
            SizeTokens.p16,
            0,
            SizeTokens.p16,
            SizeTokens.p16,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'Devam Et',
                style: TextStyle(
                  color: AppColors.gray,
                  fontSize: SizeTokens.f14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: SizeTokens.p16,
                  vertical: SizeTokens.p10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeTokens.r12),
                ),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                'Oyundan Çık',
                style: TextStyle(
                  fontSize: SizeTokens.f14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldExit == true && mounted) {
      await _closeView();
    }
  }

  bool _shouldConfirmExit() {
    final state = _vm?.gameState;
    return state == GameState.playing || state == GameState.idle;
  }

  void _syncHomeState() {
    final vm = _vm;
    if (vm == null || !mounted) {
      return;
    }

    final homeViewModel = context.read<HomeViewModel>();
    if (vm.currentGameInfo != null) {
      homeViewModel.syncGameStatus(
        balance: vm.currentBalance,
        game: vm.currentGameInfo!,
      );
      return;
    }

    homeViewModel.refresh();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final vm = context.watch<GameViewModel>();

    return PopScope(
      canPop: _allowPop,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        await _handleExitTap();
      },
      child: Scaffold(
        backgroundColor: AppColors.blue,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(vm),
                  _buildSignboard(vm),
                  Expanded(child: _buildLegAndBoxArea(vm)),
                ],
              ),
              if (vm.gameState == GameState.success) _buildSuccessOverlay(vm),
              if (vm.gameState == GameState.failed) _buildFailedOverlay(vm),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiCtrl,
                  blastDirectionality: BlastDirectionality.explosive,
                  particleDrag: 0.05,
                  emissionFrequency: 0.07,
                  numberOfParticles: 20,
                  gravity: 0.08,
                  colors: const [
                    AppColors.darkBlue,
                    AppColors.blue,
                    AppColors.titleLight,
                    Colors.white,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(GameViewModel vm) {
    final isPlaying = vm.gameState == GameState.playing;
    final isWarning = vm.timeLeft <= 3 && isPlaying;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        SizeTokens.p16,
        SizeTokens.p12,
        SizeTokens.p16,
        SizeTokens.p8,
      ),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: _handleExitTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: SizeTokens.p12,
                vertical: SizeTokens.p8,
              ),
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeTokens.r20),
              ),
            ),
            icon: Icon(Icons.close_rounded, size: SizeTokens.p18),
            label: Text(
              'Oyundan Çık',
              style: TextStyle(
                fontSize: SizeTokens.f12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: SizeTokens.p8),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeTokens.p4),
              child: SizedBox(
                height: SizeTokens.p24,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Eşleştir & Kazan',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeTokens.f16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: SizeTokens.p8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(
              horizontal: SizeTokens.p14,
              vertical: SizeTokens.p8,
            ),
            decoration: BoxDecoration(
              color: isWarning
                  ? const Color(0xFFE53935).withValues(alpha: 0.9)
                  // ignore: deprecated_member_use
                  : Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(SizeTokens.r20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: Colors.white,
                  size: SizeTokens.p18,
                ),
                SizedBox(width: SizeTokens.p6),
                Text(
                  '${vm.timeLeft} SN',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Signboard (tabela) layout ──────────────────────────────────────────────
  Widget _buildSignboard(GameViewModel vm) {
    if (vm.cards.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    const frameColor = Color(0xFFBE7D22);
    const frameDark = Color(0xFF7A4E10);
    const innerBg = Color(0xFF082038);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeTokens.p12),
      child: Container(
        decoration: BoxDecoration(
          color: frameColor,
          borderRadius: BorderRadius.circular(SizeTokens.r16),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.45),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
            BoxShadow(
              // ignore: deprecated_member_use
              color: frameDark.withOpacity(0.6),
              blurRadius: 0,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Top bar with rivets
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
              child: Row(
                children: [
                  _buildRivet(),
                  const Spacer(),
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFFFFF3C4),
                    size: 13,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'HAFIZA OYUNU',
                    style: TextStyle(
                      color: Color(0xFFFFF3C4),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.8,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFFFFF3C4),
                    size: 13,
                  ),
                  const Spacer(),
                  _buildRivet(),
                ],
              ),
            ),
            // ── Inner grid panel
            Container(
              margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              padding: EdgeInsets.all(SizeTokens.p8),
              decoration: BoxDecoration(
                color: innerBg,
                borderRadius: BorderRadius.circular(SizeTokens.r10),
                border: Border.all(color: frameDark, width: 2),
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: SizeTokens.p8,
                  crossAxisSpacing: SizeTokens.p8,
                  childAspectRatio: 0.85,
                ),
                itemCount: vm.cards.length,
                itemBuilder: (context, index) {
                  final card = vm.cards[index];
                  final animation = _flipAnimations[card.id];
                  if (animation == null) return const SizedBox.shrink();
                  return _buildFlipTile(card, index, animation);
                },
              ),
            ),
            // ── Bottom bar with rivets (leg attachment)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
              child: Row(
                children: [_buildRivet(), const Spacer(), _buildRivet()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRivet() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: const Color(0xFF7A4E10),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE8A83A), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x44000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }

  Widget _buildFlipTile(GameCard card, int index, Animation<double> animation) {
    return KeyedSubtree(
      key: _cardKeys[card.id],
      child: GestureDetector(
        onTap: () => _vm!.flipCard(index),
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            final t = animation.value;
            final isFrontVisible = t >= 0.5;
            // Back: 0→π/2 (disappears), Front: -π/2→0 (appears)
            final angle = isFrontVisible ? (t - 1.0) * pi : t * pi;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: isFrontVisible ? _buildCardFront(card) : _buildCardBack(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardFront(GameCard card) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r12),
        border: card.isMatched
            ? Border.all(color: card.color, width: 2.5)
            : null,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: card.color.withOpacity(0.35),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(card.icon, color: card.color, size: SizeTokens.p32),
          if (card.isMatched) ...[
            SizedBox(height: SizeTokens.p4),
            Icon(
              Icons.check_circle_rounded,
              color: card.color,
              size: SizeTokens.p14,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(SizeTokens.r12),
      child: SvgPicture.asset('assets/cards.svg', fit: BoxFit.contain),
    );
  }

  // ── Leg + box area below the signboard ─────────────────────────────────────
  Widget _buildLegAndBoxArea(GameViewModel vm) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeTokens.p12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // ── Left leg
              Center(child: _buildBoxArea(vm)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBoxArea(GameViewModel vm) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: _boxBounceAnim,
          child: Image.asset(
            'assets/oyunkutusu.png',
            key: _boxKey,
            height: 235,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  String? _getNextPlayableText(GameViewModel vm) {
    final nextPlayableAt = vm.nextPlayableAt;
    if (nextPlayableAt == null) {
      return null;
    }

    return DateFormatter.toTurkish(nextPlayableAt.toIso8601String());
  }

  Widget _buildNextPlayableInfo(
    GameViewModel vm, {
    required Color accentColor,
  }) {
    final nextPlayableText = _getNextPlayableText(vm);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeTokens.p12),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(SizeTokens.r12),
        border: Border.all(color: accentColor.withValues(alpha: 0.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: SizeTokens.p32,
            height: SizeTokens.p32,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.schedule_rounded,
              color: accentColor,
              size: SizeTokens.p16,
            ),
          ),
          SizedBox(width: SizeTokens.p10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bir sonraki oyun hakkın',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeTokens.f12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: SizeTokens.p2),
                Text(
                  nextPlayableText ??
                      'Oyun sonucu kaydediliyor, süre hesaplanıyor...',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: SizeTokens.f11,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultPrimaryButton({
    required String label,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeTokens.r16),
          ),
          padding: EdgeInsets.symmetric(vertical: SizeTokens.p12),
          elevation: 4,
          shadowColor: backgroundColor.withValues(alpha: 0.35),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: SizeTokens.f14,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessOverlay(GameViewModel vm) {
    const accentColor = AppColors.blue;
    const highlightColor = AppColors.titleLight;

    return MemoryGameResultOverlay(
      overlayGradientColors: [
        const Color(0xFF001A3D).withValues(alpha: 0.92),
        const Color(0xFF003366).withValues(alpha: 0.96),
      ],
      mascotAsset: 'assets/Adsız tasarım (10).png',
      cardGradientColors: const [Color(0xFF0A2A5E), Color(0xFF08172F)],
      borderColor: accentColor,
      shadowColor: accentColor.withValues(alpha: 0.2),
      statusIcon: Icons.workspace_premium_rounded,
      statusColor: accentColor,
      title: 'Tebrikler!',
      titleColor: highlightColor,
      titleLetterSpacing: 1.2,
      showTitleDivider: true,
      dividerColor: accentColor,
      description: Text(
        'Tüm kartları eşleştirdin ve ödülünü kazandın.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.80),
          fontSize: SizeTokens.f12,
          height: 1.4,
        ),
      ),
      infoCard: MemoryGameResultInfoCard(
        accentColor: highlightColor,
        child: Row(
          children: [
            Icon(
              Icons.monetization_on_rounded,
              color: highlightColor,
              size: SizeTokens.p20,
            ),
            SizedBox(width: SizeTokens.p8),
            Expanded(
              child: MemoryGameDpInlineText(
                amount: vm.displayEarnedAmount,
                suffix: ' kazandınız!',
                style: TextStyle(
                  color: highlightColor,
                  fontSize: SizeTokens.f12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomChildren: [
        SizedBox(height: SizeTokens.p12),
        _buildNextPlayableInfo(vm, accentColor: accentColor),
        SizedBox(height: SizeTokens.p16),
        _buildResultPrimaryButton(
          label: 'Ana Sayfaya Dön',
          onPressed: _closeView,
          backgroundColor: highlightColor,
          foregroundColor: AppColors.darkBlue,
        ),
      ],
    );
  }

  Widget _buildFailedOverlay(GameViewModel vm) {
    const accentColor = AppColors.blue;
    const statusColor = Color(0xFFFF7A6B);

    return MemoryGameResultOverlay(
      overlayGradientColors: [
        AppColors.darkBlue.withValues(alpha: 0.92),
        const Color(0xFF062C4F).withValues(alpha: 0.96),
      ],
      mascotAsset: 'assets/Adsız tasarım.png',
      cardGradientColors: const [Color(0xFF082038), Color(0xFF0B2C4B)],
      borderColor: accentColor,
      shadowColor: AppColors.darkBlue.withValues(alpha: 0.22),
      statusIcon: Icons.sentiment_dissatisfied_rounded,
      statusColor: statusColor,
      title: 'Bu Kez Olmadı',
      titleColor: Colors.white,
      description: MemoryGameDpInlineText(
        prefix: 'Kartların hepsini tamamlayamadın ama bir sonraki oyunda ',
        amount: vm.rewardAmount,
        suffix: ' kazanabilirsin.',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.78),
          fontSize: SizeTokens.f12,
          height: 1.45,
        ),
        textAlign: TextAlign.center,
      ),
      infoCard: MemoryGameResultInfoCard(
        accentColor: accentColor,
        borderAlpha: 0.18,
        child: Row(
          children: [
            Icon(
              Icons.volunteer_activism_rounded,
              color: accentColor,
              size: SizeTokens.p20,
            ),
            SizedBox(width: SizeTokens.p8),
            Expanded(
              child: MemoryGameDpInlineText(
                amount: vm.rewardAmount,
                suffix: ' kazanabilirdin.',
                style: TextStyle(
                  color: AppColors.titleLight,
                  fontSize: SizeTokens.f12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomChildren: [
        SizedBox(height: SizeTokens.p12),
        _buildNextPlayableInfo(vm, accentColor: accentColor),
        SizedBox(height: SizeTokens.p16),
        _buildResultPrimaryButton(
          label: 'Ana Sayfaya Dön',
          onPressed: _closeView,
          backgroundColor: const Color(0xFF0094BF),
          foregroundColor: Colors.white,
        ),
      ],
    );
  }
}

// ── Flying card overlay ───────────────────────────────────────────────────────
class _FlyingCardOverlay extends StatelessWidget {
  final Offset start;
  final Offset target;
  final Size cardSize;
  final IconData icon;
  final Color color;
  final AnimationController animation;

  const _FlyingCardOverlay({
    required this.start,
    required this.target,
    required this.cardSize,
    required this.icon,
    required this.color,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInCubic,
    );
    return AnimatedBuilder(
      animation: curved,
      builder: (context, _) {
        final t = curved.value;
        final x = start.dx + (target.dx - start.dx) * t;
        final y = start.dy + (target.dy - start.dy) * t;
        final scale = (1.0 - t * 0.88).clamp(0.0, 1.0);
        final opacity = (1.0 - t * 0.65).clamp(0.0, 1.0);
        return Positioned(
          left: x,
          top: y,
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: cardSize.width,
                height: cardSize.height,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: color.withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
