import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lex_copilot/ai/ai_providers.dart';
import 'package:lex_copilot/ai/pipelines/incident_pipeline.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/features/incident/data/voice_input_service.dart';
import 'package:lex_copilot/features/library/presentation/library_providers.dart';
import 'package:lex_copilot/features/scan/data/document_scanner_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'incident_controller.g.dart';

/// Provides the speech-to-text service for Incident voice input.
@Riverpod(keepAlive: true)
VoiceInputService voiceInputService(Ref ref) => SpeechToTextVoiceInputService();

/// Immutable UI state for [IncidentController].
@immutable
class IncidentState {
  /// Creates an [IncidentState].
  const new({
    this.selectedCategory = IncidentCategory.theft,
    this.description = '',
    this.attachedPhotos = const [],
    this.isListening = false,
    this.isAnalyzing = false,
    this.result,
    this.errorMessage,
  });

  /// Selected preset incident type.
  final IncidentCategory? selectedCategory;

  /// User's description of what happened.
  final String description;

  /// Attached evidence or notice photos.
  final List<ScannedPageInput> attachedPhotos;

  /// Whether voice dictation is active.
  final bool isListening;

  /// Whether [IncidentPipeline] is currently running.
  final bool isAnalyzing;

  /// Latest grounded analysis result.
  final IncidentAnalysisResult? result;

  /// Recoverable error message.
  final String? errorMessage;

  /// Returns an updated copy of [IncidentState].
  IncidentState copyWith({
    IncidentCategory? selectedCategory,
    bool clearCategory = false,
    String? description,
    List<ScannedPageInput>? attachedPhotos,
    bool? isListening,
    bool? isAnalyzing,
    IncidentAnalysisResult? result,
    bool clearResult = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return IncidentState(
      selectedCategory: clearCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      description: description ?? this.description,
      attachedPhotos: attachedPhotos ?? this.attachedPhotos,
      isListening: isListening ?? this.isListening,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Manages incident classification, voice dictation, evidence photo capture,
/// and [IncidentPipeline] execution.
@Riverpod(keepAlive: true)
class IncidentController extends _$IncidentController {
  @override
  IncidentState build() => const IncidentState();

  /// Updates the active incident category chip.
  void selectCategory(IncidentCategory category) {
    state = state.copyWith(selectedCategory: category, clearError: true);
  }

  /// Updates the free-text incident description.
  void setDescription(String text) {
    state = state.copyWith(description: text, clearError: true);
  }

  /// Picks a photo of evidence/scene/document from the gallery.
  Future<void> attachPhotoFromGallery() async {
    final res = await ref
        .read(documentCaptureServiceProvider)
        .pickFromGallery();
    if (res case Success(:final value)) {
      if (value.isNotEmpty) {
        state = state.copyWith(
          attachedPhotos: [...state.attachedPhotos, ...value],
          clearError: true,
        );
      }
    } else if (res case Err(:final failure)) {
      state = state.copyWith(errorMessage: failure.message);
    }
  }

  /// Removes an attached evidence photo at [index].
  void removePhoto(int index) {
    if (index < 0 || index >= state.attachedPhotos.length) return;
    final next = List<ScannedPageInput>.from(state.attachedPhotos)
      ..removeAt(index);
    state = state.copyWith(attachedPhotos: next);
  }

  /// Toggles voice dictation into [IncidentState.description].
  Future<void> toggleVoice({
    void Function(String transcript)? onTranscript,
  }) async {
    final voice = ref.read(voiceInputServiceProvider);
    if (state.isListening) {
      await voice.stopListening();
      state = state.copyWith(isListening: false);
      return;
    }

    state = state.copyWith(isListening: true, clearError: true);
    final res = await voice.startListening(
      onTranscript: (words) {
        state = state.copyWith(description: words);
        onTranscript?.call(words);
      },
    );
    if (res case Err(:final failure)) {
      state = state.copyWith(isListening: false, errorMessage: failure.message);
    }
  }

  /// Runs [IncidentPipeline.analyze] and caches verified statutory matches.
  Future<IncidentAnalysisResult?> analyze() async {
    if (state.isAnalyzing) return null;
    if (state.isListening) {
      await ref.read(voiceInputServiceProvider).stopListening();
      state = state.copyWith(isListening: false);
    }

    state = state.copyWith(isAnalyzing: true, clearError: true);

    final imageBytes = state.attachedPhotos
        .map<Uint8List>((p) => p.bytes)
        .toList();

    final res = await ref
        .read(incidentPipelineProvider)
        .analyze(
          description: state.description,
          category: state.selectedCategory,
          images: imageBytes,
        );

    switch (res) {
      case Err(:final failure):
        state = state.copyWith(
          isAnalyzing: false,
          errorMessage: failure.message,
        );
        return null;
      case Success(:final value):
        unawaited(
          ref
              .read(libraryRepositoryProvider)
              .recordActivity(
                kind: 'incident',
                title: value.category,
                subtitle:
                    '${value.provisions.length} verified provision${value.provisions.length == 1 ? '' : 's'}',
                route: '/incident',
              ),
        );
        state = state.copyWith(
          isAnalyzing: false,
          result: value,
          clearError: true,
        );
        return value;
    }
  }
}
