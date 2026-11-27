import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/ai/pipelines/document_pipeline.dart';
import 'package:lex_copilot/ai/pipelines/research_pipeline.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/chat/domain/chat_models.dart';
import 'package:lex_copilot/features/chat/presentation/chat_controller.dart';
import 'package:lex_copilot/features/scan/presentation/scan_controller.dart';

/// Multi-page document scanner, offline ML Kit OCR, and structured legal summary.
class ScanScreen extends ConsumerWidget {
  /// Creates a [ScanScreen].
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.lexTokens;
    final state = ref.watch(scanControllerProvider);
    final controller = ref.read(scanControllerProvider.notifier);

    return ListView(
      padding: EdgeInsets.fromLTRB(
        tokens.space(22),
        tokens.space(20),
        tokens.space(22),
        24 + ClaudeBottomBarInset.of(context),
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scan document',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Multi-page edge-detect crop, offline OCR, and structured legal extraction.',
                    style: TextStyle(fontSize: 14, color: tokens.secondaryText),
                  ),
                ],
              ),
            ),
            if (state.pages.isNotEmpty)
              IconButton(
                tooltip: 'Clear scan',
                onPressed: controller.reset,
                icon: Icon(Icons.refresh_rounded, color: tokens.secondaryText),
              ),
          ],
        ),
        SizedBox(height: tokens.space(16)),
        if (state.errorMessage != null) ...[
          ErrorState(
            title: 'Scan could not complete',
            message: state.errorMessage!,
            onRetry: state.pages.isNotEmpty
                ? controller.analyzeDocument
                : controller.scanDocument,
          ),
          SizedBox(height: tokens.space(14)),
        ],
        LexCard(
          padding: EdgeInsets.all(tokens.space(18)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: state.isCapturing
                          ? null
                          : controller.scanDocument,
                      icon: const Icon(Icons.document_scanner_outlined),
                      label: Text(
                        state.isCapturing ? 'Opening…' : 'Auto-scan pages',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: state.isCapturing
                          ? null
                          : controller.captureFromCamera,
                      icon: const Icon(Icons.camera_alt_outlined, size: 18),
                      label: const Text('Camera'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: state.isCapturing
                          ? null
                          : controller.pickFromGallery,
                      icon: const Icon(Icons.photo_library_outlined, size: 18),
                      label: const Text('Gallery'),
                    ),
                  ),
                ],
              ),
              if (state.pages.isEmpty) ...[
                const SizedBox(height: 18),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 150,
                        height: 170,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: tokens.accent.withValues(alpha: 0.65),
                            width: 1.5,
                          ),
                          color: tokens.background,
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LexSkeleton(width: 72, height: 6),
                            LexSkeleton(height: 6),
                            LexSkeleton(width: 96, height: 6),
                            LexSkeleton(height: 6),
                            LexSkeleton(width: 64, height: 6),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Capture rent agreements, legal notices, challans, or court orders.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: tokens.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const SizedBox(height: 16),
                Text(
                  '${state.pages.length} page${state.pages.length == 1 ? '' : 's'} queued',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: tokens.secondaryText,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (var i = 0; i < state.pages.length; i++)
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          DocumentThumb(
                            fileName: state.pages[i].fileName,
                            subtitle:
                                'Page ${i + 1} · ${(state.pages[i].bytes.length / 1024).ceil()} KB',
                          ),
                          Positioned(
                            top: -6,
                            right: -6,
                            child: Semantics(
                              button: true,
                              label: 'Remove page ${i + 1}',
                              child: InkWell(
                                onTap: () => controller.removePage(i),
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: tokens.surface,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: tokens.hairline),
                                  ),
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 14,
                                    color: tokens.text,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: state.isAnalyzing
                        ? null
                        : controller.analyzeDocument,
                    icon: state.isAnalyzing
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: tokens.onAccent,
                            ),
                          )
                        : const Icon(Icons.auto_awesome_outlined),
                    label: Text(
                      state.isAnalyzing
                          ? 'Reading text & extracting fields…'
                          : 'Extract & summarize',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (state.extraction case final ext?) ...[
          SizedBox(height: tokens.space(16)),
          _ExtractionResultView(
            extraction: ext,
            scanId: state.savedScanId ?? 'scan_active',
            fileName: state.pages.isNotEmpty
                ? state.pages.first.fileName
                : ext.documentType,
            onOpenInChat: () {
              ref
                  .read(chatControllerProvider.notifier)
                  .attachScan(
                    ChatAttachment(
                      scanId: state.savedScanId ?? 'scan_active',
                      fileName: state.pages.isNotEmpty
                          ? state.pages.first.fileName
                          : ext.documentType,
                      pageCount: ext.pageCount,
                      documentType: ext.documentType,
                      extractedText: ext.ocrText,
                      summary: ext.plainLanguageSummary,
                    ),
                  );
              context.go('/ask');
            },
          ),
        ],
      ],
    );
  }
}

class _ExtractionResultView extends StatelessWidget {
  const new({
    required this.extraction,
    required this.scanId,
    required this.fileName,
    required this.onOpenInChat,
  });

  final DocumentExtractionResult extraction;
  final String scanId;
  final String fileName;
  final VoidCallback onOpenInChat;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LexCard(
          padding: EdgeInsets.all(tokens.space(18)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ConfidenceBadge(
                    level: extraction.usedMultimodalFallback
                        ? ConfidenceLevel.medium
                        : ConfidenceLevel.high,
                    sourceCount: extraction.pageCount,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                extraction.documentType,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                extraction.plainLanguageSummary,
                style: TextStyle(fontSize: 14, height: 1.5, color: tokens.text),
              ),
              const SizedBox(height: 14),
              if (extraction.parties.isNotEmpty)
                _FactGroup(label: 'Parties', items: extraction.parties),
              if (extraction.dates.isNotEmpty)
                _FactGroup(label: 'Dates', items: extraction.dates),
              if (extraction.deadlines.isNotEmpty)
                _FactGroup(
                  label: 'Deadlines',
                  items: extraction.deadlines,
                  highlightColor: tokens.riskMedium,
                ),
              if (extraction.amounts.isNotEmpty)
                _FactGroup(label: 'Amounts', items: extraction.amounts),
              if (extraction.keyRisks.isNotEmpty)
                _FactGroup(
                  label: 'Points to check',
                  items: extraction.keyRisks,
                  highlightColor: tokens.riskHigh,
                ),
              const SizedBox(height: 12),
              Text(
                ResearchPipeline.verifyNotice,
                style: TextStyle(fontSize: 12, color: tokens.secondaryText),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onOpenInChat,
                  icon: const Icon(Icons.chat_bubble_outline_rounded),
                  label: const Text('Ask Lex about this document'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FactGroup extends StatelessWidget {
  const new({required this.label, required this.items, this.highlightColor});

  final String label;
  final List<String> items;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: highlightColor ?? tokens.secondaryText,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final item in items)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: (highlightColor ?? tokens.accent).withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(fontSize: 13, color: tokens.text),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
