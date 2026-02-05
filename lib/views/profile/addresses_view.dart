import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../viewmodels/address_view_model.dart';
import 'widgets/address_item.dart';

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.darkBlue,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Adreslerim",
          style: TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.bold,
            fontSize: SizeTokens.f18,
          ),
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
          // TODO: Implement Add Address
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Adres ekleme yakında eklenecektir.")),
          );
        },
        backgroundColor: AppColors.blue,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildErrorView(AddressViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
            size: SizeTokens.p48,
          ),
          SizedBox(height: SizeTokens.p16),
          Text(
            viewModel.errorMessage ?? "Bir hata oluştu",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.darkBlue,
              fontSize: SizeTokens.f14,
            ),
          ),
          SizedBox(height: SizeTokens.p16),
          ElevatedButton(
            onPressed: viewModel.refresh,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeTokens.r12),
              ),
            ),
            child: const Text("Tekrar Dene"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(SizeTokens.p24),
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_off_rounded,
              color: AppColors.blue.withOpacity(0.2),
              size: SizeTokens.p64,
            ),
          ),
          SizedBox(height: SizeTokens.p24),
          Text(
            "Henüz bir adres eklemediniz",
            style: TextStyle(
              color: AppColors.darkBlue,
              fontSize: SizeTokens.f18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: SizeTokens.p8),
          Text(
            "Yeni bir adres eklemek için + butonuna basabilirsiniz.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.gray, fontSize: SizeTokens.f14),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressList(AddressViewModel viewModel) {
    return ListView.builder(
      padding: EdgeInsets.all(SizeTokens.p24),
      itemCount: viewModel.addresses.length,
      itemBuilder: (context, index) {
        final address = viewModel.addresses[index];
        return AddressItem(
          address: address,
          onEdit: () {
            // TODO: Implement Edit
          },
          onDelete: () {
            // TODO: Implement Delete
          },
        );
      },
    );
  }
}
