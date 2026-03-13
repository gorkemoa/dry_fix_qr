import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_tokens.dart';
import '../../core/widgets/dp_symbol.dart';
import '../../viewmodels/product_view_model.dart';
import '../../viewmodels/address_view_model.dart';
import '../../models/address_model.dart';
import '../profile/add_address_view.dart';
import '../profile/edit_billing_info_view.dart';
import '../orders/order_success_view.dart';
import '../../models/product_model.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final TextEditingController _noteController = TextEditingController();
  Address? _selectedAddress;

  // Billing
  final TextEditingController _companyTitleController = TextEditingController();
  final TextEditingController _taxOfficeController = TextEditingController();
  final TextEditingController _taxNumberController = TextEditingController();
  final TextEditingController _companyAddressController = TextEditingController();
  final TextEditingController _companyEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addressViewModel = context.read<AddressViewModel>();
      addressViewModel.fetchAddresses().then((_) {
        // Auto-select default address
        addressViewModel.addresses.firstWhere(
          (a) => a.isDefault,
          orElse: () => addressViewModel.addresses.isNotEmpty
              ? addressViewModel.addresses.first
              : addressViewModel
                    .addresses
                    .first, // Hacky: assumes list might not be empty, handles later
        );
        if (addressViewModel.addresses.isNotEmpty) {
          final addr = addressViewModel.addresses.firstWhere(
            (element) => element.isDefault,
            orElse: () => addressViewModel.addresses.first,
          );
          setState(() {
            _selectedAddress = addr;
            _fillBillingFromAddress(addr);
          });
        }
      });
    });
  }

  void _fillBillingFromAddress(Address addr) {
    _companyTitleController.text = addr.companyTitle ?? '';
    _taxOfficeController.text = addr.taxOffice ?? '';
    _taxNumberController.text = addr.taxNumber ?? '';
    _companyAddressController.text = addr.companyAddress ?? '';
    _companyEmailController.text = addr.companyEmail ?? '';
  }

  void _showBillingEditDialog(BuildContext context) {
    if (_selectedAddress == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditBillingInfoView(address: _selectedAddress!),
      ),
    ).then((_) {
      final addressViewModel = context.read<AddressViewModel>();
      addressViewModel.fetchAddresses().then((_) {
        final updated = addressViewModel.addresses.firstWhere(
          (a) => a.id == _selectedAddress!.id,
          orElse: () => _selectedAddress!,
        );
        setState(() {
          _selectedAddress = updated;
          _fillBillingFromAddress(updated);
        });
      });
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    _companyTitleController.dispose();
    _taxOfficeController.dispose();
    _taxNumberController.dispose();
    _companyAddressController.dispose();
    _companyEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductViewModel>();
    final addressViewModel = context.watch<AddressViewModel>();
    final cartItems = viewModel.cart;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Siparişi Onayla",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeTokens.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Order Summary
            Text(
              "Sipariş Özeti",
              style: TextStyle(
                fontSize: SizeTokens.f16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
            ),
            SizedBox(height: SizeTokens.p8),
            Container(
              padding: EdgeInsets.all(SizeTokens.p12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(SizeTokens.r8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  ...cartItems.map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: SizeTokens.p8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.name, // Simplified, as cart logic is simple
                              style: TextStyle(fontSize: SizeTokens.f14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                         
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Toplam",
                        style: TextStyle(
                          fontSize: SizeTokens.f16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                        
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "${viewModel.cartTotalTokenPrice} ",
                                  style: TextStyle(
                                    fontSize: SizeTokens.f20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkBlue,
                                  ),
                                ),
                                DpSymbol(
                                  size: SizeTokens.p32,
                                  color: AppColors.blue,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: SizeTokens.p24),

            // Address Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Teslimat Adresi",
                  style: TextStyle(
                    fontSize: SizeTokens.f16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddAddressView(),
                      ),
                    );
                  },
                  child: const Text("Adres Ekle"),
                ),
              ],
            ),
            if (addressViewModel.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (addressViewModel.addresses.isEmpty)
              Container(
                padding: EdgeInsets.all(SizeTokens.p16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(SizeTokens.r8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Text(
                  "Kayıtlı adresiniz bulunmamaktadır. Lütfen adres ekleyin.",
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(SizeTokens.r8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: addressViewModel.addresses.map((address) {
                    return RadioListTile<Address>(
                      title: Text(
                        address.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${address.addressLine1} ${address.district}/${address.city}",
                      ),
                      value: address,
                      groupValue: _selectedAddress,
                      activeColor: AppColors.darkBlue,
                      onChanged: (Address? value) {
                        setState(() {
                          _selectedAddress = value;
                          if (value != null) _fillBillingFromAddress(value);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),

            SizedBox(height: SizeTokens.p24),

            // ── Fatura Bilgileri ─────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Fatura Bilgileri",
                  style: TextStyle(
                    fontSize: SizeTokens.f16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                TextButton(
                  onPressed: () => _showBillingEditDialog(context),
                  child: Text(
                    "Düzenle",
                    style: TextStyle(color: AppColors.blue),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(SizeTokens.r8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: EdgeInsets.all(SizeTokens.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _companyTitleController.text.isNotEmpty
                          ? _companyTitleController.text
                          : "Firma bilgisi girilmemiş",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (_taxNumberController.text.isNotEmpty)
                      Text(
                        "${_taxOfficeController.text} / ${_taxNumberController.text}",
                        style: TextStyle(
                          fontSize: SizeTokens.f13,
                          color: AppColors.gray,
                        ),
                      ),
                    if (_companyAddressController.text.isNotEmpty)
                      Text(
                        _companyAddressController.text,
                        style: TextStyle(
                          fontSize: SizeTokens.f13,
                          color: AppColors.gray,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            SizedBox(height: SizeTokens.p24),

            // Notes
            Text(
              "Sipariş Notu",
              style: TextStyle(
                fontSize: SizeTokens.f16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
            ),
            SizedBox(height: SizeTokens.p8),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Sipariş notunuzu buraya yazabilirsiniz...",
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SizeTokens.r8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SizeTokens.r8),
                  borderSide: BorderSide(color: AppColors.blue),
                ),
              ),
            ),

            SizedBox(height: SizeTokens.p24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(SizeTokens.p16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: viewModel.isLoading || _selectedAddress == null
                  ? null
                  : () async {
                      // Prepare data
                      final address = _selectedAddress!;
                      final notes = _noteController.text;

                      final orderedItems = List<ProductModel>.from(
                        viewModel.cart,
                      );
                      final Map<String, dynamic> billingPayload = {
                        "company_title": _companyTitleController.text.trim(),
                        "tax_office": _taxOfficeController.text.trim(),
                        "tax_number": _taxNumberController.text.trim(),
                        "company_address": _companyAddressController.text.trim(),
                        "company_email": _companyEmailController.text.trim(),
                      };

                      final success = await viewModel.completeOrder(
                        address: address,
                        notes: notes,
                        billing: billingPayload,
                      );

                      if (!context.mounted) return;

                      if (success) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderSuccessView(items: orderedItems),
                          ),
                          (route) => route.isFirst,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              viewModel.errorMessage ?? "Sipariş verilemedi.",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeTokens.r8),
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
                      "Siparişi Onayla",
                      style: TextStyle(
                        fontSize: SizeTokens.f16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
