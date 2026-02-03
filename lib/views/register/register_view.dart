import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/register_view_model.dart';
import '../../models/user_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../home/home_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final viewModel = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.darkBlue,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Kayıt Ol",
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: SizeTokens.f18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: SizeTokens.p32,
          vertical: SizeTokens.p16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Yeni Hesap Oluştur",
              style: TextStyle(
                fontSize: SizeTokens.f24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: SizeTokens.p8),
            Text(
              "Sisteme kayıt olmak için bilgilerinizi girin.",
              style: TextStyle(fontSize: SizeTokens.f14, color: AppColors.gray),
            ),
            SizedBox(height: SizeTokens.p32),

            _buildFieldLabel("Ad Soyad"),
            _buildTextField(
              controller: _nameController,
              hint: "Örn: Ahmet Yılmaz",
              icon: Icons.person_outline_rounded,
            ),
            SizedBox(height: SizeTokens.p20),

            _buildFieldLabel("E-Posta"),
            _buildTextField(
              controller: _emailController,
              hint: "Örn: ahmet@domain.com",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: SizeTokens.p20),

            _buildFieldLabel("Telefon"),
            _buildTextField(
              controller: _phoneController,
              hint: "+90 5xx ...",
              icon: Icons.phone_android_outlined,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: SizeTokens.p20),

            _buildFieldLabel("Şifre"),
            _buildTextField(
              controller: _passwordController,
              hint: "••••••••",
              icon: Icons.lock_outline_rounded,
              obscureText: true,
            ),
            SizedBox(height: SizeTokens.p20),

            _buildFieldLabel("Şifre Tekrar"),
            _buildTextField(
              controller: _passwordConfirmController,
              hint: "••••••••",
              icon: Icons.lock_outline_rounded,
              obscureText: true,
            ),

            SizedBox(height: SizeTokens.p32),

            if (viewModel.isLoading)
              const Center(
                child: CircularProgressIndicator(color: AppColors.darkBlue),
              )
            else
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    final request = RegisterRequest(
                      name: _nameController.text,
                      email: _emailController.text,
                      phone: _phoneController.text,
                      password: _passwordController.text,
                      passwordConfirmation: _passwordConfirmController.text,
                    );
                    final success = await viewModel.register(request);
                    if (success && mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomeView()),
                        (route) => false,
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
                    "Kayıt Ol",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            if (viewModel.errorMessage != null)
              Padding(
                padding: EdgeInsets.only(top: SizeTokens.p16),
                child: Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),

            SizedBox(height: SizeTokens.p32),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeTokens.p8),
      child: Text(
        label,
        style: TextStyle(
          fontSize: SizeTokens.f12,
          fontWeight: FontWeight.w600,
          color: AppColors.darkBlue.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
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
        prefixIcon: Icon(
          icon,
          color: AppColors.darkBlue.withOpacity(0.5),
          size: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeTokens.r8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeTokens.r8),
          borderSide: const BorderSide(color: AppColors.darkBlue, width: 1),
        ),
      ),
    );
  }
}
