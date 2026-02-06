import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/profile_view_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../transactions/transactions_view.dart';
import 'edit_profile_view.dart';
import 'update_password_view.dart';
import 'addresses_view.dart';
import '../login/login_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String _version = "";
  String _buildNumber = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().fetchProfile();
    });
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  String _getUserInitials(String? name) {
    if (name == null || name.isEmpty) return "M";
    final names = name.split(" ");
    if (names.length > 1) {
      return "${names[0][0]}${names[names.length - 1][0]}".toUpperCase();
    }
    return names[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final viewModel = context.watch<ProfileViewModel>();
    final user = viewModel.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Profilim",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EditProfileView()),
              );
            },
            icon: Icon(
              Icons.edit_note_rounded,
              color: Colors.white,
              size: SizeTokens.p24,
            ),
          ),
          SizedBox(width: SizeTokens.p8),
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
                  SizedBox(height: SizeTokens.p20),
                  // User Info Header
                  // User Info Header
                  Row(
                    children: [
                      Container(
                        width: SizeTokens.p80,
                        height: SizeTokens.p80,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blue.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                          border: Border.all(
                            color: AppColors.blue.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/Adsız tasarım (9).png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                  child: Text(
                                    _getUserInitials(user?.name),
                                    style: TextStyle(
                                      color: AppColors.blue,
                                      fontSize: SizeTokens.f32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                          ),
                        ),
                      ),
                      SizedBox(width: SizeTokens.p20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  size: SizeTokens.p14,
                                  color: AppColors.gray,
                                ),
                                SizedBox(width: SizeTokens.p4),
                                Flexible(
                                  child: Text(
                                    user?.email ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.gray,
                                      fontSize: SizeTokens.f13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (user?.phone != null &&
                                user!.phone.isNotEmpty) ...[
                              SizedBox(height: SizeTokens.p4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone_android_outlined,
                                    size: SizeTokens.p14,
                                    color: AppColors.gray,
                                  ),
                                  SizedBox(width: SizeTokens.p4),
                                  Text(
                                    user.phone,
                                    style: TextStyle(
                                      color: AppColors.gray,
                                      fontSize: SizeTokens.f13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeTokens.p32),

                  // Balance Card
                  _buildBalanceCard(context, user?.tokenBalance ?? 0),

                  SizedBox(height: SizeTokens.p32),

                  // Account Section
                  _buildSectionHeader("Hesap İşlemleri"),
                  _buildMenuCard([
                    _buildMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: "Kişisel Bilgiler",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EditProfileView(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.location_on_outlined,
                      title: "Adreslerim",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AddressesView(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.lock_outline_rounded,
                      title: "Şifre İşlemleri",
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
                  _buildSectionHeader("Uygulama"),
                  _buildMenuCard([
                    _buildMenuItem(
                      icon: Icons.headset_mic_outlined,
                      title: "Destek ve Yardım",
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.logout_rounded,
                      title: "Çıkış Yap",
                      titleColor: Colors.redAccent,
                      iconColor: Colors.redAccent.withOpacity(0.08),
                      showArrow: false,
                      onTap: () {
                        _showLogoutDialog(context, viewModel);
                      },
                      isLast: true,
                    ),
                  ]),

                  SizedBox(height: SizeTokens.p40),

                  // Footer
                  Opacity(
                    opacity: 0.5,
                    child: Column(
                      children: [
                        Text(
                          "Dryfix QR Sistemi",
                          style: TextStyle(
                            color: AppColors.darkBlue,
                            fontSize: SizeTokens.f12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: SizeTokens.p4),
                        Text(
                          "v$_version ($_buildNumber)",
                          style: TextStyle(
                            color: AppColors.gray,
                            fontSize: SizeTokens.f11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeTokens.p32),
                ],
              ),
            ),
    );
  }

  void _showLogoutDialog(BuildContext context, ProfileViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeTokens.r20),
        ),
        title: Text(
          "Çıkış Yap",
          style: TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.bold,
            fontSize: SizeTokens.f18,
          ),
        ),
        content: Text(
          "Hesabınızdan çıkış yapmak istediğinize emin misiniz?",
          style: TextStyle(color: AppColors.gray, fontSize: SizeTokens.f14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Vazgeç",
              style: TextStyle(
                color: AppColors.gray,
                fontWeight: FontWeight.w600,
                fontSize: SizeTokens.f14,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              viewModel.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginView()),
                (route) => false,
              );
            },
            child: Text(
              "Çıkış Yap",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: SizeTokens.f14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, int balance) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeTokens.p24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.darkBlue, AppColors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(SizeTokens.r24),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -SizeTokens.p20,
            bottom: -SizeTokens.p20,
            child: Icon(
              Icons.account_balance_wallet_rounded,
              size: SizeTokens.p100,
              color: AppColors.white.withOpacity(0.1),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "DryPara Bakiyesi",
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.8),
                  fontSize: SizeTokens.f13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: SizeTokens.p8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    balance.toString(),
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: SizeTokens.f32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: SizeTokens.p4),
                  Text(
                    "DP",
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.8),
                      fontSize: SizeTokens.f16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeTokens.p20),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TransactionsView()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeTokens.p16,
                    vertical: SizeTokens.p8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(SizeTokens.r12),
                    border: Border.all(color: AppColors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "İşlem Geçmişi",
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: SizeTokens.f12,
                        ),
                      ),
                      SizedBox(width: SizeTokens.p4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.white,
                        size: SizeTokens.p14,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: SizeTokens.p4, bottom: SizeTokens.p12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: SizeTokens.f16,
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
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
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
            indent: SizeTokens.p64,
            endIndent: SizeTokens.p16,
            color: AppColors.background,
          ),
      ],
    );
  }
}
