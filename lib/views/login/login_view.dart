import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/login_view_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../home/home_view.dart';
import '../register/register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController(
    text: 'testuser@example.com',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: '12341234',
  );

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final viewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: SizeTokens.p32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              // Corporate Logo Placeholder
              Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.darkBlue,
                      borderRadius: BorderRadius.circular(SizeTokens.r12),
                    ),
                    child: const Icon(
                      Icons.qr_code_2_rounded,
                      color: AppColors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: SizeTokens.p24),
                  Text(
                    "Dry Fix QR",
                    style: TextStyle(
                      fontSize: SizeTokens.f24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue,
                      letterSpacing: -1,
                    ),
                  ),
                  SizedBox(height: SizeTokens.p8),
                  Text(
                    "Kurumsal QR Yönetim Sistemi",
                    style: TextStyle(
                      fontSize: SizeTokens.f14,
                      color: AppColors.gray,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeTokens.p32 * 2),

              // Email field
              Text(
                "E-Posta Adresi",
                style: TextStyle(
                  fontSize: SizeTokens.f12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkBlue.withOpacity(0.7),
                ),
              ),
              SizedBox(height: SizeTokens.p8),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Örn: kurumsal@domain.com",
                  hintStyle: TextStyle(
                    color: AppColors.gray.withOpacity(0.5),
                    fontSize: SizeTokens.f14,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: SizeTokens.p16,
                    vertical: SizeTokens.p12,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SizeTokens.r8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SizeTokens.r8),
                    borderSide: const BorderSide(
                      color: AppColors.darkBlue,
                      width: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeTokens.p20),

              // Password field
              Text(
                "Şifre",
                style: TextStyle(
                  fontSize: SizeTokens.f12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkBlue.withOpacity(0.7),
                ),
              ),
              SizedBox(height: SizeTokens.p8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "••••••••",
                  hintStyle: TextStyle(
                    color: AppColors.gray.withOpacity(0.5),
                    fontSize: SizeTokens.f14,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: SizeTokens.p16,
                    vertical: SizeTokens.p12,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SizeTokens.r8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SizeTokens.r8),
                    borderSide: const BorderSide(
                      color: AppColors.darkBlue,
                      width: 1,
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Şifremi Unuttum",
                    style: TextStyle(
                      fontSize: SizeTokens.f12,
                      color: AppColors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: SizeTokens.p24),

              if (viewModel.isLoading)
                const Center(
                  child: CircularProgressIndicator(color: AppColors.darkBlue),
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      await viewModel.login(
                        _emailController.text,
                        _passwordController.text,
                      );
                      if (viewModel.user != null && mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const HomeView()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkBlue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(SizeTokens.r8),
                      ),
                    ),
                    child: const Text(
                      "Giriş Yap",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

              if (viewModel.errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(top: SizeTokens.p16),
                  child: Text(
                    viewModel.errorMessage!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              SizedBox(height: SizeTokens.p32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Henüz bir hesabınız yok mu? ",
                    style: TextStyle(
                      color: AppColors.gray,
                      fontSize: SizeTokens.f12,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RegisterView()),
                      );
                    },
                    child: Text(
                      "Kayıt Ol",
                      style: TextStyle(
                        color: AppColors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeTokens.f12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
