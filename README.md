# Lex — Offline-Capable AI Legal Copilot (India)

Lex helps individuals, small businesses, and lawyers in India scan legal documents, ask grounded questions with verified statutory citations, classify incidents into **BNS / BNSS / BSA 2023** provisions, review contracts with clause-level redlines, generate templated drafts with PDF export, manage case files with local reminders, and locate legal aid or emergency support.

> Every AI response is grounded against the bundled local corpus, labelled with a confidence tier, paired with verified citation chips, and clearly marked *"Verify with official statutory text — not legal advice."*

## Features Implemented
- **Onboarding & Live Customization**: 3-step persona & privacy setup (`Individual`, `Business`, `Lawyer`), live `LexTokens` liquid-glass theming (`Light`/`Dark`/`System`, accents, radius, glass blur intensity, font family, text scale, compact density, reorderable Home widgets, `en`/`hi`/`te` localization).
- **Scan -> Chat**: Multi-page ML Kit auto edge-detection & crop, camera/gallery import, on-device OCR with automatic multimodal Gemma 4 fallback on low OCR confidence, structured extraction, encrypted `LEX1` file storage, and one-tap handoff to grounded streaming chat.
- **Ask Lex**: Streaming legal Q&A with deterministic corpus citation verification, tappable verified `CitationChip`s -> Section Reader, `ConfidenceBadge`, **Reasoning trail** & **Counter-arguments** toggles, prompt preservation & retry on error.
- **Incident to Sections**: 6 preset categories (`Theft`, `Accident`, `Cheque bounce`, `Cyber fraud`, `Tenancy`, `Workplace`) + text, voice (`speech_to_text`), and photo evidence -> corpus-verified `BNS`/`BNSS`/`BSA` provisions, actionable Next Steps, and Evidence checklist.
- **Offline Section Reader & Library**: 1,059 verbatim sections from official Gazette Acts (`BNS`: 358, `BNSS`: 531, `BSA`: 170), FTS5 search, bookmarks, saved scans, saved drafts, and history inside a `sqlite3mc` SQLCipher-encrypted database.
- **Contract Review**: Clause segmentation, 0–100 `ScoreRing`, High/Medium/Low flags with rationales, side-by-side redline preview, and one-tap **Apply safer wording** + shareable amended text.
- **Draft & PDF Export**: 5 templates (`Rent agreement`, `NDA`, `Legal notice`, `Affidavit`, `Employment offer`), scan-driven field prefill, `[Placeholder]` tracking, mandatory-clause self-check, A4 PDF export (`pdf` + `printing`), and mandatory `LAWYER REVIEW NOTICE`.
- **Case File & Find Legal Help**: Encrypted matter tracker with compliance checklists, timelines, attached scans/drafts, local deadline notifications (`flutter_local_notifications`), `FlutterMap` + `Geolocator` proximity sorting over a pluggable `LegalHelpDirectorySource` (bundled with explicitly marked placeholder data), and case summary sharing.
- **Security & Privacy**: OS Keystore/Keychain 256-bit DB key (`flutter_secure_storage`), `LEX1` encrypted scan vault, pre-flight `PiiRedactor` before any cloud proxy request, biometric app lock (`local_auth`), Android `FLAG_SECURE`, startup expired-scan purge, JSON data export, and full **Delete all data** wipe.

## Project Documentation
- [Architecture Overview](docs/architecture.md)
- [AI & Verification Workflows](docs/ai-workflows.md)
- [Threat Model & Privacy Controls](docs/threat-model.md)
- [Hackathon Demo Script](docs/demo-script.md) & [Pitch Outline](docs/pitch-outline.md)
- [Sample AI Outputs](docs/sample-outputs/)

## Quick Verification (Flutter + Backend)

```bash
# 1. Regenerate localizations & codegen (if schemas/providers/routes changed)
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs

# 2. Format, static analysis (zero infos/warnings), and full test suite
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos
flutter test

# 3. FastAPI backend unit tests
python -m pytest backend/tests/test_api.py -v
```

## Running the FastAPI Backend

```bash
cd backend
pip install -r requirements.txt
# Configure environment variables (never commit real API keys):
#   LEX_DEVICE_TOKEN_SECRET=<strong-random-secret>
#   GEMINI_API_KEY=<server-only-key>
uvicorn app.main:app --host 0.0.0.0 --port 8080
```

Or via Docker:
```bash
docker build -t lex-backend ./backend
docker run -p 8080:8080 -e LEX_DEVICE_TOKEN_SECRET=change-me lex-backend
```

## Flavors, Android Signing & iOS Build Notes
- **Flavors**:
  - `flutter run --flavor dev -t lib/main_dev.dart`
  - `flutter run --flavor staging -t lib/main_staging.dart`
  - `flutter run --flavor prod -t lib/main_prod.dart --dart-define=LEX_API_BASE_URL=https://api.example.com`
- **Android Release Signing**:
  1. Generate an upload keystore outside git (`keytool -genkey -v -keystore lex-release.jks ...`).
  2. Configure `android/key.properties` (`storePassword`, `keyPassword`, `keyAlias`, `storeFile`) and wire `signingConfigs.release` in `android/app/build.gradle.kts`.
  3. Build signed bundle: `flutter build appbundle --flavor prod -t lib/main_prod.dart`.
- **iOS Build Notes**:
  1. Privacy usage keys (`NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`, `NSMicrophoneUsageDescription`, `NSSpeechRecognitionUsageDescription`, `NSLocationWhenInUseUsageDescription`, `NSFaceIDUsageDescription`) are configured in `ios/Runner/Info.plist`.
  2. Open `ios/Runner.xcworkspace` in Xcode on macOS to select your Team ID and Provisioning Profile, then run `flutter build ipa --flavor prod -t lib/main_prod.dart`.

## Known Verification Gaps (`TODO(verify)`)
1. `scripts/ingest_legal_corpus.py`: `indiacode.nic.in` timed out from this build host, so NI Act 1881, IT Act 2000, and the complete BPR&D legacy IPC/CrPC/IEA mapping table carry `TODO(verify)` for rerun from an unrestricted network.
2. `lib/core/network/lex_http_client.dart`: Production TLS certificate SPKI pins carry `TODO(verify)` until the production API domain certificate is provisioned.
3. Physical iOS/Android camera scanner, LiteRT-LM Gemma 4 `.litertlm` multi-GB weight download, and biometric hardware unlock require testing on physical Android/iOS devices (`flutter test` runs deterministic adapters in CI).
