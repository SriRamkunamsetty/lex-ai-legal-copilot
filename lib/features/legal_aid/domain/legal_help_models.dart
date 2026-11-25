import 'package:flutter/foundation.dart';

/// Directory categories shown on the Find Legal Help screen.
enum LegalHelpCategory {
  /// State & District Legal Services Authorities (free legal aid).
  legalAid('Legal aid'),

  /// Independent advocate / clinic directory entries.
  lawyers('Lawyers'),

  /// Police station & cyber helpline desks.
  police('Police');

  new(this.label);

  /// Segmented control label.
  final String label;
}

/// Single entry returned by a pluggable `LegalHelpDirectorySource`.
@immutable
class LegalHelpEntry {
  /// Creates a [LegalHelpEntry].
  const new({
    required this.id,
    required this.name,
    required this.category,
    required this.city,
    required this.address,
    required this.phone,
    required this.hours,
    required this.latitude,
    required this.longitude,
    this.notes = '',
    this.isPlaceholder = true,
    this.distanceKm,
  });

  /// Stable entry identifier.
  final String id;

  /// Organization, authority, or clinic name.
  final String name;

  /// Directory category.
  final LegalHelpCategory category;

  /// City / district label.
  final String city;

  /// Street / court complex address.
  final String address;

  /// Contact phone (explicit placeholder format when [isPlaceholder] is `true`).
  final String phone;

  /// Visiting or helpline hours.
  final String hours;

  /// Latitude coordinate for map pins.
  final double latitude;

  /// Longitude coordinate for map pins.
  final double longitude;

  /// Eligibility or service notes.
  final String notes;

  /// Explicitly marks synthetic starter entries so users never mistake them
  /// for verified real advocates or station extensions.
  final bool isPlaceholder;

  /// Optional Haversine distance in kilometers when location is available.
  final double? distanceKm;

  /// Returns a copy annotated with [distanceKm].
  LegalHelpEntry withDistance(double km) => LegalHelpEntry(
    id: id,
    name: name,
    category: category,
    city: city,
    address: address,
    phone: phone,
    hours: hours,
    latitude: latitude,
    longitude: longitude,
    notes: notes,
    isPlaceholder: isPlaceholder,
    distanceKm: km,
  );
}
