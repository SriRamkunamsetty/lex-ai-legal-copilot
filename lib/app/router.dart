import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/case_file/presentation/case_file_screen.dart';
import 'package:lex_copilot/features/chat/presentation/ask_screen.dart';
import 'package:lex_copilot/features/contract_review/presentation/contract_review_screen.dart';
import 'package:lex_copilot/features/draft/presentation/draft_screen.dart';
import 'package:lex_copilot/features/home/presentation/home_screen.dart';
import 'package:lex_copilot/features/incident/presentation/incident_screen.dart';
import 'package:lex_copilot/features/legal_aid/presentation/legal_help_screen.dart';
import 'package:lex_copilot/features/library/presentation/library_screen.dart';
import 'package:lex_copilot/features/onboarding/presentation/onboarding_screen.dart';
import 'package:lex_copilot/features/scan/presentation/scan_screen.dart';
import 'package:lex_copilot/features/section_reader/presentation/section_reader_screen.dart';
import 'package:lex_copilot/features/settings/presentation/ai_privacy_screen.dart';
import 'package:lex_copilot/features/settings/presentation/appearance_studio_screen.dart';
import 'package:lex_copilot/features/settings/presentation/customize_screen.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';
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

/// Customize hub route (`/customize`) with Appearance Studio and AI/Privacy subroutes.
@TypedGoRoute<CustomizeRoute>(
  path: '/customize',
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<AppearanceRoute>(path: 'appearance'),
    TypedGoRoute<AiPrivacyRoute>(path: 'ai-privacy'),
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

/// Floating liquid-glass tab bar shell wrapping the 4 primary tabs.
class MainShellScaffold extends StatelessWidget {
  /// Creates a [MainShellScaffold].
  const new({required this.navigationShell, super.key});

  /// GoRouter navigation shell managing indexed branch state.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return LexScaffold(
      body: navigationShell,
      bottomOverlay: LexNavBar(
        currentIndex: navigationShell.currentIndex,
        onSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
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
