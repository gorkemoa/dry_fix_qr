import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../viewmodels/reset_password_view_model.dart';
import '../../viewmodels/forgot_password_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResetPasswordView extends StatefulWidget {
  final String? email;
  final String? phone;
  final String resetCode;

  const ResetPasswordView({
    super.key,
    this.email,
    this.phone,
    required this.resetCode,
  });

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  bool _codeVerified = false;
  String? _codeError;

  // Resend
  late String _currentResetCode;
  int _resendCountdown = 0;
  Timer? _resendTimer;

  static const Color brandBlue = AppColors.darkBlue; // Define your brand color here

  void _startResendTimer() {
    setState(() => _resendCountdown = 30);
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown <= 1) {
        timer.cancel();
        if (mounted) setState(() => _resendCountdown = 0);
      } else {
        if (mounted) setState(() => _resendCountdown--);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _currentResetCode = widget.resetCode;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ResetPasswordViewModel>(context, listen: false).init();
      _startResendTimer();
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _codeController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final viewModel = Provider.of<ResetPasswordViewModel>(context);

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
                        'Şifre Sıfırla',
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
                        _codeVerified
                            ? 'Yeni şifrenizi girin.'
                            : 'E-postanıza gelen 6 haneli kodu girin.',
                        style: TextStyle(
                          // ignore: deprecated_member_use
                          color: AppColors.darkBlue.withOpacity(0.6),
                          fontSize: SizeTokens.f14,
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: SizeTokens.p32),
                      if (!_codeVerified) ..._buildCodeStep()
                      else ..._buildPasswordStep(viewModel),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction? textInputAction,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
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

  List<Widget> _buildCodeStep() {
    return [
      _buildTextField(
        controller: _codeController,
        hint: '6 haneli kod',
        icon: Icons.verified_outlined,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ],
        textInputAction: TextInputAction.done,
      ),
      if (_codeError != null) _buildErrorMessage(_codeError!),
      SizedBox(height: SizeTokens.p24),
      _buildActionButton(
        text: 'Kodu Doğrula',
        isLoading: false,
        onPressed: () {
          final entered = _codeController.text.trim();
          if (entered == _currentResetCode) {
            setState(() {
              _codeVerified = true;
              _codeError = null;
            });
          } else {
            setState(() {
              _codeError = 'Girdiğiniz kod hatalı. Lütfen tekrar deneyin.';
            });
          }
        },
      ),
      SizedBox(height: SizeTokens.p16),
      Center(
        child: _resendCountdown > 0
            ? Text(
                'Yeniden göndermek için $_resendCountdown saniye bekleyin.',
                style: TextStyle(
                  // ignore: deprecated_member_use
                  color: AppColors.darkBlue.withOpacity(0.5),
                  fontSize: SizeTokens.f13,
                ),
                textAlign: TextAlign.center,
              )
            : Consumer<ForgotPasswordViewModel>(
                builder: (context, forgotVm, _) => TextButton(
                  onPressed: forgotVm.isLoading
                      ? null
                      : () async {
                          final success =
                              await forgotVm.sendResetCode(
                            email: widget.email,
                            phone: widget.phone,
                          );
                          if (success && mounted) {
                            setState(() {
                              _currentResetCode =
                                  forgotVm.response?.resetCode ?? _currentResetCode;
                              _codeController.clear();
                              _codeError = null;
                            });
                            _startResendTimer();
                          }
                        },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: forgotVm.isLoading
                      ? SizedBox(
                          height: SizeTokens.p16,
                          width: SizeTokens.p16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: brandBlue,
                          ),
                        )
                      : Text(
                          'Kodu yeniden gönder',
                          style: TextStyle(
                            color: brandBlue,
                            fontSize: SizeTokens.f14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                ),
              ),
      ),
      SizedBox(height: SizeTokens.p16),
      Center(
        child: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Geri dön',
            style: TextStyle(
              color: brandBlue,
              fontSize: SizeTokens.f14,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildPasswordStep(ResetPasswordViewModel viewModel) {
    return [
      _buildTextField(
        controller: _passwordController,
        hint: 'Yeni şifre',
        icon: Icons.lock_outline,
        isPassword: true,
        textInputAction: TextInputAction.next,
      ),
      SizedBox(height: SizeTokens.p16),
      _buildTextField(
        controller: _passwordConfirmController,
        hint: 'Yeni şifre tekrar',
        icon: Icons.lock_outline,
        isPassword: true,
        textInputAction: TextInputAction.done,
      ),
      SizedBox(height: SizeTokens.p24),
      _buildActionButton(
        text: 'Şifremi Sıfırla',
        isLoading: viewModel.isLoading,
        onPressed: () async {
          final navigator = Navigator.of(context);
          final messenger = ScaffoldMessenger.of(context);
          final success = await viewModel.resetPassword(
            email: widget.email,
            phone: widget.phone,
            code: _currentResetCode,
            password: _passwordController.text,
            passwordConfirmation: _passwordConfirmController.text,
          );
          if (success && mounted) {
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  viewModel.successMessage ?? 'Şifreniz güncellendi.',
                ),
                backgroundColor: Colors.green,
              ),
            );
            navigator.popUntil((route) => route.isFirst);
          }
        },
      ),
      if (viewModel.errorMessage != null)
        _buildErrorMessage(viewModel.errorMessage!),
      SizedBox(height: SizeTokens.p24),
      Center(
        child: TextButton(
          onPressed: () => setState(() {
            _codeVerified = false;
            _codeError = null;
          }),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Kodu değiştir',
            style: TextStyle(
              color: brandBlue,
              fontSize: SizeTokens.f14,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    ];
  }
}
