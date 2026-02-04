import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/update_password_view_model.dart';
import '../../models/user_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../login/login_view.dart';

class UpdatePasswordView extends StatefulWidget {
  const UpdatePasswordView({super.key});

  @override
  State<UpdatePasswordView> createState() => _UpdatePasswordViewState();
}

class _UpdatePasswordViewState extends State<UpdatePasswordView> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final viewModel = context.watch<UpdatePasswordViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Şifre Değiştir")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeTokens.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Güvenliğiniz için şifrenizi düzenli aralıklarla güncelleyin.",
              style: TextStyle(fontSize: SizeTokens.f14, color: AppColors.gray),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeTokens.p32),
            _buildPasswordField(
              controller: _currentPasswordController,
              label: "Mevcut Şifre",
            ),
            SizedBox(height: SizeTokens.p16),
            _buildPasswordField(
              controller: _newPasswordController,
              label: "Yeni Şifre",
            ),
            SizedBox(height: SizeTokens.p16),
            _buildPasswordField(
              controller: _confirmPasswordController,
              label: "Yeni Şifre Tekrar",
            ),
            SizedBox(height: SizeTokens.p32),
            if (viewModel.isLoading)
              const Center(
                child: CircularProgressIndicator(color: AppColors.blue),
              )
            else
              ElevatedButton(
                onPressed: () async {
                  if (_newPasswordController.text !=
                      _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Yeni şifreler eşleşmiyor."),
                      ),
                    );
                    return;
                  }

                  final request = UpdatePasswordRequest(
                    currentPassword: _currentPasswordController.text,
                    password: _newPasswordController.text,
                    passwordConfirmation: _confirmPasswordController.text,
                  );

                  await viewModel.updatePassword(request);

                  if (viewModel.isSuccess && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Şifreniz başarıyla güncellendi."),
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  "Şifreyi Güncelle",
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
            SizedBox(height: SizeTokens.p48),
            const Divider(),
            SizedBox(height: SizeTokens.p16),
            TextButton(
              onPressed: () => _showDeactivateDialog(context, viewModel),
              child: const Text(
                "Hesabı Kapat",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeactivateDialog(
    BuildContext context,
    UpdatePasswordViewModel viewModel,
  ) {
    final TextEditingController passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hesabı Kapat"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hesabınızı kapatmak istediğinize emin misiniz? Bu işlem geri alınamaz.",
            ),
            SizedBox(height: SizeTokens.p16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Şifreniz",
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
            child: const Text("Vazgeç"),
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
                  const SnackBar(content: Text("Hesabınız kapatıldı.")),
                );
              } else if (viewModel.errorMessage != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(viewModel.errorMessage!),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: const Text(
              "Hesabı Kapat",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.gray),
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
