import 'package:flutter/material.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';

/// iOS-style pill segmented control matching the prototype's segment bars.
class SegmentedControl<T> extends StatelessWidget {
  /// Creates a [SegmentedControl] for a list of `(value, label)` [segments].
  const new({
    required this.segments,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  /// Ordered segments to display.
  final List<({T value, String label})> segments;

  /// Currently active value.
  final T selected;

  /// Invoked when the user selects a different segment.
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: tokens.neutralControlFill,
        borderRadius: BorderRadius.circular(tokens.chipRadius + 6),
      ),
      child: Row(
        children: [
          for (final segment in segments)
            Expanded(
              child: Semantics(
                button: true,
                selected: segment.value == selected,
                label: segment.label,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(segment.value),
                  child: AnimatedContainer(
                    duration: disableAnimations
                        ? Duration.zero
                        : const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    constraints: const BoxConstraints(minHeight: 36),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: segment.value == selected
                          ? tokens.surface
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        tokens.chipRadius + 2,
                      ),
                      boxShadow: segment.value == selected
                          ? [
                              BoxShadow(
                                color: tokens.glassShadow.withValues(
                                  alpha: 0.14,
                                ),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      segment.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: segment.value == selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: segment.value == selected
                            ? tokens.text
                            : tokens.secondaryText,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
