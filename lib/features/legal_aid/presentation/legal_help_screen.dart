import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/case_file/presentation/case_file_providers.dart';
import 'package:lex_copilot/features/legal_aid/domain/legal_help_models.dart';
import 'package:lex_copilot/features/legal_aid/presentation/legal_help_providers.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Find Legal Help screen with Legal Aid, Lawyers, and Police station tabs,
/// interactive map markers, GPS distance sorting, clearly marked placeholder
/// entries via a pluggable `LegalHelpDirectorySource`, and Share Case Summary.
class LegalHelpScreen extends ConsumerStatefulWidget {
  /// Creates a [LegalHelpScreen].
  const new({super.key, this.showInteractiveMap = true});

  /// Toggleable primarily so headless tests can avoid live OSM tile HTTP calls
  /// while keeping map widget behavior verifiable.
  final bool showInteractiveMap;

  @override
  ConsumerState<LegalHelpScreen> createState() => _LegalHelpScreenState();
}

class _LegalHelpScreenState extends ConsumerState<LegalHelpScreen> {
  LegalHelpCategory _category = LegalHelpCategory.legalAid;
  double? _lat;
  double? _lng;
  bool _locating = false;
  String? _locationNotice;

  Future<void> _locateMe() async {
    setState(() {
      _locating = true;
      _locationNotice = null;
    });
    final res = await ref.read(deviceLocationServiceProvider).currentLocation();
    if (!mounted) return;
    switch (res) {
      case Success(:final value):
        setState(() {
          _lat = value.latitude;
          _lng = value.longitude;
          _locating = false;
          _locationNotice = 'Sorted near current GPS coordinates.';
        });
      case Err(:final failure):
        setState(() {
          _locating = false;
          _locationNotice = failure.message;
        });
    }
  }

  Future<void> _shareCaseSummary() async {
    final cases = ref.read(casesStreamProvider).value ?? const [];
    if (cases.isEmpty) {
      await SharePlus.instance.share(
        ShareParams(
          text: 'Requesting legal assistance (shared via Lex). No saved case file attached yet.',
        ),
      );
      return;
    }

    final repo = ref.read(caseFileRepositoryProvider);
    final res = await repo.getCaseBundle(cases.first.id);
    if (res case Success(:final value)) {
      await SharePlus.instance.share(
        ShareParams(text: repo.buildShareableSummary(value)),
      );
    }
  }

  Future<void> _launchPhone(String rawPhone) async {
    final digits = rawPhone.replaceAll(RegExp('[^0-9+]'), '');
    if (digits.isEmpty || digits.contains('00000')) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Placeholder demo number — replace with verified local helpline before calling.',
          ),
        ),
      );
      return;
    }
    await launchUrl(Uri(scheme: 'tel', path: digits));
  }

  Future<void> _openMaps(LegalHelpEntry entry) async {
    final uri = Uri.parse(
      'https://maps.google.com/?q=${entry.latitude},${entry.longitude}',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    final entriesAsync = ref.watch(
      legalHelpEntriesProvider(_category, latitude: _lat, longitude: _lng),
    );

    return LexScaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          tokens.space(22),
          tokens.space(16),
          tokens.space(22),
          tokens.space(32),
        ),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Back',
                onPressed: () => context.pop(),
                icon: Icon(Icons.chevron_left_rounded, color: tokens.text),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Find legal help',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              IconButton(
                tooltip: 'Use current location',
                onPressed: _locating ? null : _locateMe,
                icon: Icon(
                  Icons.my_location_rounded,
                  color: _lat != null ? tokens.accent : tokens.text,
                ),
              ),
            ],
          ),
          Text(
            'Legal aid authorities, counsel panels, and police desks.',
            style: TextStyle(fontSize: 14, color: tokens.secondaryText),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: tokens.riskMedium.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Demo placeholder directory via pluggable LegalHelpDirectorySource. Verify official NALSA (15100), Cyber (1930), or Emergency (112) contacts locally.',
              style: TextStyle(fontSize: 12, color: tokens.text),
            ),
          ),
          if (_locationNotice != null) ...[
            const SizedBox(height: 8),
            Text(
              _locationNotice!,
              style: TextStyle(fontSize: 12, color: tokens.accent),
            ),
          ],
          const SizedBox(height: 12),
          SegmentedControl<LegalHelpCategory>(
            selected: _category,
            onChanged: (value) => setState(() => _category = value),
            segments: [
              for (final c in LegalHelpCategory.values)
                (value: c, label: c.label),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _shareCaseSummary,
              icon: const Icon(Icons.ios_share_rounded, size: 18),
              label: const Text('Share my case summary'),
            ),
          ),
          const SizedBox(height: 14),
          entriesAsync.when(
            loading: () => const LexCard(child: LexSkeleton(height: 140)),
            error: (err, _) =>
                ErrorState(title: 'Directory unavailable', message: '$err'),
            data: (entries) {
              if (entries.isEmpty) {
                return const EmptyState(
                  icon: Icons.location_off_outlined,
                  title: 'No directory entries',
                  message:
                      'No contacts returned by the active directory source.',
                );
              }

              final center = LatLng(
                _lat ?? entries.first.latitude,
                _lng ?? entries.first.longitude,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.showInteractiveMap) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(tokens.cardRadius),
                      child: SizedBox(
                        height: 170,
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: center,
                            initialZoom: 5,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'in.lexcopilot.app',
                            ),
                            MarkerLayer(
                              markers: [
                                for (final e in entries)
                                  Marker(
                                    point: LatLng(e.latitude, e.longitude),
                                    width: 34,
                                    height: 34,
                                    child: Icon(
                                      Icons.location_on_rounded,
                                      color: tokens.accent,
                                      size: 32,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  for (final entry in entries) ...[
                    LexCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entry.name,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: tokens.text,
                                  ),
                                ),
                              ),
                              if (entry.isPlaceholder)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: tokens.riskMedium,
                                    ),
                                  ),
                                  child: Text(
                                    'Placeholder',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: tokens.riskMedium,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${entry.city} · ${entry.address}',
                            style: TextStyle(
                              fontSize: 13,
                              color: tokens.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${entry.hours} · ${entry.phone}'
                            '${entry.distanceKm != null ? ' · ${entry.distanceKm!.toStringAsFixed(1)} km' : ''}',
                            style: TextStyle(
                              fontSize: 12,
                              color: tokens.secondaryText,
                            ),
                          ),
                          if (entry.notes.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              entry.notes,
                              style: TextStyle(
                                fontSize: 12,
                                color: tokens.text,
                              ),
                            ),
                          ],
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => _launchPhone(entry.phone),
                                icon: const Icon(Icons.call_outlined, size: 16),
                                label: const Text('Call'),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                onPressed: () => _openMaps(entry),
                                icon: const Icon(
                                  Icons.directions_outlined,
                                  size: 16,
                                ),
                                label: const Text('Map'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
