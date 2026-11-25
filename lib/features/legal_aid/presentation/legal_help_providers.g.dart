// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_help_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Pluggable directory provider for legal aid, lawyers, and police desks.

@ProviderFor(legalHelpDirectorySource)
final legalHelpDirectorySourceProvider = LegalHelpDirectorySourceProvider._();

/// Pluggable directory provider for legal aid, lawyers, and police desks.

final class LegalHelpDirectorySourceProvider
    extends
        $FunctionalProvider<
          LegalHelpDirectorySource,
          LegalHelpDirectorySource,
          LegalHelpDirectorySource
        >
    with $Provider<LegalHelpDirectorySource> {
  /// Pluggable directory provider for legal aid, lawyers, and police desks.
  LegalHelpDirectorySourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'legalHelpDirectorySourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$legalHelpDirectorySourceHash();

  @$internal
  @override
  $ProviderElement<LegalHelpDirectorySource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LegalHelpDirectorySource create(Ref ref) {
    return legalHelpDirectorySource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LegalHelpDirectorySource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LegalHelpDirectorySource>(value),
    );
  }
}

String _$legalHelpDirectorySourceHash() =>
    r'95d9939d738d7c8a75d0d71f9b1b294b125c63c6';

/// Device GPS location provider.

@ProviderFor(deviceLocationService)
final deviceLocationServiceProvider = DeviceLocationServiceProvider._();

/// Device GPS location provider.

final class DeviceLocationServiceProvider
    extends
        $FunctionalProvider<
          DeviceLocationService,
          DeviceLocationService,
          DeviceLocationService
        >
    with $Provider<DeviceLocationService> {
  /// Device GPS location provider.
  DeviceLocationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceLocationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceLocationServiceHash();

  @$internal
  @override
  $ProviderElement<DeviceLocationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeviceLocationService create(Ref ref) {
    return deviceLocationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceLocationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceLocationService>(value),
    );
  }
}

String _$deviceLocationServiceHash() =>
    r'9c0c1920a10bbeb667693249e45519c3758f130c';

/// Fetches entries for [category] near optional coordinates.

@ProviderFor(legalHelpEntries)
final legalHelpEntriesProvider = LegalHelpEntriesFamily._();

/// Fetches entries for [category] near optional coordinates.

final class LegalHelpEntriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LegalHelpEntry>>,
          List<LegalHelpEntry>,
          FutureOr<List<LegalHelpEntry>>
        >
    with
        $FutureModifier<List<LegalHelpEntry>>,
        $FutureProvider<List<LegalHelpEntry>> {
  /// Fetches entries for [category] near optional coordinates.
  LegalHelpEntriesProvider._({
    required LegalHelpEntriesFamily super.from,
    required (LegalHelpCategory, {double? latitude, double? longitude})
    super.argument,
  }) : super(
         retry: null,
         name: r'legalHelpEntriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$legalHelpEntriesHash();

  @override
  String toString() {
    return r'legalHelpEntriesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<LegalHelpEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LegalHelpEntry>> create(Ref ref) {
    final argument =
        this.argument
            as (LegalHelpCategory, {double? latitude, double? longitude});
    return legalHelpEntries(
      ref,
      argument.$1,
      latitude: argument.latitude,
      longitude: argument.longitude,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LegalHelpEntriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$legalHelpEntriesHash() => r'ed448a6cb77bc515a0581d2d2307d61c4034c03b';

/// Fetches entries for [category] near optional coordinates.

final class LegalHelpEntriesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<LegalHelpEntry>>,
          (LegalHelpCategory, {double? latitude, double? longitude})
        > {
  LegalHelpEntriesFamily._()
    : super(
        retry: null,
        name: r'legalHelpEntriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches entries for [category] near optional coordinates.

  LegalHelpEntriesProvider call(
    LegalHelpCategory category, {
    double? latitude,
    double? longitude,
  }) => LegalHelpEntriesProvider._(
    argument: (category, latitude: latitude, longitude: longitude),
    from: this,
  );

  @override
  String toString() => r'legalHelpEntriesProvider';
}
