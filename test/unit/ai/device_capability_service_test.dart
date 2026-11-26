import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/ai/on_device/device_capability_service.dart';
import 'package:lex_copilot/ai/on_device/on_device_gemma_service.dart';

class _FakeMetricsReader implements DeviceMetricsReader {
  const new(this.metrics);

  final RawDeviceMetrics metrics;

  @override
  Future<RawDeviceMetrics> readMetrics() async => metrics;
}

void main() {
  group('DeviceCapabilityService', () {
    test('recommends E2B on 6 GB RAM phones and blocks E4B', () async {
      const service = DeviceCapabilityService(
        metricsReader: _FakeMetricsReader(
          RawDeviceMetrics(
            totalRamMb: 5900,
            freeStorageMb: 12000,
            osLabel: 'android 14',
          ),
        ),
      );
      final report = await service.evaluate();
      expect(report.canInstallE2b, isTrue);
      expect(report.canInstallE4b, isFalse);
      expect(report.recommendedTier, Gemma4Tier.e2b);
    });

    test(
      'allows E4B on >= 8 GB RAM + cool thermal + sufficient storage',
      () async {
        const service = DeviceCapabilityService(
          metricsReader: _FakeMetricsReader(
            RawDeviceMetrics(
              totalRamMb: 8192,
              freeStorageMb: 12000,
              osLabel: 'android 15',
            ),
          ),
        );
        final report = await service.evaluate();
        expect(report.canInstallE2b, isTrue);
        expect(report.canInstallE4b, isTrue);
        expect(report.recommendedTier, Gemma4Tier.e4b);
      },
    );

    test(
      'blocks downloads cleanly when free storage is critically low',
      () async {
        const service = DeviceCapabilityService(
          metricsReader: _FakeMetricsReader(
            RawDeviceMetrics(
              totalRamMb: 8192,
              freeStorageMb: 900,
              osLabel: 'ios 18',
            ),
          ),
        );
        final report = await service.evaluate();
        expect(report.canInstallE2b, isFalse);
        expect(report.canInstallE4b, isFalse);
        expect(report.advisoryReason, contains('Free storage'));
      },
    );

    test(
      'downgrades recommendation to E2B under serious thermal throttling',
      () async {
        const service = DeviceCapabilityService(
          metricsReader: _FakeMetricsReader(
            RawDeviceMetrics(
              totalRamMb: 12000,
              freeStorageMb: 20000,
              osLabel: 'android 15',
              thermalState: DeviceThermalState.serious,
            ),
          ),
        );
        final report = await service.evaluate();
        expect(report.canInstallE4b, isFalse);
        expect(report.recommendedTier, Gemma4Tier.e2b);
      },
    );
  });
}
