import 'dart:convert';

import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists non-sensitive UI and AI preference settings using [SharedPreferences].
class SettingsRepository {
  /// Creates a [SettingsRepository] backed by [_prefs].
  const new(this._prefs);

  /// Storage key for the serialized [LexSettings] JSON payload.
  static const String settingsKey = 'lex_settings_v1';

  final SharedPreferences _prefs;

  /// Loads persisted [LexSettings], returning defaults if none are stored.
  Result<LexSettings> load() {
    try {
      final raw = _prefs.getString(settingsKey);
      if (raw == null || raw.isEmpty) {
        return const Success(LexSettings());
      }
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return const Err(
          StorageFailure('Stored settings payload is not a JSON object.'),
        );
      }
      return Success(LexSettings.fromJson(decoded));
    } on Object catch (error) {
      return Err(StorageFailure('Failed to read settings.', cause: error));
    }
  }

  /// Persists [settings] to [SharedPreferences].
  Future<Result<LexSettings>> save(LexSettings settings) async {
    try {
      final encoded = jsonEncode(settings.toJson());
      final ok = await _prefs.setString(settingsKey, encoded);
      if (!ok) {
        return const Err(
          StorageFailure('SharedPreferences rejected settings write.'),
        );
      }
      return Success(settings);
    } on Object catch (error) {
      return Err(StorageFailure('Failed to save settings.', cause: error));
    }
  }

  /// Resets settings back to factory defaults.
  Future<Result<LexSettings>> reset() async {
    try {
      await _prefs.remove(settingsKey);
      return const Success(LexSettings());
    } on Object catch (error) {
      return Err(StorageFailure('Failed to reset settings.', cause: error));
    }
  }
}
