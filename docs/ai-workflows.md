# Lex AI & Grounding Workflows

## 1. Unified `LlmService` & Hybrid Model Routing
All AI features code against `abstract interface class LlmService`:
- **`OnDeviceGemmaService`** (`lib/ai/on_device/on_device_gemma_service.dart`): Uses `flutter_edge_ai` + `flutter_edge_ai_litertlm` (`LiteRtLmEngine`) with Google Gemma 4 `gemma-4-e4b-it` / `gemma-4-e2b-it` `.litertlm` weights, SHA-256 download verification, E4B -> E2B / GPU -> CPU low-memory fallback, and vision/audio flags.
- **`CloudGemmaService`** (`lib/ai/cloud/cloud_gemma_service.dart`): Streams SSE responses and structured JSON from the FastAPI proxy (`POST /v1/chat`, etc.) using Gemma 4 26B/31B (`TODO(verify)` exact hosted Vertex/AI Studio model ID in deployment `.env`).
- **`ModelRouter`** (`lib/ai/router/model_router.dart`): Honors user preference (`Auto`, `On-device`, `Cloud`). In `Auto`, private/offline/short queries run locally while deep research or cloud-eligible tasks can route through `CloudGemmaService`, automatically degrading to on-device if the cloud endpoint fails.

## 2. Pre-Flight PII Redaction (`PiiRedactor`)
Before any request reaches `CloudGemmaService`, `PiiRedactor` (`lib/ai/redaction/pii_redactor.dart`) replaces Indian Aadhaar numbers, PANs, +91 mobile numbers, email addresses, IFSC codes, UPI handles, long bank account sequences, and supplied party names with numbered placeholders (`[AADHAAR_1]`, `[PHONE_1]`, etc.), and restores them client-side after streaming finishes.

## 3. Pipelines

| Pipeline | Steps | Trust & Verification Guardrail |
|---|---|---|
| `DocumentPipeline` | Multi-page ML Kit scanner/OCR -> confidence heuristic -> multimodal image fallback (`usedMultimodalFallback`) when OCR confidence is low -> structured JSON (`document_type`, `parties`, `dates`, `deadlines`, `amounts`, `plain_language_summary`, `key_risks`). | JSON schema validation + 1 retry on malformed output. |
| `ResearchPipeline` | Query rewrite -> FTS5 & citation retrieval from local `LegalCorpusRepository` -> low-temperature grounded generation -> **Deterministic Corpus Verifier Pass** -> confidence score. | Checks every `BNS`/`BNSS`/`BSA` reference against local DB; strips unverified citations under `strictCitationsOnly`, appends `"Verify with official statutory text — not legal advice."` |
| `IncidentPipeline` | Category expansion + keyword FTS5 search (+ `BNSS 173` baseline) -> candidate section prompt -> structured JSON + corpus verification -> offline deterministic fallback if model unavailable. | Only provisions existing in `LegalCorpusRepository` can be returned. |
| `ContractPipeline` | Heuristic clause segmentation -> structured per-clause severity (`high`/`medium`/`low`), rationale, suggested rewrite, 0-100 risk score -> one-tap `applySaferWording`. | Offline keyword heuristic fallback if model unavailable; outputs highlight negotiation points rather than formal legal sign-off. |
| `DraftPipeline` | 5 templates (`Rent agreement`, `NDA`, `Legal notice`, `Affidavit`, `Employment offer`) -> optional `SavedScans` entity prefill -> generation with `[Placeholder]` markers -> mandatory-clause self-check -> A4 PDF export. | Always appends `"LAWYER REVIEW NOTICE"` banner & text section. |
