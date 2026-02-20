import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/support_view_model.dart';
import '../../viewmodels/profile_view_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import 'create_support_view.dart';
import 'support_detail_view.dart';

class SupportListView extends StatefulWidget {
  const SupportListView({super.key});

  @override
  State<SupportListView> createState() => _SupportListViewState();
}

class _SupportListViewState extends State<SupportListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<ProfileViewModel>().user?.id;
      context.read<SupportViewModel>().fetchMessages(
        userId: userId,
        refresh: true,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final userId = context.read<ProfileViewModel>().user?.id;
      context.read<SupportViewModel>().fetchMessages(userId: userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final viewModel = context.watch<SupportViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.white,
            size: SizeTokens.p24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Destek ve Yardım",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: viewModel.isLoading && viewModel.messages.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.blue),
            )
          : RefreshIndicator(
              onRefresh: () async {
                final userId = context.read<ProfileViewModel>().user?.id;
                await viewModel.fetchMessages(userId: userId, refresh: true);
              },
              child: viewModel.messages.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(SizeTokens.p24),
                      itemCount:
                          viewModel.messages.length +
                          (viewModel.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < viewModel.messages.length) {
                          final message = viewModel.messages[index];
                          return _buildSupportItem(message);
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.blue,
                              ),
                            ),
                          );
                        }
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateSupportView()),
          );
        },
        backgroundColor: AppColors.darkBlue,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.support_agent_rounded,
            size: SizeTokens.p64,
            color: AppColors.gray.withOpacity(0.5),
          ),
          SizedBox(height: SizeTokens.p16),
          Text(
            "Henüz destek talebiniz bulunmuyor.",
            style: TextStyle(
              color: AppColors.darkBlue,
              fontSize: SizeTokens.f16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: SizeTokens.p8),
          Text(
            "Yeni bir talep oluşturmak için + butonuna basın.",
            style: TextStyle(color: AppColors.gray, fontSize: SizeTokens.f14),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportItem(message) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeTokens.p16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SupportDetailView(message: message),
            ),
          );
        },
        contentPadding: EdgeInsets.all(SizeTokens.p16),
        title: Text(
          message.title,
          style: TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.bold,
            fontSize: SizeTokens.f16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeTokens.p4),
            Text(
              message.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.gray, fontSize: SizeTokens.f14),
            ),
            SizedBox(height: SizeTokens.p8),
            Text(
              message.createdAt,
              style: TextStyle(
                color: AppColors.gray.withOpacity(0.6),
                fontSize: SizeTokens.f12,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: SizeTokens.p16,
          color: AppColors.gray.withOpacity(0.3),
        ),
      ),
    );
  }
}
