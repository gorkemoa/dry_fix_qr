import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/profile_view_model.dart';
import '../../models/user_model.dart';
import 'update_password_view.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import 'widgets/address_form_field.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<ProfileViewModel>();
      if (viewModel.user != null) {
        _nameController.text = viewModel.user!.name;
        _emailController.text = viewModel.user!.email;
        String phone = viewModel.user!.phone;
        if (phone.startsWith('+90')) {
          phone = phone.substring(3);
        }
        _phoneController.text = phone;
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
          "Profil Bilgileri",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: viewModel.isLoading && viewModel.user == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.darkBlue),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(SizeTokens.p24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AddressFormField(
                      controller: _nameController,
                      label: "Ad Soyad",
                      hint: "Adınızı ve soyadınızı giriniz",
                      validator: (v) => v?.isEmpty ?? true ? "Gerekli" : null,
                    ),
                    SizedBox(height: SizeTokens.p16),
                    AddressFormField(
                      controller: _emailController,
                      label: "E-Posta",
                      hint: "E-posta adresinizi giriniz",
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      validator: (v) => v?.isEmpty ?? true ? "Gerekli" : null,
                    ),
                    SizedBox(height: SizeTokens.p16),
                    AddressFormField(
                      controller: _phoneController,
                      label: "Telefon",
                      hint: "(___) ___ __ __",
                      keyboardType: TextInputType.phone,
                      prefix: Container(
                        width: 60,
                        alignment: Alignment.center,
                        child: const Text(
                          "+90",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      validator: (v) => v?.isEmpty ?? true ? "Gerekli" : null,
                    ),
                    SizedBox(height: SizeTokens.p32),

                    ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                final request = UpdateProfileRequest(
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  phone: "+90${_phoneController.text.trim()}",
                                );

                                await viewModel.updateProfile(request);

                                if (viewModel.isSuccess && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        "Profil bilgileriniz güncellendi.",
                                      ),
                                      backgroundColor: AppColors.darkBlue,
                                    ),
                                  );
                                  Navigator.pop(context);
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
                              "Bilgileri Güncelle",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
                        style: TextStyle(
                          color: AppColors.blue,
                          fontWeight: FontWeight.w600,
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
            ),
    );
  }
}
