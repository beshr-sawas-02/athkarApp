import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';

import '../models/daily_stats.dart';
import '../models/thikr_category.dart';
import '../models/thikr_model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final GetStorage _box = GetStorage();
  final Uuid _uuid = const Uuid();

  static const _athkarKey = 'athkar_list';
  static const _isFirstRunKey = 'is_first_run';
  static const _themeModeKey = 'theme_mode';
  static const _vibrationKey = 'vibration_enabled';
  static const _soundKey = 'sound_enabled';
  static const _fontScaleKey = 'font_scale';
  static const _dailyResetKey = 'daily_reset_enabled';
  static const _lastResetDateKey = 'last_reset_date';
  static const _statsHistoryKey = 'stats_history';
  static const _streakKey = 'current_streak';
  static const _lastActiveDateKey = 'last_active_date';
  static const _selectedThikrIdKey = 'selected_thikr_id';

  Future<void> init() async {
    await GetStorage.init();
  }

  bool get isFirstRun => _box.read(_isFirstRunKey) ?? true;

  void setFirstRunComplete() => _box.write(_isFirstRunKey, false);

  // ── Settings ──────────────────────────────────────────────

  ThemeMode get themeMode {
    final value = _box.read<String>(_themeModeKey) ?? 'system';
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void setThemeMode(ThemeMode mode) {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    _box.write(_themeModeKey, value);
  }

  bool get vibrationEnabled => _box.read(_vibrationKey) ?? true;
  void setVibrationEnabled(bool value) => _box.write(_vibrationKey, value);

  bool get soundEnabled => _box.read(_soundKey) ?? false;
  void setSoundEnabled(bool value) => _box.write(_soundKey, value);

  double get fontScale => (_box.read(_fontScaleKey) as num?)?.toDouble() ?? 1.0;
  void setFontScale(double value) => _box.write(_fontScaleKey, value);

  bool get dailyResetEnabled => _box.read(_dailyResetKey) ?? false;
  void setDailyResetEnabled(bool value) => _box.write(_dailyResetKey, value);

  String? get lastResetDate => _box.read<String>(_lastResetDateKey);
  void setLastResetDate(String date) => _box.write(_lastResetDateKey, date);

  int get currentStreak => (_box.read(_streakKey) as num?)?.toInt() ?? 0;
  void setCurrentStreak(int value) => _box.write(_streakKey, value);

  String? get lastActiveDate => _box.read<String>(_lastActiveDateKey);
  void setLastActiveDate(String date) => _box.write(_lastActiveDateKey, date);

  String? get selectedThikrId => _box.read<String>(_selectedThikrIdKey);
  void setSelectedThikrId(String? id) {
    if (id == null) {
      _box.remove(_selectedThikrIdKey);
    } else {
      _box.write(_selectedThikrIdKey, id);
    }
  }

  static String todayKey([DateTime? date]) {
    final d = date ?? DateTime.now();
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  // ── Athkar ────────────────────────────────────────────────

  List<Thikr> getDefaultAthkar() {
    return [
      Thikr(
        id: _uuid.v4(),
        name: 'أستغفر الله',
        goal: 100,
        isDefault: true,
        category: ThikrCategory.general,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'الحمد لله',
        goal: 100,
        isDefault: true,
        category: ThikrCategory.general,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'سبحان الله',
        goal: 33,
        isDefault: true,
        category: ThikrCategory.general,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'الله أكبر',
        goal: 33,
        isDefault: true,
        category: ThikrCategory.general,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'لا إله إلا الله',
        goal: 100,
        isDefault: true,
        category: ThikrCategory.general,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'اللهم صلِّ على سيدنا محمد',
        goal: 100,
        isDefault: true,
        category: ThikrCategory.general,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'سبحان الله وبحمده، سبحان الله العظيم',
        goal: 100,
        isDefault: true,
        category: ThikrCategory.general,
      ),
      // Morning
      Thikr(
        id: _uuid.v4(),
        name: 'أذكار الصباح',
        goal: 1,
        isDefault: true,
        category: ThikrCategory.morning,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'آية الكرسي',
        goal: 1,
        isDefault: true,
        category: ThikrCategory.morning,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'سور الإخلاص والمعوذتين',
        goal: 3,
        isDefault: true,
        category: ThikrCategory.morning,
      ),
      // Evening
      Thikr(
        id: _uuid.v4(),
        name: 'أذكار المساء',
        goal: 1,
        isDefault: true,
        category: ThikrCategory.evening,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'أعوذ بكلمات الله التامات',
        goal: 3,
        isDefault: true,
        category: ThikrCategory.evening,
      ),
      // After prayer
      Thikr(
        id: _uuid.v4(),
        name: 'أستغفر الله (بعد الصلاة)',
        goal: 3,
        isDefault: true,
        category: ThikrCategory.afterPrayer,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'اللهم أنت السلام',
        goal: 1,
        isDefault: true,
        category: ThikrCategory.afterPrayer,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'التسبيح بعد الصلاة',
        goal: 33,
        isDefault: true,
        category: ThikrCategory.afterPrayer,
      ),
      // Sleep
      Thikr(
        id: _uuid.v4(),
        name: 'باسمك اللهم أموت وأحيا',
        goal: 1,
        isDefault: true,
        category: ThikrCategory.sleep,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'آية الكرسي قبل النوم',
        goal: 1,
        isDefault: true,
        category: ThikrCategory.sleep,
      ),
      // Travel
      Thikr(
        id: _uuid.v4(),
        name: 'دعاء السفر',
        goal: 1,
        isDefault: true,
        category: ThikrCategory.travel,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'سبحان الذي سخر لنا هذا',
        goal: 1,
        isDefault: true,
        category: ThikrCategory.travel,
      ),
    ];
  }

  List<Thikr> getExtraPresets() {
    return [
      Thikr(
        id: _uuid.v4(),
        name: 'حسبي الله لا إله إلا هو',
        goal: 7,
        isDefault: true,
        category: ThikrCategory.morning,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'لا حول ولا قوة إلا بالله',
        goal: 100,
        isDefault: true,
        category: ThikrCategory.general,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'رضيت بالله رباً',
        goal: 3,
        isDefault: true,
        category: ThikrCategory.evening,
      ),
    ];
  }

  List<Thikr> loadAthkar() {
    final data = _box.read<List>(_athkarKey);
    if (data == null) return [];
    return data
        .map((item) => Thikr.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  void saveAthkar(List<Thikr> athkar) {
    final data = athkar.map((item) => item.toJson()).toList();
    _box.write(_athkarKey, data);
  }

  String generateId() => _uuid.v4();

  // ── Stats ─────────────────────────────────────────────────

  List<DailyStats> loadStatsHistory() {
    final data = _box.read<List>(_statsHistoryKey);
    if (data == null) return [];
    return data
        .map((e) => DailyStats.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  void saveStatsHistory(List<DailyStats> history) {
    _box.write(_statsHistoryKey, history.map((e) => e.toJson()).toList());
  }

  DailyStats getTodayStats() {
    final today = todayKey();
    final history = loadStatsHistory();
    return history.firstWhere(
      (s) => s.date == today,
      orElse: () => DailyStats(date: today),
    );
  }

  void upsertTodayStats(DailyStats stats) {
    final history = loadStatsHistory();
    final index = history.indexWhere((s) => s.date == stats.date);
    if (index == -1) {
      history.add(stats);
    } else {
      history[index] = stats;
    }
    // Keep last 90 days
    history.sort((a, b) => b.date.compareTo(a.date));
    if (history.length > 90) {
      history.removeRange(90, history.length);
    }
    saveStatsHistory(history);
  }

  List<DailyStats> getWeekStats() {
    final now = DateTime.now();
    final history = loadStatsHistory();
    final keys = List.generate(7, (i) {
      final d = now.subtract(Duration(days: i));
      return todayKey(d);
    });
    return keys.map((k) {
      return history.firstWhere(
        (s) => s.date == k,
        orElse: () => DailyStats(date: k),
      );
    }).toList();
  }

  // ── Backup ────────────────────────────────────────────────

  String exportBackupJson() {
    final payload = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'athkar': loadAthkar().map((e) => e.toJson()).toList(),
      'stats': loadStatsHistory().map((e) => e.toJson()).toList(),
      'settings': {
        'themeMode': _box.read(_themeModeKey) ?? 'system',
        'vibrationEnabled': vibrationEnabled,
        'soundEnabled': soundEnabled,
        'fontScale': fontScale,
        'dailyResetEnabled': dailyResetEnabled,
        'currentStreak': currentStreak,
        'lastActiveDate': lastActiveDate,
      },
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  /// Returns number of athkar restored, or throws on invalid data.
  int importBackupJson(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      throw const FormatException('ملف النسخة الاحتياطية غير صالح');
    }
    final map = Map<String, dynamic>.from(decoded);

    final athkarRaw = map['athkar'];
    if (athkarRaw is! List) {
      throw const FormatException('لا توجد أذكار في الملف');
    }

    final athkar = athkarRaw
        .map((e) => Thikr.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    saveAthkar(athkar);

    final statsRaw = map['stats'];
    if (statsRaw is List) {
      final stats = statsRaw
          .map((e) => DailyStats.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      saveStatsHistory(stats);
    }

    final settings = map['settings'];
    if (settings is Map) {
      final s = Map<String, dynamic>.from(settings);
      if (s['themeMode'] != null) _box.write(_themeModeKey, s['themeMode']);
      if (s['vibrationEnabled'] != null) {
        setVibrationEnabled(s['vibrationEnabled'] == true);
      }
      if (s['soundEnabled'] != null) {
        setSoundEnabled(s['soundEnabled'] == true);
      }
      if (s['fontScale'] != null) {
        setFontScale((s['fontScale'] as num).toDouble());
      }
      if (s['dailyResetEnabled'] != null) {
        setDailyResetEnabled(s['dailyResetEnabled'] == true);
      }
      if (s['currentStreak'] != null) {
        setCurrentStreak((s['currentStreak'] as num).toInt());
      }
      if (s['lastActiveDate'] != null) {
        setLastActiveDate(s['lastActiveDate'] as String);
      }
    }

    return athkar.length;
  }
}
