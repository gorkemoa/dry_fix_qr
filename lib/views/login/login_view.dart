import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/login_view_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../home/home_view.dart';

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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeTokens.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Giriş Yap",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: SizeTokens.f20 * 1.5,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeTokens.p32),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "E-Posta",
                labelStyle: const TextStyle(color: AppColors.gray),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SizeTokens.r12),
                  borderSide: const BorderSide(color: AppColors.blue),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SizeTokens.r12),
                ),
              ),
            ),
            SizedBox(height: SizeTokens.p16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Şifre",
                labelStyle: const TextStyle(color: AppColors.gray),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SizeTokens.r12),
                  borderSide: const BorderSide(color: AppColors.blue),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SizeTokens.r12),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: SizeTokens.p24),
            if (viewModel.isLoading)
              const Center(
                child: CircularProgressIndicator(color: AppColors.blue),
              )
            else
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                  padding: EdgeInsets.symmetric(vertical: SizeTokens.p16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeTokens.r12),
                  ),
                ),
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
                child: Text(
                  "Giriş Yap",
                  style: TextStyle(
                    fontSize: SizeTokens.f16,
                    color: AppColors.white,
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
            if (viewModel.user != null)
              Padding(
                padding: EdgeInsets.only(top: SizeTokens.p16),
                child: Text(
                  "Hoşgeldin, ${viewModel.user!.name}\nBakiye: ${viewModel.user!.tokenBalance}",
                  style: const TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
