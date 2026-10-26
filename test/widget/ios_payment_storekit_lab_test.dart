import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handy_learn/features/labs/screens/ios_payment_storekit_lab_screen.dart';

void main() {
  group('StoreKit 2 & Apple Pay Interactive Lab Tests', () {
    testWidgets('renders StoreKit 2 purchases and executes verified purchase', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: IosPaymentStoreKitLabScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('StoreKit 2 & Payments Lab'), findsOneWidget);
      expect(find.text('StoreKit 2 Async'), findsOneWidget);
      expect(find.text('Apple Pay & PassKit'), findsOneWidget);
      expect(find.text('0 Active'), findsOneWidget);

      // Tap Pro Monthly Subscription card
      await tester.tap(find.text('Pro Monthly Subscription'));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();

      // Verify entitlement unlocked
      expect(find.text('1 Active'), findsOneWidget);
      expect(find.text('com.pro.monthly'), findsWidgets);
      expect(find.textContaining('JWS Cryptographic Verification Result: .verified'), findsOneWidget);
    });

    testWidgets('simulates MITM tamper injection in StoreKit 2', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: IosPaymentStoreKitLabScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Tampered MITM Attack Simulator
      await tester.tap(find.text('Tampered MITM Attack Simulator'));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();

      // Verify tamper rejection
      expect(find.textContaining('.unverified(VerificationError.invalidSignature)'), findsOneWidget);
      expect(find.textContaining('Tampered payload detected!'), findsOneWidget);
    });

    testWidgets('simulates external lifecycle events (Family Sharing & Revocation)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: IosPaymentStoreKitLabScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Inject Family Sharing
      await tester.tap(find.text('Family Sharing Approval'));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.text('1 Active'), findsOneWidget);
      expect(find.text('com.pro.annual'), findsWidgets);

      // Inject Revocation
      await tester.tap(find.text('Refund / Revocation'));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.text('0 Active'), findsOneWidget);
    });

    testWidgets('switches to Apple Pay tab and authorizes via Server Intent & PassKit', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: IosPaymentStoreKitLabScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Switch to Apple Pay & PassKit tab
      await tester.tap(find.text('Apple Pay & PassKit'));
      await tester.pumpAndSettle();

      expect(find.text('Architecture Pipeline'), findsOneWidget);
      expect(find.text('Server Intent + PassKit'), findsOneWidget);
      expect(find.text('Client Direct Charge'), findsOneWidget);

      // Tap Pay with Apple Pay
      await tester.tap(find.text('Pay with Apple Pay'));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      // Verify payment complete and tokenized credentials
      expect(find.textContaining('PAYMENT COMPLETE: Goods unlocked'), findsOneWidget);
      expect(find.textContaining('Secure Element Isolated Tokenization'), findsOneWidget);
    });
  });
}
