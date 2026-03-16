import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../models/address_model.dart';
import '../../models/city_model.dart';
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

  // Common fields
  late final TextEditingController _titleController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressLine1Controller;

  // Shipping-specific fields
  late final TextEditingController _fullNameController;
  late final TextEditingController _cityController;
  late final TextEditingController _districtController;
  late final TextEditingController _neighborhoodController;
  late final TextEditingController _postalCodeController;

  // Billing-specific fields
  late final TextEditingController _billingCompanyTitleController;
  late final TextEditingController _billingTaxOfficeController;
  late final TextEditingController _billingTaxNumberController;
  late final TextEditingController _billingInvoiceEmailController;
  late final TextEditingController _billingIdentityNumberController;

  bool _isDefault = false;
  String _selectedAddressType = 'shipping';
  String _selectedBillingType = 'corporate';

  bool get isEditMode => widget.address != null;

  @override
  void initState() {
    super.initState();

    final addr = widget.address;
    _selectedAddressType = addr?.addressType ?? 'shipping';
    _selectedBillingType = addr?.billingType ?? 'corporate';

    _titleController = TextEditingController(text: addr?.title);
    _phoneController = TextEditingController(
      text: addr?.phone.replaceAll('+90', ''),
    );
    _addressLine1Controller = TextEditingController(text: addr?.addressLine1);

    _fullNameController = TextEditingController(text: addr?.fullName);
    _cityController = TextEditingController(text: addr?.city);
    _districtController = TextEditingController(text: addr?.district);
    _neighborhoodController = TextEditingController(text: addr?.neighborhood);
    _postalCodeController = TextEditingController(text: addr?.postalCode);

    _billingCompanyTitleController =
        TextEditingController(text: addr?.billingCompanyTitle);
    _billingTaxOfficeController =
        TextEditingController(text: addr?.billingTaxOffice);
    _billingTaxNumberController =
        TextEditingController(text: addr?.billingTaxNumber);
    _billingInvoiceEmailController =
        TextEditingController(text: addr?.billingInvoiceEmail);
    _billingIdentityNumberController =
        TextEditingController(text: addr?.billingIdentityNumber);

    _isDefault = addr?.isDefault ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedAddressType == 'shipping') {
        final viewModel = context.read<AddressViewModel>();
        viewModel.resetSelection();
        viewModel.fetchCities().then((_) {
          if (isEditMode && addr != null) {
            final city = viewModel.cities.cast<City?>().firstWhere(
              (c) => c?.name == addr.city,
              orElse: () => null,
            );
            if (city != null) {
              viewModel.setSelectedCity(city);
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _phoneController.dispose();
    _addressLine1Controller.dispose();
    _fullNameController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _neighborhoodController.dispose();
    _postalCodeController.dispose();
    _billingCompanyTitleController.dispose();
    _billingTaxOfficeController.dispose();
    _billingTaxNumberController.dispose();
    _billingInvoiceEmailController.dispose();
    _billingIdentityNumberController.dispose();
    super.dispose();
  }

  void _showIOSPicker({
    required BuildContext context,
    required String title,
    required List<String> items,
    required Function(int) onSelected,
    int initialIndex = 0,
  }) {
    int selectedIndex = initialIndex;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: Container(
          height: SizeTokens.p300,
          color: AppColors.white,
          child: Column(
            children: [
              Container(
                height: SizeTokens.p50,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: SizeTokens.p16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "İptal",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: SizeTokens.f14,
                        ),
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeTokens.f16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        onSelected(selectedIndex);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Tamam",
                        style: TextStyle(
                          color: AppColors.blue,
                          fontWeight: FontWeight.w700,
                          fontSize: SizeTokens.f14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: SizeTokens.p40,
                  scrollController: FixedExtentScrollController(
                    initialItem: initialIndex,
                  ),
                  onSelectedItemChanged: (index) {
                    selectedIndex = index;
                  },
                  children: items
                      .map(
                        (item) => Center(
                          child: Text(
                            item,
                            style: TextStyle(
                              color: AppColors.darkBlue,
                              fontSize: SizeTokens.f16,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCitySelection(BuildContext context, AddressViewModel viewModel) {
    if (viewModel.cities.isEmpty) return;

    final cityNames = viewModel.cities.map((c) => c.name).toList();
    int initialIdx = 0;
    if (viewModel.selectedCity != null) {
      initialIdx = viewModel.cities.indexWhere(
        (c) => c.id == viewModel.selectedCity!.id,
      );
      if (initialIdx == -1) initialIdx = 0;
    }

    _showIOSPicker(
      context: context,
      title: "Şehir Seçiniz",
      items: cityNames,
      initialIndex: initialIdx,
      onSelected: (index) {
        final city = viewModel.cities[index];
        viewModel.setSelectedCity(city);
        _cityController.text = city.name;
        _districtController.clear();

        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            _showDistrictSelection(context, viewModel);
          }
        });
      },
    );
  }

  void _showDistrictSelection(
    BuildContext context,
    AddressViewModel viewModel,
  ) {
    if (viewModel.selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen önce bir şehir seçiniz.")),
      );
      return;
    }

    if (viewModel.districts.isEmpty) {
      if (viewModel.isLoading) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bu şehir için ilçe bulunamadı.")),
      );
      return;
    }

    final districtNames = viewModel.districts.map((d) => d.name).toList();
    int initialIdx = 0;
    if (viewModel.selectedDistrict != null) {
      initialIdx = viewModel.districts.indexWhere(
        (d) => d.id == viewModel.selectedDistrict!.id,
      );
      if (initialIdx == -1) initialIdx = 0;
    }

    _showIOSPicker(
      context: context,
      title: "İlçe Seçiniz",
      items: districtNames,
      initialIndex: initialIdx,
      onSelected: (index) {
        final district = viewModel.districts[index];
        viewModel.setSelectedDistrict(district);
        _districtController.text = district.name;
      },
    );
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
              // Address Type Toggle (only shown when creating)
              if (!isEditMode) ...[
                _buildAddressTypeToggle(),
                SizedBox(height: SizeTokens.p24),
              ] else ...[
                _buildAddressTypeBadge(),
                SizedBox(height: SizeTokens.p16),
              ],

              // Billing Type Toggle (only for billing addresses)
              if (_selectedAddressType == 'billing' && !isEditMode) ...[
                _buildBillingTypeToggle(),
                SizedBox(height: SizeTokens.p24),
              ] else if (_selectedAddressType == 'billing' && isEditMode) ...[
                _buildBillingTypeBadge(),
                SizedBox(height: SizeTokens.p16),
              ],

              // Common: Adres Başlığı
              AddressFormField(
                controller: _titleController,
                label: "Adres Başlığı",
                hint: "Adres başlığı giriniz (Ev, İş vb.)",
                validator: (v) => v?.isEmpty ?? true ? "Gerekli" : null,
              ),
              SizedBox(height: SizeTokens.p16),

              // Common: Telefon
              AddressFormField(
                controller: _phoneController,
                label: "Telefon",
                hint: "(___) ___ __ __",
                keyboardType: TextInputType.phone,
                prefix: Container(
                  width: SizeTokens.p60,
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

              // Shipping-specific fields
              if (_selectedAddressType == 'shipping') ...[
                AddressFormField(
                  controller: _fullNameController,
                  label: "Ad Soyad",
                  hint: "Adınızı ve soyadınızı giriniz",
                  validator: (v) => v?.isEmpty ?? true ? "Gerekli" : null,
                ),
                SizedBox(height: SizeTokens.p16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showCitySelection(context, viewModel),
                        child: AbsorbPointer(
                          child: AddressFormField(
                            controller: _cityController,
                            label: "İl",
                            hint: "Seçiniz",
                            suffix: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.gray,
                            ),
                            validator: (v) =>
                                v?.isEmpty ?? true ? "Gerekli" : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: SizeTokens.p16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            _showDistrictSelection(context, viewModel),
                        child: AbsorbPointer(
                          child: AddressFormField(
                            controller: _districtController,
                            label: "İlçe",
                            hint: "Seçiniz",
                            suffix: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.gray,
                            ),
                            validator: (v) =>
                                v?.isEmpty ?? true ? "Gerekli" : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeTokens.p16),
                AddressFormField(
                  controller: _neighborhoodController,
                  label: "Mahalle",
                  hint: "Mahalle adını giriniz",
                  validator: (v) => v?.isEmpty ?? true ? "Gerekli" : null,
                ),
                SizedBox(height: SizeTokens.p16),
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
              ],

              // Common: Adres Satırı
              AddressFormField(
                controller: _addressLine1Controller,
                label: "Adres",
                hint: _selectedAddressType == 'shipping'
                    ? "Cadde, mahalle sokak ve diğer bilgileri giriniz."
                    : "Fatura adresi giriniz",
                maxLines: _selectedAddressType == 'shipping' ? 3 : 2,
                validator: (v) => v?.isEmpty ?? true ? "Gerekli" : null,
              ),
              SizedBox(height: SizeTokens.p16),

              // Shipping-specific: Posta Kodu
              if (_selectedAddressType == 'shipping') ...[
                AddressFormField(
                  controller: _postalCodeController,
                  label: "Posta Kodu",
                  hint: "Opsiyonel",
                  isRequired: false,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: SizeTokens.p16),
              ],

              // Billing corporate fields
              if (_selectedAddressType == 'billing' &&
                  _selectedBillingType == 'corporate') ...[
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
                        label: "Vergi Numarası",
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

              // Billing individual fields
              if (_selectedAddressType == 'billing' &&
                  _selectedBillingType == 'individual') ...[
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

              // Default Switch
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Varsayılan Adres Yap",
                  style: TextStyle(
                    color: Color(0xFF444444),
                    fontWeight: FontWeight.bold,
                    fontSize: SizeTokens.f14,
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
              SizedBox(height: SizeTokens.p32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressTypeToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Adres Tipi",
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
                label: "Teslimat",
                icon: Icons.local_shipping_outlined,
                isSelected: _selectedAddressType == 'shipping',
                onTap: () {
                  setState(() {
                    _selectedAddressType = 'shipping';
                  });
                  final viewModel = context.read<AddressViewModel>();
                  viewModel.resetSelection();
                  viewModel.fetchCities();
                },
              ),
            ),
            SizedBox(width: SizeTokens.p12),
            Expanded(
              child: _buildTypeButton(
                label: "Fatura",
                icon: Icons.receipt_long_outlined,
                isSelected: _selectedAddressType == 'billing',
                onTap: () => setState(() => _selectedAddressType = 'billing'),
              ),
            ),
          ],
        ),
      ],
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
                isSelected: _selectedBillingType == 'corporate',
                onTap: () =>
                    setState(() => _selectedBillingType = 'corporate'),
              ),
            ),
            SizedBox(width: SizeTokens.p12),
            Expanded(
              child: _buildTypeButton(
                label: "Bireysel",
                icon: Icons.person_outline_rounded,
                isSelected: _selectedBillingType == 'individual',
                onTap: () =>
                    setState(() => _selectedBillingType = 'individual'),
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
            color: isSelected
                ? AppColors.darkBlue
                : Colors.grey.shade300,
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

  Widget _buildAddressTypeBadge() {
    final isShipping = _selectedAddressType == 'shipping';
    return Row(
      children: [
        Icon(
          isShipping
              ? Icons.local_shipping_outlined
              : Icons.receipt_long_outlined,
          size: SizeTokens.f16,
          color: AppColors.darkBlue,
        ),
        SizedBox(width: SizeTokens.p8),
        Text(
          isShipping ? "Teslimat Adresi" : "Fatura Adresi",
          style: TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.bold,
            fontSize: SizeTokens.f14,
          ),
        ),
      ],
    );
  }

  Widget _buildBillingTypeBadge() {
    final isCorporate = _selectedBillingType == 'corporate';
    return Row(
      children: [
        Icon(
          isCorporate ? Icons.business_outlined : Icons.person_outline_rounded,
          size: SizeTokens.f16,
          color: AppColors.gray,
        ),
        SizedBox(width: SizeTokens.p8),
        Text(
          isCorporate ? "Kurumsal Fatura" : "Bireysel Fatura",
          style: TextStyle(
            color: AppColors.gray,
            fontSize: SizeTokens.f13,
          ),
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final viewModel = context.read<AddressViewModel>();

      final phone = _phoneController.text.trim().isEmpty
          ? null
          : "+90${_phoneController.text.trim()}";

      final CreateAddressRequest request;

      if (_selectedAddressType == 'shipping') {
        request = CreateAddressRequest(
          addressType: 'shipping',
          title: _titleController.text.trim(),
          fullName: _fullNameController.text.trim(),
          phone: phone,
          city: _cityController.text.trim(),
          district: _districtController.text.trim(),
          neighborhood: _neighborhoodController.text.trim(),
          addressLine1: _addressLine1Controller.text.trim(),
          postalCode: _postalCodeController.text.trim().isEmpty
              ? null
              : _postalCodeController.text.trim(),
          isDefault: _isDefault,
        );
      } else if (_selectedBillingType == 'corporate') {
        request = CreateAddressRequest(
          addressType: 'billing',
          billingType: 'corporate',
          title: _titleController.text.trim(),
          phone: phone,
          addressLine1: _addressLine1Controller.text.trim(),
          billingCompanyTitle:
              _billingCompanyTitleController.text.trim().isEmpty
                  ? null
                  : _billingCompanyTitleController.text.trim(),
          billingTaxOffice: _billingTaxOfficeController.text.trim().isEmpty
              ? null
              : _billingTaxOfficeController.text.trim(),
          billingTaxNumber: _billingTaxNumberController.text.trim().isEmpty
              ? null
              : _billingTaxNumberController.text.trim(),
          billingInvoiceEmail:
              _billingInvoiceEmailController.text.trim().isEmpty
                  ? null
                  : _billingInvoiceEmailController.text.trim(),
          isDefault: _isDefault,
        );
      } else {
        request = CreateAddressRequest(
          addressType: 'billing',
          billingType: 'individual',
          title: _titleController.text.trim(),
          fullName: _fullNameController.text.trim(),
          phone: phone,
          addressLine1: _addressLine1Controller.text.trim(),
          billingIdentityNumber:
              _billingIdentityNumberController.text.trim().isEmpty
                  ? null
                  : _billingIdentityNumberController.text.trim(),
          billingInvoiceEmail:
              _billingInvoiceEmailController.text.trim().isEmpty
                  ? null
                  : _billingInvoiceEmailController.text.trim(),
          isDefault: _isDefault,
        );
      }

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

