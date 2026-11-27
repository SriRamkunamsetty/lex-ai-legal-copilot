import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/case_file/presentation/case_file_screen.dart';
import 'package:lex_copilot/features/chat/presentation/ask_screen.dart';
import 'package:lex_copilot/features/compliance/presentation/compliance_screen.dart';
import 'package:lex_copilot/features/contract_review/presentation/contract_review_screen.dart';
import 'package:lex_copilot/features/draft/presentation/draft_screen.dart';
import 'package:lex_copilot/features/home/presentation/home_screen.dart';
import 'package:lex_copilot/features/incident/presentation/incident_screen.dart';
import 'package:lex_copilot/features/legal_aid/presentation/legal_help_screen.dart';
import 'package:lex_copilot/features/library/presentation/knowledge_packs_screen.dart';
import 'package:lex_copilot/features/library/presentation/library_screen.dart';
import 'package:lex_copilot/features/onboarding/presentation/onboarding_screen.dart';
import 'package:lex_copilot/features/scan/presentation/scan_screen.dart';
import 'package:lex_copilot/features/section_reader/presentation/section_reader_screen.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';
import 'package:lex_copilot/features/settings/presentation/ai_privacy_screen.dart';
import 'package:lex_copilot/features/settings/presentation/appearance_studio_screen.dart';
import 'package:lex_copilot/features/settings/presentation/customize_screen.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';
import 'package:lex_copilot/features/settings/presentation/workspace_sync_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

/// Root navigator key used by top-level non-shell routes.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'rootNavigator',
);

/// Onboarding route displayed on first launch before completing setup.
@TypedGoRoute<OnboardingRoute>(path: '/onboarding')
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  /// Creates an [OnboardingRoute].
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OnboardingScreen();
}

/// Persistent 4-tab shell route containing Home, Scan, Ask, and Library.
@TypedStatefulShellRoute<MainShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<HomeBranchData>(
      routes: <TypedRoute<RouteData>>[TypedGoRoute<HomeRoute>(path: '/home')],
    ),
    TypedStatefulShellBranch<ScanBranchData>(
      routes: <TypedRoute<RouteData>>[TypedGoRoute<ScanRoute>(path: '/scan')],
    ),
    TypedStatefulShellBranch<AskBranchData>(
      routes: <TypedRoute<RouteData>>[TypedGoRoute<AskRoute>(path: '/ask')],
    ),
    TypedStatefulShellBranch<LibraryBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<LibraryRoute>(path: '/library'),
      ],
    ),
  ],
)
class MainShellRouteData extends StatefulShellRouteData {
  /// Creates a [MainShellRouteData].
  const new();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return MainShellScaffold(navigationShell: navigationShell);
  }
}

/// Home branch configuration.
class HomeBranchData extends StatefulShellBranchData {
  /// Creates a [HomeBranchData].
  const new();
}

/// Scan branch configuration.
class ScanBranchData extends StatefulShellBranchData {
  /// Creates a [ScanBranchData].
  const new();
}

/// Ask branch configuration.
class AskBranchData extends StatefulShellBranchData {
  /// Creates an [AskBranchData].
  const new();
}

/// Library branch configuration.
class LibraryBranchData extends StatefulShellBranchData {
  /// Creates a [LibraryBranchData].
  const new();
}

