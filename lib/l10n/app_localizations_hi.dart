// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'लेक्स (Lex)';

  @override
  String get navHome => 'होम';

  @override
  String get navScan => 'स्कैन';

  @override
  String get navAsk => 'पूछें';

  @override
  String get navLibrary => 'लाइब्रेरी';

  @override
  String get homeGreeting => 'नमस्ते';

  @override
  String get homeHeading => 'आपका कानूनी डेस्क';

  @override
  String get scanCtaTitle => 'दस्तावेज़ स्कैन करें';

  @override
  String get scanCtaSubtitle => 'नोटिस, अनुबंध या आदेश';

  @override
  String get askPromptHint => 'लेक्स से कोई भी कानूनी प्रश्न पूछें…';

  @override
  String get trustNotice =>
      'आधिकारिक कानून के पाठ से सत्यापित करें — यह कानूनी सलाह नहीं है।';

  @override
  String get biometricUnlockTitle => 'लेक्स अनलॉक करें';

  @override
  String get biometricUnlockSubtitle =>
      'अपनी एन्क्रिप्टेड कानूनी फ़ाइलें देखने के लिए बायोमेट्रिक्स सत्यापित करें।';

  @override
  String get biometricUnlockButton => 'अनलॉक करें';

  @override
  String get exportMyData => 'मेरा डेटा निर्यात करें';

  @override
  String get deleteAllData => 'सारा डेटा हटाएं';

  @override
  String get privacyNoticeTitle => 'गोपनीयता सूचना';
}
