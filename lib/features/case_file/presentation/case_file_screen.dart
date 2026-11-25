import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/case_file/domain/case_file_models.dart';
import 'package:lex_copilot/features/case_file/presentation/case_file_providers.dart';
import 'package:lex_copilot/features/library/presentation/library_providers.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';
import 'package:share_plus/share_plus.dart';

/// Encrypted matter tracker supporting case timelines, deadlines with local
/// OS notifications, compliance checklists, attached docs, and case summaries.
class CaseFileScreen extends ConsumerStatefulWidget {
  /// Creates a [CaseFileScreen].
  const new({super.key});

  @override
  ConsumerState<CaseFileScreen> createState() => _CaseFileScreenState();
}

class _CaseFileScreenState extends ConsumerState<CaseFileScreen> {
  String? _selectedCaseId;
  int _tab = 0;

  static const List<String> _statuses = [
    'Open',
    'Notice sent',
    'In progress',
    'Closed',
  ];

  Future<void> _showCreateCaseDialog() async {
    final result =
        await showDialog<({String title, String category, String summary})>(
          context: context,
          builder: (_) => const _CreateCaseDialog(),
        );
    if (result == null || !mounted) return;

    final res = await ref
        .read(caseFileRepositoryProvider)
        .createCase(
          title: result.title,
          category: result.category,
          summary: result.summary,
        );
    if (!mounted) return;
    if (res case Success(:final value)) {
      setState(() => _selectedCaseId = value);
      unawaited(
        ref
            .read(libraryRepositoryProvider)
            .recordActivity(
              kind: 'case_file',
              title: result.title,
              subtitle: result.category,
              route: '/case-file',
            ),
      );
    }
  }

  Future<void> _showAddDeadlineDialog(CaseFileRecord matter) async {
    final result = await showDialog<({String title, int daysAhead})>(
      context: context,
      builder: (_) => const _AddDeadlineDialog(),
    );
    if (result == null || !mounted) return;

    final dueAt = DateTime.now().add(Duration(days: result.daysAhead));
    final repo = ref.read(caseFileRepositoryProvider);
    final res = await repo.addDeadline(
      caseId: matter.id,
      title: result.title,
      dueAt: dueAt,
    );

    if (res case Success(:final value)) {
      final remindersOn = ref
          .read(settingsControllerProvider)
          .deadlineRemindersEnabled;
      if (remindersOn) {
        final scheduled = await ref
            .read(reminderSchedulerProvider)
            .scheduleDeadlineReminder(
              id: value,
              title: 'Lex Case Deadline: ${matter.title}',
              body: result.title,
              scheduledAt: dueAt,
            );
        if (scheduled case Success(value: true)) {
          await repo.markReminderScheduled(deadlineId: value, scheduled: true);
        }
      }
    }
  }

  Future<void> _showAddChecklistDialog(String caseId) async {
    final text = await showDialog<String>(
      context: context,
      builder: (_) => const _AddChecklistDialog(),
    );
    if (text != null && text.isNotEmpty) {
      await ref
          .read(caseFileRepositoryProvider)
          .addChecklistOrTimelineItem(caseId: caseId, title: text);
    }
  }