/// Home tab route (`/home`).
class HomeRoute extends GoRouteData with $HomeRoute {
  /// Creates a [HomeRoute].
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

/// Scan tab route (`/scan`).
class ScanRoute extends GoRouteData with $ScanRoute {
  /// Creates a [ScanRoute].
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ScanScreen();
}

/// Ask (chat) tab route (`/ask`).
class AskRoute extends GoRouteData with $AskRoute {
  /// Creates an [AskRoute].
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const AskScreen();
}

/// Library tab route (`/library`).
class LibraryRoute extends GoRouteData with $LibraryRoute {
  /// Creates a [LibraryRoute].
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LibraryScreen();
}

/// Incident-to-sections route (`/incident`).
@TypedGoRoute<IncidentRoute>(path: '/incident')
class IncidentRoute extends GoRouteData with $IncidentRoute {
  /// Creates an [IncidentRoute].
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const IncidentScreen();
}

/// Section reader route (`/section/:act/:number`).
@TypedGoRoute<SectionReaderRoute>(path: '/section/:act/:number')
class SectionReaderRoute extends GoRouteData with $SectionReaderRoute {
  /// Creates a [SectionReaderRoute].
  const new({required this.act, required this.number});

  /// Short act code (e.g. `BNS`).
  final String act;

  /// Section number (e.g. `304`).
  final String number;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SectionReaderScreen(act: act, sectionNumber: number);
}

/// Contract review route (`/contract-review`).
@TypedGoRoute<ContractReviewRoute>(path: '/contract-review')
class ContractReviewRoute extends GoRouteData with $ContractReviewRoute {
  /// Creates a [ContractReviewRoute].
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ContractReviewScreen();
}

/// Document drafting route (`/draft`).
@TypedGoRoute<DraftRoute>(path: '/draft')
class DraftRoute extends GoRouteData with $DraftRoute {
  /// Creates a [DraftRoute].
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DraftScreen();
}

/// Case file route (`/case-file`).
@TypedGoRoute<CaseFileRoute>(path: '/case-file')
class CaseFileRoute extends GoRouteData with $CaseFileRoute {
  /// Creates a [CaseFileRoute].
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CaseFileScreen();
}

/// Legal aid & help directory route (`/legal-help`).
@TypedGoRoute<LegalHelpRoute>(path: '/legal-help')
class LegalHelpRoute extends GoRouteData with $LegalHelpRoute {
  /// Creates a [LegalHelpRoute].
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LegalHelpScreen();
}

/// DPDP Act 2023 & Indian Compliance Intelligence route (`/compliance`).
@TypedGoRoute<ComplianceRoute>(path: '/compliance')
class ComplianceRoute extends GoRouteData with $ComplianceRoute {
  /// Creates a [ComplianceRoute].
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ComplianceScreen();
}

/// Customize hub route (`/customize`) with Appearance Studio and AI/Privacy subroutes.
@TypedGoRoute<CustomizeRoute>(
  path: '/customize',
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<AppearanceRoute>(path: 'appearance'),
    TypedGoRoute<AiPrivacyRoute>(path: 'ai-privacy'),
    TypedGoRoute<KnowledgePacksRoute>(path: 'knowledge-packs'),
    TypedGoRoute<WorkspaceSyncRoute>(path: 'workspace-sync'),
  ],
)
class CustomizeRoute extends GoRouteData with $CustomizeRoute {
  /// Creates a [CustomizeRoute].
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CustomizeScreen();
}

/// Appearance studio route (`/customize/appearance`).
class AppearanceRoute extends GoRouteData with $AppearanceRoute {
  /// Creates an [AppearanceRoute].
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AppearanceStudioScreen();
}

/// AI & Privacy controls route (`/customize/ai-privacy`).
class AiPrivacyRoute extends GoRouteData with $AiPrivacyRoute {
  /// Creates an [AiPrivacyRoute].
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AiPrivacyScreen();
}

/// Offline Knowledge Packs management route (`/customize/knowledge-packs`).
class KnowledgePacksRoute extends GoRouteData with $KnowledgePacksRoute {
  /// Creates a [KnowledgePacksRoute].
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const KnowledgePacksScreen();
}

/// Optional E2EE cloud sync & workspace route (`/customize/workspace-sync`).
class WorkspaceSyncRoute extends GoRouteData with $WorkspaceSyncRoute {
  /// Creates a [WorkspaceSyncRoute].
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const WorkspaceSyncScreen();
}

