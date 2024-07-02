import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_code_scan/generate_qr.dart';
import 'package:qr_code_scan/main.dart';
import 'package:mockito/mockito.dart';
import 'package:qr_code_scan/scan_qr.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  testWidgets('Main screen with two buttons test', (WidgetTester tester) async {
    NavigatorObserver mockObserver = MockNavigatorObserver();

    final homeRoute = MaterialPageRoute(builder: (_) => const HomePage());
    final scanQRRoute = MaterialPageRoute(builder: (_) => const ScanQR());
    final generateQRRoute = MaterialPageRoute(builder: (_) => const GenerateQR());

    const scanBtnKey = Key('ScanButtonMain');
    const generateBtnKey = Key('GenerateButtonMain');

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/',
        navigatorObservers: [mockObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return homeRoute;
            case '/scan':
              return scanQRRoute;
            case '/generate':
              return generateQRRoute;
          }
          return null;
        }
      ),  
    );

    // Verify that our main screen has two buttons.
    expect(find.byKey(scanBtnKey), findsOneWidget, reason: 'Scan QR code button should be found');
    expect(find.byKey(generateBtnKey), findsOneWidget, reason: 'Generate QR code button should be found');

    // Click the scan QR button and trigger a frame.
    await tester.tap(find.byKey(scanBtnKey));
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(scanQRRoute, homeRoute));

    /// We'd also want to be sure that our page is now
    /// present in the screen.
    expect(find.byType(ScanQR), findsOneWidget, reason: 'Class of type ScanQR should be present');

    await tester.pageBack();
    await tester.pumpAndSettle();

    verify(mockObserver.didPop(scanQRRoute, homeRoute));

    // Click the generate QR button and trigger a frame.
    await tester.tap(find.byKey(generateBtnKey));
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(generateQRRoute, homeRoute));

    /// We'd also want to be sure that our page is now
    /// present in the screen.
    expect(find.byType(GenerateQR), findsOneWidget, reason: 'Class of type GenerateQR should be present');

    await tester.pageBack();
    await tester.pumpAndSettle();

    verify(mockObserver.didPop(generateQRRoute, homeRoute));
  });
}
