import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../models/address_model.dart';
import '../../viewmodels/address_view_model.dart';
import 'widgets/address_form_field.dart';

class EditBillingInfoView extends StatefulWidget {
  final Address? address;

  const EditBillingInfoView({super.key, this.address});

  @override
  State<EditBillingInfoView> createState() => _EditBillingInfoViewState();
}

class _EditBillingInfoViewState extends State<EditBillingInfoView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _billingCompanyTitleController;
  late final TextEditingController _billingTaxOfficeController;
  late final TextEditingController _billingTaxNumberController;
  late final TextEditingController _billingInvoiceEmailController;
  late final TextEditingController _billingIdentityNumberController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressLine1Controller;
  late final TextEditingController _fullNameController;

  String _selectedBillingType = 'corporate';

  bool get isEditMode => widget.address != null;

  @override
  void initState() {
    super.initState();
    final addr = widget.address;
    _selectedBillingType = addr?.billingType ?? 'corporate';

    _titleController = TextEditingController(text: addr?.title);
    _billingCompanyTitleController = TextEditingController(
      text: addr?.billingCompanyTitle,
    );
    _billingTaxOfficeController = TextEditingController(
      text: addr?.billingTaxOffice,
    );
    _billingTaxNumberController = TextEditingController(
      text: addr?.billingTaxNumber,
    );
    _billingInvoiceEmailController = TextEditingController(
      text: addr?.billingInvoiceEmail,
    );
    _billingIdentityNumberController = TextEditingController(
      text: addr?.billingIdentityNumber,
    );
    _phoneController = TextEditingController(
      text: addr?.phone.replaceAll('+90', ''),
    );
    _addressLine1Controller = TextEditingController(
      text: addr?.addressLine1,
    );
    _fullNameController = TextEditingController(
      text: addr?.fullName,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
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

  bool get _isCorporate => _selectedBillingType == 'corporate';

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
          isEditMode
              ? (_isCorporate ? "Kurumsal Fatura Bilgileri" : "Bireysel Fatura Bilgileri")
              : "Fatura Bilgileri",
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
              // Fatura tipi toggle (sadece oluştururken) veya badge (düzenlerken)
              if (!isEditMode) ...[
                _buildBillingTypeToggle(),
                SizedBox(height: SizeTokens.p24),
              ] else ...[
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
              ],

              // Fatura Başlığı
              AddressFormField(
                controller: _titleController,
                label: "Fatura Başlığı",
                hint: "Fatura başlığı giriniz (Şirket, Bireysel vb.)",
                validator: (v) => v?.isEmpty ?? true ? "Gerekli" : null,
              ),
              SizedBox(height: SizeTokens.p16),

              // Corporate fields
              if (_isCorporate) ...[
                AddressFormField(
                  controller: _billingCompanyTitleController,
                  label: "Firma Unvanı",
                  hint: "Firma unvanını giriniz",
                  validator: (v) => v?.isEmpty ?? true ? "Gerekli" : null,
                ),
                SizedBox(height: SizeTokens.p16),
                Row(
                  children: [
                    Expanded(
                      child: AddressFormField(
                        controller: _billingTaxOfficeController,
                        label: "Vergi Dairesi",
                        hint: "Vergi dairesi",
                        validator: (v) =>
                            v?.isEmpty ?? true ? "Gerekli" : null,
                      ),
                    ),
                    SizedBox(width: SizeTokens.p16),
                    Expanded(
                      child: AddressFormField(
                        controller: _billingTaxNumberController,
                        label: "Vergi No",
                        hint: "Vergi numarası",
                        validator: (v) =>
                            v?.isEmpty ?? true ? "Gerekli" : null,
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
                  validator: (v) => v?.isEmpty ?? true ? "Gerekli" : null,
                ),
                SizedBox(height: SizeTokens.p16),
                AddressFormField(
                  controller: _billingIdentityNumberController,
                  label: "TC Kimlik Numarası",
                  hint: "TC kimlik numaranızı giriniz",
                  validator: (v) => v?.isEmpty ?? true ? "Gerekli" : null,
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
                  minimumSize: Size(double.infinity, SizeTokens.p56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeTokens.r8),
                  ),
                ),
                child: viewModel.isLoading
                    ? SizedBox(
                        height: SizeTokens.p20,
                        width: SizeTokens.p20,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        isEditMode ? "Güncelle" : "Kaydet",
                        style: const TextStyle(
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

  Widget _buildBillingTypeToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Fatura Tipi",
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: SizeTokens.f14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: SizeTokens.p8),
        Row(
          children: [
            Expanded(
              child: _buildTypeButton(
                label: "Kurumsal",
                icon: Icons.business_outlined,
                isSelected: _isCorporate,
                onTap: () => setState(() => _selectedBillingType = 'corporate'),
              ),
            ),
            SizedBox(width: SizeTokens.p12),
            Expanded(
              child: _buildTypeButton(
                label: "Bireysel",
                icon: Icons.person_outline_rounded,
                isSelected: !_isCorporate,
                onTap: () => setState(() => _selectedBillingType = 'individual'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: SizeTokens.p12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkBlue : AppColors.white,
          borderRadius: BorderRadius.circular(SizeTokens.r8),
          border: Border.all(
            color: isSelected ? AppColors.darkBlue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: SizeTokens.f18,
              color: isSelected ? AppColors.white : AppColors.gray,
            ),
            SizedBox(width: SizeTokens.p8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.darkBlue,
                fontWeight: FontWeight.bold,
                fontSize: SizeTokens.f14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final viewModel = context.read<AddressViewModel>();

      final phone = _phoneController.text.trim().isEmpty
          ? (isEditMode ? widget.address!.phone : null)
          : "+90${_phoneController.text.trim()}";

      final request = CreateAddressRequest(
        addressType: 'billing',
        billingType: _selectedBillingType,
        title: _titleController.text.trim().isEmpty
            ? (isEditMode ? widget.address!.title : _selectedBillingType == 'corporate' ? 'Kurumsal Fatura' : 'Bireysel Fatura')
            : _titleController.text.trim(),
        fullName: !_isCorporate ? _fullNameController.text.trim() : null,
        phone: phone,
        addressLine1: _addressLine1Controller.text.trim().isEmpty
            ? (isEditMode ? widget.address!.addressLine1 : null)
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
        isDefault: isEditMode ? widget.address!.isDefault : true,
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
            content: Text(isEditMode ? "Fatura bilgileri güncellendi." : "Fatura bilgileri kaydedildi."),
            backgroundColor: AppColors.darkBlue,
          ),
        );
        viewModel.refresh();
        Navigator.pop(context);
      }
    }
  }
}
