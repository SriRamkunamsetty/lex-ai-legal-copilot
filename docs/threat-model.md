# Lex Threat Model & Security Controls

## 1. Assets Protected
- **Legal scans & OCR text** (`SavedScans`, vault image files) containing PII (Aadhaar, PAN, phone numbers, bank/account IDs, names, addresses).
- **Case files, drafts, bookmarks, and chat history** stored on-device.
- **Model inference API keys** (must never ship inside Flutter binary assets or Dart constants).
- **Bundled Indian Statutory Corpus** (`BNS 2023`, `BNSS 2023`, `BSA 2023` JSON) — integrity-verified offline trust anchor.

## 2. Trust Boundaries
1. **Device Storage Boundary**: Local OS file system vs. App-private SQLite vault + scan vault.
2. **UI Screen Boundary**: OS task switcher previews / screen capture vs. confidential legal documents.
3. **Device -> Cloud Proxy Boundary**: Mobile app to FastAPI backend (`/v1/*`) over HTTPS with short-lived device token (`X-Device-Token`).
4. **Cloud Proxy -> LLM Provider Boundary**: FastAPI backend to Gemini / Gemma 4 26B/31B endpoints.

## 3. Threats & Mitigations

| Threat | Vector | Mitigation Implemented in Lex |
|---|---|---|
| Plaintext database exfiltration on rooted/stolen device | Reading app SQLite file directly | `sqlite3mc` SQLCipher-compatible encryption (`PRAGMA key`) with random 256-bit key stored in OS Keystore/Keychain via `flutter_secure_storage` (`SecureKeyManager`), tested by `app_database_encryption_test.dart`. |
| Plaintext document scan leak from app support dir | Reading cached scan JPEGs | `EncryptedFileStore` (`LEX1` envelope: 16-byte CSPRNG nonce + SHA-256 CTR stream + HMAC-SHA256 tag) keyed from `SecureKeyManager`, active when `encryptLocalFiles` is enabled. |
| Unauthorized glance / shoulder-surfing / screenshot capture | Task switcher preview or unlocked screen | `BiometricLockGate` (`local_auth`) + Android `FLAG_SECURE` enabled on `MainActivity.kt` + dynamic method channel control. |
| Sensitive PII sent to cloud Gemma model | User scans notice containing Aadhaar/PAN/phone/bank info | Deterministic `PiiRedactor` scrubs Aadhaar, PAN, Indian mobile numbers, emails, IFSC, UPI IDs, bank account numbers, and known party names pre-flight and restores placeholders locally after streaming; redacted tokens never leave device unless unredacted text was explicitly pasted outside patterns. |
| Unauthenticated / abusive cloud proxy usage or quota drain | Replaying backend requests without app auth | Short-lived HMAC-signed device token (`backend/app/auth.py`) + per-device rate limiting (`backend/app/main.py`) + no-content logging (`backend/app/config.py`). |
| Model / API key extraction from APK/IPA | Reverse engineering Dart binary | Zero LLM API keys inside Flutter; `CLOUD_GEMMA_API_KEY` lives strictly in FastAPI server environment variables. |
| Hallucinated statutory citations presented as Indian law | Model invents non-existent section numbers | Deterministic corpus verifier in `ResearchPipeline` & `IncidentPipeline` drops/flags any citation absent from local `LegalCorpusRepository` (`strictCitationsOnly` enforced by default). |
| Stale sensitive scan accumulation | Old documents kept indefinitely | `autoDeleteScansDays` setting (default 30 days) sets `expiresAt` on `SavedScans`, purged on app startup (`bootstrap.dart`), plus full `"Delete all data"` wipe in `AiPrivacyScreen`. |

## 4. Residual Risks & `TODO(verify)` Items
- `TODO(verify)`: Add production FastAPI TLS SPKI pin hashes in `LexHttpClient` before production release builds (`prod` flavor).
- `TODO(verify)`: Verify iOS screenshot/background snapshot blurring in `SceneDelegate` before App Store submission.
- `TODO(verify)`: Complete `PiiRedactor` validation against real multi-lingual Hindi/Telugu transliterated names in extended field testing.
