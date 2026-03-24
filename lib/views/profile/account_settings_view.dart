import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_tokens.dart';
import 'update_password_view.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/update_password_view_model.dart';
import '../login/login_view.dart';

class AccountSettingsView extends StatelessWidget {
  const AccountSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Hesap Ayarları",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.darkBlue,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: SizeTokens.p20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeTokens.p20),
        child: Column(
          children: [
            _buildMenuCard([
              _buildMenuItem(
                icon: Icons.lock_reset_rounded,
                title: "Şifre İşlemleri",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UpdatePasswordView(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.person_off_rounded,
                title: "Hesabı Sil",
                titleColor: Colors.redAccent,
                iconColor: Colors.redAccent.withOpacity(0.08),
                onTap: () => _showDeleteAccountDialog(context),
                isLast: true,
              ),
            ]),
            SizedBox(height: SizeTokens.p32),
            Text(
              "Hesabınızı silmeniz durumunda tüm verileriniz kalıcı olarak kaldırılacaktır. Bu işlem geri alınamaz.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.gray, fontSize: SizeTokens.f12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: SizeTokens.f14,
            offset: Offset(0, SizeTokens.p4),
          ),
        ],
      ),
      child: Column(children: items),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
    bool showArrow = true,
    bool isLast = false,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          dense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: SizeTokens.p16,
            vertical: SizeTokens.p4,
          ),
          leading: Container(
            padding: EdgeInsets.all(SizeTokens.p10),
            decoration: BoxDecoration(
              color: iconColor ?? AppColors.background,
              borderRadius: BorderRadius.circular(SizeTokens.r12),
            ),
            child: Icon(
              icon,
              color: titleColor ?? AppColors.darkBlue.withOpacity(0.8),
              size: SizeTokens.p20,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: titleColor ?? AppColors.darkBlue,
              fontSize: SizeTokens.f14,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: showArrow
              ? Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.gray.withOpacity(0.4),
                  size: SizeTokens.p12,
                )
              : null,
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: SizeTokens.p16 + SizeTokens.p40 + SizeTokens.p16,
            endIndent: SizeTokens.p16,
            color: AppColors.gray.withOpacity(0.1),
          ),
      ],
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final passwordController = TextEditingController();
    final viewModel = context.read<UpdatePasswordViewModel>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeTokens.r20),
        ),
        title: Text(
          "Hesabı Sil",
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: SizeTokens.f18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Apple kuralları gereği hesabınızı silme hakkına sahipsiniz. Devam etmek için şifrenizi giriniz.",
              style: TextStyle(color: AppColors.gray, fontSize: SizeTokens.f14),
            ),
            SizedBox(height: SizeTokens.p16),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: TextStyle(fontSize: SizeTokens.f14),
              decoration: InputDecoration(
                hintText: "Şifreniz",
                hintStyle: TextStyle(
                  fontSize: SizeTokens.f14,
                  color: AppColors.gray,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: SizeTokens.p12,
                  vertical: SizeTokens.p8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SizeTokens.r8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Vazgeç",
              style: TextStyle(color: AppColors.gray, fontSize: SizeTokens.f14),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (passwordController.text.isEmpty) return;

              await viewModel.deactivateAccount(passwordController.text);

              if (viewModel.isSuccess && context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginView()),
                  (route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Hesabınız kalıcı olarak silindi."),
                  ),
                );
              } else if (viewModel.errorMessage != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(viewModel.errorMessage!)),
                );
              }
            },
            child: Text(
              "Kalıcı Olarak Sil",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: SizeTokens.f14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
