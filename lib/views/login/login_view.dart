import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/login_view_model.dart';
import '../../viewmodels/register_view_model.dart';
import '../../models/user_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../home/home_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../common/pdf_viewer_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

enum AuthTab { login, register }

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}
class _LoginViewState extends State<LoginView> {
  // Common
  AuthTab _selectedTab = AuthTab.login;
  bool _isPhoneInput = false;

  // Login Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneLoginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  // Register Controllers
  final TextEditingController _regNameController = TextEditingController();
  final TextEditingController _regEmailController = TextEditingController();
  final TextEditingController _regPhoneController = TextEditingController();
  final TextEditingController _regPassController = TextEditingController();
  final TextEditingController _regPassConfirmController =
      TextEditingController();
  bool _isAccepted = false;
  bool _isKvkkAccepted = false;

  static const Color brandBlue = Color(0xFF3B71F3);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final loginViewModel = Provider.of<LoginViewModel>(context);
    final registerViewModel = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // White Container (Content)
            Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(240)),
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight:
                        SizeConfig.screenHeight -
                        getProportionateScreenHeight(240),
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
                      Center(
                        child: SvgPicture.asset(
                          'assets/dry_fix.svg',
                          height: SizeTokens.p40,
                        ),
                      ),
                      SizedBox(height: SizeTokens.p24),
                      // Custom Tabs (Giriş / Üye ol)
                      Container(
                        height: SizeTokens.p48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8ECF5),
                          borderRadius: BorderRadius.circular(SizeTokens.r32),
                        ),
                        padding: EdgeInsets.all(SizeTokens.p4),
                        child: Row(
                          children: [
                            _buildTabItem(
                              title: "Giriş Yap",
                              tab: AuthTab.login,
                              isSelected: _selectedTab == AuthTab.login,
                            ),
                            _buildTabItem(
                              title: "Üye Ol",
                              tab: AuthTab.register,
                              isSelected: _selectedTab == AuthTab.register,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: SizeTokens.p32),

                      // Form Content
                      if (_selectedTab == AuthTab.login)
                        _buildLoginForm(loginViewModel)
                      else
                        _buildRegisterForm(registerViewModel),
                    ],
                  ),
                ),
              ],
            ),
            // Mascot (Top Layer)
            Positioned(
              top: MediaQuery.of(context).padding.top,
              child: IgnorePointer(
                child: SizedBox(
                  height: getProportionateScreenHeight(250),
                  width: SizeConfig.screenWidth,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Image.asset(
                      _selectedTab == AuthTab.register
                          ? 'assets/register_mascot.png'
                          : 'assets/login_mascot.png',
                      key: ValueKey(_selectedTab),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
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
        if (!_isPhoneInput)
          _buildTextField(
            controller: _emailController,
            hint: "E-mail",
            icon: Icons.mail_outline,
            textInputAction: TextInputAction.next,
          )
        else
          _buildTextField(
            controller: _phoneLoginController,
            hint: "(5xx) xxx xx xx",
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            prefixText: '+90 ',
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text.startsWith('0')) return oldValue;
                return newValue;
              }),
            ],
          ),
        SizedBox(height: SizeTokens.p16),
        _buildTextField(
          controller: _passwordController,
          hint: "Password",
          icon: Icons.lock_outline,
          isPassword: true,
          textInputAction: TextInputAction.done,
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
                    // ignore: deprecated_member_use
                    color: AppColors.darkBlue.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () => setState(() => _isPhoneInput = !_isPhoneInput),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                _isPhoneInput ? "E-mail ile Giriş" : "Telefon ile Giriş",
                style: TextStyle(
                  color: brandBlue,
                  fontSize: SizeTokens.f14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
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
            final identifier = !_isPhoneInput
                ? _emailController.text
                : '+90${_phoneLoginController.text}';
            await viewModel.login(
              identifier,
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
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: SizeTokens.p16),
        _buildTextField(
          controller: _regEmailController,
          hint: "Email",
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: SizeTokens.p16),
        _buildTextField(
          controller: _regPassController,
          hint: "Şifre",
          icon: Icons.lock_outline,
          isPassword: true,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: SizeTokens.p16),
        _buildTextField(
          controller: _regPassConfirmController,
          hint: "Şifre Tekrar",
          icon: Icons.lock_outline,
          isPassword: true,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: SizeTokens.p16),
        _buildTextField(
          controller: _regPhoneController,
          hint: "(5xx) xxx xx xx",
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          prefixText: '+90 ',
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
            TextInputFormatter.withFunction((oldValue, newValue) {
              if (newValue.text.startsWith('0')) return oldValue;
              return newValue;
            }),
          ],
        ),
        SizedBox(height: SizeTokens.p16),
        // Üyelik & Kullanım Sözleşmesi
        Row(
          children: [
            Transform.scale(
              scale: 0.9,
              child: Checkbox(
                value: _isAccepted,
                onChanged: (val) {
                  setState(() {
                    _isAccepted = val ?? false;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: const BorderSide(color: brandBlue),
                activeColor: brandBlue,
              ),
            ),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Üyelik & Kullanım Sözleşmesi",
                      style: const TextStyle(
                        color: brandBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PdfViewerScreen(
                                assetPath:
                                    'assets/Üyelik _ Kullanım Sözleşmesi.pdf',
                                title: 'Üyelik & Kullanım Sözleşmesi',
                              ),
                            ),
                          );
                        },
                    ),
                    TextSpan(
                      text: " okudum ve kabul ediyorum.",
                      style: TextStyle(
                        fontSize: 12,
                        // ignore: deprecated_member_use
                        color: AppColors.darkBlue.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: SizeTokens.p8),
        // KVKK Açık Rıza Metni
        Row(
          children: [
            Transform.scale(
              scale: 0.9,
              child: Checkbox(
                value: _isKvkkAccepted,
                onChanged: (val) {
                  setState(() {
                    _isKvkkAccepted = val ?? false;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: const BorderSide(color: brandBlue),
                activeColor: brandBlue,
              ),
            ),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "KVKK Açık Rıza Metni",
                      style: const TextStyle(
                        color: brandBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PdfViewerScreen(
                                assetPath: 'assets/KVKK Açık Rıza Metni.pdf',
                                title: 'KVKK Açık Rıza Metni',
                              ),
                            ),
                          );
                        },
                    ),
                    TextSpan(
                      text: " okudum ve kabul ediyorum.",
                      style: TextStyle(
                        fontSize: 12,
                        // ignore: deprecated_member_use
                        color: AppColors.darkBlue.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: SizeTokens.p32),
        _buildActionButton(
          text: "Kayıt Ol",
          isLoading: viewModel.isLoading,
          onPressed: () async {
            if (!_isAccepted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Lütfen Üyelik & Kullanım Sözleşmesi'ni onaylayın.",
                  ),
                ),
              );
              return;
            }
            if (!_isKvkkAccepted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Lütfen KVKK Açık Rıza Metni'ni onaylayın."),
                ),
              );
              return;
            }
            final request = RegisterRequest(
              name: _regNameController.text,
              email: _regEmailController.text,
              phone: '+90${_regPhoneController.text}',
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
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    String? prefixText,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hint,
        hintStyle: TextStyle(
          // ignore: deprecated_member_use
          color: AppColors.darkBlue.withOpacity(0.5),
          fontSize: SizeTokens.f14,
        ),
        prefixIcon: Icon(icon, color: brandBlue),
        prefixText: prefixText,
        prefixStyle: prefixText != null
            ? TextStyle(
                color: brandBlue,
                fontWeight: FontWeight.bold,
                fontSize: SizeTokens.f14,
              )
            : null,
        filled: true,
        fillColor: AppColors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: SizeTokens.p20,
          vertical: SizeTokens.p16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeTokens.r32),
          // ignore: deprecated_member_use
          borderSide: BorderSide(color: AppColors.darkBlue.withOpacity(0.2)),
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

  Widget _buildTabItem({
    required String title,
    required AuthTab tab,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(SizeTokens.r24),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? AppColors.darkBlue : AppColors.gray,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: SizeTokens.f13,
            ),
          ),
        ),
      ),
    );
  }
}
