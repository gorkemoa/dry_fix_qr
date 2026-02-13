import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/notifications_view_model.dart';
import '../../core/responsive/size_tokens.dart';
import '../../app/app_theme.dart';
import 'widgets/notification_item_widget.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsViewModel>().fetchNotifications();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationsViewModel>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirimler'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<NotificationsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null && viewModel.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: SizeTokens.p48,
                    color: AppColors.gray,
                  ),
                  SizedBox(height: SizeTokens.p16),
                  Text(viewModel.errorMessage!),
                  ElevatedButton(
                    onPressed: viewModel.refresh,
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: SizeTokens.p64,
                    color: AppColors.gray.withOpacity(0.5),
                  ),
                  SizedBox(height: SizeTokens.p16),
                  Text(
                    'Henüz bildirim yok',
                    style: TextStyle(
                      color: AppColors.gray,
                      fontSize: SizeTokens.f16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: viewModel.refresh,
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(SizeTokens.p16),
              itemCount:
                  viewModel.items.length + (viewModel.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < viewModel.items.length) {
                  final item = viewModel.items[index];
                  return NotificationItemWidget(
                    item: item,
                    onTap: () {
                      // Navigate to detail if needed
                    },
                  );
                } else {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
