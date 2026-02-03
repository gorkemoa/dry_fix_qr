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
      appBar: AppBar(title: const Text("Kayıt Ol")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeTokens.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Yeni Hesap Oluştur",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: SizeTokens.f20 * 1.5,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeTokens.p32),
            _buildTextField(
              controller: _nameController,
              label: "Ad Soyad",
              icon: Icons.person_outline,
            ),
            SizedBox(height: SizeTokens.p16),
            _buildTextField(
              controller: _emailController,
              label: "E-Posta",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: SizeTokens.p16),
            _buildTextField(
              controller: _phoneController,
              label: "Telefon",
              icon: Icons.phone_android_outlined,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: SizeTokens.p16),
            _buildTextField(
              controller: _passwordController,
              label: "Şifre",
              icon: Icons.lock_outline,
              obscureText: true,
            ),
            SizedBox(height: SizeTokens.p16),
            _buildTextField(
              controller: _passwordConfirmController,
              label: "Şifre Tekrar",
              icon: Icons.lock_outline,
              obscureText: true,
            ),
            SizedBox(height: SizeTokens.p32),
            if (viewModel.isLoading)
              const Center(
                child: CircularProgressIndicator(color: AppColors.blue),
              )
            else
              ElevatedButton(
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
                child: Text(
                  "Kayıt Ol",
                  style: TextStyle(
                    fontSize: SizeTokens.f16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (viewModel.errorMessage != null)
              Padding(
                padding: EdgeInsets.only(top: SizeTokens.p16),
                child: Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.gray),
        labelStyle: const TextStyle(color: AppColors.gray),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeTokens.r12),
          borderSide: const BorderSide(color: AppColors.blue),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeTokens.r12),
        ),
      ),
    );
  }
}
