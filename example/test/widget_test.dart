import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notification_package_example/main.dart';
import 'package:notifications_package/notifications_package.dart';

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  testWidgets('Integration test: show the notification in the app example',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MyApp), findsOneWidget);

    await tester.tap(find.byKey(const Key('showNotificationButton')));
    await tester.pumpAndSettle();

    expect(
        find.descendant(
            of: find.byKey(const Key('notificationContainer')),
            matching: find.text('Title')),
        findsOneWidget);

    expect(find.text('Example message'), findsOneWidget);

    // Cancelar todos los temporizadores después de la prueba
    NotificationWidget.cancelAllTimers();
  });
}
