import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/history_view_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../home/widgets/history_item.dart';

class TransactionsView extends StatefulWidget {
  const TransactionsView({super.key});

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryViewModel>().fetchHistory();
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
      context.read<HistoryViewModel>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final viewModel = context.watch<HistoryViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tüm İşlemler"),
        backgroundColor: AppColors.background,
      ),
      body: viewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.blue),
            )
          : RefreshIndicator(
              onRefresh: () => viewModel.refresh(),
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(SizeTokens.p24),
                itemCount: viewModel.items.length + (viewModel.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < viewModel.items.length) {
                    return HistoryItem(item: viewModel.items[index]);
                  } else {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.blue),
                      ),
                    );
                  }
                },
              ),
            ),
    );
  }
}
