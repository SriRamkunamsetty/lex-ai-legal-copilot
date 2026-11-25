import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lex_copilot/ai/ai_providers.dart';
import 'package:lex_copilot/ai/pipelines/contract_pipeline.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/features/library/presentation/library_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contract_review_controller.g.dart';

/// Immutable UI state for [ContractReviewController].
@immutable
class ContractReviewState {
  /// Creates a [ContractReviewState].
  const new({
    this.documentTitle = 'Pasted contract',
    this.sourceText = '',
    this.isReviewing = false,
    this.review,
    this.errorMessage,
  });

  /// Display title of the reviewed contract.
  final String documentTitle;

  /// Input contract text.
  final String sourceText;

  /// Whether [ContractPipeline.review] is currently running.
  final bool isReviewing;

  /// Latest contract review result.
  final ContractReviewResult? review;

  /// Recoverable error message.
  final String? errorMessage;

  /// Returns an updated copy of [ContractReviewState].
  ContractReviewState copyWith({
    String? documentTitle,
    String? sourceText,
    bool? isReviewing,
    ContractReviewResult? review,
    bool clearReview = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ContractReviewState(
      documentTitle: documentTitle ?? this.documentTitle,
      sourceText: sourceText ?? this.sourceText,
      isReviewing: isReviewing ?? this.isReviewing,
      review: clearReview ? null : (review ?? this.review),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Manages contract input/scan import, risk scoring, redlines, and rewrites.
@Riverpod(keepAlive: true)
class ContractReviewController extends _$ContractReviewController {
  @override
  ContractReviewState build() => const ContractReviewState();

  /// Updates the raw contract text before/after loading a scan.
  void setSourceText(String text, {String? title}) {
    state = state.copyWith(
      sourceText: text,
      documentTitle: title ?? state.documentTitle,
      clearError: true,
    );
  }

  /// Runs [ContractPipeline.review] on [ContractReviewState.sourceText] and logs activity.
  Future<ContractReviewResult?> analyze([String? overrideText]) async {
    if (state.isReviewing) return null;
    final text = (overrideText ?? state.sourceText).trim();
    if (text.isEmpty) {
      state = state.copyWith(
        errorMessage:
            'Paste contract clauses or load a scanned document first.',
      );
      return null;
    }

    state = state.copyWith(
      sourceText: text,
      isReviewing: true,
      clearError: true,
    );

    final res = await ref.read(contractPipelineProvider).review(text);
    switch (res) {
      case Err(:final failure):
        state = state.copyWith(
          isReviewing: false,
          errorMessage: failure.message,
        );
        return null;
      case Success(:final value):
        unawaited(
          ref
              .read(libraryRepositoryProvider)
              .recordActivity(
                kind: 'contract_review',
                title: state.documentTitle,
                subtitle: 'Risk ${value.riskScore}/100 · ${value.riskLabel}',
                route: '/contract-review',
              ),
        );
        state = state.copyWith(
          isReviewing: false,
          review: value,
          clearError: true,
        );
        return value;
    }
  }

  /// Applies the safer suggested wording for [clauseId] into [ContractReviewState.review].
  void applySaferWording(String clauseId) {
    final current = state.review;
    if (current == null) return;
    final updated = ref
        .read(contractPipelineProvider)
        .applySaferWording(review: current, clauseId: clauseId);
    state = state.copyWith(review: updated, sourceText: updated.workingText);
  }

  /// Applies all remaining un-applied safer rewrites.
  void applyAllSaferWording() {
    var current = state.review;
    if (current == null) return;
    final pipeline = ref.read(contractPipelineProvider);
    for (final clause in current.clauses) {
      if (!clause.applied) {
        current = pipeline.applySaferWording(
          review: current!,
          clauseId: clause.id,
        );
      }
    }
    state = state.copyWith(review: current, sourceText: current!.workingText);
  }
}
