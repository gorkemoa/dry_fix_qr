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

  late final TextEditingController _companyTitleController;
  late final TextEditingController _companyAddressController;
  late final TextEditingController _taxOfficeController;
  late final TextEditingController _taxNumberController;
  late final TextEditingController _companyEmailController;

  @override
  void initState() {
    super.initState();
    _companyTitleController = TextEditingController(
      text: widget.address.companyTitle,
    );
    _companyAddressController = TextEditingController(
      text: widget.address.companyAddress,
    );
    _taxOfficeController = TextEditingController(
      text: widget.address.taxOffice,
    );
    _taxNumberController = TextEditingController(
      text: widget.address.taxNumber,
    );
    _companyEmailController = TextEditingController(
      text: widget.address.companyEmail,
    );
  }

  @override
  void dispose() {
    _companyTitleController.dispose();
    _companyAddressController.dispose();
    _taxOfficeController.dispose();
    _taxNumberController.dispose();
    _companyEmailController.dispose();
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
        title: const Text(
          "Kurumsal Bilgiler",
          style: TextStyle(
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
              AddressFormField(
                controller: _companyTitleController,
                label: "Şirket Adı",
                hint: "Şirket adını giriniz",
                isRequired: false,
              ),
              SizedBox(height: SizeTokens.p16),

              AddressFormField(
                controller: _companyAddressController,
                label: "Şirket Adresi",
                hint: "Şirket adresini giriniz",
                isRequired: false,
                maxLines: 2,
              ),
              SizedBox(height: SizeTokens.p16),

              Row(
                children: [
                  Expanded(
                    child: AddressFormField(
                      controller: _taxOfficeController,
                      label: "Vergi Dairesi",
                      hint: "Vergi dairesi",
                      isRequired: false,
                    ),
                  ),
                  SizedBox(width: SizeTokens.p16),
                  Expanded(
                    child: AddressFormField(
                      controller: _taxNumberController,
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
                controller: _companyEmailController,
                label: "Şirket E-postası",
                hint: "Şirket e-posta adresini giriniz",
                isRequired: false,
                keyboardType: TextInputType.emailAddress,
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

      final request = CreateAddressRequest(
        title: widget.address.title,
        fullName: widget.address.fullName,
        phone: widget.address.phone,
        city: widget.address.city,
        district: widget.address.district,
        neighborhood: widget.address.neighborhood,
        addressLine1: widget.address.addressLine1,
        addressLine2: widget.address.addressLine2,
        postalCode: widget.address.postalCode,
        isDefault: widget.address.isDefault,
        companyTitle: _companyTitleController.text.trim().isEmpty
            ? null
            : _companyTitleController.text.trim(),
        companyAddress: _companyAddressController.text.trim().isEmpty
            ? null
            : _companyAddressController.text.trim(),
        taxOffice: _taxOfficeController.text.trim().isEmpty
            ? null
            : _taxOfficeController.text.trim(),
        taxNumber: _taxNumberController.text.trim().isEmpty
            ? null
            : _taxNumberController.text.trim(),
        companyEmail: _companyEmailController.text.trim().isEmpty
            ? null
            : _companyEmailController.text.trim(),
      );

      final success =
          await viewModel.updateAddress(widget.address.id, request);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Kurumsal bilgiler güncellendi."),
            backgroundColor: AppColors.darkBlue,
          ),
        );
        viewModel.refresh();
        Navigator.pop(context);
      }
    }
  }
}
