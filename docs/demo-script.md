# Lex 3-Minute Demo Script

1. **Trust-First Onboarding (0:00 – 0:25)**
   - Launch Lex -> select persona (`Individual`, `Small Business`, or `Lawyer`) -> choose **On-device** (Gemma 4 E2B/E4B via LiteRT-LM) or **Auto hybrid**.
   - Show live Appearance Studio (`Customize` -> toggle dark/light theme, royal indigo/teal accent, corner radius, liquid glass blur, language `English` / `हिन्दी` / `తెలుగు`).

2. **Scan a Real Legal Notice -> Grounded Chat (0:25 – 1:10)**
   - Tap **Scan a document** -> scan or pick a multi-page Rent Eviction Notice -> ML Kit edge-detects and runs OCR -> `DocumentPipeline` extracts parties, ₹ amount, and the **30-day deadline**.
   - Tap **Ask Lex about this document** -> document OCR loads into chat context -> ask *"Can my landlord lock me out before 30 days?"* -> stream grounded answer with tappable `CitationChip`s (`BNS 329`, `BNSS 173`), `ConfidenceBadge`, and toggles for **Reasoning trail** and **Counter-arguments**.
   - Tap `BNSS 173` chip to open the **Section Reader** completely offline (verbatim Gazette text + plain-language breakdown + bookmark + share).

3. **Incident -> Verified Sections -> Action Plan (1:10 – 1:45)**
   - From Home quick actions, open **Incident** -> tap **Theft** chip and dictate via mic (*"My phone was snatched outside the metro station"*).
   - Inspect **Sections** (`BNS 304` Snatching, `BNS 303` Theft, `BNSS 173` FIR — all verified against local FTS5 corpus), **Next steps** (police station / 112 / CEIR), and **Evidence** checklist.

4. **Contract Review & Drafting with PDF Export (1:45 – 2:30)**
   - Open **Contract review** -> load sample/scan -> inspect 0-100 **ScoreRing**, High/Medium flags (Indemnity, Termination), expand **Preview redline**, tap **Apply safer wording** -> risk score drops and working text updates live.
   - Open **Draft** -> pick `Legal notice` -> tap **Prefill from scan** -> generate draft with explicit `[Placeholders]` and mandatory `LAWYER REVIEW NOTICE` -> export A4 PDF.

5. **Case File + Find Legal Help + Privacy Controls (2:30 – 3:00)**
   - Open **Case file** -> attach scan/draft to timeline, add a 7-day compliance deadline scheduling a local OS reminder -> tap **Find legal help** -> switch between placeholder Legal Aid / Lawyers / Police tabs & share case summary.
   - Finish in **AI and privacy**: highlight OS Keystore SQLCipher vault, `LEX1` file encryption, pre-flight PII redaction, and one-tap **Export my data** / **Delete all data**.
