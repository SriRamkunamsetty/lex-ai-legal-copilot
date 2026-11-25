import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/features/legal_aid/domain/legal_help_models.dart';

/// Pluggable data source contract for Legal Aid, Lawyer, and Police contacts.
abstract interface class LegalHelpDirectorySource {
  /// Fetches directory entries for [category], optionally sorted near
  /// `([latitude], [longitude])`.
  Future<Result<List<LegalHelpEntry>>> fetchEntries({
    required LegalHelpCategory category,
    double? latitude,
    double? longitude,
  });
}

/// Abstraction over device GPS lookup so tests can stub location cleanly.
abstract interface class DeviceLocationService {
  /// Requests location permission if needed and returns current `(lat, lng)`.
  Future<Result<({double latitude, double longitude})>> currentLocation();
}

/// Production [DeviceLocationService] backed by `geolocator`.
class GeolocatorLocationService implements DeviceLocationService {
  /// Creates a [GeolocatorLocationService].
  const new();

  @override
  Future<Result<({double latitude, double longitude})>> currentLocation() =>
      Result.guard(
        () async {
          final enabled = await Geolocator.isLocationServiceEnabled();
          if (!enabled) {
            throw StateError('Device location services are turned off.');
          }
          var permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }
          if (permission == LocationPermission.denied ||
              permission == LocationPermission.deniedForever) {
            throw StateError('Location permission denied.');
          }
          final pos = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
              timeLimit: Duration(seconds: 8),
            ),
          );
          return (latitude: pos.latitude, longitude: pos.longitude);
        },
        onError: (error, _) =>
            NetworkFailure('Unable to read current location.', cause: error),
      );
}

/// Clearly marked placeholder [LegalHelpDirectorySource] shipped with Lex.
///
/// Uses synthetic office labels and `00000` sample numbers — never fabricated
/// real individuals or unverified personal phone numbers.
class PlaceholderLegalHelpDirectorySource implements LegalHelpDirectorySource {
  /// Creates a [PlaceholderLegalHelpDirectorySource].
  const new();

  static const List<LegalHelpEntry> _entries = [
    LegalHelpEntry(
      id: 'aid_1',
      name: '[Placeholder] District Legal Services Authority — Help Desk',
      category: LegalHelpCategory.legalAid,
      city: 'Bengaluru Urban',
      address: 'Sample City Civil Court Complex, K.G. Road, Bengaluru',
      phone: '+91 00000 00001 (Placeholder)',
      hours: 'Mon–Sat · 10:00–17:00',
      latitude: 12.9762,
      longitude: 77.5847,
      notes: 'Free legal aid under Legal Services Authorities Act, 1987.',
    ),
    LegalHelpEntry(
      id: 'aid_2',
      name: '[Placeholder] State Legal Aid Helpline Reference (NALSA 15100)',
      category: LegalHelpCategory.legalAid,
      city: 'New Delhi',
      address: 'Sample Nyaya Kendra Wing, Tilak Marg, New Delhi',
      phone: '15100 (Public NALSA Helpline)',
      hours: '24×7 Toll-Free Guidance',
      latitude: 28.6221,
      longitude: 77.2395,
      notes: 'Official national toll-free legal aid helpline number.',
    ),
    LegalHelpEntry(
      id: 'aid_3',
      name: '[Placeholder] Consumer & Tenancy Conciliation Clinic',
      category: LegalHelpCategory.legalAid,
      city: 'Mumbai',
      address: 'Sample Legal Aid Annexe, Fort, Mumbai',
      phone: '+91 00000 00002 (Placeholder)',
      hours: 'Mon–Fri · 10:30–16:30',
      latitude: 18.9322,
      longitude: 72.8331,
      notes: 'Pre-litigation mediation & legal notice review desk.',
    ),
    LegalHelpEntry(
      id: 'law_1',
      name: '[Placeholder] Pro-Bono Criminal & Cyber Law Panel',
      category: LegalHelpCategory.lawyers,
      city: 'Bengaluru',
      address: 'Sample Bar Association Chamber Block, Bengaluru',
      phone: '+91 00000 00003 (Placeholder)',
      hours: 'Mon–Sat · By appointment',
      latitude: 12.9781,
      longitude: 77.5902,
      notes: 'Placeholder slot for state Bar Council verified panel feed.',
    ),
    LegalHelpEntry(
      id: 'law_2',
      name: '[Placeholder] MSME Contract & Labour Counsel Desk',
      category: LegalHelpCategory.lawyers,
      city: 'Hyderabad',
      address: 'Sample Advocate Chambers, Nampally, Hyderabad',
      phone: '+91 00000 00004 (Placeholder)',
      hours: 'Mon–Fri · 11:00–18:00',
      latitude: 17.3887,
      longitude: 78.4697,
      notes: 'Placeholder entry — connect verified directory API in prod.',
    ),
    LegalHelpEntry(
      id: 'pol_1',
      name: '[Placeholder] Nearest Town Police Station Desk',
      category: LegalHelpCategory.police,
      city: 'Bengaluru',
      address: 'Sample Division Police Complex, Central Zone',
      phone: '112 (National Emergency)',
      hours: '24×7 Emergency & BNSS 173 e-FIR Desk',
      latitude: 12.9718,
      longitude: 77.5946,
      notes: 'Call 112 for immediate police/ambulance assistance.',
    ),
    LegalHelpEntry(
      id: 'pol_2',
      name: '[Placeholder] National Cyber Crime Reporting Portal',
      category: LegalHelpCategory.police,
      city: 'Pan-India',
      address: 'cybercrime.gov.in · Sample Cyber Cell Node',
      phone: '1930 (National Cyber Helpline)',
      hours: '24×7 Financial & UPI Fraud Freeze Desk',
      latitude: 28.6139,
      longitude: 77.2090,
      notes: 'Report cyber/UPI fraud immediately to freeze suspect accounts.',
    ),
  ];

  @override
  Future<Result<List<LegalHelpEntry>>> fetchEntries({
    required LegalHelpCategory category,
    double? latitude,
    double? longitude,
  }) async {
    final filtered = _entries.where((e) => e.category == category).toList();
    if (latitude == null || longitude == null) {
      return Success(filtered);
    }
    final withDist =
        filtered
            .map(
              (e) => e.withDistance(
                _haversineKm(latitude, longitude, e.latitude, e.longitude),
              ),
            )
            .toList()
          ..sort((a, b) => (a.distanceKm ?? 0).compareTo(b.distanceKm ?? 0));
    return Success(withDist);
  }

  static double _haversineKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const r = 6371.0;
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degToRad(lat1)) *
            math.cos(_degToRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  static double _degToRad(double deg) => deg * (math.pi / 180.0);
}
