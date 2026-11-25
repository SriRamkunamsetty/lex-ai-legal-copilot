import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Abstraction for on-device speech-to-text used on the Incident screen.
abstract interface class VoiceInputService {
  /// Starts listening for spoken incident details and streams partial
  /// transcripts into [onTranscript].
  Future<Result<void>> startListening({
    required void Function(String transcript) onTranscript,
    String localeId = 'en_IN',
  });

  /// Stops an active listening session.
  Future<void> stopListening();

  /// Whether the service is currently capturing speech.
  bool get isListening;
}

/// Default implementation backed by `speech_to_text`.
class SpeechToTextVoiceInputService implements VoiceInputService {
  /// Creates a [SpeechToTextVoiceInputService].
  new([SpeechToText? speech]) : _speech = speech ?? SpeechToText();

  final SpeechToText _speech;
  bool _initialized = false;

  @override
  bool get isListening => _speech.isListening;

  @override
  Future<Result<void>> startListening({
    required void Function(String transcript) onTranscript,
    String localeId = 'en_IN',
  }) async {
    try {
      if (!_initialized) {
        _initialized = await _speech.initialize(
          onError: (err) =>
              debugPrint('Speech recognition error: ${err.errorMsg}'),
        );
      }
      if (!_initialized) {
        return const Err(
          UnexpectedFailure(
            'Speech recognition is unavailable or microphone permission was denied.',
          ),
        );
      }

      await _speech.listen(
        listenOptions: SpeechListenOptions(
          localeId: localeId,
          listenFor: const Duration(seconds: 45),
          listenMode: ListenMode.dictation,
        ),
        onResult: (result) {
          final words = result.recognizedWords.trim();
          if (words.isNotEmpty) {
            onTranscript(words);
          }
        },
      );
      return const Success(null);
    } on Object catch (error) {
      return Err(
        UnexpectedFailure('Unable to start voice recognition.', cause: error),
      );
    }
  }

  @override
  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }
}
