import 'package:flutter/material.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/widgets/glass_bar.dart';
import 'package:lex_copilot/l10n/app_localizations.dart';

/// Destination metadata for [LexNavBar].
@immutable
class LexNavDestination {
  /// Creates a [LexNavDestination].
  const new({required this.icon, required this.label});

  /// Outline icon rendered above the label.
  final IconData icon;

  /// Short tab label (`Home`, `Scan`, `Ask`, `Library`).
  final String label;
}

/// Floating 4-tab liquid-glass bottom navigation bar matching the prototype.
class LexNavBar extends StatelessWidget {
  /// Creates a [LexNavBar].
  const new({
    required this.currentIndex,
    required this.onSelected,
    super.key,
    this.destinations = defaultDestinations,
  });

  /// Default 4 destinations matching the prototype (`Home`, `Scan`, `Ask`, `Library`).
  static const List<LexNavDestination> defaultDestinations = [
    LexNavDestination(icon: Icons.home_outlined, label: 'Home'),
    LexNavDestination(icon: Icons.document_scanner_outlined, label: 'Scan'),
    LexNavDestination(icon: Icons.chat_bubble_outline_rounded, label: 'Ask'),
    LexNavDestination(icon: Icons.menu_book_outlined, label: 'Library'),
  ];

  /// Active tab index.
  final int currentIndex;

  /// Callback when a tab is tapped.
  final ValueChanged<int> onSelected;

  /// Destinations rendered inside the bar.
  final List<LexNavDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    final l10n = Localizations.of<AppLocalizations>(context, AppLocalizations);
    final localizedLabels = [
      l10n?.navHome,
      l10n?.navScan,
      l10n?.navAsk,
      l10n?.navLibrary,
    ];

    return GlassBar(
      height: 66,
      borderRadius: 33,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < destinations.length; i++)
            _NavItem(
              destination: LexNavDestination(
                icon: destinations[i].icon,
                label:
                    (i < localizedLabels.length ? localizedLabels[i] : null) ??
                    destinations[i].label,
              ),
              selected: i == currentIndex,
              tokens: tokens,
              onTap: () => onSelected(i),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const new({
    required this.destination,
    required this.selected,
    required this.tokens,
    required this.onTap,
  });

  final LexNavDestination destination;
  final bool selected;
  final LexTokens tokens;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? tokens.text : tokens.secondaryText;

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: Material(
        color: selected ? tokens.accentTint : Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: 72,
            height: 52,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(destination.icon, size: 22, color: fg),
                const SizedBox(height: 2),
                Text(
                  destination.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: fg,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
