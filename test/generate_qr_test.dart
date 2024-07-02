import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_code_scan/generate_qr.dart';
import 'package:qr_code_scan/main.dart';
import 'package:mockito/mockito.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  testWidgets('Generate QR screen with QR code and text input test', (WidgetTester tester) async {
    NavigatorObserver mockObserver = MockNavigatorObserver();

    final homeRoute = MaterialPageRoute(builder: (_) => const HomePage());
    final generateQRRoute = MaterialPageRoute(builder: (_) => const GenerateQR());

    const generateBtnKey = Key('GenerateButtonMain');
    const generateTextKey = Key('GenerateTextKey');
    const generateQRKey = Key('GeneratedQRKey');

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/',
        navigatorObservers: [mockObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return homeRoute;
            case '/generate':
              return generateQRRoute;
          }
          return null;
        }
      ),  
    );

    // Verify that our main screen has generate button.
    expect(find.byKey(generateBtnKey), findsOneWidget, reason: 'Generate QR code button should be found');

    // Click the generate QR button and trigger a frame.
    await tester.tap(find.byKey(generateBtnKey));
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(generateQRRoute, homeRoute));

    /// We'd also want to be sure that our page is now
    /// present in the screen.
    expect(find.byType(GenerateQR), findsOneWidget, reason: 'Class of type GenerateQR should be present');

    //Test if generate input text field present or not
    Finder generateTextWidget = find.byKey(generateTextKey);
    expect(generateTextWidget, findsOneWidget, reason: 'A text input field should be there');
    //Test if can enter text or not
    await tester.enterText(generateTextWidget, 'hi');
    // Rebuild the widget after the state has changed.
    await tester.pump();
    //Test if QR code is generated or not
    Finder generatedQRWidget = find.byKey(generateQRKey);
    expect(generatedQRWidget, findsOneWidget, reason: 'A QR image should be there');
    expect(generatedQRWidget.evaluate().single.widget as QrImageView, isA<QrImageView>(), reason: 'The generated should be of type QR image');

    await tester.pageBack();
    await tester.pumpAndSettle();

    verify(mockObserver.didPop(generateQRRoute, homeRoute));
  });
}
