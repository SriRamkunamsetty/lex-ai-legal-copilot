import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/ai/pipelines/draft_pipeline.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/draft/presentation/draft_controller.dart';
import 'package:lex_copilot/features/library/presentation/library_providers.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

/// Legal document drafting screen supporting 5 Indian templates, scan prefill,
/// `[placeholder]` detection, mandatory clause check, PDF export, and sharing.
class DraftScreen extends ConsumerStatefulWidget {
  /// Creates a [DraftScreen].
  const new({super.key});

  @override
  ConsumerState<DraftScreen> createState() => _DraftScreenState();
}

class _DraftScreenState extends ConsumerState<DraftScreen> {
  final Map<String, TextEditingController> _fieldControllers = {};
  final TextEditingController _draftEditorController = TextEditingController();

  TextEditingController _controllerFor(String key, String currentValue) {
    final existing = _fieldControllers[key];
    if (existing != null) {
      if (existing.text != currentValue && currentValue.isNotEmpty) {
        existing.text = currentValue;
      }
      return existing;
    }
    final created = TextEditingController(text: currentValue);
    _fieldControllers[key] = created;
    return created;
  }

  @override
  void dispose() {
    for (final c in _fieldControllers.values) {
      c.dispose();
    }
    _draftEditorController.dispose();
    super.dispose();
  }

  Future<void> _exportPdf() async {
    final bytes = await ref
        .read(draftControllerProvider.notifier)
        .buildPdfBytes();
    final label = ref.read(draftControllerProvider).template.storageKey;
    await Printing.sharePdf(bytes: bytes, filename: 'lex_$label.pdf');
  }

  Future<void> _shareText() async {
    final content = ref.read(draftControllerProvider).editedContent.trim();
    if (content.isEmpty) return;
    await SharePlus.instance.share(ShareParams(text: content));
  }

  Future<void> _saveDraft() async {
    final res = await ref
        .read(draftControllerProvider.notifier)
        .saveToLibrary();
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    switch (res) {
      case Success():
        messenger.showSnackBar(
          const SnackBar(content: Text('Draft saved to encrypted Library.')),
        );
      case Err(:final failure):
        messenger.showSnackBar(SnackBar(content: Text(failure.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    final state = ref.watch(draftControllerProvider);
    final controller = ref.read(draftControllerProvider.notifier);
    final scansAsync = ref.watch(scansStreamProvider(''));

    if (state.editedContent.isNotEmpty &&
        _draftEditorController.text != state.editedContent) {
      _draftEditorController.text = state.editedContent;
    } else if (state.editedContent.isEmpty &&
        _draftEditorController.text.isNotEmpty &&
        state.result == null) {
      _draftEditorController.clear();
    }

    return LexScaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          tokens.space(22),
          tokens.space(16),
          tokens.space(22),
          tokens.space(32),
        ),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Back',
                onPressed: () => context.pop(),
                icon: Icon(Icons.chevron_left_rounded, color: tokens.text),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Draft',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              if (state.editedContent.isNotEmpty) ...[
                IconButton(
                  tooltip: 'Export PDF',
                  onPressed: _exportPdf,
                  icon: Icon(Icons.picture_as_pdf_outlined, color: tokens.text),
                ),
                IconButton(
                  tooltip: 'Share draft',
                  onPressed: _shareText,
                  icon: Icon(Icons.ios_share_rounded, color: tokens.text),
                ),
              ],
            ],
          ),
          Text(
            'Pick a template, prefill facts or leave blanks for [placeholders], and export PDF.',
            style: TextStyle(fontSize: 14, color: tokens.secondaryText),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in DraftTemplate.values)
                LexChip(
                  label: t.label,
                  selected: t == state.template,
                  onTap: () {
                    for (final c in _fieldControllers.values) {
                      c.clear();
                    }
                    controller.selectTemplate(t);
                  },
                ),
            ],
          ),
          if (scansAsync.value case final scans? when scans.isNotEmpty) ...[
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final scan in scans.take(4))
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: LexChip(
                        label: 'Prefill from: ${scan.title}',
                        onTap: () {
                          controller.prefillFromScan(
                            ocrText: scan.ocrText,
                            summaryJson: scan.summaryJson,
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          LexCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${state.template.label} details',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                for (final key in state.template.fieldKeys) ...[
                  TextField(
                    controller: _controllerFor(key, state.fields[key] ?? ''),
                    onChanged: (val) => controller.setField(key, val),
                    decoration: InputDecoration(
                      labelText: key,
                      hintText: 'Leave blank for [$key]',
                      isDense: true,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: state.isGenerating
                        ? null
                        : controller.generateDraft,
                    icon: const Icon(Icons.edit_document),
                    label: Text(
                      state.isGenerating
                          ? 'Generating draft…'
                          : 'Generate ${state.template.label}',
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (state.errorMessage != null) ...[
            const SizedBox(height: 12),
            ErrorState(
              title: 'Draft generation failed',
              message: state.errorMessage!,
              onRetry: controller.generateDraft,
            ),
          ],
          if (state.result case final generated?) ...[
            const SizedBox(height: 16),
            LexCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      ConfidenceBadge(
                        level:
                            generated.selfCheck.missingMandatoryClauses.isEmpty
                            ? ConfidenceLevel.high
                            : ConfidenceLevel.medium,
                      ),
                      Chip(
                        label: Text(
                          '${generated.selfCheck.placeholders.length} placeholder${generated.selfCheck.placeholders.length == 1 ? '' : 's'}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _draftEditorController,
                    maxLines: null,
                    minLines: 8,
                    onChanged: controller.updateEditedContent,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: tokens.text,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: tokens.accentTint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      DraftPipeline.lawyerReviewNotice,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: tokens.text,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _saveDraft,
                          icon: const Icon(Icons.bookmark_add_outlined),
                          label: Text(
                            state.savedDraftId != null ? 'Saved' : 'Save',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _exportPdf,
                          icon: const Icon(Icons.picture_as_pdf_outlined),
                          label: const Text('Export PDF'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
