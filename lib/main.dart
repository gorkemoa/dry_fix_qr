import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app_theme.dart';
import 'core/network/api_client.dart';
import 'services/auth_service.dart';
import 'viewmodels/login_view_model.dart';
import 'views/login/login_view.dart';
import 'viewmodels/home_view_model.dart';
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel(authService)),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: MaterialApp(
        title: 'DryFix Boyacı',
        theme: AppTheme.lightTheme,
        home: const LoginView(),
      ),
    );
  }
}
