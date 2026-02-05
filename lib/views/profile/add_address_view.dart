import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../models/address_model.dart';
import '../../viewmodels/address_view_model.dart';
import 'widgets/address_form_field.dart';

class AddAddressView extends StatefulWidget {
  final Address? address;

  const AddAddressView({super.key, this.address});

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _cityController;
  late final TextEditingController _districtController;
  late final TextEditingController _neighborhoodController;
  late final TextEditingController _addressLine1Controller;
  late final TextEditingController _titleController;
  late final TextEditingController _postalCodeController;

  bool _isDefault = false;

  bool get isEditMode => widget.address != null;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.address?.fullName);
    _phoneController = TextEditingController(
      text: widget.address?.phone.replaceAll('+90', ''),
    );
    _cityController = TextEditingController(text: widget.address?.city);
    _districtController = TextEditingController(text: widget.address?.district);
    _neighborhoodController = TextEditingController(
      text: widget.address?.neighborhood,
    );
    _addressLine1Controller = TextEditingController(
      text: widget.address?.addressLine1,
    );
    _titleController = TextEditingController(text: widget.address?.title);
    _postalCodeController = TextEditingController(
      text: widget.address?.postalCode,
    );
    _isDefault = widget.address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _neighborhoodController.dispose();
    _addressLine1Controller.dispose();
    _titleController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final viewModel = context.watch<AddressViewModel>();

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
        title: Text(
          isEditMode ? "Adresi Düzenle" : "Yeni Adres Ekle",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeTokens.p24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ad Soyad (Combined)
              AddressFormField(
                controller: _fullNameController,
                label: "Ad Soyad",
                hint: "Adınızı ve soyadınızı giriniz",
                validator: (v) => v?.isEmpty ?? true ? "Gerekli" : null,
              ),
              SizedBox(height: SizeTokens.p16),

              // Telefon
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
              SizedBox(height: SizeTokens.p16),

              // İl / İlçe
              Row(
                children: [
                  Expanded(
                    child: AddressFormField(
                      controller: _cityController,
                      label: "İl",
                      hint: "Seçiniz",
                      validator: (v) => v?.isEmpty ?? true ? "Gerekli" : null,
                    ),
                  ),
                  SizedBox(width: SizeTokens.p16),
                  Expanded(
                    child: AddressFormField(
                      controller: _districtController,
                      label: "İlçe",
                      hint: "Seçiniz",
                      validator: (v) => v?.isEmpty ?? true ? "Gerekli" : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeTokens.p16),

              // Mahalle
              AddressFormField(
                controller: _neighborhoodController,
                label: "Mahalle",
                hint: "Seçiniz",
                validator: (v) => v?.isEmpty ?? true ? "Gerekli" : null,
              ),
              SizedBox(height: SizeTokens.p16),

              // Info Box
              Container(
                padding: EdgeInsets.all(SizeTokens.f10),
                decoration: BoxDecoration(
                  color: AppColors.darkBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(SizeTokens.r8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_rounded,
                      color: AppColors.darkBlue,
                      size: SizeTokens.f20,
                    ),
                    SizedBox(width: SizeTokens.p12),
                    Expanded(
                      child: Text(
                        "Kargonuzun sorunsuz ulaşması için adres bilgilerinizi eksiksiz girin.",
                        style: TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: SizeTokens.f12,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeTokens.p16),

              // Adres
              AddressFormField(
                controller: _addressLine1Controller,
                label: "Adres",
                hint: "Cadde, mahalle sokak ve diğer bilgileri giriniz.",
                maxLines: 3,
                validator: (v) => v?.isEmpty ?? true ? "Gerekli" : null,
              ),
              SizedBox(height: SizeTokens.p16),

              // Adres Başlığı
              AddressFormField(
                controller: _titleController,
                label: "Adres Başlığı",
                hint: "Adres Başlığı Giriniz",
                validator: (v) => v?.isEmpty ?? true ? "Gerekli" : null,
              ),
              SizedBox(height: SizeTokens.p16),

              // Posta Kodu
              AddressFormField(
                controller: _postalCodeController,
                label: "Posta Kodu",
                hint: "Opsiyonel",
                isRequired: false,
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: SizeTokens.p24),

              // Default Switch
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "Varsayılan Adres Yap",
                  style: TextStyle(
                    color: Color(0xFF444444),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                value: _isDefault,
                activeColor: AppColors.blue,
                onChanged: (v) => setState(() => _isDefault = v),
              ),

              SizedBox(height: SizeTokens.p32),

              ElevatedButton(
                onPressed: viewModel.isLoading ? null : _submitForm,
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
                        isEditMode ? "Güncelle" : "Adresi Kaydet",
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
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
              SizedBox(height: SizeTokens.p32),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final viewModel = context.read<AddressViewModel>();

      final fullName = _fullNameController.text.trim();
      final phone = "+90${_phoneController.text.trim()}";

      final request = CreateAddressRequest(
        title: _titleController.text,
        fullName: fullName,
        phone: phone,
        city: _cityController.text,
        district: _districtController.text,
        neighborhood: _neighborhoodController.text,
        addressLine1: _addressLine1Controller.text,
        postalCode: _postalCodeController.text,
        isDefault: _isDefault,
      );

      final bool success;
      if (isEditMode) {
        success = await viewModel.updateAddress(widget.address!.id, request);
      } else {
        success = await viewModel.createAddress(request);
      }

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditMode ? "Adres güncellendi." : "Adres eklendi."),
            backgroundColor: AppColors.darkBlue,
          ),
        );
        viewModel.refresh();
        Navigator.pop(context);
      }
    }
  }
}
