// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $onboardingRoute,
  $mainShellRouteData,
  $incidentRoute,
  $sectionReaderRoute,
  $contractReviewRoute,
  $draftRoute,
  $caseFileRoute,
  $legalHelpRoute,
  $customizeRoute,
];

RouteBase get $onboardingRoute => GoRouteData.$route(
  path: '/onboarding',
  hasOverriddenOnExit: false,
  factory: $OnboardingRoute._fromState,
);

mixin $OnboardingRoute on GoRouteData {
  static OnboardingRoute _fromState(GoRouterState state) =>
      const OnboardingRoute();

  @override
  String get location => GoRouteData.$location('/onboarding');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mainShellRouteData => StatefulShellRouteData.$route(
  factory: $MainShellRouteDataExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/home',
          hasOverriddenOnExit: false,
          factory: $HomeRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/scan',
          hasOverriddenOnExit: false,
          factory: $ScanRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/ask',
          hasOverriddenOnExit: false,
          factory: $AskRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/library',
          hasOverriddenOnExit: false,
          factory: $LibraryRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $MainShellRouteDataExtension on MainShellRouteData {
  static MainShellRouteData _fromState(GoRouterState state) =>
      const MainShellRouteData();
}

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ScanRoute on GoRouteData {
  static ScanRoute _fromState(GoRouterState state) => const ScanRoute();

  @override
  String get location => GoRouteData.$location('/scan');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AskRoute on GoRouteData {
  static AskRoute _fromState(GoRouterState state) => const AskRoute();

  @override
  String get location => GoRouteData.$location('/ask');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $LibraryRoute on GoRouteData {
  static LibraryRoute _fromState(GoRouterState state) => const LibraryRoute();

  @override
  String get location => GoRouteData.$location('/library');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $incidentRoute => GoRouteData.$route(
  path: '/incident',
  hasOverriddenOnExit: false,
  factory: $IncidentRoute._fromState,
);

mixin $IncidentRoute on GoRouteData {
  static IncidentRoute _fromState(GoRouterState state) => const IncidentRoute();

  @override
  String get location => GoRouteData.$location('/incident');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $sectionReaderRoute => GoRouteData.$route(
  path: '/section/:act/:number',
  hasOverriddenOnExit: false,
  factory: $SectionReaderRoute._fromState,
);

mixin $SectionReaderRoute on GoRouteData {
  static SectionReaderRoute _fromState(GoRouterState state) =>
      SectionReaderRoute(
        act: state.pathParameters['act']!,
        number: state.pathParameters['number']!,
      );

  SectionReaderRoute get _self => this as SectionReaderRoute;

  @override
  String get location => GoRouteData.$location(
    '/section/${Uri.encodeComponent(_self.act)}/${Uri.encodeComponent(_self.number)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $contractReviewRoute => GoRouteData.$route(
  path: '/contract-review',
  hasOverriddenOnExit: false,
  factory: $ContractReviewRoute._fromState,
);

mixin $ContractReviewRoute on GoRouteData {
  static ContractReviewRoute _fromState(GoRouterState state) =>
      const ContractReviewRoute();

  @override
  String get location => GoRouteData.$location('/contract-review');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $draftRoute => GoRouteData.$route(
  path: '/draft',
  hasOverriddenOnExit: false,
  factory: $DraftRoute._fromState,
);

mixin $DraftRoute on GoRouteData {
  static DraftRoute _fromState(GoRouterState state) => const DraftRoute();

  @override
  String get location => GoRouteData.$location('/draft');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $caseFileRoute => GoRouteData.$route(
  path: '/case-file',
  hasOverriddenOnExit: false,
  factory: $CaseFileRoute._fromState,
);

mixin $CaseFileRoute on GoRouteData {
  static CaseFileRoute _fromState(GoRouterState state) => const CaseFileRoute();

  @override
  String get location => GoRouteData.$location('/case-file');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $legalHelpRoute => GoRouteData.$route(
  path: '/legal-help',
  hasOverriddenOnExit: false,
  factory: $LegalHelpRoute._fromState,
);

mixin $LegalHelpRoute on GoRouteData {
  static LegalHelpRoute _fromState(GoRouterState state) =>
      const LegalHelpRoute();

  @override
  String get location => GoRouteData.$location('/legal-help');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $customizeRoute => GoRouteData.$route(
  path: '/customize',
  hasOverriddenOnExit: false,
  factory: $CustomizeRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'appearance',
      hasOverriddenOnExit: false,
      factory: $AppearanceRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'ai-privacy',
      hasOverriddenOnExit: false,
      factory: $AiPrivacyRoute._fromState,
    ),
  ],
);

mixin $CustomizeRoute on GoRouteData {
  static CustomizeRoute _fromState(GoRouterState state) =>
      const CustomizeRoute();

  @override
  String get location => GoRouteData.$location('/customize');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AppearanceRoute on GoRouteData {
  static AppearanceRoute _fromState(GoRouterState state) =>
      const AppearanceRoute();

  @override
  String get location => GoRouteData.$location('/customize/appearance');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AiPrivacyRoute on GoRouteData {
  static AiPrivacyRoute _fromState(GoRouterState state) =>
      const AiPrivacyRoute();

  @override
  String get location => GoRouteData.$location('/customize/ai-privacy');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the app's configured [GoRouter].

@ProviderFor(lexRouter)
final lexRouterProvider = LexRouterProvider._();

/// Provides the app's configured [GoRouter].

final class LexRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Provides the app's configured [GoRouter].
  LexRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lexRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lexRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return lexRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$lexRouterHash() => r'dfe0a47eeed923cf029ee1d2763b733ae2496b6b';
