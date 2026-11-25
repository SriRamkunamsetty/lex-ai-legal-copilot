# Lex Hackathon Pitch Outline

## Slide 1 — Problem
- Over 80% of individuals and MSMEs in India encounter rent disputes, cyber/UPI scams, vendor contracts, or police complaints without affordable immediate legal clarity.
- General AI chatbots hallucinate repealed IPC/CrPC numbers or send sensitive Aadhaar, PAN, and banking details in plaintext to remote clouds.

## Slide 2 — Solution: Lex
- Offline-capable, liquid-glass mobile legal copilot built for India's post-2024 criminal codes (**BNS, BNSS, BSA 2023**) and everyday contracts.
- **No fabricated citations**: every AI answer and incident classification runs through a deterministic verifier against a bundled **1,059-section SQLite FTS5 statutory corpus**.

## Slide 3 — Deep Hybrid AI Architecture (25% Judging Weight)
- **Dual-path Gemma 4**: On-device multimodal Gemma 4 E2B/E4B (`LiteRT-LM`) + Cloud proxy (`FastAPI` + SSE + server-held keys).
- **Pre-flight `PiiRedactor`**: Aadhaar, PAN, phone, IFSC, UPI, bank numbers never leave the phone raw.
- **Multimodal OCR fallback**: ML Kit OCR escalates low-confidence blurred pages to multimodal vision automatically.

## Slide 4 — End-to-End Action Workflows (Product Innovation + UI/UX)
- **Scan -> Chat -> Section Reader** -> **Incident (voice/photo/text) -> Next Steps** -> **Contract Redlines** -> **Prefilled Draft + PDF** -> **Case Deadlines + Local Notifications** -> **Legal Aid Share**.
- Live customizable liquid-glass design system (`ThemeExtension<LexTokens>`), dark/light parity, WCAG AA targets, English/Hindi/Telugu localization.

## Slide 5 — Trust, Security & Viability
- SQLCipher-compatible `sqlite3mc` DB keyed in Android Keystore / iOS Keychain, `LEX1` encrypted scan vault, Android `FLAG_SECURE`, biometric lock, startup scan expiry purge, and one-tap JSON export/wipe.
- Monorepo validation: `flutter analyze --fatal-infos` (0 warnings), 45+ automated Flutter unit/widget/golden/eval/integration tests, FastAPI unit tests, and automated eval harness (100% citation hallucination drop rate & 100% incident recall on seed benchmark).
- **Business model**: Freemium offline legal reader & on-device triage for citizens; Pro tier for MSME contract review & Advocate multi-matter workspaces; pluggable Legal Aid / Bar Council referral directory.
