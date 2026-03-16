import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../models/address_model.dart';
import '../../viewmodels/address_view_model.dart';
import 'widgets/address_form_field.dart';

class EditBillingInfoView extends StatefulWidget {
  final Address address;

  const EditBillingInfoView({super.key, required this.address});

  @override
  State<EditBillingInfoView> createState() => _EditBillingInfoViewState();
}

class _EditBillingInfoViewState extends State<EditBillingInfoView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _billingCompanyTitleController;
  late final TextEditingController _billingTaxOfficeController;
  late final TextEditingController _billingTaxNumberController;
  late final TextEditingController _billingInvoiceEmailController;
  late final TextEditingController _billingIdentityNumberController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressLine1Controller;
  late final TextEditingController _fullNameController;

  @override
  void initState() {
    super.initState();
    _billingCompanyTitleController = TextEditingController(
      text: widget.address.billingCompanyTitle,
    );
    _billingTaxOfficeController = TextEditingController(
      text: widget.address.billingTaxOffice,
    );
    _billingTaxNumberController = TextEditingController(
      text: widget.address.billingTaxNumber,
    );
    _billingInvoiceEmailController = TextEditingController(
      text: widget.address.billingInvoiceEmail,
    );
    _billingIdentityNumberController = TextEditingController(
      text: widget.address.billingIdentityNumber,
    );
    _phoneController = TextEditingController(
      text: widget.address.phone.replaceAll('+90', ''),
    );
    _addressLine1Controller = TextEditingController(
      text: widget.address.addressLine1,
    );
    _fullNameController = TextEditingController(
      text: widget.address.fullName,
    );
  }

  @override
  void dispose() {
    _billingCompanyTitleController.dispose();
    _billingTaxOfficeController.dispose();
    _billingTaxNumberController.dispose();
    _billingInvoiceEmailController.dispose();
    _billingIdentityNumberController.dispose();
    _phoneController.dispose();
    _addressLine1Controller.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  bool get _isCorporate => widget.address.billingType == 'corporate';

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
          _isCorporate ? "Kurumsal Fatura Bilgileri" : "Bireysel Fatura Bilgileri",
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
              // Billing type badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeTokens.p12,
                  vertical: SizeTokens.p8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.darkBlue.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(SizeTokens.r8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isCorporate
                          ? Icons.business_outlined
                          : Icons.person_outline_rounded,
                      size: SizeTokens.f16,
                      color: AppColors.darkBlue,
                    ),
                    SizedBox(width: SizeTokens.p8),
                    Text(
                      _isCorporate ? "Kurumsal Fatura" : "Bireysel Fatura",
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeTokens.f14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeTokens.p24),

              // Corporate fields
              if (_isCorporate) ...[
                AddressFormField(
                  controller: _billingCompanyTitleController,
                  label: "Firma Unvanı",
                  hint: "Firma unvanını giriniz",
                ),
                SizedBox(height: SizeTokens.p16),
                Row(
                  children: [
                    Expanded(
                      child: AddressFormField(
                        controller: _billingTaxOfficeController,
                        label: "Vergi Dairesi",
                        hint: "Vergi dairesi",
                        isRequired: false,
                      ),
                    ),
                    SizedBox(width: SizeTokens.p16),
                    Expanded(
                      child: AddressFormField(
                        controller: _billingTaxNumberController,
                        label: "Vergi No",
                        hint: "Vergi numarası",
                        isRequired: false,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeTokens.p16),
                AddressFormField(
                  controller: _billingInvoiceEmailController,
                  label: "Fatura E-posta",
                  hint: "Fatura e-posta adresini giriniz",
                  isRequired: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: SizeTokens.p16),
              ],

              // Individual fields
              if (!_isCorporate) ...[
                AddressFormField(
                  controller: _fullNameController,
                  label: "Ad Soyad",
                  hint: "Adınızı ve soyadınızı giriniz",
                  isRequired: false,
                ),
                SizedBox(height: SizeTokens.p16),
                AddressFormField(
                  controller: _billingIdentityNumberController,
                  label: "TC Kimlik Numarası",
                  hint: "TC kimlik numaranızı giriniz",
                  isRequired: false,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: SizeTokens.p16),
                AddressFormField(
                  controller: _billingInvoiceEmailController,
                  label: "Fatura E-posta",
                  hint: "Fatura e-posta adresini giriniz",
                  isRequired: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: SizeTokens.p16),
              ],

              // Common: Phone
              AddressFormField(
                controller: _phoneController,
                label: "Telefon",
                hint: "(___) ___ __ __",
                isRequired: false,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: SizeTokens.p16),

              // Common: Address Line
              AddressFormField(
                controller: _addressLine1Controller,
                label: "Adres",
                hint: "Fatura adresi giriniz",
                isRequired: false,
                maxLines: 2,
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
                    : const Text(
                        "Güncelle",
                        style: TextStyle(
                          color: Colors.white,
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

      final phone = _phoneController.text.trim().isEmpty
          ? widget.address.phone
          : "+90${_phoneController.text.trim()}";

      final request = CreateAddressRequest(
        addressType: 'billing',
        billingType: widget.address.billingType,
        title: widget.address.title,
        fullName: _isCorporate ? null : _fullNameController.text.trim(),
        phone: phone,
        addressLine1: _addressLine1Controller.text.trim().isEmpty
            ? widget.address.addressLine1
            : _addressLine1Controller.text.trim(),
        billingCompanyTitle: _isCorporate
            ? (_billingCompanyTitleController.text.trim().isEmpty
                ? null
                : _billingCompanyTitleController.text.trim())
            : null,
        billingTaxOffice: _isCorporate
            ? (_billingTaxOfficeController.text.trim().isEmpty
                ? null
                : _billingTaxOfficeController.text.trim())
            : null,
        billingTaxNumber: _isCorporate
            ? (_billingTaxNumberController.text.trim().isEmpty
                ? null
                : _billingTaxNumberController.text.trim())
            : null,
        billingIdentityNumber: !_isCorporate
            ? (_billingIdentityNumberController.text.trim().isEmpty
                ? null
                : _billingIdentityNumberController.text.trim())
            : null,
        billingInvoiceEmail: _billingInvoiceEmailController.text.trim().isEmpty
            ? null
            : _billingInvoiceEmailController.text.trim(),
        isDefault: widget.address.isDefault,
      );

      final success = await viewModel.updateAddress(widget.address.id, request);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Fatura bilgileri güncellendi."),
            backgroundColor: AppColors.darkBlue,
          ),
        );
        viewModel.refresh();
        Navigator.pop(context);
      }
    }
  }
}
