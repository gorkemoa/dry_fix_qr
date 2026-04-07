import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_config.dart';
import '../../../core/responsive/size_tokens.dart';
import '../../../core/widgets/dp_symbol.dart';
import '../../../viewmodels/welcome_bonus_view_model.dart';
import '../../../viewmodels/home_view_model.dart';

class WelcomeBonusDialog extends StatelessWidget {
  const WelcomeBonusDialog({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final viewModel = context.watch<WelcomeBonusViewModel>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: SizeTokens.p24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(SizeTokens.r24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dark blue header with mascot
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.darkBlue,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(SizeTokens.r24),
                ),
              ),
              padding: EdgeInsets.only(
                top: SizeTokens.p24,
                left: SizeTokens.p16,
                right: SizeTokens.p16,
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/mascot.png',
                    height: SizeTokens.p120,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: SizeTokens.p12),
                  Text(
                    'Seni Bekleyen Sürpriz!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: SizeTokens.f20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: SizeTokens.p8),
                ],
              ),
            ),
            // Body
            Padding(
              padding: EdgeInsets.all(SizeTokens.p24),
              child: Column(
                children: [
                  // 1000 DryPara badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeTokens.p20,
                      vertical: SizeTokens.p12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(SizeTokens.r40),
                      border: Border.all(
                        // ignore: deprecated_member_use
                        color: AppColors.darkBlue.withOpacity(0.15),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '1.000 ',
                          style: TextStyle(
                            color: AppColors.darkBlue,
                            fontSize: SizeTokens.f24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                        DpSymbol(size: SizeTokens.p32, color: AppColors.darkBlue),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeTokens.p16),
                  Text(
                    'Mağazaya hoş geldin! Sana özel 1.000 DryPara ödülün hazır. Cüzdanına eklemek için aşağıdaki butona dokun.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.gray,
                      fontSize: SizeTokens.f14,
                      height: 1.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: SizeTokens.p24),
                  if (viewModel.errorMessage != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: SizeTokens.p12),
                      child: Text(
                        viewModel.errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: SizeTokens.f12,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  // Claim button
                  SizedBox(
                    width: double.infinity,
                    height: SizeTokens.p56,
                    child: ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : () async {
                              final success = await viewModel.claimBonus();
                              if (success && context.mounted) {
                                // Refresh user data to update token balance
                                context.read<HomeViewModel>().init();
                                Navigator.of(context).pop();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkBlue,
                        foregroundColor: AppColors.white,
                        disabledBackgroundColor:
                            // ignore: deprecated_member_use
                            AppColors.darkBlue.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SizeTokens.r12),
                        ),
                        elevation: 0,
                      ),
                      child: viewModel.isLoading
                          ? SizedBox(
                              width: SizeTokens.p24,
                              height: SizeTokens.p24,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Cüzdana Ekle',
                              style: TextStyle(
                                fontSize: SizeTokens.f16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: SizeTokens.p12),
                  // Dismiss button
                  TextButton(
                    onPressed: viewModel.isLoading
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: Text(
                      'Daha sonra',
                      style: TextStyle(
                        color: AppColors.gray,
                        fontSize: SizeTokens.f14,
                        fontFamily: 'Inter',
                      ),
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
