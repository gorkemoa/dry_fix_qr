import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../models/address_model.dart';
import '../../viewmodels/address_view_model.dart';
import 'widgets/address_item.dart';
import 'edit_billing_info_view.dart';

class BillingAddressesView extends StatefulWidget {
  const BillingAddressesView({super.key});

  @override
  State<BillingAddressesView> createState() => _BillingAddressesViewState();
}

class _BillingAddressesViewState extends State<BillingAddressesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressViewModel>().fetchAddresses();
    });
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
            color: AppColors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Fatura Bilgileri",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: viewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.blue),
            )
          : viewModel.errorMessage != null
          ? _buildErrorView(viewModel)
          : viewModel.billingAddresses.isEmpty
          ? _buildEmptyView()
          : _buildBillingList(viewModel),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditBillingInfoView()),
          ).then((_) => context.read<AddressViewModel>().fetchAddresses());
        },
        backgroundColor: AppColors.darkBlue,
        elevation: 4,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildErrorView(AddressViewModel viewModel) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SizeTokens.p32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(SizeTokens.p24),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.redAccent,
                size: SizeTokens.p48,
              ),
            ),
            SizedBox(height: SizeTokens.p24),
            Text(
              "Bir Sorun Oluştu",
              style: TextStyle(
                color: AppColors.darkBlue,
                fontSize: SizeTokens.f18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: SizeTokens.p8),
            Text(
              viewModel.errorMessage ?? "Fatura bilgileri yüklenirken bir hata oluştu.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.gray, fontSize: SizeTokens.f14),
            ),
            SizedBox(height: SizeTokens.p32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: viewModel.refresh,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                  padding: EdgeInsets.symmetric(vertical: SizeTokens.p16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeTokens.r16),
                  ),
                ),
                child: const Text("Tekrar Dene"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SizeTokens.p32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(SizeTokens.p32),
              decoration: BoxDecoration(
                color: AppColors.darkBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(SizeTokens.r32),
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                color: AppColors.darkBlue.withOpacity(0.2),
                size: SizeTokens.p64,
              ),
            ),
            SizedBox(height: SizeTokens.p32),
            Text(
              "Fatura Bilgisi Bulunamadı",
              style: TextStyle(
                color: AppColors.darkBlue,
                fontSize: SizeTokens.f20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: SizeTokens.p12),
            Text(
              "Henüz bir fatura bilgisi eklememişsiniz. Yeni bir fatura bilgisi ekleyerek devam edebilirsiniz.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.gray,
                fontSize: SizeTokens.f14,
                height: 1.5,
              ),
            ),
            SizedBox(height: SizeTokens.p40),
            SizedBox(
              width: 220,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditBillingInfoView(),
                    ),
                  ).then((_) => context.read<AddressViewModel>().fetchAddresses());
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text("Fatura Bilgisi Ekle"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                  padding: EdgeInsets.symmetric(vertical: SizeTokens.p16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeTokens.r16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingList(AddressViewModel viewModel) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        SizeTokens.p24,
        SizeTokens.p12,
        SizeTokens.p24,
        SizeTokens.p100,
      ),
      itemCount: viewModel.billingAddresses.length,
      itemBuilder: (context, index) {
        final address = viewModel.billingAddresses[index];
        return AddressItem(
          address: address,
          onEdit: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditBillingInfoView(address: address),
              ),
            ).then((_) => context.read<AddressViewModel>().fetchAddresses());
          },
          onDelete: () {
            _showDeleteConfirmation(context, viewModel, address);
          },
          onSetDefault: address.isDefault
              ? null
              : () => _setDefault(context, viewModel, address),
        );
      },
    );
  }

  void _setDefault(
    BuildContext context,
    AddressViewModel viewModel,
    Address address,
  ) async {
    final success = await viewModel.setDefaultAddress(address.id);
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("\"${address.title}\" varsayılan olarak ayarlandı."),
          backgroundColor: AppColors.darkBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeTokens.r12),
          ),
        ),
      );
    }
  }

  void _showDeleteConfirmation(
    BuildContext context,
    AddressViewModel viewModel,
    Address address,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeTokens.r24),
        ),
        title: Text(
          "Fatura Bilgisini Sil",
          style: TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "\"${address.title}\" başlıklı fatura bilgisini silmek istediğinize emin misiniz?",
          style: TextStyle(color: AppColors.darkBlue.withOpacity(0.8)),
        ),
        actionsPadding: EdgeInsets.only(
          right: SizeTokens.p16,
          bottom: SizeTokens.p16,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Vazgeç",
              style: TextStyle(
                color: AppColors.gray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await viewModel.deleteAddress(address.id);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Fatura bilgisi başarıyla silindi."),
                    backgroundColor: AppColors.darkBlue,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeTokens.r12),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: EdgeInsets.symmetric(
                horizontal: SizeTokens.p20,
                vertical: SizeTokens.p8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeTokens.r12),
              ),
            ),
            child: const Text("Sil"),
          ),
        ],
      ),
    );
  }
}
