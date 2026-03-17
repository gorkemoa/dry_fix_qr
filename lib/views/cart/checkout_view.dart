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
  Address? _selectedBillingAddress;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addressViewModel = context.read<AddressViewModel>();
      addressViewModel.fetchAddresses().then((_) {
        // Auto-select default shipping address
        if (addressViewModel.shippingAddresses.isNotEmpty) {
          final defaultShipping = addressViewModel.shippingAddresses.firstWhere(
            (a) => a.isDefault,
            orElse: () => addressViewModel.shippingAddresses.first,
          );
          setState(() => _selectedAddress = defaultShipping);
        }
        // Auto-select default billing address
        if (addressViewModel.billingAddresses.isNotEmpty) {
          final defaultBilling = addressViewModel.billingAddresses.firstWhere(
            (a) => a.isDefault,
            orElse: () => addressViewModel.billingAddresses.first,
          );
          setState(() => _selectedBillingAddress = defaultBilling);
        }
      });
    });
  }

  Map<String, dynamic> _buildBillingPayload(Address address) {
    final isCorporate = address.billingType == 'corporate';
    if (isCorporate) {
      return {
        "invoice_type": "corporate",
        "company_title": address.billingCompanyTitle ?? "",
        "company_address": address.addressLine1,
        "tax_office": address.billingTaxOffice ?? "",
        "tax_number": address.billingTaxNumber ?? "",
        "company_phone": address.phone,
        "invoice_email": address.billingInvoiceEmail ?? "",
      };
    } else {
      return {
        "invoice_type": "individual",
        "full_name": address.fullName,
        "tc_no": address.billingIdentityNumber ?? "",
        "phone": address.phone,
        "email": address.billingInvoiceEmail ?? "",
        "address": address.addressLine1,
      };
    }
  }

  void _showBillingEditDialog(BuildContext context) {    if (_selectedBillingAddress == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EditBillingInfoView(address: _selectedBillingAddress!),
      ),
    ).then((_) {
      final addressViewModel = context.read<AddressViewModel>();
      addressViewModel.fetchAddresses().then((_) {
        final updated = addressViewModel.billingAddresses.firstWhere(
          (a) => a.id == _selectedBillingAddress!.id,
          orElse: () => _selectedBillingAddress!,
        );
        setState(() => _selectedBillingAddress = updated);
      });
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
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
            else if (addressViewModel.shippingAddresses.isEmpty)
              Container(
                padding: EdgeInsets.all(SizeTokens.p16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(SizeTokens.r8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: const Text(
                  "Kayıtlı teslimat adresiniz bulunmamaktadır. Lütfen adres ekleyin.",
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
                  children: addressViewModel.shippingAddresses.map((address) {
                    return RadioListTile<Address>(
                      title: Text(
                        address.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${address.addressLine1} ${address.district}/${address.city}",
                      ),
                      value: address,
                      groupValue: _selectedAddress,
                      activeColor: AppColors.darkBlue,
                      onChanged: (Address? value) {
                        setState(() => _selectedAddress = value);
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
                  "Fatura Adresi",
                  style: TextStyle(
                    fontSize: SizeTokens.f16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                if (addressViewModel.billingAddresses.isNotEmpty)
                  if (_selectedBillingAddress != null)
                    TextButton(
                      onPressed: () => _showBillingEditDialog(context),
                      child: Text(
                        "Düzenle",
                        style: TextStyle(color: AppColors.blue),
                      ),
                    )
                  else
                    const SizedBox.shrink()
                else
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditBillingInfoView(),
                        ),
                      ).then((_) {
                        addressViewModel.fetchAddresses();
                      });
                    },
                    child: const Text("Fatura Adresi Ekle"),
                  ),
              ],
            ),
            if (addressViewModel.billingAddresses.isEmpty)
              Container(
                padding: EdgeInsets.all(SizeTokens.p16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(SizeTokens.r8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Text(
                  "Kayıtlı fatura adresiniz bulunmamaktadır.Fatura adresi eklemeniz gerekmektedir.",
                  style: TextStyle(color: Colors.grey),
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
                  children: addressViewModel.billingAddresses.map((address) {
                    final isCorporate = address.billingType == 'corporate';
                    return RadioListTile<Address>(
                      title: Text(
                        address.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        isCorporate
                            ? (address.billingCompanyTitle ?? address.addressLine1)
                            : "${address.fullName} - ${address.addressLine1}",
                      ),
                      value: address,
                      groupValue: _selectedBillingAddress,
                      activeColor: AppColors.darkBlue,
                      onChanged: (Address? value) {
                        setState(() => _selectedBillingAddress = value);
                      },
                    );
                  }).toList(),
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
            height: SizeTokens.p50,
            child: ElevatedButton(
              onPressed: viewModel.isLoading || _selectedAddress == null
                  ? null
                  : () async {
                      final address = _selectedAddress!;
                      final notes = _noteController.text;

                      final orderedItems = List<ProductModel>.from(
                        viewModel.cart,
                      );

                      final Map<String, dynamic>? billingPayload =
                          _selectedBillingAddress != null
                              ? _buildBillingPayload(_selectedBillingAddress!)
                              : null;

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
