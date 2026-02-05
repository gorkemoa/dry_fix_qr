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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<AddressViewModel>();
      viewModel.resetSelection();
      viewModel.fetchCities().then((_) {
        if (isEditMode && widget.address != null) {
          final city = viewModel.cities.cast<City?>().firstWhere(
            (c) => c?.name == widget.address!.city,
            orElse: () => null,
          );
          if (city != null) {
            viewModel.setSelectedCity(city);
          }
        }
      });
    });
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
          height: 300,
          color: AppColors.white,
          child: Column(
            children: [
              Container(
                height: 50,
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
                  itemExtent: 40,
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

        // Auto-open district selection after city is selected
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
      if (viewModel.isLoading) {
        return; // Still loading
      }
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
                      onTap: () => _showDistrictSelection(context, viewModel),
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

              // Mahalle
              AddressFormField(
                controller: _neighborhoodController,
                label: "Mahalle",
                hint: "Mahalle adını giriniz",
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
                textInputAction: TextInputAction.next,
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
