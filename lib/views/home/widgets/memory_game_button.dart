import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/responsive/size_tokens.dart';

class MemoryGameButton extends StatefulWidget {
  final bool isPlayable;
  final DateTime? nextPlayableAt;
  final VoidCallback? onTap;

  const MemoryGameButton({
    super.key,
    required this.isPlayable,
    this.nextPlayableAt,
    this.onTap,
  });

  @override
  State<MemoryGameButton> createState() => _MemoryGameButtonState();
}

class _MemoryGameButtonState extends State<MemoryGameButton> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    if (!widget.isPlayable) {
      // Rebuild every second to keep countdown fresh
      _refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void didUpdateWidget(MemoryGameButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlayable && _refreshTimer != null) {
      _refreshTimer?.cancel();
      _refreshTimer = null;
    } else if (!widget.isPlayable && _refreshTimer == null) {
      _refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  String _buildCountdown() {
    if (widget.nextPlayableAt == null) return '';
    final remaining = widget.nextPlayableAt!.difference(DateTime.now());
    if (remaining.isNegative) return '';
    final days = remaining.inDays;
    final hours = remaining.inHours % 24;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;

    if (days >= 2) return '$days gün';
    if (days == 1) return '${days}g ${hours}sa';
    if (hours >= 1) return '${hours}sa ${minutes}dk';
    if (minutes >= 1) return '${minutes}dk';
    return '${seconds}sn';
  }

  @override
  Widget build(BuildContext context) {
    final countdown = _buildCountdown();

    return GestureDetector(
      onTap: widget.isPlayable ? widget.onTap : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: SizeTokens.p48,
            height: SizeTokens.p48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: widget.isPlayable
                  ? const LinearGradient(
                      colors: [Color(0xFFFFB300), Color(0xFFF4511E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: widget.isPlayable
                  ? null
                  : Colors.black.withOpacity(0.25),
              boxShadow: widget.isPlayable
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFFB300).withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.style_rounded,
                  color: widget.isPlayable
                      ? Colors.white
                      : Colors.white.withOpacity(0.45),
                  size: SizeTokens.p24,
                ),
              ],
            ),
          ),
          SizedBox(height: SizeTokens.p4),
          widget.isPlayable
              ? _buildOynaKazanLabel()
              : _buildCountdownLabel(countdown),
        ],
      ),
    );
  }

  Widget _buildOynaKazanLabel() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeTokens.p6,
        vertical: SizeTokens.p2,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFB300),
        borderRadius: BorderRadius.circular(SizeTokens.r8),
      ),
      child: Text(
        'Oyna-Kazan',
        style: TextStyle(
          color: Colors.white,
          fontSize: SizeTokens.f10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCountdownLabel(String countdown) {
    return Text(
      countdown.isNotEmpty ? countdown : '...',
      style: TextStyle(
        color: Colors.white.withOpacity(0.55),
        fontSize: SizeTokens.f10,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
