import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/update_password_view_model.dart';
import '../../models/user_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../login/login_view.dart';
import 'widgets/address_form_field.dart';

class UpdatePasswordView extends StatefulWidget {
  const UpdatePasswordView({super.key});

  @override
  State<UpdatePasswordView> createState() => _UpdatePasswordViewState();
}

class _UpdatePasswordViewState extends State<UpdatePasswordView> {
  final _formKey = GlobalKey<FormState>();

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Şifre Değiştir",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeTokens.p24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(SizeTokens.p12),
                decoration: BoxDecoration(
                  color: AppColors.darkBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(SizeTokens.r8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.darkBlue,
                      size: SizeTokens.f20,
                    ),
                    SizedBox(width: SizeTokens.p12),
                    Expanded(
                      child: Text(
                        "Güvenliğiniz için şifrenizi düzenli aralıklarla güncelleyin.",
                        style: TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: SizeTokens.f12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeTokens.p24),

              AddressFormField(
                controller: _currentPasswordController,
                label: "Mevcut Şifre",
                hint: "********",
                obscureText: true,
                validator: (v) => v?.isEmpty ?? true ? "Gerekli" : null,
              ),
              SizedBox(height: SizeTokens.p16),

              AddressFormField(
                controller: _newPasswordController,
                label: "Yeni Şifre",
                hint: "********",
                obscureText: true,
                validator: (v) => v?.isEmpty ?? true ? "Gerekli" : null,
              ),
              SizedBox(height: SizeTokens.p16),

              AddressFormField(
                controller: _confirmPasswordController,
                label: "Yeni Şifre Tekrar",
                hint: "********",
                obscureText: true,
                validator: (v) {
                  if (v?.isEmpty ?? true) return "Gerekli";
                  if (v != _newPasswordController.text) {
                    return "Şifreler eşleşmiyor";
                  }
                  return null;
                },
              ),

              SizedBox(height: SizeTokens.p32),

              ElevatedButton(
                onPressed: viewModel.isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          final request = UpdatePasswordRequest(
                            currentPassword: _currentPasswordController.text,
                            password: _newPasswordController.text,
                            passwordConfirmation:
                                _confirmPasswordController.text,
                          );

                          await viewModel.updatePassword(request);

                          if (viewModel.isSuccess && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  "Şifreniz başarıyla güncellendi.",
                                ),
                                backgroundColor: AppColors.darkBlue,
                              ),
                            );
                            Navigator.of(context).pop();
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeTokens.r8),
                  ),
                ),
                child: viewModel.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Şifreyi Güncelle",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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
}
