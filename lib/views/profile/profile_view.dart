import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/profile_view_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../transactions/transactions_view.dart';
import 'edit_profile_view.dart';
import 'update_password_view.dart';
import '../login/login_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final viewModel = context.watch<ProfileViewModel>();
    final user = viewModel.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Profilim",
          style: TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.bold,
            fontSize: SizeTokens.f18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EditProfileView()),
              );
            },
            child: Text(
              "Düzenle",
              style: TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
                fontSize: SizeTokens.f14,
              ),
            ),
          ),
        ],
      ),
      body: viewModel.isLoading && user == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.blue),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: SizeTokens.p24),
              child: Column(
                children: [
                  SizedBox(height: SizeTokens.p24),
                  // User Info Header
                  Text(
                    user?.name ?? "Misafir Kullanıcı",
                    style: TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: SizeTokens.f24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: SizeTokens.p8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: SizeTokens.p14,
                        color: AppColors.gray,
                      ),
                      SizedBox(width: SizeTokens.p4),
                      Text(
                        user?.email ?? "",
                        style: TextStyle(
                          color: AppColors.gray,
                          fontSize: SizeTokens.f13,
                        ),
                      ),
                      SizedBox(width: SizeTokens.p16),
                      Icon(
                        Icons.phone_android_outlined,
                        size: SizeTokens.p14,
                        color: AppColors.gray,
                      ),
                      SizedBox(width: SizeTokens.p4),
                      Text(
                        user?.phone ?? "",
                        style: TextStyle(
                          color: AppColors.gray,
                          fontSize: SizeTokens.f13,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeTokens.p32),

                  // Balance Card
                  _buildBalanceCard(context, user?.tokenBalance ?? 0),

                  SizedBox(height: SizeTokens.p32),

                  // Account & Settings Section
                  _buildSectionTitle("Hesap & Ayarlar"),
                  _buildMenuCard([
                    _buildMenuItem(
                      icon: Icons.person_rounded,
                      title: "Hesap Bilgileri",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EditProfileView(),
                          ),
                        );
                      },
                      isLast: false,
                    ),
                    _buildMenuItem(
                      icon: Icons.lock_rounded,
                      title: "Güvenlik Ayarları",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const UpdatePasswordView(),
                          ),
                        );
                      },
                      isLast: true,
                    ),
                  ]),

                  SizedBox(height: SizeTokens.p24),

                  // Other Section
                  _buildSectionTitle("Diğer"),
                  _buildMenuCard([
                    _buildMenuItem(
                      icon: Icons.headset_mic_rounded,
                      title: "Canlı Destek",
                      onTap: () {},
                      isLast: false,
                    ),
                    _buildMenuItem(
                      icon: Icons.logout_rounded,
                      title: "Çıkış Yap",
                      titleColor: Colors.redAccent,
                      iconColor: Colors.redAccent.withOpacity(0.1),
                      showArrow: false,
                      onTap: () {
                        _showLogoutDialog(context, viewModel);
                      },
                      isLast: true,
                    ),
                  ]),

                  SizedBox(height: SizeTokens.p40),

                  // Footer
                  Text(
                    "Dryfix v2.4.1 (Build 204)",
                    style: TextStyle(
                      color: AppColors.gray.withOpacity(0.6),
                      fontSize: SizeTokens.f12,
                    ),
                  ),
                  SizedBox(height: SizeTokens.p24),
                ],
              ),
            ),
    );
  }

  void _showLogoutDialog(BuildContext context, ProfileViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Çıkış Yap"),
        content: const Text("Çıkış yapmak istediğinize emin misiniz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          TextButton(
            onPressed: () {
              viewModel.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginView()),
                (route) => false,
              );
            },
            child: const Text("Çıkış Yap", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, int balance) {
    return Container(
      padding: EdgeInsets.all(SizeTokens.p24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "DRYPARA BAKİYESİ",
                style: TextStyle(
                  color: AppColors.gray,
                  fontSize: SizeTokens.f10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: SizeTokens.p4),
              Text(
                "$balance DP",
                style: TextStyle(
                  color: AppColors.darkBlue,
                  fontSize: SizeTokens.f24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Material(
            color: const Color(0xFFE8F1FF), // Light blue background
            borderRadius: BorderRadius.circular(SizeTokens.r12),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TransactionsView()),
                );
              },
              borderRadius: BorderRadius.circular(SizeTokens.r12),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeTokens.p16,
                  vertical: SizeTokens.p8,
                ),
                child: Text(
                  "Detaylar",
                  style: TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeTokens.f14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: SizeTokens.p12),
        child: Text(
          title,
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: SizeTokens.f18,
            fontWeight: FontWeight.bold,
          ),
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
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
            horizontal: SizeTokens.p20,
            vertical: SizeTokens.p4,
          ),
          leading: Container(
            padding: EdgeInsets.all(SizeTokens.p8),
            decoration: BoxDecoration(
              color: iconColor ?? const Color(0xFFF0F4FF),
              borderRadius: BorderRadius.circular(SizeTokens.r12),
            ),
            child: Icon(
              icon,
              color: titleColor ?? AppColors.blue,
              size: SizeTokens.p20,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: titleColor ?? AppColors.darkBlue,
              fontSize: SizeTokens.f16,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: showArrow
              ? Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.gray.withOpacity(0.5),
                  size: SizeTokens.p14,
                )
              : null,
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: SizeTokens.p64,
            endIndent: SizeTokens.p20,
            color: AppColors.gray.withOpacity(0.1),
          ),
      ],
    );
  }
}
