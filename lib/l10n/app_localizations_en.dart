// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Lex';

  @override
  String get navHome => 'Home';

  @override
  String get navScan => 'Scan';

  @override
  String get navAsk => 'Ask';

  @override
  String get navLibrary => 'Library';

  @override
  String get homeGreeting => 'Good day';

  @override
  String get homeHeading => 'Your legal desk';

  @override
  String get scanCtaTitle => 'Scan a document';

  @override
  String get scanCtaSubtitle => 'Notice, contract or order';

  @override
  String get askPromptHint => 'Ask Lex anything legal…';

  @override
  String get trustNotice =>
      'Verify with official statutory text — not legal advice.';

  @override
  String get biometricUnlockTitle => 'Unlock Lex';

  @override
  String get biometricUnlockSubtitle =>
      'Verify with biometrics to view your encrypted legal files.';

  @override
  String get biometricUnlockButton => 'Unlock';

  @override
  String get exportMyData => 'Export my data';

  @override
  String get deleteAllData => 'Delete all data';

  @override
  String get privacyNoticeTitle => 'Privacy notice';
}
