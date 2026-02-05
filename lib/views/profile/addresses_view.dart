import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../models/address_model.dart';
import '../../viewmodels/address_view_model.dart';
import 'widgets/address_item.dart';
import 'add_address_view.dart';

class AddressesView extends StatefulWidget {
  const AddressesView({super.key});

  @override
  State<AddressesView> createState() => _AddressesViewState();
}

class _AddressesViewState extends State<AddressesView> {
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
          "Adreslerim",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: viewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.blue),
            )
          : viewModel.errorMessage != null
          ? _buildErrorView(viewModel)
          : viewModel.addresses.isEmpty
          ? _buildEmptyView()
          : _buildAddressList(viewModel),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddAddressView()),
          );
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
              viewModel.errorMessage ?? "Adresler yüklenirken bir hata oluştu.",
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
                Icons.location_off_rounded,
                color: AppColors.darkBlue.withOpacity(0.2),
                size: SizeTokens.p64,
              ),
            ),
            SizedBox(height: SizeTokens.p32),
            Text(
              "Adres Bulunamadı",
              style: TextStyle(
                color: AppColors.darkBlue,
                fontSize: SizeTokens.f20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: SizeTokens.p12),
            Text(
              "Henüz bir adres eklememişsiniz. Yeni bir adres ekleyerek devam edebilirsiniz.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.gray,
                fontSize: SizeTokens.f14,
                height: 1.5,
              ),
            ),
            SizedBox(height: SizeTokens.p40),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddAddressView()),
                  );
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text("Adres Ekle"),
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

  Widget _buildAddressList(AddressViewModel viewModel) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        SizeTokens.p24,
        SizeTokens.p12,
        SizeTokens.p24,
        SizeTokens.p100, // Space for FAB
      ),
      itemCount: viewModel.addresses.length,
      itemBuilder: (context, index) {
        final address = viewModel.addresses[index];
        return AddressItem(
          address: address,
          onEdit: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddAddressView(address: address),
              ),
            );
          },
          onDelete: () {
            _showDeleteConfirmation(context, viewModel, address);
          },
        );
      },
    );
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
          "Adresi Sil",
          style: TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "\"${address.title}\" başlıklı adresi silmek istediğinize emin misiniz?",
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
                    content: const Text("Adres başarıyla silindi."),
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
