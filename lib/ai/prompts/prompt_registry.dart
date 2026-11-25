import 'package:flutter/services.dart';

/// Identifiers for versioned prompt templates stored in `assets/ai/prompts/`.
enum LexPromptId {
  /// Core Indian legal trust & citation system instruction.
  systemLegalIndia('assets/ai/prompts/system_legal_india_v1.txt'),

  /// Document OCR field extraction & plain-language summary prompt.
  documentExtract('assets/ai/prompts/document_extract_v1.txt'),

  /// Grounded legal research & Q&A prompt.
  researchAnswer('assets/ai/prompts/research_answer_v1.txt'),

  /// Incident classification & section mapping prompt.
  incidentClassify('assets/ai/prompts/incident_classify_v1.txt'),

  /// Contract clause risk classification & redline prompt.
  contractReview('assets/ai/prompts/contract_review_v1.txt'),

  /// Legal template drafting prompt.
  draftGenerate('assets/ai/prompts/draft_generate_v1.txt');

  new(this.assetPath);

  /// Bundled asset path.
  final String assetPath;
}

/// Loads and caches versioned prompt templates from Flutter assets.
class PromptRegistry {
  /// Creates a [PromptRegistry].
  new([this._bundle]);

  final AssetBundle? _bundle;
  final Map<LexPromptId, String> _cache = {};

  AssetBundle get _effectiveBundle => _bundle ?? rootBundle;

  /// Loads [id] from assets and interpolates `{{key}}` placeholders from
  /// [variables].
  Future<String> render(
    LexPromptId id, {
    Map<String, String> variables = const {},
  }) async {
    var template = _cache[id];
    if (template == null) {
      template = await _effectiveBundle.loadString(id.assetPath);
      _cache[id] = template;
    }
    var rendered = template;
    for (final entry in variables.entries) {
      rendered = rendered.replaceAll('{{${entry.key}}}', entry.value);
    }
    return rendered;
  }
}
