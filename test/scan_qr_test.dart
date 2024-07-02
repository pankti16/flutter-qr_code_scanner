import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_code_scan/main.dart';
import 'package:mockito/mockito.dart';
import 'package:qr_code_scan/scan_qr.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  testWidgets('Scan QR screen with scanner and text test', (WidgetTester tester) async {
    NavigatorObserver mockObserver = MockNavigatorObserver();

    final homeRoute = MaterialPageRoute(builder: (_) => const HomePage());
    final scanQRRoute = MaterialPageRoute(builder: (_) => const ScanQR());

    const scanBtnKey = Key('ScanButtonMain');
    const scanTextKey = Key('ScanTextKey');
    const scanQRKey = Key('QR');

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
          }
          return null;
        }
      ),  
    );

    // Verify that our main screen has scan button.
    expect(find.byKey(scanBtnKey), findsOneWidget, reason: 'Scan QR code button should be found');

    // Click the scan QR button and trigger a frame.
    await tester.tap(find.byKey(scanBtnKey));
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(scanQRRoute, homeRoute));

    /// We'd also want to be sure that our page is now
    /// present in the screen.
    expect(find.byType(ScanQR), findsOneWidget, reason: 'Class of type ScanQR should be present');

    //Test if scan data text present or not
    Finder scanTextWidget = find.byKey(scanTextKey);
    expect(scanTextWidget, findsOneWidget, reason: 'A text should be there to display scanned data');
    //Test if default text matches or not
    expect((scanTextWidget.evaluate().single.widget as Text).data, 'Scanned data will be shown here!', reason: 'Default text should be visible');
    //Test if QRView is loaded or not
    expect(find.byKey(scanQRKey), findsOneWidget, reason: 'QR code scanner should be on screen');

    await tester.pageBack();
    await tester.pumpAndSettle();

    verify(mockObserver.didPop(scanQRRoute, homeRoute));
  });
}
