import 'package:flutter/foundation.dart';

/// Build flavors supported by Lex.
enum LexFlavor {
  /// Local development flavor with verbose diagnostics and local backend.
  dev,

  /// Pre-production staging flavor.
  staging,

  /// Production release flavor.
  prod,
}

/// Immutable environment configuration for the active [LexFlavor].
@immutable
class FlavorConfig {
  /// Creates a [FlavorConfig].
  const new({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
    required this.enableVerboseLogging,
    required this.enableCertificatePinning,
  });

  /// Resolves the active flavor from `--dart-define=LEX_FLAVOR` or build mode.
  factory fromEnvironment([LexFlavor? overrideFlavor]) {
    const rawFlavor = String.fromEnvironment('LEX_FLAVOR');
    final flavor =
        overrideFlavor ??
        switch (rawFlavor.toLowerCase()) {
          'dev' => LexFlavor.dev,
          'staging' => LexFlavor.staging,
          'prod' => LexFlavor.prod,
          _ => kReleaseMode ? LexFlavor.prod : LexFlavor.dev,
        };

    return FlavorConfig.forFlavor(flavor);
  }

  /// Returns the canonical [FlavorConfig] for [flavor].
  factory forFlavor(LexFlavor flavor) => switch (flavor) {
    LexFlavor.dev => const FlavorConfig(
      flavor: LexFlavor.dev,
      appName: 'Lex Dev',
      apiBaseUrl: 'http://10.0.2.2:8000',
      enableVerboseLogging: true,
      enableCertificatePinning: false,
    ),
    LexFlavor.staging => const FlavorConfig(
      flavor: LexFlavor.staging,
      appName: 'Lex Staging',
      // TODO(verify): Replace with actual staging API endpoint before release.
      apiBaseUrl: 'https://staging-api.lexlegal.example',
      enableVerboseLogging: true,
      enableCertificatePinning: false,
    ),
    LexFlavor.prod => const FlavorConfig(
      flavor: LexFlavor.prod,
      appName: 'Lex',
      // TODO(verify): Replace with actual production API endpoint before release.
      apiBaseUrl: 'https://api.lexlegal.example',
      enableVerboseLogging: false,
      enableCertificatePinning: true,
    ),
  };

  /// Current build flavor.
  final LexFlavor flavor;

  /// Human-readable application name shown in headers or diagnostics.
  final String appName;

  /// Base URL of the FastAPI AI-proxy backend.
  final String apiBaseUrl;

  /// Whether non-PII diagnostic logs are enabled.
  final bool enableVerboseLogging;

  /// Whether TLS certificate pinning is active in production HTTP calls.
  final bool enableCertificatePinning;
}
