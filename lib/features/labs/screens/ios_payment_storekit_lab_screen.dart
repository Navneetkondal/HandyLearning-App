import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/pressable_scale.dart';

/// StoreKit 2 & Apple Pay Interactive Sandbox Screen
/// Simulates StoreKit 2 async purchase pipelines, JWS cryptographic verification,
/// subscription lifecycle states, PassKit biometric authorization, and DPAN tokenization.
class IosPaymentStoreKitLabScreen extends StatefulWidget {
  const IosPaymentStoreKitLabScreen({super.key});

  @override
  State<IosPaymentStoreKitLabScreen> createState() => _IosPaymentStoreKitLabScreenState();
}

class _IosPaymentStoreKitLabScreenState extends State<IosPaymentStoreKitLabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ── StoreKit 2 State ──
  final Set<String> _activeEntitlements = {};
  String? _lastTransactionId;
  String? _lastJwsHeader;
  String? _lastJwsPayload;
  bool _isJwsVerified = true;
  bool _isProcessingStoreKit = false;
  final List<String> _skLogs = [];

  // ── Apple Pay & Server Intent State ──
  int _selectedPaymentFlow = 0; // 0: Secure Server Intent + PassKit, 1: Unsafe Client Direct Charge
  bool _simulateNetworkDrop = false;
  bool _isProcessingPayment = false;
  String _paymentState = 'idle'; // idle, intent_created, biometric_auth, token_generated, webhook_captured, failed
  String? _dpanToken;
  String? _cryptogram;
  final List<String> _payLogs = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _resetStoreKit();
    _resetPayment();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _resetStoreKit() {
    setState(() {
      _activeEntitlements.clear();
      _lastTransactionId = null;
      _lastJwsHeader = null;
      _lastJwsPayload = null;
      _isJwsVerified = true;
      _isProcessingStoreKit = false;
      _skLogs.clear();
      _skLogs.add('StoreKit 2 Sandbox ready. Tap a product to simulate Product.purchase().');
    });
  }

  void _resetPayment() {
    setState(() {
      _isProcessingPayment = false;
      _paymentState = 'idle';
      _dpanToken = null;
      _cryptogram = null;
      _payLogs.clear();
      _payLogs.add('Payment Sandbox ready. Select architecture and tap "Authorize Apple Pay".');
    });
  }

  // ── StoreKit 2 Simulations ──

  Future<void> _simulatePurchase({
    required String productId,
    required String title,
    required String price,
    bool simulateTampering = false,
  }) async {
    if (_isProcessingStoreKit) return;
    AppHaptics.medium();

    setState(() {
      _isProcessingStoreKit = true;
      _skLogs.clear();
      _skLogs.add('🛒 Product.purchase() initiated for: $title ($price)');
      _skLogs.add('Invoking out-of-process App Store authentication sheet...');
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (simulateTampering) {
      // Simulate MITM/Jailbreak tamper attack
      AppHaptics.light();
      setState(() {
        _isJwsVerified = false;
        _lastTransactionId = 'txn_fake_99482';
        _lastJwsHeader = '{"alg": "none", "typ": "JWT"}';
        _lastJwsPayload = '{"productId": "$productId", "tampered": true}';
        _isProcessingStoreKit = false;
        _skLogs.add('⚠️ JWS Verification Result: .unverified(VerificationError.invalidSignature)');
        _skLogs.add('❌ Tampered payload detected! Apple Root CA certificate chain check failed.');
        _skLogs.add('🛡️ Entitlement DENIED. Transaction rejected safely without unlocking premium.');
      });
      return;
    }

    // Normal Verified StoreKit 2 Purchase
    await Future.delayed(const Duration(milliseconds: 600));
    final txnId = 'txn_${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';

    AppHaptics.success();
    setState(() {
      _isJwsVerified = true;
      _lastTransactionId = txnId;
      _lastJwsHeader = '{"alg": "ES256", "x5c": ["MIIB...AppleRootCA"]}';
      _lastJwsPayload = '{"productId": "$productId", "transactionId": "$txnId", "revocationDate": null}';
      _activeEntitlements.add(productId);
      _isProcessingStoreKit = false;
      _skLogs.add('✅ JWS Cryptographic Verification Result: .verified(Transaction)');
      _skLogs.add('Apple Inc. Root CA signature chain validated in 1.4ms.');
      _skLogs.add('🔓 Entitlement unlocked: $productId added to Transaction.currentEntitlements.');
      _skLogs.add('📦 Invoked `await transaction.finish()` to complete queue processing.');
    });
  }

  Future<void> _simulateExternalEvent(String eventType) async {
    AppHaptics.selection();
    setState(() {
      _skLogs.add('📡 Injected out-of-band event: $eventType');
    });

    await Future.delayed(const Duration(milliseconds: 400));

    if (eventType == 'Family Sharing Approval') {
      setState(() {
        _activeEntitlements.add('com.pro.annual');
        _skLogs.add('👥 Transaction.updates caught background purchase approval.');
        _skLogs.add('Auto-unlocked `com.pro.annual` via Family Sharing sync.');
      });
      AppHaptics.success();
    } else if (eventType == 'Refund / Revocation') {
      setState(() {
        _activeEntitlements.remove('com.pro.annual');
        _activeEntitlements.remove('com.pro.monthly');
        _skLogs.add('🛑 Transaction.updates received App Store Revocation / Refund.');
        _skLogs.add('`transaction.revocationDate` is non-nil. Entitlement revoked immediately.');
      });
      AppHaptics.medium();
    } else if (eventType == 'Billing Grace Period') {
      setState(() {
        _skLogs.add('⏳ Billing Grace Period active (Day 3 of 16).');
        _skLogs.add('`transaction.isUpToDate == true`. Access preserved while Apple retries card.');
      });
      AppHaptics.light();
    }
  }

  // ── Apple Pay & Server Intent Simulations ──

  Future<void> _runApplePaySimulation() async {
    if (_isProcessingPayment) return;
    AppHaptics.medium();

    setState(() {
      _isProcessingPayment = true;
      _paymentState = 'intent_created';
      _payLogs.clear();
    });

    if (_selectedPaymentFlow == 0) {
      // Flow 0: Secure Server Payment Intent + PassKit (SAQ A)
      _payLogs.add('1. Client requested Payment Intent from trusted backend...');
      await Future.delayed(const Duration(milliseconds: 400));

      final idempotencyKey = 'idem_req_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      _payLogs.add('2. Backend generated Payment Intent with Idempotency-Key: $idempotencyKey');
      _payLogs.add('   Price (\$49.00) locked on server database. Client secret returned.');

      setState(() => _paymentState = 'biometric_auth');
      await Future.delayed(const Duration(milliseconds: 600));

      _payLogs.add('3. Presented `PKPaymentAuthorizationController` out-of-process.');
      _payLogs.add('   User authenticated with Face ID via Secure Enclave sensor.');

      setState(() {
        _paymentState = 'token_generated';
        _dpanToken = 'DPAN_4111_****_****_8821';
        _cryptogram = 'AQEBAwEBBQYGBwcJC...';
      });
      await Future.delayed(const Duration(milliseconds: 500));

      _payLogs.add('4. Secure Element hardware derived dynamic 3DS2 cryptogram.');
      _payLogs.add('   `PKPaymentToken` packaged with zero raw PAN in application RAM.');

      if (_simulateNetworkDrop) {
        // Simulate network failure during transit
        AppHaptics.light();
        setState(() {
          _paymentState = 'failed';
          _isProcessingPayment = false;
          _payLogs.add('💥 NETWORK TIMEOUT: Cellular connection dropped before server response.');
          _payLogs.add('🔄 Safe Recovery: Retrying with same Idempotency-Key `$idempotencyKey`...');
          _payLogs.add('✅ Server idempotency cache caught duplicate key! Zero duplicate charge occurred.');
        });
        return;
      }

      setState(() => _paymentState = 'webhook_captured');
      await Future.delayed(const Duration(milliseconds: 500));

      _payLogs.add('5. Gateway dispatched HMAC-SHA256 signed webhook to backend.');
      _payLogs.add('6. Backend validated webhook signature, settled funds, and recorded audit ledger.');

      AppHaptics.success();
      setState(() {
        _isProcessingPayment = false;
        _payLogs.add('🎉 PAYMENT COMPLETE: Goods unlocked via trusted server authorization.');
      });
    } else {
      // Flow 1: Unsafe Client Direct Charge (Vulnerability Demonstration)
      _payLogs.add('⚠️ FLOW: Direct Client-Side Card Capture (Non-Compliant SAQ A-EP)');
      await Future.delayed(const Duration(milliseconds: 400));
      _payLogs.add('1. Raw credit card (16-digit PAN + CVV) held in application RAM.');
      _payLogs.add('   🚨 Critical PCI-DSS violation: unencrypted String buffer in heap!');

      setState(() => _paymentState = 'token_generated');
      await Future.delayed(const Duration(milliseconds: 500));

      _payLogs.add('2. Client attempted direct charge to gateway bypassing server intent.');
      _payLogs.add('🚨 VULNERABILITY: Attacker using Frida swizzled payment status to `.success`.');
      _payLogs.add('🚨 Client unlocked \$10,000 product for \$0.00! No server webhook verification.');

      AppHaptics.light();
      setState(() {
        _paymentState = 'failed';
        _isProcessingPayment = false;
        _payLogs.add('❌ INSECURE ARCHITECTURE DEMONSTRATION FAILED SECURITY AUDIT.');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final border = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final text = isDark ? Colors.white : const Color(0xFF0F172A);
    final sub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('StoreKit 2 & Payments Lab'),
        elevation: 0,
        backgroundColor: cardBg,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF4F46E5),
          unselectedLabelColor: sub,
          indicatorColor: const Color(0xFF4F46E5),
          tabs: const [
            Tab(icon: Icon(Icons.shopping_bag_outlined), text: 'StoreKit 2 Async'),
            Tab(icon: Icon(Icons.payment_rounded), text: 'Apple Pay & PassKit'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStoreKitTab(isDark, cardBg, border, text, sub),
          _buildApplePayTab(isDark, cardBg, border, text, sub),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TAB 1: StoreKit 2 Async & JWS Verification
  // ─────────────────────────────────────────────
  Widget _buildStoreKitTab(bool isDark, Color cardBg, Color border, Color text, Color sub) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF312E81), Color(0xFF4338CA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: AppColors.cardShadow(isDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.security_rounded, size: 18, color: Color(0xFF34D399)),
                  const SizedBox(width: 8),
                  Text(
                    'StoreKit 2 Cryptographic Pipeline',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.95),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Test pure Swift async/await purchases, JSON Web Signature (JWS) root CA verification, and background Transaction.updates lifecycle listeners.',
                style: TextStyle(fontSize: 12, height: 1.4, color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Active Entitlements Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
            boxShadow: AppColors.cardShadow(isDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transaction.currentEntitlements',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: text),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _activeEntitlements.isEmpty
                          ? Colors.grey.withValues(alpha: 0.15)
                          : const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${_activeEntitlements.length} Active',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _activeEntitlements.isEmpty ? sub : const Color(0xFF10B981),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_activeEntitlements.isEmpty)
                Text('No active unlocked products. Tap a purchase button below.',
                    style: TextStyle(fontSize: 12, color: sub))
              else
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _activeEntitlements.map((id) {
                    return Chip(
                      label: Text(id, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      avatar: const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF10B981)),
                      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // StoreKit 2 Catalog
        Text('Available Sandbox Products', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: text)),
        const SizedBox(height: 8),
        _buildProductCard(
          title: 'Pro Monthly Subscription',
          productId: 'com.pro.monthly',
          price: '\$9.99 / mo',
          badge: 'Auto-Renewable',
          isDark: isDark,
          cardBg: cardBg,
          border: border,
          text: text,
          sub: sub,
          onTap: () => _simulatePurchase(productId: 'com.pro.monthly', title: 'Pro Monthly', price: '\$9.99'),
        ),
        _buildProductCard(
          title: 'Pro Annual (Family Sharing)',
          productId: 'com.pro.annual',
          price: '\$89.99 / yr',
          badge: 'Family Sharing',
          isDark: isDark,
          cardBg: cardBg,
          border: border,
          text: text,
          sub: sub,
          onTap: () => _simulatePurchase(productId: 'com.pro.annual', title: 'Pro Annual', price: '\$89.99'),
        ),
        _buildProductCard(
          title: 'Tampered MITM Attack Simulator',
          productId: 'com.malicious.fake',
          price: 'Simulate Hack',
          badge: 'Security Test',
          isDark: isDark,
          cardBg: cardBg,
          border: border,
          text: text,
          sub: sub,
          isDanger: true,
          onTap: () => _simulatePurchase(
            productId: 'com.malicious.fake',
            title: 'Tampered Payload',
            price: '\$0.00',
            simulateTampering: true,
          ),
        ),
        const SizedBox(height: 16),

        // External Events Rail
        Text('External Lifecycle Injections', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: text)),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildEventButton('Family Sharing Approval', Icons.people_outline, isDark, cardBg, border, text),
              const SizedBox(width: 8),
              _buildEventButton('Refund / Revocation', Icons.cancel_outlined, isDark, cardBg, border, text),
              const SizedBox(width: 8),
              _buildEventButton('Billing Grace Period', Icons.timer_outlined, isDark, cardBg, border, text),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // JWS Inspector (if transaction present)
        if (_lastTransactionId != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _isJwsVerified ? const Color(0xFF10B981) : Colors.redAccent,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _isJwsVerified ? Icons.verified_user_rounded : Icons.gpp_bad_rounded,
                      size: 16,
                      color: _isJwsVerified ? const Color(0xFF10B981) : Colors.redAccent,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isJwsVerified ? 'Verified JWS Container' : 'Tampered JWS Rejected',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _isJwsVerified ? const Color(0xFF10B981) : Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Header: $_lastJwsHeader',
                    style: const TextStyle(fontSize: 10.5, fontFamily: 'monospace')),
                Text('Payload: $_lastJwsPayload',
                    style: const TextStyle(fontSize: 10.5, fontFamily: 'monospace')),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Event Console
        _buildConsoleCard('StoreKit 2 Execution Log', _skLogs, _resetStoreKit, isDark, cardBg, border, text, sub),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // TAB 2: Apple Pay & PassKit Intent Sandbox
  // ─────────────────────────────────────────────
  Widget _buildApplePayTab(bool isDark, Color cardBg, Color border, Color text, Color sub) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Flow Selector
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
            boxShadow: AppColors.cardShadow(isDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Architecture Pipeline', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: text)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _paymentState == 'failed'
                          ? Colors.red.withAlpha(40)
                          : (_paymentState == 'webhook_captured' || _paymentState == 'token_generated')
                              ? Colors.green.withAlpha(40)
                              : Colors.blue.withAlpha(40),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _paymentState.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _paymentState == 'failed'
                            ? Colors.red
                            : (_paymentState == 'webhook_captured' || _paymentState == 'token_generated')
                                ? Colors.green
                                : Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildFlowChoice(
                      index: 0,
                      label: 'Server Intent + PassKit',
                      sublabel: 'SAQ A (Zero PAN in RAM)',
                      icon: Icons.shield_rounded,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFlowChoice(
                      index: 1,
                      label: 'Client Direct Charge',
                      sublabel: 'SAQ A-EP (Anti-Pattern)',
                      icon: Icons.warning_amber_rounded,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Controls
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
            boxShadow: AppColors.cardShadow(isDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order Total: \$49.00 USD', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: text)),
                      Text('Merchant ID: merchant.com.enterprise.app', style: TextStyle(fontSize: 11, color: sub)),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Simulate Drop', style: TextStyle(fontSize: 11, color: sub)),
                      Switch(
                        value: _simulateNetworkDrop,
                        onChanged: (v) {
                          AppHaptics.selection();
                          setState(() => _simulateNetworkDrop = v);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: PressableScale(
                  scaleFactor: 0.98,
                  onTap: _isProcessingPayment ? null : _runApplePaySimulation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _isProcessingPayment
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.apple_rounded, size: 20, color: isDark ? Colors.black : Colors.white),
                              const SizedBox(width: 6),
                              Text(
                                'Pay with Apple Pay',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.black : Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Token Inspector
        if (_dpanToken != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF10B981)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lock_outline_rounded, size: 14, color: Color(0xFF10B981)),
                    SizedBox(width: 6),
                    Text(
                      'Secure Element Isolated Tokenization',
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text('DPAN (Device Primary Account): $_dpanToken', style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
                Text('3DS Cryptogram (One-Time ECC Signature): $_cryptogram', style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Console Log
        _buildConsoleCard('Payment Intent & PassKit Lifecycle Log', _payLogs, _resetPayment, isDark, cardBg, border, text, sub),
      ],
    );
  }

  // ── Helper Widgets ──

  Widget _buildProductCard({
    required String title,
    required String productId,
    required String price,
    required String badge,
    required bool isDark,
    required Color cardBg,
    required Color border,
    required Color text,
    required Color sub,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    final isPurchased = _activeEntitlements.contains(productId);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: PressableScale(
        scaleFactor: 0.97,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isPurchased ? const Color(0xFF10B981) : border),
            boxShadow: AppColors.cardShadow(isDark),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDanger
                      ? Colors.redAccent.withValues(alpha: 0.15)
                      : (isPurchased
                          ? const Color(0xFF10B981).withValues(alpha: 0.15)
                          : const Color(0xFF6366F1).withValues(alpha: 0.15)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isPurchased ? Icons.verified_rounded : (isDanger ? Icons.warning_rounded : Icons.shopping_bag_rounded),
                  size: 18,
                  color: isDanger
                      ? Colors.redAccent
                      : (isPurchased ? const Color(0xFF10B981) : const Color(0xFF6366F1)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: text)),
                    Text('$badge • $productId', style: TextStyle(fontSize: 11, color: sub)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isPurchased
                      ? const Color(0xFF10B981).withValues(alpha: 0.12)
                      : (isDanger ? Colors.redAccent.withValues(alpha: 0.12) : const Color(0xFF4F46E5).withValues(alpha: 0.12)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isPurchased ? 'Active ✓' : price,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isPurchased
                        ? const Color(0xFF10B981)
                        : (isDanger ? Colors.redAccent : const Color(0xFF4F46E5)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventButton(String label, IconData icon, bool isDark, Color cardBg, Color border, Color text) {
    return PressableScale(
      scaleFactor: 0.94,
      onTap: () => _simulateExternalEvent(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border),
          boxShadow: AppColors.cardShadow(isDark),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF4F46E5)),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: text)),
          ],
        ),
      ),
    );
  }

  Widget _buildFlowChoice({
    required int index,
    required String label,
    required String sublabel,
    required IconData icon,
    required bool isDark,
  }) {
    final isSelected = _selectedPaymentFlow == index;

    return PressableScale(
      scaleFactor: 0.96,
      onTap: () {
        AppHaptics.selection();
        setState(() => _selectedPaymentFlow = index);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4F46E5).withValues(alpha: isDark ? 0.2 : 0.08)
              : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF4F46E5) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: isSelected ? const Color(0xFF4F46E5) : Colors.grey),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isSelected ? const Color(0xFF4F46E5) : null)),
            Text(sublabel, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildConsoleCard(
    String title,
    List<String> logs,
    VoidCallback onClear,
    bool isDark,
    Color cardBg,
    Color border,
    Color text,
    Color sub,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.terminal_rounded, size: 14, color: Color(0xFF10B981)),
                  const SizedBox(width: 6),
                  Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: text)),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 16),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Reset Console',
                onPressed: () {
                  AppHaptics.light();
                  onClear();
                },
              ),
            ],
          ),
          const Divider(height: 16),
          ...logs.map((log) {
            final isError = log.contains('❌') || log.contains('🚨') || log.contains('💥') || log.contains('⚠️');
            final isSuccess = log.contains('✅') || log.contains('🎉') || log.contains('🔓');
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                log,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: isError
                      ? Colors.redAccent
                      : (isSuccess ? const Color(0xFF10B981) : (isDark ? Colors.white70 : const Color(0xFF334155))),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