  Future<void> _attachLibraryDoc(String caseId) async {
    final scans = ref.read(scansStreamProvider('')).value ?? const [];
    final drafts = ref.read(draftsStreamProvider('')).value ?? const [];
    if (scans.isEmpty && drafts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No saved scans or drafts in Library yet.'),
        ),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Attach scan or draft',
              style: Theme.of(ctx).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            for (final s in scans)
              ListTile(
                leading: const Icon(Icons.document_scanner_outlined),
                title: Text(s.title),
                subtitle: Text('${s.pageCount} page(s)'),
                onTap: () async {
                  await ref
                      .read(caseFileRepositoryProvider)
                      .addChecklistOrTimelineItem(
                        caseId: caseId,
                        title: 'Scan: ${s.title}',
                        kind: 'scan',
                        referenceId: s.id,
                      );
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              ),
            for (final d in drafts)
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: Text(d.title),
                subtitle: Text(d.templateType),
                onTap: () async {
                  await ref
                      .read(caseFileRepositoryProvider)
                      .addChecklistOrTimelineItem(
                        caseId: caseId,
                        title: 'Draft: ${d.title}',
                        kind: 'draft',
                        referenceId: d.id,
                      );
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareSummary(String caseId) async {
    final repo = ref.read(caseFileRepositoryProvider);
    final res = await repo.getCaseBundle(caseId);
    if (res case Success(:final value)) {
      final text = repo.buildShareableSummary(value);
      await SharePlus.instance.share(ShareParams(text: text));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    final casesAsync = ref.watch(casesStreamProvider);

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
                  'Case file',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: _showCreateCaseDialog,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('New case'),
              ),
            ],
          ),
          Text(
            'Track disputes, attach scans and drafts, schedule local deadline reminders, and export summaries.',
            style: TextStyle(fontSize: 14, color: tokens.secondaryText),
          ),
          const SizedBox(height: 14),
          casesAsync.when(
            loading: () => const LexCard(child: LexSkeleton(height: 60)),
            error: (err, _) =>
                ErrorState(title: 'Unable to load cases', message: '$err'),
            data: (cases) {
              if (cases.isEmpty) {
                return EmptyState(
                  icon: Icons.folder_open_rounded,
                  title: 'No active case files',
                  message: 'Create a matter for a dispute to track timelines, compliance tasks, and local deadline notifications.',
                  actionLabel: 'Create case file',
                  onAction: _showCreateCaseDialog,
                );
              }

              final active = cases.firstWhere(
                (c) => c.id == _selectedCaseId,
                orElse: () => cases.first,
              );

              return _ActiveCaseView(
                cases: cases,
                active: active,
                tab: _tab,
                statuses: _statuses,
                onSelectCase: (id) => setState(() => _selectedCaseId = id),
                onTabChanged: (t) => setState(() => _tab = t),
                onStatusChanged: (status) => ref
                    .read(caseFileRepositoryProvider)
                    .updateStatus(caseId: active.id, status: status),
                onShareSummary: () => _shareSummary(active.id),
                onFindHelp: () => context.push('/legal-help'),
                onAddDeadline: () => _showAddDeadlineDialog(active),
                onAddChecklist: () => _showAddChecklistDialog(active.id),
                onAttachDoc: () => _attachLibraryDoc(active.id),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActiveCaseView extends ConsumerWidget {
  const new({
    required this.cases,
    required this.active,
    required this.tab,
    required this.statuses,
    required this.onSelectCase,
    required this.onTabChanged,
    required this.onStatusChanged,
    required this.onShareSummary,
    required this.onFindHelp,
    required this.onAddDeadline,
    required this.onAddChecklist,
    required this.onAttachDoc,
  });

  final List<CaseFileRecord> cases;
  final CaseFileRecord active;
  final int tab;
  final List<String> statuses;
  final void Function(String id) onSelectCase;
  final void Function(int tab) onTabChanged;
  final void Function(String status) onStatusChanged;
  final VoidCallback onShareSummary;
  final VoidCallback onFindHelp;
  final VoidCallback onAddDeadline;
  final VoidCallback onAddChecklist;
  final VoidCallback onAttachDoc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.lexTokens;
    final deadlines =
        ref.watch(caseDeadlinesStreamProvider(active.id)).value ?? const [];
    final allItems =
        ref.watch(caseItemsStreamProvider(active.id)).value ?? const [];
    final checklist = allItems.where((i) => i.kind == 'checklist').toList();
    final timeline = allItems.where((i) => i.kind != 'checklist').toList();
    final completedCount = checklist.where((i) => i.done).length;
    final progress = checklist.isEmpty
        ? 0.0
        : completedCount / checklist.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final c in cases)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: LexChip(
                    label: c.title,
                    selected: c.id == active.id,
                    onTap: () => onSelectCase(c.id),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        LexCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      active.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Chip(label: Text(active.category)),
                ],
              ),
              if (active.summary.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  active.summary,
                  style: TextStyle(fontSize: 13, color: tokens.secondaryText),
                ),
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final s in statuses)
                    LexChip(
                      label: s,
                      selected: s == active.status,
                      onTap: () => onStatusChanged(s),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 6),
              Text(
                '$completedCount of ${checklist.length} compliance steps completed',
                style: TextStyle(fontSize: 12, color: tokens.secondaryText),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onShareSummary,
                      icon: const Icon(Icons.ios_share_rounded, size: 16),
                      label: const Text('Share summary'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: onFindHelp,
                      icon: const Icon(Icons.support_agent_rounded, size: 16),
                      label: const Text('Find legal help'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SegmentedControl<int>(
          selected: tab,
          onChanged: onTabChanged,
          segments: const [
            (value: 0, label: 'Checklist'),
            (value: 1, label: 'Deadlines'),
            (value: 2, label: 'Timeline'),
          ],
        ),
        const SizedBox(height: 12),
        if (tab == 0) ...[
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onAddChecklist,
              icon: const Icon(Icons.add_task_rounded, size: 18),
              label: const Text('Add compliance step'),
            ),
          ),
          for (final item in checklist)
            LexCard(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: item.done,
                title: Text(
                  item.title,
                  style: TextStyle(
                    decoration: item.done ? TextDecoration.lineThrough : null,
                  ),
                ),
                onChanged: (checked) => ref
                    .read(caseFileRepositoryProvider)
                    .toggleItemDone(itemId: item.id, done: checked ?? false),
              ),
            ),
        ] else if (tab == 1) ...[
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onAddDeadline,
              icon: const Icon(Icons.notification_add_outlined, size: 18),
              label: const Text('Add deadline reminder'),
            ),
          ),
          if (deadlines.isEmpty)
            const EmptyState(
              icon: Icons.event_available_outlined,
              title: 'No deadlines scheduled',
              message: 'Add notice expiry or hearing dates to schedule local reminders.',
            )
          else
            for (final d in deadlines)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: LexCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: d.completed,
                    title: Text(d.title),
                    subtitle: Text(
                      'Due ${d.dueAt.year}-${d.dueAt.month.toString().padLeft(2, '0')}-${d.dueAt.day.toString().padLeft(2, '0')}'
                      '${d.reminderScheduled ? ' · Reminder set' : ''}',
                    ),
                    onChanged: (val) => ref
                        .read(caseFileRepositoryProvider)
                        .toggleDeadlineCompleted(
                          deadlineId: d.id,
                          completed: val ?? false,
                        ),
                  ),
                ),
              ),
        ] else ...[
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onAttachDoc,
              icon: const Icon(Icons.attach_file_rounded, size: 18),
              label: const Text('Attach scan or draft'),
            ),
          ),
          for (final event in timeline)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: LexCard(
                child: Row(
                  children: [
                    Icon(Icons.history_rounded, color: tokens.accent),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: tokens.text,
                            ),
                          ),
                          Text(
                            event.kind.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              color: tokens.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _CreateCaseDialog extends StatefulWidget {
  const new();

  @override
  State<_CreateCaseDialog> createState() => _CreateCaseDialogState();
}

class _CreateCaseDialogState extends State<_CreateCaseDialog> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _summaryCtrl = TextEditingController();
  String _category = 'Tenancy';
  static const List<String> _categories = [
    'Tenancy',
    'Criminal',
    'Consumer',
    'Employment',
    'General',
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _summaryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New case file'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Matter title',
                hintText: 'e.g. Deposit refund notice',
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: [
                for (final c in _categories)
                  DropdownMenuItem(value: c, child: Text(c)),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _category = v);
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _summaryCtrl,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Key facts summary'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final title = _titleCtrl.text.trim();
            if (title.isEmpty) {
              Navigator.pop(context);
              return;
            }
            Navigator.pop(context, (
              title: title,
              category: _category,
              summary: _summaryCtrl.text.trim(),
            ));
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}

class _AddDeadlineDialog extends StatefulWidget {
  const new();

  @override
  State<_AddDeadlineDialog> createState() => _AddDeadlineDialogState();
}

class _AddDeadlineDialogState extends State<_AddDeadlineDialog> {
  final TextEditingController _titleCtrl = TextEditingController();
  int _daysAhead = 7;

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add deadline & reminder'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleCtrl,
            decoration: const InputDecoration(
              labelText: 'Deadline title',
              hintText: 'e.g. Reply period expires',
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: _daysAhead,
            decoration: const InputDecoration(labelText: 'Due in'),
            items: const [
              DropdownMenuItem(value: 1, child: Text('Tomorrow (24 hours)')),
              DropdownMenuItem(value: 3, child: Text('In 3 days')),
              DropdownMenuItem(value: 7, child: Text('In 7 days')),
              DropdownMenuItem(value: 15, child: Text('In 15 days')),
              DropdownMenuItem(value: 30, child: Text('In 30 days')),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _daysAhead = v);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final title = _titleCtrl.text.trim();
            if (title.isEmpty) {
              Navigator.pop(context);
              return;
            }
            Navigator.pop(context, (title: title, daysAhead: _daysAhead));
          },
          child: const Text('Save deadline'),
        ),
      ],
    );
  }
}

class _AddChecklistDialog extends StatefulWidget {
  const new();

  @override
  State<_AddChecklistDialog> createState() => _AddChecklistDialogState();
}

class _AddChecklistDialogState extends State<_AddChecklistDialog> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add compliance step'),
      content: TextField(
        controller: _ctrl,
        decoration: const InputDecoration(
          labelText: 'Step description',
          hintText: 'e.g. Send registered post acknowledgement',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _ctrl.text.trim()),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
