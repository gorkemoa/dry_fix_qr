import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../viewmodels/forgot_password_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../forgot_password/reset_password_view.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isPhoneInput = false;

  static const Color brandBlue = Color(0xFF3B71F3);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ForgotPasswordViewModel>(context, listen: false).init();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final viewModel = Provider.of<ForgotPasswordViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(250)),
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight:
                        SizeConfig.screenHeight -
                        getProportionateScreenHeight(250),
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
                      Text(
                        'Şifremi Unuttum',
                        style: TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: SizeTokens.f24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: SizeTokens.p8),
                      Text(
                        'Şifrenizi sıfırlamak için kayıtlı e-posta veya telefon numaranızı girin. Hesabınız yoksa lütfen üye olun.',
                        style: TextStyle(
                          // ignore: deprecated_member_use
                          color: AppColors.darkBlue.withOpacity(0.6),
                          fontSize: SizeTokens.f14,
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: SizeTokens.p24),
                      // Email / Phone toggle
                      Container(
                        height: SizeTokens.p48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8ECF5),
                          borderRadius: BorderRadius.circular(SizeTokens.r32),
                        ),
                        padding: EdgeInsets.all(SizeTokens.p4),
                        child: Row(
                          children: [
                            _buildToggleItem(
                              title: 'E-posta',
                              isSelected: !_isPhoneInput,
                              onTap: () => setState(() => _isPhoneInput = false),
                            ),
                            _buildToggleItem(
                              title: 'Telefon',
                              isSelected: _isPhoneInput,
                              onTap: () => setState(() => _isPhoneInput = true),
                            ),
                          ],
                        ),
                      ),
                      if (_isPhoneInput) ...[
                        SizedBox(height: SizeTokens.p8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeTokens.p16,
                            vertical: SizeTokens.p8,
                          ),
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: AppColors.blue.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(SizeTokens.r12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                // ignore: deprecated_member_use
                                color: AppColors.blue.withOpacity(0.8),
                                size: SizeTokens.p16,
                              ),
                              SizedBox(width: SizeTokens.p8),
                              Expanded(
                                child: Text(
                                  'Sıfırlama kodu kayıtlı e-posta adresinize gönderilecektir.',
                                  style: TextStyle(
                                    // ignore: deprecated_member_use
                                    color: AppColors.darkBlue.withOpacity(0.7),
                                    fontSize: SizeTokens.f12,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: SizeTokens.p16),
                      if (!_isPhoneInput)
                        _buildTextField(
                          controller: _emailController,
                          hint: 'E-posta adresiniz',
                          icon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                        )
                      else
                        _buildPhoneField(),
                      SizedBox(height: SizeTokens.p24),
                      _buildActionButton(
                        text: 'Kod Gönder',
                        isLoading: viewModel.isLoading,
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          final String? email = !_isPhoneInput
                              ? _emailController.text.trim()
                              : null;
                          final String? phone = _isPhoneInput
                              ? '+90${_phoneController.text.trim()}'
                              : null;
                          final success = await viewModel.sendResetCode(
                            email: email,
                            phone: phone,
                          );
                          if (success && mounted) {
                            navigator.push(
                              MaterialPageRoute(
                                builder: (_) => ResetPasswordView(
                                  email: email,
                                  phone: phone,
                                  resetCode: viewModel.response?.resetCode ?? '',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      if (viewModel.errorMessage != null)
                        _buildErrorMessage(viewModel.errorMessage!),
                      SizedBox(height: SizeTokens.p24), 
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Giriş sayfasına dön',
                            style: TextStyle(
                              color: brandBlue,
                              fontSize: SizeTokens.f14,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top,
              child: IgnorePointer(
                child: SizedBox(
                  height: getProportionateScreenHeight(210),
                  width: SizeConfig.screenWidth,
                  child: Image.asset(
                    'assets/sifremiunuttum.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
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

  Widget _buildPhoneField() {
    return TextField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
        TextInputFormatter.withFunction((oldValue, newValue) {
          if (newValue.text.startsWith('0')) return oldValue;
          return newValue;
        }),
      ],
      decoration: InputDecoration(
        hintText: '(5xx) xxx xx xx',
        hintStyle: TextStyle(
          // ignore: deprecated_member_use
          color: AppColors.darkBlue.withOpacity(0.5),
          fontSize: SizeTokens.f14,
        ),
        prefixIcon: Icon(Icons.phone_outlined, color: brandBlue),
        prefix: Text(
          '+90 ',
          style: TextStyle(
            color: brandBlue,
            fontWeight: FontWeight.bold,
            fontSize: SizeTokens.f14,
          ),
        ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          // ignore: deprecated_member_use
          color: AppColors.darkBlue.withOpacity(0.5),
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
}
