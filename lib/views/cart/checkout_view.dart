import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../common/pdf_viewer_screen.dart';
import '../../core/responsive/size_tokens.dart';
import '../../core/widgets/dp_symbol.dart';
import '../../viewmodels/product_view_model.dart';
import '../../viewmodels/address_view_model.dart';
import '../../models/address_model.dart';
import '../profile/add_address_view.dart';
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

  bool _isKvkkAccepted = false;
  bool _isEkSozlesmeAccepted = false;

  static const Color _brandBlue = Color(0xFF3B71F3);

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
                                  "+ ${viewModel.cartTotalTokenPrice} ",
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

            SizedBox(height: SizeTokens.p24),

            // ── Zorunlu Sözleşme Onayları ──────────────────────────────────
            Container(
              padding: EdgeInsets.all(SizeTokens.p16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(SizeTokens.r8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Zorunlu Onaylar",
                    style: TextStyle(
                      fontSize: SizeTokens.f14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  SizedBox(height: SizeTokens.p12),

                  // KVKK Onayı
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform.scale(
                        scale: 0.9,
                        child: Checkbox(
                          value: _isKvkkAccepted,
                          onChanged: (val) =>
                              setState(() => _isKvkkAccepted = val ?? false),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: const BorderSide(color: _brandBlue),
                          activeColor: _brandBlue,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "KVKK Aydınlatma Metni",
                                  style: const TextStyle(
                                    color: _brandBlue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const PdfViewerScreen(
                                              assetPath:
                                                  'assets/KVKK Açık Rıza Metni.pdf',
                                              title: 'KVKK Açık Rıza Metni',
                                            ),
                                          ),
                                        ),
                                ),
                                TextSpan(
                                  text:
                                      "'ni okudum, kişisel verilerimin işlenmesini onaylıyorum.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.darkBlue.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: SizeTokens.p8),

                  // Ek Sözleşme Onayı
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform.scale(
                        scale: 0.9,
                        child: Checkbox(
                          value: _isEkSozlesmeAccepted,
                          onChanged: (val) => setState(
                              () => _isEkSozlesmeAccepted = val ?? false),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: const BorderSide(color: _brandBlue),
                          activeColor: _brandBlue,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Ek Sözleşme",
                                  style: const TextStyle(
                                    color: _brandBlue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const PdfViewerScreen(
                                              assetPath:
                                                  'assets/Üyelik _ Kullanım Sözleşmesi.pdf',
                                              title:
                                                  'Üyelik & Kullanım Sözleşmesi',
                                            ),
                                          ),
                                        ),
                                ),
                                TextSpan(
                                  text: "'yi okudum ve kabul ediyorum.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.darkBlue.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (!_isKvkkAccepted || !_isEkSozlesmeAccepted)
                    Padding(
                      padding: EdgeInsets.only(top: SizeTokens.p8),
                      child: Text(
                        "Siparişi tamamlamak için her iki onayı da vermeniz gerekmektedir.",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.red.shade400,
                        ),
                      ),
                    ),
                ],
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
              onPressed: viewModel.isLoading ||
                      _selectedAddress == null ||
                      !_isKvkkAccepted ||
                      !_isEkSozlesmeAccepted
                  ? null
                  : () async {
                      // Prepare data
                      final address = _selectedAddress!;
                      final notes = _noteController.text;

                      final orderedItems = List<ProductModel>.from(
                        viewModel.cart,
                      );
                      final success = await viewModel.completeOrder(
                        address: address,
                        notes: notes,
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
