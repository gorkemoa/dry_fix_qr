import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/support_view_model.dart';
import '../../core/responsive/size_tokens.dart';

class CreateSupportView extends StatefulWidget {
  const CreateSupportView({super.key});

  @override
  State<CreateSupportView> createState() => _CreateSupportViewState();
}

class _CreateSupportViewState extends State<CreateSupportView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await context.read<SupportViewModel>().createMessage(
        title: _titleController.text,
        message: _messageController.text,
      );
      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Destek talebiniz başarıyla oluşturuldu."),
          ),
        );
      } else if (!success && mounted) {
        final error = context.read<SupportViewModel>().errorMessage;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error ?? "Bir hata oluştu.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SupportViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Yeni Destek Talebi",
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
              Text(
                "Konu",
                style: TextStyle(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: SizeTokens.f14,
                ),
              ),
              SizedBox(height: SizeTokens.p8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Talebinizin konusu",
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SizeTokens.r12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? "Lütfen bir konu girin" : null,
              ),
              SizedBox(height: SizeTokens.p20),
              Text(
                "Mesajınız",
                style: TextStyle(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: SizeTokens.f14,
                ),
              ),
              SizedBox(height: SizeTokens.p8),
              TextFormField(
                controller: _messageController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: "Sorununuzu detaylıca açıklayın",
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SizeTokens.r12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? "Lütfen bir mesaj girin" : null,
              ),
              SizedBox(height: SizeTokens.p32),
              ElevatedButton(
                onPressed: viewModel.isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                  padding: EdgeInsets.symmetric(vertical: SizeTokens.p16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeTokens.r12),
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
                    : const Text(
                        "Gönder",
                        style: TextStyle(
                          color: Colors.white,
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
}
