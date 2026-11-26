import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:lex_copilot/ai/on_device/on_device_gemma_service.dart';
import 'package:path_provider/path_provider.dart';

/// Reported device thermal pressure impacting GPU/CPU Gemma inference stability.
enum DeviceThermalState {
  /// Normal operating temperature.
  nominal,

  /// Slightly warm; safe for inference.
  fair,

  /// Elevated thermal state; downgrade from E4B/GPU to lighter tier.
  serious,

  /// Critical thermal throttling; advise delaying heavy local workloads.
  critical,
}

/// Hardware telemetry snapshot returned by [DeviceMetricsReader].
@immutable
class RawDeviceMetrics {
  /// Creates a [RawDeviceMetrics].
  const new({
    required this.totalRamMb,
    required this.freeStorageMb,
    required this.osLabel,
    this.thermalState = DeviceThermalState.nominal,
  });

  /// Total physical RAM in MiB (`0` when unreadable).
  final int totalRamMb;

  /// Available free app-storage space in MiB (`0` when unreadable).
  final int freeStorageMb;

  /// Operating system summary string.
  final String osLabel;

  /// Device thermal throttling tier.
  final DeviceThermalState thermalState;
}

/// Hardware compatibility assessment determining safe Gemma 4 tier selection.
@immutable
class DeviceCapabilityReport {
  /// Creates a [DeviceCapabilityReport].
  const new({
    required this.totalRamMb,
    required this.freeStorageMb,
    required this.osLabel,
    required this.thermalState,
    required this.recommendedTier,
    required this.canInstallE2b,
    required this.canInstallE4b,
    required this.advisoryReason,
  });

  /// Minimum RAM threshold (MiB) required before recommending Gemma 4 E4B (~8 GB devices).
  static const int minRamForE4bMb = 7200;

  /// Minimum RAM threshold (MiB) required for Gemma 4 E2B.
  static const int minRamForE2bMb = 3600;

  /// Minimum free disk space (MiB) for downloading/extracting Gemma 4 E2B (~2.6 GB + headroom).
  static const int minStorageForE2bMb = 3200;

  /// Minimum free disk space (MiB) for downloading/extracting Gemma 4 E4B.
  static const int minStorageForE4bMb = 5400;

  /// Total physical RAM in MiB.
  final int totalRamMb;

  /// Free disk space in MiB.
  final int freeStorageMb;

  /// Operating system description.
  final String osLabel;

  /// Thermal throttling level.
  final DeviceThermalState thermalState;

  /// Safe recommended [Gemma4Tier] (`e2b` unless >= 8 GB class + ample storage + cool).
  final Gemma4Tier recommendedTier;

  /// Whether storage & RAM safely allow `Gemma 4 E2B`.
  final bool canInstallE2b;

  /// Whether storage, RAM, and thermal checks allow `Gemma 4 E4B`.
  final bool canInstallE4b;

  /// Plain-language explanation shown in AI & Privacy model setup.
  final String advisoryReason;
}

/// Platform telemetry source (injectable for deterministic unit tests).
abstract interface class DeviceMetricsReader {
  /// Reads current RAM, free storage, OS version, and thermal status.
  Future<RawDeviceMetrics> readMetrics();
}

/// Production [DeviceMetricsReader] inspecting Linux/Android `/proc/meminfo`,
/// optional native platform telemetry channel, and local directory free space.
class PlatformDeviceMetricsReader implements DeviceMetricsReader {
  /// Creates a [PlatformDeviceMetricsReader].
  const new({MethodChannel? telemetryChannel})
    : _channel =
          telemetryChannel ??
          const MethodChannel('in.lexcopilot.app/telemetry');

  final MethodChannel _channel;

  @override
  Future<RawDeviceMetrics> readMetrics() async {
    var ramMb = await _readPlatformInt('getTotalRamMb') ?? 0;
    if (ramMb <= 0 && (Platform.isAndroid || Platform.isLinux)) {
      ramMb = _readLinuxMemTotalMb();
    }

    var freeMb = await _readPlatformInt('getFreeStorageMb') ?? 0;
    if (freeMb <= 0) {
      freeMb = await _probeFreeDiskMb();
    }

    final thermalRaw = await _readPlatformString('getThermalState');
    final thermal = switch (thermalRaw?.toLowerCase()) {
      'critical' => DeviceThermalState.critical,
      'serious' => DeviceThermalState.serious,
      'fair' => DeviceThermalState.fair,
      _ => DeviceThermalState.nominal,
    };

    return RawDeviceMetrics(
      totalRamMb: ramMb,
      freeStorageMb: freeMb,
      osLabel: '${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
      thermalState: thermal,
    );
  }

  Future<int?> _readPlatformInt(String method) async {
    try {
      return await _channel.invokeMethod<int>(method);
    } on Object {
      return null;
    }
  }

