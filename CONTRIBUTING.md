# Contributing to Lex

Thank you for considering contributing to **Lex**! Lex is an open-source,
offline-capable AI legal copilot built for India. Because users rely on Lex for
sensitive documents and statutory lookups, **accuracy, verifiability, and
privacy** are our highest engineering priorities.

---

## Ways to Contribute

- **Bug fixes & UI/UX improvements** in the Flutter client (`lib/`)
- **AI pipeline & evaluation improvements** (`lib/ai/`, `test/eval/`)
- **Legal corpus verification & expansion** (`scripts/ingest_legal_corpus.py`) — strictly sourced from official Government of India / Gazette publications
- **Translations** in `lib/l10n/` (`app_en.arb`, `app_hi.arb`, `app_te.arb`, or new Indian languages)
- **FastAPI proxy hardening & tests** in `backend/`
- **Pluggable `LegalHelpDirectorySource` adapters** backed by verified public registries (e.g., NALSA / State Legal Services Authorities)

---

## Development Setup

### Prerequisites

- **Flutter** (stable channel, Dart SDK `^3.13.5`)
- **Python 3.12+** (for FastAPI backend and legal corpus ingestion scripts)
- **Android Studio / SDK** and/or **Xcode** (for device testing)

### 1. Flutter Setup

```bash
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
```

### 2. Backend Setup

```bash
cd backend
python -m venv .venv
# Linux/macOS: source .venv/bin/activate
# Windows PowerShell: .venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

---

## Pull Request Checklist

Before opening a pull request, run the exact CI verification suite locally and
confirm every check passes with **zero warnings**:

```bash
# 1. Regenerate l10n & Freezed/Drift/Riverpod/GoRouter outputs if applicable
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs

# 2. Formatting & strict static analysis (`very_good_analysis`)
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos

# 3. Full Flutter test suite (unit, widget, golden, integration, eval harness)
flutter test

# 4. FastAPI backend tests
python -m pytest backend/tests/test_api.py -v
```

If you modify widgets covered by `test/golden/design_system_golden_test.dart`
intentionally, regenerate goldens with:

```bash
flutter test --update-goldens test/golden/design_system_golden_test.dart
```

---

## Engineering & Safety Rules

1. **No Unhandled Cross-Layer Exceptions**: Domain, repository, network, and AI pipeline boundaries return sealed `Result<T>` (`Success` / `Err`) with `Failure` subtypes (`lib/core/result.dart`, `lib/core/errors/failure.dart`).
2. **Never Fabricate Legal Data**:
   - Never hardcode or invent statutory text, punishments, or legacy IPC/CrPC/IEA mappings.
   - Any section added to `assets/corpus/` must come from an official statutory source parsed by `scripts/ingest_legal_corpus.py`.
   - Never add fabricated people, chambers, or phone numbers to `LegalHelpDirectorySource`; synthetic entries must keep `isPlaceholder: true` and placeholder tags.
3. **Zero Client-Side Secrets**:
   - Never place LLM/API keys in Dart code, `.env` files committed to git, or Flutter assets.
   - Never commit `.env`, `*.jks`, `*.keystore`, or `key.properties`.
4. **Preserve PII Redaction**:
   - Any new cloud endpoint or prompt payload must pass through `PiiRedactor` (`lib/ai/redaction/pii_redactor.dart`) before leaving the device.
   - Never log raw OCR text, chat prompts, contract bodies, or PII on either client or server.
5. **Versioned Prompts & Schemas**:
   - Store AI prompts in `assets/ai/prompts/` and JSON schemas in `assets/ai/schemas/` rather than inline multiline prompt strings in business logic.
6. **Accessible Liquid Glass UI**:
   - Style components from `ThemeExtension<LexTokens>` (`lib/app/theme/lex_tokens.dart`).
   - Provide semantic labels on icon buttons, preserve 48dp touch targets, and test both light and dark modes.

---

## Reporting Security or Privacy Issues

Please **do not** open a public GitHub issue for security vulnerabilities,
encryption flaws, or PII leaks. Contact the maintainer directly at
**mohansriramkunamsetty@gmail.com** with reproduction details so a fix can be
coordinated responsibly.

---

## License

By contributing to Lex, you agree that your contributions will be licensed under
the [MIT License](LICENSE).
