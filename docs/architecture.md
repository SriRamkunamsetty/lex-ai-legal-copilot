# Lex Architecture

## 1. Clean Feature-First Layout

```text
lib/
  app/              # Bootstrap, FlavorConfig (dev/staging/prod), go_router_builder routes, LexTokens ThemeExtension
  core/             # Result<T>/Failure, encrypted AppDatabase (Drift + sqlite3mc), SecureKeyManager, EncryptedFileStore, BiometricLockGate, LexHttpClient, liquid-glass UI primitives
  ai/               # LlmService interface, OnDeviceGemmaService (LiteRT-LM Gemma 4 E2B/E4B), CloudGemmaService (FastAPI SSE), ModelRouter, PiiRedactor, versioned prompts & schemas, 5 AI pipelines
  legal_corpus/     # Offline SQLite + FTS5 corpus repository (1,059 sections: BNS 358, BNSS 531, BSA 170)
  features/
    onboarding/     # 3-step value props, role (Individual / Business / Lawyer), privacy routing choice
    home/           # Customizable legal desk dashboard ("Good day")
    scan/           # ML Kit document scanner + gallery/camera + OCR + DocumentPipeline + encrypted file save
    chat/           # Ask Lex streaming Q&A, Reasoning trail & Counter-arguments toggles, citation verification
    incident/       # Category chips + text/speech_to_text voice/photo + IncidentPipeline + Next steps & Evidence
    section_reader/ # Offline statutory reader, IPC cross-reference badge, bookmarks, share, Ask Lex handoff
    contract_review/# Clause segmentation, 0-100 risk score, redline preview, apply safer wording
    draft/          # 5 Indian legal templates, scan prefill, [placeholder] checks, A4 PDF export
    case_file/      # Encrypted matter tracker, deadlines + local OS notifications, checklists, shareable summary
    legal_aid/      # Pluggable LegalHelpDirectorySource + FlutterMap + Geolocator + placeholder directory
    library/        # Full-text search + Bookmarks / Scans / Drafts / History tabs
    settings/       # Live Appearance Studio & AI/Privacy controls (theme, accent, glass blur, radius, l10n, data wipe)
  l10n/             # ARB files for English (`en`), Hindi (`hi`), Telugu (`te`)
backend/            # Async Python FastAPI proxy, device-token HMAC auth, rate limit, Chroma/in-memory corpus, Gemma cloud client
```

## 2. State, Routing, and Error Handling
- **State**: Riverpod (`@riverpod` / `riverpod_generator`) with keep-alive singletons for DB, HTTP client, ModelRouter, ChatController, ScanController, DraftController, and ContractReviewController.
- **Navigation**: `go_router` + `go_router_builder` typed routes with a 4-tab `StatefulShellRoute` (`/home`, `/scan`, `/ask`, `/library`) and full-screen feature routes (`/incident`, `/section/:act/:number`, `/contract-review`, `/draft`, `/case-file`, `/legal-help`, `/customize`, `/onboarding`).
- **Errors**: Sealed `Result<T>` (`Success` / `Err`) and sealed `Failure` hierarchy (`NetworkFailure`, `StorageFailure`, `ValidationFailure`, `AuthFailure`, `AiFailure`, `NotFoundFailure`, `UnexpectedFailure`). Cross-layer methods return `Result<T>` rather than throwing uncaught domain exceptions.

## 3. Storage & Encryption Architecture
- **UI Preferences**: Non-sensitive display preferences (`LexSettings` Freezed JSON) live in `SharedPreferences`.
- **Encrypted Vault (`AppDatabase` v2)**: Encrypted via `sqlite3` (`sqlite3mc` SQLCipher compatibility) with `PRAGMA key` backed by `SecureKeyManager` (`flutter_secure_storage` OS Keystore/Keychain). Includes automatic `onUpgrade` migration from v1 to v2 (`CaseFiles`, `CaseDeadlines`, `CaseChecklistItems`).
- **Encrypted Scan Files (`EncryptedFileStore`)**: Writes `LEX1`-prefixed encrypted blobs (random 16-byte nonce + SHA-256 CTR stream + HMAC-SHA256 integrity tag) when `encryptLocalFiles` is enabled, with automatic startup expiry cleanup (`autoDeleteScansDays`).
