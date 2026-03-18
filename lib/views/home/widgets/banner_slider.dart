import 'dart:async';
import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';
import '../../../models/banner_model.dart';

class BannerSlider extends StatefulWidget {
  final List<BannerModel> banners;
  final Future<void> Function(BannerModel) onBannerTap;

  const BannerSlider({
    super.key,
    required this.banners,
    required this.onBannerTap,
  });

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    if (widget.banners.length <= 1) return;
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      final nextPage = (_currentPage + 1) % widget.banners.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: SizeTokens.p145,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.banners.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeTokens.p24),
                child: _BannerCard(
                  banner: widget.banners[index],
                  onTap: widget.onBannerTap,
                ),
              );
            },
          ),
        ),
        if (widget.banners.length > 1) ...[
          SizedBox(height: SizeTokens.p12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.banners.length, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: SizeTokens.p4),
                width: isActive ? SizeTokens.p20 : SizeTokens.p8,
                height: SizeTokens.p8,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.blue
                      // ignore: deprecated_member_use
                      : AppColors.gray.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(SizeTokens.r4),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

class _BannerCard extends StatefulWidget {
  final BannerModel banner;
  final Future<void> Function(BannerModel) onTap;

  const _BannerCard({required this.banner, required this.onTap});

  @override
  State<_BannerCard> createState() => _BannerCardState();
}

class _BannerCardState extends State<_BannerCard> {
  bool _isLoading = false;

  String _formatDateShort(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      const months = [
        'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
        'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }


  @override
  Widget build(BuildContext context) {
    final banner = widget.banner;

    return GestureDetector(
      onTap: _isLoading
          ? null
          : () async {
              setState(() => _isLoading = true);
              await widget.onTap(banner);
              if (mounted) setState(() => _isLoading = false);
            },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(SizeTokens.r20),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SizeTokens.r20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Image.network(
                banner.image,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppColors.titleLight,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.blue,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.titleLight,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.gray,
                      size: SizeTokens.p40,
                    ),
                  );
                },
              ),

              // Dark gradient overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        // ignore: deprecated_member_use
                        Colors.black.withOpacity(0.72),
                      ],
                      stops: const [0.30, 1.0],
                    ),
                  ),
                ),
              ),

              // Top-right: date range chip
              Positioned(
                top: SizeTokens.p10,
                right: SizeTokens.p10,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeTokens.p10,
                    vertical: SizeTokens.p4,
                  ),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(SizeTokens.r20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: SizeTokens.p10,
                        // ignore: deprecated_member_use
                        color: AppColors.white.withOpacity(0.85),
                      ),
                      SizedBox(width: SizeTokens.p4),
                      Text(
                        '${_formatDateShort(banner.startsAt)} – ${_formatDateShort(banner.endsAt)}',
                        style: TextStyle(
                          fontSize: SizeTokens.f10,
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom: title + product name + token_price badge
              Positioned(
                left: SizeTokens.p16,
                right: SizeTokens.p16,
                bottom: SizeTokens.p12,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            banner.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: SizeTokens.f16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          if (banner.product != null) ...[
                            SizedBox(height: SizeTokens.p2),
                            Text(
                              banner.product!.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: SizeTokens.f11,
                                // ignore: deprecated_member_use
                                color: AppColors.white.withOpacity(0.85),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  
                  ],
                ),
              ),

              // Tap loading overlay
              if (_isLoading)
                Container(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.35),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2.5,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
