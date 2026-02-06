import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_tokens.dart';
import '../../viewmodels/product_view_model.dart';
import '../../viewmodels/address_view_model.dart';
import '../../models/address_model.dart';
import '../profile/add_address_view.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final TextEditingController _noteController = TextEditingController();
  Address? _selectedAddress;

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
          setState(() {
            _selectedAddress = addressViewModel.addresses.firstWhere(
              (element) => element.isDefault,
              orElse: () => addressViewModel.addresses.first,
            );
          });
        }
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
                              "${item.name} x1", // Simplified, as cart logic is simple
                              style: TextStyle(fontSize: SizeTokens.f14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "${item.price} TL",
                            style: TextStyle(
                              fontSize: SizeTokens.f14,
                              fontWeight: FontWeight.w600,
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
                          Text(
                            "${viewModel.cartTotalPrice.toStringAsFixed(2)} TL",
                            style: TextStyle(
                              fontSize: SizeTokens.f16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blue,
                            ),
                          ),
                          if (viewModel.cartTotalTokenPrice > 0)
                            Text(
                              "+ ${viewModel.cartTotalTokenPrice} DP",
                              style: TextStyle(
                                fontSize: SizeTokens.f12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBlue,
                              ),
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
                        });
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

                      final success = await viewModel.completeOrder(
                        address: address,
                        notes: notes,
                      );

                      if (!context.mounted) return;

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Siparişiniz başarıyla alındı."),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Pop CheckoutView
                        Navigator.pop(context);
                        // Pop CartView
                        Navigator.pop(context);
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
