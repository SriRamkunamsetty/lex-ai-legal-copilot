import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Abstraction over local notification reminders for case deadlines & hearings.
abstract interface class ReminderScheduler {
  /// Initializes notification channels/permissions if needed.
  Future<Result<void>> initialize();

  /// Schedules a local notification at [scheduledAt] (returns whether scheduled).
  Future<Result<bool>> scheduleDeadlineReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
  });

  /// Cancels any previously scheduled notification with [id].
  Future<void> cancelReminder(int id);
}

/// Production [ReminderScheduler] backed by `flutter_local_notifications`.
class LocalNotificationReminderScheduler implements ReminderScheduler {
  /// Creates a [LocalNotificationReminderScheduler].
  new([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  static const _channelId = 'lex_case_deadlines';
  static const _channelName = 'Case Deadlines & Hearings';

  @override
  Future<Result<void>> initialize() async {
    if (_initialized) return const Success(null);
    try {
      tz_data.initializeTimeZones();
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwin = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: android,
          iOS: darwin,
          macOS: darwin,
        ),
      );
      _initialized = true;
      return const Success(null);
    } on Object catch (error) {
      debugPrint('Notification scheduler init skipped: $error');
      return Err(
        StorageFailure(
          'Local notification initialization unavailable on this host.',
          cause: error,
        ),
      );
    }
  }

  @override
  Future<Result<bool>> scheduleDeadlineReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
  }) async {
    final initRes = await initialize();
    if (initRes.isErr) {
      return const Success(false);
    }
    try {
      final now = DateTime.now();
      final target = scheduledAt.isAfter(now)
          ? scheduledAt
          : now.add(const Duration(seconds: 10));
      final tzTime = tz.TZDateTime.from(target, tz.local);

      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      );

      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzTime,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
      return const Success(true);
    } on Object catch (error) {
      debugPrint('Unable to schedule local reminder: $error');
      return const Success(false);
    }
  }

  @override
  Future<void> cancelReminder(int id) async {
    if (!_initialized) return;
    try {
      await _plugin.cancel(id: id);
    } on Object {
      // Ignore cancellation failures on unsupported desktop hosts.
    }
  }
}