  Future<String?> _readPlatformString(String method) async {
    try {
      return await _channel.invokeMethod<String>(method);
    } on Object {
      return null;
    }
  }

  static int _readLinuxMemTotalMb() {
    try {
      final meminfo = File('/proc/meminfo');
      if (!meminfo.existsSync()) return 0;
      for (final line in meminfo.readAsLinesSync()) {
        if (line.startsWith('MemTotal:')) {
          final m = RegExp(r'(\d+)').firstMatch(line);
          if (m != null) {
            final kb = int.parse(m.group(1)!);
            return kb ~/ 1024;
          }
        }
      }
    } on Object {
      // Unreadable inside restricted sandboxes.
    }
    return 0;
  }

  static Future<int> _probeFreeDiskMb() async {
    try {
      final dir = await getApplicationSupportDirectory();
      if (Platform.isLinux || Platform.isMacOS || Platform.isAndroid) {
        final res = await Process.run('df', ['-Pm', dir.path]);
        if (res.exitCode == 0) {
          final lines = res.stdout.toString().trim().split('\n');
          if (lines.length >= 2) {
            final cols = lines[1].trim().split(RegExp(r'\s+'));
            if (cols.length >= 4) {
              return int.tryParse(cols[3]) ?? 0;
            }
          }
        }
      }
    } on Object {
      // Platform stat unavailable without native plugin.
    }
    return 0;
  }
}

/// Evaluates device RAM, free storage, OS compatibility, and thermal headroom
/// before downloading or loading Gemma 4 weights.
class DeviceCapabilityService {
  /// Creates a [DeviceCapabilityService].
  const new({DeviceMetricsReader? metricsReader})
    : _reader = metricsReader ?? const PlatformDeviceMetricsReader();

  final DeviceMetricsReader _reader;

  /// Evaluates hardware capability and returns a [DeviceCapabilityReport].
  Future<DeviceCapabilityReport> evaluate() async {
    final m = await _reader.readMetrics();
    final ramKnown = m.totalRamMb > 0;
    final storageKnown = m.freeStorageMb > 0;

    final ramOkE2b =
        !ramKnown || m.totalRamMb >= DeviceCapabilityReport.minRamForE2bMb;
    final ramOkE4b =
        ramKnown && m.totalRamMb >= DeviceCapabilityReport.minRamForE4bMb;

    final storageOkE2b =
        !storageKnown ||
        m.freeStorageMb >= DeviceCapabilityReport.minStorageForE2bMb;
    final storageOkE4b =
        !storageKnown ||
        m.freeStorageMb >= DeviceCapabilityReport.minStorageForE4bMb;

    final thermalOkE4b =
        m.thermalState == DeviceThermalState.nominal ||
        m.thermalState == DeviceThermalState.fair;

    final canE2b = ramOkE2b && storageOkE2b;
    final canE4b = ramOkE4b && storageOkE4b && thermalOkE4b;
    final recommended = canE4b ? Gemma4Tier.e4b : Gemma4Tier.e2b;

    final reason = StringBuffer();
    if (!canE2b) {
      if (!ramOkE2b) {
        reason.write(
          'Device RAM (${m.totalRamMb} MB) is below 3.6 GB minimum for reliable Gemma 4 E2B inference. ',
        );
      }
      if (!storageOkE2b) {
        reason.write(
          'Free storage (${m.freeStorageMb} MB) is below ${DeviceCapabilityReport.minStorageForE2bMb} MB required for E2B.',
        );
      }
    } else if (canE4b) {
      reason.write(
        'Device (${m.totalRamMb} MB RAM) supports Gemma 4 E4B for richer on-device legal reasoning.',
      );
    } else {
      if (!ramKnown) {
        reason.write(
          'Defaulting to Gemma 4 E2B (~2.59 GB) until device RAM is confirmed >= 7.2 GB.',
        );
      } else if (!ramOkE4b) {
        reason.write(
          'Device RAM (${m.totalRamMb} MB) suits Gemma 4 E2B; E4B requires >= 7.2 GB RAM to avoid out-of-memory crashes.',
        );
      } else if (!thermalOkE4b) {
        reason.write(
          'Device thermal pressure is ${m.thermalState.name}; Gemma 4 E2B is recommended.',
        );
      } else {
        reason.write(
          'Free storage (${m.freeStorageMb} MB) fits Gemma 4 E2B; E4B needs ${DeviceCapabilityReport.minStorageForE4bMb} MB free.',
        );
      }
    }

    return DeviceCapabilityReport(
      totalRamMb: m.totalRamMb,
      freeStorageMb: m.freeStorageMb,
      osLabel: m.osLabel,
      thermalState: m.thermalState,
      recommendedTier: recommended,
      canInstallE2b: canE2b,
      canInstallE4b: canE4b,
      advisoryReason: reason.toString().trim(),
    );
  }
}
