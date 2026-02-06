import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/login_view_model.dart';
import '../../viewmodels/register_view_model.dart';
import '../../models/user_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../home/home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Common
  bool _isLogin = true;

  // Login Controllers
  final TextEditingController _emailController = TextEditingController(
    text: 'testuser@example.com',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: '12341234',
  );
  bool _rememberMe = false;

  // Register Controllers
  final TextEditingController _regNameController = TextEditingController();
  final TextEditingController _regEmailController = TextEditingController();
  final TextEditingController _regPhoneController = TextEditingController();
  final TextEditingController _regPassController = TextEditingController();
  final TextEditingController _regPassConfirmController =
      TextEditingController();

  static const Color brandBlue = Color(0xFF3B71F3);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final loginViewModel = Provider.of<LoginViewModel>(context);
    final registerViewModel = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section with Mascot (Changes based on state)
            Container(
              height: getProportionateScreenHeight(300),
              width: double.infinity,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Image.asset(
                  _isLogin
                      ? 'assets/login_mascot.png'
                      : 'assets/register_mascot.png',
                  key: ValueKey(_isLogin),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // White Container for Form
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight:
                    SizeConfig.screenHeight - getProportionateScreenHeight(200),
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeTokens.r40),
                  topRight: Radius.circular(SizeTokens.r40),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: SizeTokens.p32,
                vertical: SizeTokens.p40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Custom Tabs (Giriş / Üye ol)
                  Container(
                    height: SizeTokens.p64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8ECF5),
                      borderRadius: BorderRadius.circular(SizeTokens.r32),
                    ),
                    padding: EdgeInsets.all(SizeTokens.p4),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isLogin = true),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: _isLogin
                                    ? AppColors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  SizeTokens.r32,
                                ),
                                boxShadow: _isLogin
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : [],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Giriş",
                                style: TextStyle(
                                  color: _isLogin
                                      ? AppColors.darkBlue
                                      : AppColors.gray,
                                  fontWeight: _isLogin
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  fontSize: SizeTokens.f14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isLogin = false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: !_isLogin
                                    ? AppColors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  SizeTokens.r32,
                                ),
                                boxShadow: !_isLogin
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : [],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Üye Ol",
                                style: TextStyle(
                                  color: !_isLogin
                                      ? AppColors.darkBlue
                                      : AppColors.gray,
                                  fontWeight: !_isLogin
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  fontSize: SizeTokens.f14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeTokens.p32),

                  // Form Content
                  if (_isLogin)
                    _buildLoginForm(loginViewModel)
                  else
                    _buildRegisterForm(registerViewModel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(LoginViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(
          controller: _emailController,
          hint: "E-mail",
          icon: Icons.mail_outline,
        ),
        SizedBox(height: SizeTokens.p16),
        _buildTextField(
          controller: _passwordController,
          hint: "Password",
          icon: Icons.lock_outline,
          isPassword: true,
        ),
        SizedBox(height: SizeTokens.p16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Transform.scale(
                  scale: 0.9,
                  child: Checkbox(
                    value: _rememberMe,
                    onChanged: (val) {
                      setState(() {
                        _rememberMe = val ?? false;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: const BorderSide(color: brandBlue),
                    activeColor: brandBlue,
                  ),
                ),
                Text(
                  "Beni Hatırla",
                  style: TextStyle(
                    fontSize: SizeTokens.f12,
                    color: AppColors.darkBlue.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "Şifremi Unuttum",
                style: TextStyle(
                  fontSize: SizeTokens.f12,
                  color: brandBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: SizeTokens.p24),
        _buildActionButton(
          text: "Giriş Yap",
          isLoading: viewModel.isLoading,
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
        ),
        if (viewModel.errorMessage != null)
          _buildErrorMessage(viewModel.errorMessage!),
      ],
    );
  }

  Widget _buildRegisterForm(RegisterViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(
          controller: _regNameController,
          hint: "Ad Soyad",
          icon: Icons.person_outline,
        ),
        SizedBox(height: SizeTokens.p16),
        _buildTextField(
          controller: _regEmailController,
          hint: "Email",
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: SizeTokens.p16),
        _buildTextField(
          controller: _regPassController,
          hint: "Şifre",
          icon: Icons.lock_outline,
          isPassword: true,
        ),
        SizedBox(height: SizeTokens.p16),
        _buildTextField(
          controller: _regPassConfirmController,
          hint: "Şifre Tekrar",
          icon: Icons.lock_outline,
          isPassword: true,
        ),
        SizedBox(height: SizeTokens.p16),
        _buildTextField(
          controller: _regPhoneController,
          hint: "Phone No.",
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: SizeTokens.p32),
        _buildActionButton(
          text: "Kayıt Ol",
          isLoading: viewModel.isLoading,
          onPressed: () async {
            final request = RegisterRequest(
              name: _regNameController.text,
              email: _regEmailController.text,
              phone: _regPhoneController.text,
              password: _regPassController.text,
              passwordConfirmation: _regPassConfirmController.text,
            );
            final success = await viewModel.register(request);
            if (success && mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomeView()),
                (route) => false,
              );
            }
          },
        ),
        if (viewModel.errorMessage != null)
          _buildErrorMessage(viewModel.errorMessage!),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.gray.withOpacity(0.6),
          fontSize: SizeTokens.f14,
        ),
        prefixIcon: Icon(icon, color: brandBlue),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: SizeTokens.p20,
          vertical: SizeTokens.p16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeTokens.r32),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeTokens.r32),
          borderSide: const BorderSide(color: brandBlue, width: 1),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: SizeTokens.p56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: brandBlue,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeTokens.r32),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: SizeTokens.f16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Padding(
      padding: EdgeInsets.only(top: SizeTokens.p16),
      child: Text(
        message,
        style: const TextStyle(color: Colors.redAccent),
        textAlign: TextAlign.center,
      ),
    );
  }
}
