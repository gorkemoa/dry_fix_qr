import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'services/notification_service.dart';
import 'app/app_theme.dart';
import 'core/network/api_client.dart';
import 'core/storage/storage_manager.dart';
import 'core/utils/navigation_service.dart';
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
import 'viewmodels/address_view_model.dart';
import 'services/address_service.dart';
import 'views/login/login_view.dart';
import 'views/home/home_view.dart';
import 'views/qr_scanner/qr_share_process_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Storage initialize
  await StorageManager.init();

  // Firebase initialize
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await NotificationService().init();
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  // App de dönme olmasın (Lock orientation to portrait)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Dependency Injection setup for initial check
  final apiClient = ApiClient();
  final authService = AuthService(apiClient);

  // Check shared files (Intent)
  List<SharedMediaFile> sharedFiles = [];
  try {
    sharedFiles = await ReceiveSharingIntent.instance.getInitialMedia();
  } catch (e) {
    debugPrint("Shared intent error: $e");
  }

  Widget initialView = const LoginView();

  // Check token
  final token = StorageManager.getToken();
  if (token != null) {
    apiClient.setToken(token);
    final result = await authService.fetchMe();
    if (result.isSuccess) {
      initialView = const HomeView();
    } else {
      // Token invalid or expired
      await StorageManager.deleteToken();
      apiClient.clearToken();
    }
  }

  // Eğer paylaşım ile gelindiyse, initialView'ı override et
  if (sharedFiles.isNotEmpty) {
    initialView = QrShareProcessView(sharedFiles: sharedFiles);
  }

  runApp(
    MyApp(
      apiClient: apiClient,
      authService: authService,
      initialView: initialView,
    ),
  );
}

class MyApp extends StatefulWidget {
  final ApiClient apiClient;
  final AuthService authService;
  final Widget initialView;

  const MyApp({
    super.key,
    required this.apiClient,
    required this.authService,
    required this.initialView,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription _intentDataStreamSubscription;

  @override
  void initState() {
    super.initState();
    // Uygulama hafıdayken (background/active) gelen paylaşımları dinle
    _intentDataStreamSubscription = ReceiveSharingIntent.instance
        .getMediaStream()
        .listen(
          (List<SharedMediaFile> value) {
            if (value.isNotEmpty) {
              // NavigationService ile yönlendir
              NavigationService.navigatorKey.currentState?.push(
                MaterialPageRoute(
                  builder: (_) => QrShareProcessView(sharedFiles: value),
                ),
              );
            }
          },
          onError: (err) {
            debugPrint("getIntentDataStream error: $err");
          },
        );
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyService = HistoryService(widget.apiClient);
    final qrService = QrService(widget.apiClient);
    final orderService = OrderService(widget.apiClient);
    final productService = ProductService(widget.apiClient);
    final addressService = AddressService(widget.apiClient);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(widget.authService),
        ),
        ChangeNotifierProvider(
          create: (_) => RegisterViewModel(widget.authService),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(widget.authService),
        ),
        ChangeNotifierProvider(create: (_) => HistoryViewModel(historyService)),
        ChangeNotifierProvider(
          create: (_) => UpdatePasswordViewModel(widget.authService),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileViewModel(widget.authService),
        ),
        ChangeNotifierProvider(create: (_) => QrViewModel(qrService)),
        ChangeNotifierProvider(create: (_) => OrderViewModel(orderService)),
        ChangeNotifierProvider(
          create: (_) => ProductViewModel(productService, orderService),
        ),
        ChangeNotifierProvider(create: (_) => AddressViewModel(addressService)),
      ],
      child: MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        title: 'DryFix Boyacı',
        theme: AppTheme.lightTheme,
        builder: (context, child) {
          return GestureDetector(
            // Klavye kapanma kolaylığı (Dismiss keyboard on tap)
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: MediaQuery(
              // Sistem ayarlarında yazı boyutu ve kalın metin olanları varsayılana döndür (Ignore system font and bold settings)
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.noScaling, boldText: false),
              child: child!,
            ),
          );
        },
        home: widget.initialView,
      ),
    );
  }
}
