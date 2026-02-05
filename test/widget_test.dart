import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dry_fix_qr/main.dart';
import 'package:dry_fix_qr/core/network/api_client.dart';
import 'package:dry_fix_qr/services/auth_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    final apiClient = ApiClient();
    final authService = AuthService(apiClient);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MyApp(
        apiClient: apiClient,
        authService: authService,
        initialView: const Scaffold(), // Just a placeholder
      ),
    );

    expect(find.byType(MyApp), findsOneWidget);
  });
}
