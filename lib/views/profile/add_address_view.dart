import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../models/address_model.dart';
import '../../viewmodels/address_view_model.dart';
import 'widgets/address_form_field.dart';

class AddAddressView extends StatefulWidget {
  final Address? address; // If null, it's Add mode. If present, it's Edit mode.

  const AddAddressView({super.key, this.address});

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _cityController;
  late final TextEditingController _districtController;
  late final TextEditingController _neighborhoodController;
  late final TextEditingController _addressLine1Controller;
  late final TextEditingController _postalCodeController;

  bool _isDefault = false;

  bool get isEditMode => widget.address != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.address?.title);
    _fullNameController = TextEditingController(text: widget.address?.fullName);
    _phoneController = TextEditingController(text: widget.address?.phone);
    _cityController = TextEditingController(text: widget.address?.city);
    _districtController = TextEditingController(text: widget.address?.district);
    _neighborhoodController = TextEditingController(
      text: widget.address?.neighborhood,
    );
    _addressLine1Controller = TextEditingController(
      text: widget.address?.addressLine1,
    );
    _postalCodeController = TextEditingController(
      text: widget.address?.postalCode,
    );
    _isDefault = widget.address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _neighborhoodController.dispose();
    _addressLine1Controller.dispose();
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.darkBlue,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditMode ? "Adresi Düzenle" : "Yeni Adres Ekle",
          style: TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.bold,
            fontSize: SizeTokens.f18,
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
              AddressFormField(
                controller: _titleController,
                label: "Adres Başlığı",
                hint: "Örn: Ev, İş, Ofis",
                icon: Icons.title_rounded,
                validator: (v) =>
                    v?.isEmpty ?? true ? "Lütfen başlık giriniz" : null,
              ),
              SizedBox(height: SizeTokens.p16),
              AddressFormField(
                controller: _fullNameController,
                label: "Ad Soyad",
                hint: "Teslim alacak kişinin adı",
                icon: Icons.person_outline_rounded,
                validator: (v) =>
                    v?.isEmpty ?? true ? "Lütfen ad soyad giriniz" : null,
              ),
              SizedBox(height: SizeTokens.p16),
              AddressFormField(
                controller: _phoneController,
                label: "Telefon Numarası",
                hint: "5XXXXXXXXX",
                icon: Icons.phone_android_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v?.isEmpty ?? true ? "Lütfen telefon giriniz" : null,
              ),
              SizedBox(height: SizeTokens.p16),
              Row(
                children: [
                  Expanded(
                    child: AddressFormField(
                      controller: _cityController,
                      label: "Şehir",
                      hint: "Örn: İstanbul",
                      validator: (v) => v?.isEmpty ?? true ? "Zorunlu" : null,
                    ),
                  ),
                  SizedBox(width: SizeTokens.p16),
                  Expanded(
                    child: AddressFormField(
                      controller: _districtController,
                      label: "İlçe",
                      hint: "Örn: Kadıköy",
                      validator: (v) => v?.isEmpty ?? true ? "Zorunlu" : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeTokens.p16),
              AddressFormField(
                controller: _neighborhoodController,
                label: "Mahalle",
                hint: "Örn: Moda Mah.",
                validator: (v) =>
                    v?.isEmpty ?? true ? "Lütfen mahalle giriniz" : null,
              ),
              SizedBox(height: SizeTokens.p16),
              AddressFormField(
                controller: _addressLine1Controller,
                label: "Adres",
                hint: "Sokak, bina no, daire no...",
                maxLines: 3,
                validator: (v) =>
                    v?.isEmpty ?? true ? "Lütfen adres giriniz" : null,
              ),
              SizedBox(height: SizeTokens.p16),
              AddressFormField(
                controller: _postalCodeController,
                label: "Posta Kodu",
                hint: "Örn: 34710",
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: SizeTokens.p24),

              // Default Switch
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeTokens.p16,
                  vertical: SizeTokens.p8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(SizeTokens.r12),
                  border: Border.all(color: AppColors.gray.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Varsayılan Adres Yap",
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: SizeTokens.f14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Switch.adaptive(
                      value: _isDefault,
                      onChanged: (v) => setState(() => _isDefault = v),
                      activeColor: AppColors.blue,
                    ),
                  ],
                ),
              ),

              SizedBox(height: SizeTokens.p40),

              ElevatedButton(
                onPressed: viewModel.isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  padding: EdgeInsets.symmetric(vertical: SizeTokens.p16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeTokens.r16),
                  ),
                  elevation: 0,
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
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeTokens.f16,
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

              SizedBox(height: SizeTokens.p24),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final viewModel = context.read<AddressViewModel>();

      final request = CreateAddressRequest(
        title: _titleController.text,
        fullName: _fullNameController.text,
        phone: _phoneController.text,
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
            content: Text(
              isEditMode
                  ? "Adres başarıyla güncellendi."
                  : "Adres başarıyla eklendi.",
            ),
          ),
        );
        viewModel.refresh();
        Navigator.pop(context);
      }
    }
  }
}