/// Claude-inspired outer frame with rounded content sheet & 4-icon bottom nav bar.
class MainShellScaffold extends ConsumerWidget {
  /// Creates a [MainShellScaffold].
  const new({required this.navigationShell, super.key});

  /// GoRouter navigation shell managing indexed branch state.
  final StatefulNavigationShell navigationShell;

  Future<void> _openWorkspaceDrawer(
    BuildContext context,
    LexSettings settings,
  ) async {
    unawaited(HapticFeedback.selectionClick());
    final tokens = context.lexTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1E1D1B) : const Color(0xFFFAF8F5);
    final cardBg = isDark ? const Color(0xFF282624) : const Color(0xFFFFFFFF);
    final border = isDark ? const Color(0xFF383531) : const Color(0xFFE8E4DC);
    final handleBg = isDark ? const Color(0xFF47443E) : const Color(0xFFD5D0C7);

    final modeLabel = switch (settings.modelRouting) {
      LexModelRouting.onDevice => 'Local Gemma 4',
      LexModelRouting.auto => 'Hybrid Auto',
      LexModelRouting.cloud => 'Cloud Gemini',
    };

    void openRoute(BuildContext ctx, String path) {
      unawaited(HapticFeedback.selectionClick());
      Navigator.pop(ctx);
      unawaited(context.push(path));
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: border)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: handleBg,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: tokens.accent.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.balance_rounded,
                          size: 20,
                          color: tokens.accent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lex Workspace',
                              style: Theme.of(ctx).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Tools, case vaults & local sync',
                              style: Theme.of(ctx).textTheme.bodySmall
                                  ?.copyWith(color: tokens.secondaryText),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color:
                                    settings.modelRouting ==
                                        LexModelRouting.onDevice
                                    ? const Color(0xFF4CAF50)
                                    : tokens.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              modeLabel,
                              style: Theme.of(ctx).textTheme.labelSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'LEGAL WORKFLOWS',
                    style: Theme.of(ctx).textTheme.labelSmall?.copyWith(
                      color: tokens.secondaryText,
                      letterSpacing: 0.9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _WorkspaceTileCard(
                          icon: Icons.fact_check_rounded,
                          title: 'Contract Review',
                          subtitle: 'Redline & risks',
                          accent: tokens.accent,
                          cardBg: cardBg,
                          border: border,
                          secondaryText: tokens.secondaryText,
                          onTap: () => openRoute(ctx, '/contract-review'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _WorkspaceTileCard(
                          icon: Icons.edit_document,
                          title: 'Draft Studio',
                          subtitle: 'Notices & deeds',
                          accent: const Color(0xFF3E7BFA),
                          cardBg: cardBg,
                          border: border,
                          secondaryText: tokens.secondaryText,
                          onTap: () => openRoute(ctx, '/draft'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _WorkspaceTileCard(
                          icon: Icons.folder_copy_rounded,
                          title: 'Case Files',
                          subtitle: 'Saved binders',
                          accent: const Color(0xFF1F9D77),
                          cardBg: cardBg,
                          border: border,
                          secondaryText: tokens.secondaryText,
                          onTap: () => openRoute(ctx, '/case-file'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _WorkspaceTileCard(
                          icon: Icons.verified_user_rounded,
                          title: 'DPDP Check',
                          subtitle: 'Compliance audit',
                          accent: const Color(0xFF8B5CF6),
                          cardBg: cardBg,
                          border: border,
                          secondaryText: tokens.secondaryText,
                          onTap: () => openRoute(ctx, '/compliance'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'KNOWLEDGE, SYNC & SETTINGS',
                    style: Theme.of(ctx).textTheme.labelSmall?.copyWith(
                      color: tokens.secondaryText,
                      letterSpacing: 0.9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      children: [
                        _WorkspaceListRow(
                          icon: Icons.inventory_2_rounded,
                          title: 'Offline Knowledge Packs',
                          subtitle: 'BNS, BNSS, BSA & DPDP bundles',
                          accent: tokens.accent,
                          secondaryText: tokens.secondaryText,
                          onTap: () =>
                              openRoute(ctx, '/customize/knowledge-packs'),
                        ),
                        Divider(height: 1, indent: 54, color: border),
                        _WorkspaceListRow(
                          icon: Icons.cloud_sync_rounded,
                          title: 'E2EE Sync & Workspaces',
                          subtitle: 'Encrypted backup & devices',
                          accent: tokens.accent,
                          secondaryText: tokens.secondaryText,
                          onTap: () =>
                              openRoute(ctx, '/customize/workspace-sync'),
                        ),
                        Divider(height: 1, indent: 54, color: border),
                        _WorkspaceListRow(
                          icon: Icons.support_agent_rounded,
                          title: 'Legal Aid & Helplines',
                          subtitle: 'NALSA & state legal clinics',
                          accent: tokens.accent,
                          secondaryText: tokens.secondaryText,
                          onTap: () => openRoute(ctx, '/legal-help'),
                        ),
                        Divider(height: 1, indent: 54, color: border),
                        _WorkspaceListRow(
                          icon: Icons.tune_rounded,
                          title: 'Customize & AI Privacy',
                          subtitle: 'Theme, font scale & local models',
                          accent: tokens.accent,
                          secondaryText: tokens.secondaryText,
                          onTap: () => openRoute(ctx, '/customize'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final isPrivateMode = settings.modelRouting == LexModelRouting.onDevice;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 840) {
          return ClaudeShellScaffold(
            currentIndex: navigationShell.currentIndex,
            onSelectTab: (index) => navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            ),
            onOpenMenu: () => _openWorkspaceDrawer(context, settings),
            onSearchTap: () => navigationShell.goBranch(3),
            isPrivateMode: isPrivateMode,
            onPrivateModeToggle: () {
              final next = isPrivateMode
                  ? LexModelRouting.auto
                  : LexModelRouting.onDevice;
              unawaited(
                ref
                    .read(settingsControllerProvider.notifier)
                    .setModelRouting(next),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 2),
                  content: Text(
                    next == LexModelRouting.onDevice
                        ? 'Private mode on: Local Gemma 4 only (offline safe).'
                        : 'Private mode switched to Auto routing.',
                  ),
                ),
              );
            },
            body: navigationShell,
          );
        }
        return LexScaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: (index) => navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                ),
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home_rounded),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.document_scanner_outlined),
                    selectedIcon: Icon(Icons.document_scanner_rounded),
                    label: Text('Scan'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.forum_outlined),
                    selectedIcon: Icon(Icons.forum_rounded),
                    label: Text('Ask'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.layers_outlined),
                    selectedIcon: Icon(Icons.layers_rounded),
                    label: Text('Library'),
                  ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: navigationShell),
            ],
          ),
        );
      },
    );
  }
}

/// Provides the app's configured [GoRouter].
@Riverpod(keepAlive: true)
GoRouter lexRouter(Ref ref) {
  final onboardingDone = ref.watch(
    settingsControllerProvider.select((s) => s.onboardingCompleted),
  );

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: onboardingDone ? '/home' : '/onboarding',
    routes: $appRoutes,
    redirect: (context, state) {
      final isOnboarding = state.matchedLocation == '/onboarding';
      if (!onboardingDone && !isOnboarding) {
        return '/onboarding';
      }
      if (onboardingDone && isOnboarding) {
        return '/home';
      }
      return null;
    },
  );
}

class _WorkspaceTileCard extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.cardBg,
    required this.border,
    required this.secondaryText,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final Color cardBg;
  final Color border;
  final Color secondaryText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 19, color: accent),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: secondaryText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkspaceListRow extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.secondaryText,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final Color secondaryText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: secondaryText),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 18, color: secondaryText),
          ],
        ),
      ),
    );
  }
}
