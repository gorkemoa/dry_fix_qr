import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/profile_view_model.dart';
import '../../models/user_model.dart';
import 'update_password_view.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<ProfileViewModel>();
      if (viewModel.user != null) {
        _nameController.text = viewModel.user!.name;
        _emailController.text = viewModel.user!.email;
        _phoneController.text = viewModel.user!.phone;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final viewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Profil Bilgileri")),
      body: viewModel.isLoading && viewModel.user == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.blue),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(SizeTokens.p24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                  SizedBox(height: SizeTokens.p32),
                  if (viewModel.isLoading)
                    const Center(
                      child: CircularProgressIndicator(color: AppColors.blue),
                    )
                  else
                    ElevatedButton(
                      onPressed: () async {
                        final request = UpdateProfileRequest(
                          name: _nameController.text,
                          email: _emailController.text,
                          phone: _phoneController.text,
                        );

                        await viewModel.updateProfile(request);

                        if (viewModel.isSuccess && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Profil bilgileriniz güncellendi."),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "Bilgileri Güncelle",
                        style: TextStyle(
                          fontSize: SizeTokens.f16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  SizedBox(height: SizeTokens.p16),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const UpdatePasswordView(),
                        ),
                      );
                    },
                    child: const Text(
                      "Şifre Değiştirmek İstiyorum",
                      style: TextStyle(color: AppColors.blue),
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
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
