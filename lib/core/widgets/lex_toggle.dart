import 'package:flutter/material.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';

/// iOS-style pill toggle switch with an accessible 48dp hit target.
class LexToggle extends StatelessWidget {
  /// Creates a [LexToggle].
  const new({
    required this.value,
    required this.onChanged,
    super.key,
    this.semanticLabel,
  });

  /// Current toggle state.
  final bool value;

  /// Invoked when the user flips the switch.
  final ValueChanged<bool> onChanged;

  /// Accessibility label announced by screen readers.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return Semantics(
      toggled: value,
      label: semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!value),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: AnimatedContainer(
              duration: disableAnimations
                  ? Duration.zero
                  : const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              width: 46,
              height: 28,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: value ? tokens.accent : tokens.neutralControlFill,
              ),
              child: AnimatedAlign(
                duration: disableAnimations
                    ? Duration.zero
                    : const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: value ? tokens.onAccent : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
