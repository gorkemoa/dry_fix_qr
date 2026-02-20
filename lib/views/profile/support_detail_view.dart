import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../models/support_message_model.dart';
import '../../core/responsive/size_tokens.dart';

class SupportDetailView extends StatelessWidget {
  final SupportMessage message;

  const SupportDetailView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Talep Detayı",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeTokens.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(SizeTokens.p20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(SizeTokens.r16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "TALEP #${message.id}",
                        style: TextStyle(
                          color: AppColors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeTokens.f12,
                        ),
                      ),
                      Text(
                        message.createdAt,
                        style: TextStyle(
                          color: AppColors.gray,
                          fontSize: SizeTokens.f12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeTokens.p12),
                  const Divider(),
                  SizedBox(height: SizeTokens.p12),
                  Text(
                    message.title,
                    style: TextStyle(
                      color: AppColors.darkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeTokens.f18,
                    ),
                  ),
                  SizedBox(height: SizeTokens.p16),
                  Text(
                    message.message,
                    style: TextStyle(
                      color: AppColors.darkBlue.withOpacity(0.8),
                      fontSize: SizeTokens.f14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
