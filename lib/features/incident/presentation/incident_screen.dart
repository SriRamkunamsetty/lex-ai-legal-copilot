import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/ai/pipelines/incident_pipeline.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/incident/presentation/incident_controller.dart';

/// Incident-to-sections flow accepting category chips, text, voice, and photos,
/// returning corpus-verified provisions, practical next steps, and evidence lists.
class IncidentScreen extends ConsumerStatefulWidget {
  /// Creates an [IncidentScreen].
  const new({super.key});

  @override
  ConsumerState<IncidentScreen> createState() => _IncidentScreenState();
}

class _IncidentScreenState extends ConsumerState<IncidentScreen> {
  final TextEditingController _textController = TextEditingController();
  int _tab = 0;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    final state = ref.watch(incidentControllerProvider);
    final controller = ref.read(incidentControllerProvider.notifier);

    if (_textController.text != state.description &&
        state.isListening &&
        state.description.isNotEmpty) {
      _textController.value = TextEditingValue(
        text: state.description,
        selection: TextSelection.collapsed(offset: state.description.length),
      );
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
                  'What happened?',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ],
          ),
          Text(
            'Pick an incident type or describe it by text, voice, or photo. Lex returns corpus-verified BNS, BNSS, and BSA provisions.',
            style: TextStyle(fontSize: 14, color: tokens.secondaryText),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final cat in IncidentCategory.values)
                LexChip(
                  label: cat.label,
                  selected: cat == state.selectedCategory,
                  onTap: () => controller.selectCategory(cat),
                ),
            ],
          ),
          const SizedBox(height: 14),
          LexCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _textController,
                  minLines: 3,
                  maxLines: 6,
                  onChanged: controller.setDescription,
                  decoration: InputDecoration(
                    hintText: 'Describe what happened, when, where, and any amount or injury…',
                    hintStyle: TextStyle(color: tokens.secondaryText),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
                if (state.attachedPhotos.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var i = 0; i < state.attachedPhotos.length; i++)
                        Chip(
                          label: Text(state.attachedPhotos[i].fileName),
                          onDeleted: () => controller.removePhoto(i),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      tooltip: state.isListening
                          ? 'Stop voice input'
                          : 'Describe by voice',
                      onPressed: () => controller.toggleVoice(
                        onTranscript: (words) {
                          _textController.text = words;
                        },
                      ),
                      icon: Icon(
                        state.isListening
                            ? Icons.mic_rounded
                            : Icons.mic_none_rounded,
                        color: state.isListening
                            ? tokens.accent
                            : tokens.secondaryText,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Attach evidence photo',
                      onPressed: controller.attachPhotoFromGallery,
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: tokens.secondaryText,
                      ),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: state.isAnalyzing ? null : controller.analyze,
                      child: Text(
                        state.isAnalyzing ? 'Analyzing…' : 'Find provisions',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (state.errorMessage != null) ...[
            const SizedBox(height: 12),
            ErrorState(
              title: 'Could not classify incident',
              message: state.errorMessage!,
              onRetry: controller.analyze,
            ),
          ],
          const SizedBox(height: 16),
          SegmentedControl<int>(
            selected: _tab,
            onChanged: (value) => setState(() => _tab = value),
            segments: const [
              (value: 0, label: 'Sections'),
              (value: 1, label: 'Next steps'),
              (value: 2, label: 'Evidence'),
            ],
          ),
          const SizedBox(height: 12),
          if (state.result == null)
            const EmptyState(
              icon: Icons.balance_rounded,
              title: 'Ready when you are',
              message: 'Choose an incident category or describe what happened, then tap Find provisions.',
            )
          else if (_tab == 0) ...[
            LexCard(
              padding: EdgeInsets.all(tokens.space(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConfidenceBadge(
                    level: ConfidenceLevel.high,
                    sourceCount: state.result!.provisions.length,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.result!.summary,
                    style: TextStyle(fontSize: 14, color: tokens.text),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (state.result!.provisions.isEmpty)
              const EmptyState(
                icon: Icons.search_off_rounded,
                title: 'No exact statutory match found',
                message: 'Add a few more details or consult legal aid. Lex never invents unverified section numbers.',
              )
            else
              for (final match in state.result!.provisions) ...[
                SectionTile(
                  citation:
                      '${match.section.actCode} ${match.section.sectionNumber}',
                  title: match.section.title,
                  summary: match.rationale,
                  onTap: () => context.push(
                    '/section/${match.section.actCode}/${match.section.sectionNumber}',
                  ),
                ),
                const SizedBox(height: 10),
              ],
          ] else if (_tab == 1) ...[
            LexCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Where to report',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.result!.whereToReport,
                    style: TextStyle(fontSize: 14, color: tokens.text),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Immediate steps',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  for (var i = 0; i < state.result!.nextSteps.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${i + 1}. ',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: tokens.accent,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              state.result!.nextSteps[i],
                              style: TextStyle(
                                fontSize: 14,
                                color: tokens.text,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ] else ...[
            LexCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Evidence to preserve',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  for (final item in state.result!.evidenceToKeep)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            size: 18,
                            color: tokens.accent,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 14,
                                color: tokens.text,
                              ),
                            ),
                          ),
                        ],
                      ),
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
