import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:local_auth/local_auth.dart';

/// Platform security bridge managing biometric unlock (`local_auth`) and
/// Android screenshot protection (`FLAG_SECURE`).
class AppSecurityService {
  /// Creates an [AppSecurityService].
  new({LocalAuthentication? auth, MethodChannel? channel})
    : _auth = auth ?? LocalAuthentication(),
      _channel = channel ?? const MethodChannel('in.lexcopilot.app/security');

  final LocalAuthentication _auth;
  final MethodChannel _channel;

  /// Prompts device biometrics / screen-lock PIN to unlock Lex.
  Future<Result<bool>> authenticate({
    String reason = 'Authenticate to unlock Lex legal vault',
  }) async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final supported = await _auth.isDeviceSupported();
      if (!canCheck && !supported) {
        return const Success(true);
      }
      final ok = await _auth.authenticate(localizedReason: reason);
      return Success(ok);
    } on Object {
      // Allow graceful non-crashing recovery on unsupported desktop test runners.
      return const Success(false);
    }
  }

  /// Toggles Android `WindowManager.LayoutParams.FLAG_SECURE` when supported.
  Future<void> setScreenProtection({required bool enabled}) async {
    try {
      await _channel.invokeMethod<void>('setSecureFlag', {'enabled': enabled});
    } on Object {
      // No-op on platforms/tests without native method handler.
    }
  }
}

/// Overlay lock gate shielding app screens when `biometricLockEnabled` is active.
class BiometricLockGate extends StatefulWidget {
  /// Creates a [BiometricLockGate].
  const new({
    required this.locked,
    required this.securityService,
    required this.child,
    super.key,
  });

  /// Whether biometric protection is enabled in user settings.
  final bool locked;

  /// Biometric authentication service.
  final AppSecurityService securityService;

  /// App content shown once unlocked.
  final Widget child;

  @override
  State<BiometricLockGate> createState() => _BiometricLockGateState();
}

class _BiometricLockGateState extends State<BiometricLockGate> {
  bool _unlocked = false;
  bool _authenticating = false;

  @override
  void initState() {
    super.initState();
    _unlocked = !widget.locked;
  }

  @override
  void didUpdateWidget(covariant BiometricLockGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.locked && !_unlocked) {
      _unlocked = true;
    } else if (widget.locked && !oldWidget.locked) {
      _unlocked = false;
    }
  }

  Future<void> _unlock() async {
    if (_authenticating) return;
    setState(() => _authenticating = true);
    final res = await widget.securityService.authenticate();
    if (!mounted) return;
    setState(() {
      _authenticating = false;
      if (res case Success(value: true)) {
        _unlocked = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.locked || _unlocked) {
      return widget.child;
    }
    final tokens = context.lexTokens;
    return Scaffold(
      backgroundColor: tokens.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: LexCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 42,
                  color: tokens.accent,
                ),
                const SizedBox(height: 14),
                Text(
                  'Unlock Lex',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Verify with biometrics to view your encrypted legal files.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: tokens.secondaryText),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: _authenticating ? null : _unlock,
                  icon: const Icon(Icons.fingerprint_rounded),
                  label: Text(_authenticating ? 'Verifying…' : 'Unlock'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
