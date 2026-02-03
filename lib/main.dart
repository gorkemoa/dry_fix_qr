import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app_theme.dart';
import 'core/network/api_client.dart';
import 'services/auth_service.dart';
import 'services/history_service.dart';
import 'services/qr_service.dart';
import 'services/order_service.dart';
import 'services/product_service.dart';
import 'viewmodels/login_view_model.dart';
import 'viewmodels/register_view_model.dart';
import 'viewmodels/home_view_model.dart';
import 'viewmodels/history_view_model.dart';
import 'viewmodels/update_password_view_model.dart';
import 'viewmodels/profile_view_model.dart';
import 'viewmodels/qr_view_model.dart';
import 'viewmodels/order_view_model.dart';
import 'viewmodels/product_view_model.dart';
import 'views/login/login_view.dart';
// import 'views/home/home_view.dart'; // No longer needed here if not initial home

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency Injection
    final apiClient = ApiClient();
    final authService = AuthService(apiClient);
    final historyService = HistoryService(apiClient);
    final qrService = QrService(apiClient);
    final orderService = OrderService(apiClient);
    final productService = ProductService(apiClient);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel(authService)),
        ChangeNotifierProvider(create: (_) => RegisterViewModel(authService)),
        ChangeNotifierProvider(create: (_) => HomeViewModel(authService)),
        ChangeNotifierProvider(create: (_) => HistoryViewModel(historyService)),
        ChangeNotifierProvider(
          create: (_) => UpdatePasswordViewModel(authService),
        ),
        ChangeNotifierProvider(create: (_) => ProfileViewModel(authService)),
        ChangeNotifierProvider(create: (_) => QrViewModel(qrService)),
        ChangeNotifierProvider(create: (_) => OrderViewModel(orderService)),
        ChangeNotifierProvider(create: (_) => ProductViewModel(productService)),
      ],
      child: MaterialApp(
        title: 'DryFix Boyacı',
        theme: AppTheme.lightTheme,
        home: const LoginView(),
      ),
    );
  }
}
