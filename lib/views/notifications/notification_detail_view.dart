import 'package:flutter/material.dart';
import '../../models/notification_model.dart';
import '../../core/responsive/size_tokens.dart';
import '../../app/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationDetailView extends StatelessWidget {
  final NotificationItem item;

  const NotificationDetailView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Bildirim Detayı'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(context),
            Padding(
              padding: EdgeInsets.all(SizeTokens.p24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: SizeTokens.p32),
                  _buildContentSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (item.imageUrl == null) {
      return Container(
        width: double.infinity,
        height: SizeTokens.p120,
        decoration: const BoxDecoration(color: AppColors.darkBlue),
        child: Center(
          child: SvgPicture.asset(
            'assets/dry_fix.svg',
            width: SizeTokens.p100,
            height: SizeTokens.p280,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: SizeTokens.p240,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Image.network(
            item.imageUrl!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: AppColors.gray.withOpacity(0.1),
              child: const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.gray,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: SizeTokens.f24,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        SizedBox(height: SizeTokens.p12),
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: SizeTokens.f16,
              color: AppColors.gray,
            ),
            SizedBox(width: SizeTokens.p6),
            Text(
              _formatDate(item.createdAt),
              style: TextStyle(
                color: AppColors.gray,
                fontSize: SizeTokens.f13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bildirim İçeriği",
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: SizeTokens.f14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: SizeTokens.p12),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(SizeTokens.p20),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(SizeTokens.r12),
            border: Border.all(color: AppColors.gray.withOpacity(0.1)),
          ),
          child: Text(
            item.body,
            style: TextStyle(
              color: AppColors.darkBlue.withOpacity(0.8),
              fontSize: SizeTokens.f16,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return '${date.day}.${date.month}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }
}
