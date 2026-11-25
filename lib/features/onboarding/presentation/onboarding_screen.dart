import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';

/// Three-step onboarding flow: value proposition, role selection, and privacy
/// routing choice.
class OnboardingScreen extends ConsumerStatefulWidget {
  /// Creates an [OnboardingScreen].
  const new({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  LexUserRole _role = LexUserRole.individual;
  LexModelRouting _routing = LexModelRouting.onDevice;

  Future<void> _next() async {
    if (_step < 2) {
      setState(() => _step += 1);
      return;
    }
    await ref
        .read(settingsControllerProvider.notifier)
        .completeOnboarding(role: _role, modelRouting: _routing);
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;

    return LexScaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          tokens.space(26),
          tokens.space(20),
          tokens.space(26),
          tokens.space(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: tokens.accent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.balance_rounded,
                        size: 18,
                        color: tokens.onAccent,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Lex',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: tokens.text,
                      ),
                    ),
                  ],
                ),
                if (_step > 0)
                  TextButton(
                    onPressed: () => setState(() => _step -= 1),
                    child: const Text('Back'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: switch (_step) {
                    0 => _ValuePropStep(tokens: tokens),
                    1 => _RoleStep(
                      selected: _role,
                      onChanged: (role) => setState(() => _role = role),
                    ),
                    _ => _PrivacyStep(
                      selected: _routing,
                      onChanged: (routing) =>
                          setState(() => _routing = routing),
                    ),
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < 3; i++)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _step ? 22 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == _step ? tokens.accent : tokens.hairline,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
              ],
            ),
            SizedBox(height: tokens.space(18)),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _next,
                child: Text(_step < 2 ? 'Continue' : 'Open your legal desk'),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Verify answers with official statutory text · Not legal advice',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: tokens.secondaryText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValuePropStep extends StatelessWidget {
  const new({required this.tokens});

  final LexTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: SizedBox(
            width: 240,
            height: 250,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: tokens.accent.withValues(alpha: 0.55),
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const LexCard(
                      padding: EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          LexSkeleton(width: 90, height: 7),
                          LexSkeleton(height: 7),
                          LexSkeleton(width: 150, height: 7),
                          LexSkeleton(height: 7),
                          LexSkeleton(width: 110, height: 7),
                          LexSkeleton(height: 7),
                          LexSkeleton(width: 75, height: 7),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: -18,
                  bottom: 24,
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    borderRadius: 18,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Notice period',
                          style: TextStyle(
                            fontSize: 12,
                            color: tokens.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '30 days',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: tokens.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: tokens.space(32)),
        Text(
          'Snap any legal document. Understand it instantly.',
          style: Theme.of(context).textTheme.headlineLarge
              ?.copyWith(height: 1.12, fontSize: 31),
        ),
        SizedBox(height: tokens.space(10)),
        Text(
          'Scan notices, check BNS/BNSS/BSA sections, and get cited answers. Private and offline-capable with Gemma 4.',
          style: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(color: tokens.secondaryText),
        ),
      ],
    );
  }
}

class _RoleStep extends StatelessWidget {
  const new({required this.selected, required this.onChanged});

  final LexUserRole selected;
  final ValueChanged<LexUserRole> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    const roles = [
      (
        role: LexUserRole.individual,
        title: 'Individual',
        subtitle:
            'Plain-language explanations, incident help, and FIR guidance.',
      ),
      (
        role: LexUserRole.business,
        title: 'Small Business',
        subtitle: 'Contract risk reviews, vendor redlines, and compliance checklists.',
      ),
      (
        role: LexUserRole.lawyer,
        title: 'Lawyer / Advocate',
        subtitle:
            'Fast BNS/IPC cross-references, citations, and structured drafts.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How will you use Lex?',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        SizedBox(height: tokens.space(8)),
        Text(
          'Lex adapts explanations, templates, and home widgets to your work.',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: tokens.secondaryText),
        ),
        SizedBox(height: tokens.space(20)),
        for (final item in roles) ...[
          LexCard(
            onTap: () => onChanged(item.role),
            backgroundColor: selected == item.role
                ? tokens.accentTint
                : tokens.surface,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: tokens.text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: tokens.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  selected == item.role
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected == item.role
                      ? tokens.accent
                      : tokens.secondaryText,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _PrivacyStep extends StatelessWidget {
  const new({required this.selected, required this.onChanged});

  final LexModelRouting selected;
  final ValueChanged<LexModelRouting> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    const options = [
      (
        routing: LexModelRouting.onDevice,
        title: 'On-device · Gemma 4 E4B',
        subtitle: 'Keeps scans and chats strictly on your phone. Works completely offline.',
      ),
      (
        routing: LexModelRouting.auto,
        title: 'Auto · Private first, Cloud for depth',
        subtitle: 'Uses on-device Gemma 4 for scans & quick checks; PII-redacted Cloud Gemma 4 31B for deep research.',
      ),
      (
        routing: LexModelRouting.cloud,
        title: 'Cloud · Gemma 4 31B',
        subtitle: 'Highest-capacity reasoning via API proxy with automatic PII redaction.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose your AI privacy mode',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        SizedBox(height: tokens.space(8)),
        Text(
          'You can switch routing anytime in Customize → AI and privacy.',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: tokens.secondaryText),
        ),
        SizedBox(height: tokens.space(20)),
        for (final item in options) ...[
          LexCard(
            onTap: () => onChanged(item.routing),
            backgroundColor: selected == item.routing
                ? tokens.accentTint
                : tokens.surface,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: tokens.text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: tokens.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  selected == item.routing
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected == item.routing
                      ? tokens.accent
                      : tokens.secondaryText,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
