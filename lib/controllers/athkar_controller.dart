import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/daily_stats.dart';
import '../models/thikr_category.dart';
import '../models/thikr_model.dart';
import '../utils/storage_service.dart';
import '../utils/widget_helper.dart';
import 'settings_controller.dart';

class AthkarController extends GetxController {
  final StorageService _storage = StorageService();

  final RxList<Thikr> athkarList = <Thikr>[].obs;
  final Rx<Thikr?> selectedThikr = Rx<Thikr?>(null);
  final RxBool isLoading = true.obs;
  final Rx<ThikrCategory?> categoryFilter = Rx<ThikrCategory?>(null);
  final Rx<DailyStats> todayStats = DailyStats(date: StorageService.todayKey()).obs;
  final RxInt streak = 0.obs;

  Thikr? _lastDeleted;
  int? _lastDeletedIndex;

  SettingsController get _settings {
    if (Get.isRegistered<SettingsController>()) {
      return Get.find<SettingsController>();
    }
    return Get.put(SettingsController());
  }

  List<Thikr> get filteredAthkar {
    final filter = categoryFilter.value;
    if (filter == null) return athkarList.toList();
    return athkarList.where((t) => t.category == filter).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _initializeAthkar();
  }

  void _initializeAthkar() {
    if (_storage.isFirstRun) {
      athkarList.assignAll(_storage.getDefaultAthkar());
      _storage.saveAthkar(athkarList);
      _storage.setFirstRunComplete();
    } else {
      athkarList.assignAll(_storage.loadAthkar());
    }

    _checkDailyReset();
    todayStats.value = _storage.getTodayStats();
    streak.value = _storage.currentStreak;

    final savedId = _storage.selectedThikrId;
    if (savedId != null) {
      selectedThikr.value =
          athkarList.firstWhereOrNull((t) => t.id == savedId) ??
              (athkarList.isNotEmpty ? athkarList.first : null);
    } else if (athkarList.isNotEmpty) {
      selectedThikr.value = athkarList.first;
    }

    isLoading.value = false;
    WidgetHelper.update(selectedThikr.value);
  }

  void _checkDailyReset() {
    if (!_storage.dailyResetEnabled) return;

    final today = StorageService.todayKey();
    final last = _storage.lastResetDate;
    if (last == today) return;

    if (last != null && last != today) {
      // Persist yesterday snapshot already in stats; reset counters
      for (var i = 0; i < athkarList.length; i++) {
        athkarList[i] = athkarList[i].copyWith(count: 0, goalReached: false);
      }
      _storage.saveAthkar(athkarList);
      if (selectedThikr.value != null) {
        final current = athkarList
            .firstWhereOrNull((t) => t.id == selectedThikr.value!.id);
        selectedThikr.value = current;
      }
    }
    _storage.setLastResetDate(today);
  }

  void selectThikr(Thikr thikr) {
    selectedThikr.value = thikr;
    _storage.setSelectedThikrId(thikr.id);
    WidgetHelper.update(thikr);
  }

  void setCategoryFilter(ThikrCategory? category) {
    categoryFilter.value = category;
  }

  void incrementCount() {
    if (selectedThikr.value == null) return;

    final thikr = selectedThikr.value!;
    final newCount = thikr.count + 1;
    final reachedGoal = newCount == thikr.goal && !thikr.goalReached;

    final updatedThikr = thikr.copyWith(
      count: newCount,
      goalReached: thikr.goalReached || reachedGoal,
    );

    _updateThikrInList(updatedThikr);
    _recordCount(updatedThikr);
    _settings.hapticLight();
    _settings.playClickSound();
    WidgetHelper.update(updatedThikr);

    if (reachedGoal) {
      _showGoalReachedDialog();
    }
  }

  void decrementCount() {
    if (selectedThikr.value == null) return;

    final thikr = selectedThikr.value!;
    if (thikr.count <= 0) return;

    final updatedThikr = thikr.copyWith(count: thikr.count - 1);
    _updateThikrInList(updatedThikr);
    _settings.hapticSelection();
    WidgetHelper.update(updatedThikr);
  }

  void resetCount() {
    if (selectedThikr.value == null) return;

    final thikr = selectedThikr.value!;
    final updatedThikr = thikr.copyWith(count: 0, goalReached: false);
    _updateThikrInList(updatedThikr);
    _settings.hapticMedium();
    WidgetHelper.update(updatedThikr);
  }

  void _recordCount(Thikr thikr) {
    final today = StorageService.todayKey();
    var stats = _storage.getTodayStats();
    if (stats.date != today) {
      stats = DailyStats(date: today);
    }

    final per = Map<String, int>.from(stats.perThikr);
    per[thikr.id] = (per[thikr.id] ?? 0) + 1;

    String? topId = stats.topThikrId;
    String? topName = stats.topThikrName;
    var topCount = topId != null ? (per[topId] ?? 0) : 0;
    if (per[thikr.id]! >= topCount) {
      topId = thikr.id;
      topName = thikr.name;
    }

    final updated = stats.copyWith(
      totalCounts: stats.totalCounts + 1,
      perThikr: per,
      topThikrId: topId,
      topThikrName: topName,
    );
    _storage.upsertTodayStats(updated);
    todayStats.value = updated;
    _updateStreak();
  }

  void _updateStreak() {
    final today = StorageService.todayKey();
    final last = _storage.lastActiveDate;
    if (last == today) return;

    final yesterday = StorageService.todayKey(
      DateTime.now().subtract(const Duration(days: 1)),
    );

    if (last == yesterday) {
      streak.value = _storage.currentStreak + 1;
    } else {
      streak.value = 1;
    }
    _storage.setCurrentStreak(streak.value);
    _storage.setLastActiveDate(today);
  }

  void _updateThikrInList(Thikr updatedThikr) {
    final index = athkarList.indexWhere((t) => t.id == updatedThikr.id);
    if (index != -1) {
      athkarList[index] = updatedThikr;
      selectedThikr.value = updatedThikr;
      _storage.saveAthkar(athkarList);
    }
  }

  void addNewThikr(String name, int goal, {ThikrCategory? category}) {
    final newThikr = Thikr(
      id: _storage.generateId(),
      name: name,
      goal: goal,
      isDefault: false,
      category: category ?? ThikrCategory.custom,
    );

    athkarList.add(newThikr);
    _storage.saveAthkar(athkarList);
    selectedThikr.value = newThikr;
    _storage.setSelectedThikrId(newThikr.id);
    WidgetHelper.update(newThikr);

    if (!Get.testMode) {
      Get.snackbar(
        'تمت الإضافة',
        'تم إضافة "$name" بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void deleteThikr(String id) {
    final index = athkarList.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final thikr = athkarList[index];
    _lastDeleted = thikr;
    _lastDeletedIndex = index;

    athkarList.removeAt(index);
    _storage.saveAthkar(athkarList);

    if (selectedThikr.value?.id == id) {
      selectedThikr.value = athkarList.isNotEmpty ? athkarList.first : null;
      _storage.setSelectedThikrId(selectedThikr.value?.id);
      WidgetHelper.update(selectedThikr.value);
    }

    if (!Get.testMode) {
      Get.snackbar(
        'تم الحذف',
        'تم حذف "${thikr.name}"',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 4),
        mainButton: TextButton(
          onPressed: undoDelete,
          child: const Text(
            'تراجع',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  void undoDelete() {
    if (_lastDeleted == null) return;
    final thikr = _lastDeleted!;
    final index = (_lastDeletedIndex ?? athkarList.length)
        .clamp(0, athkarList.length);
    athkarList.insert(index, thikr);
    _storage.saveAthkar(athkarList);
    _lastDeleted = null;
    _lastDeletedIndex = null;

    if (Get.isSnackbarOpen) {
      try {
        Get.closeCurrentSnackbar();
      } catch (_) {}
    }
    if (!Get.testMode) {
      Get.snackbar(
        'تم التراجع',
        'تمت استعادة "${thikr.name}"',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void updateThikr({
    required String id,
    String? name,
    int? goal,
    ThikrCategory? category,
  }) {
    final index = athkarList.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final thikr = athkarList[index];
    final newGoal = goal ?? thikr.goal;
    final updatedThikr = thikr.copyWith(
      name: name ?? thikr.name,
      goal: newGoal,
      category: category ?? thikr.category,
      goalReached: thikr.count >= newGoal ? thikr.goalReached : false,
    );
    athkarList[index] = updatedThikr;
    if (selectedThikr.value?.id == id) {
      selectedThikr.value = updatedThikr;
    }
    _storage.saveAthkar(athkarList);
    WidgetHelper.update(selectedThikr.value);

    if (!Get.testMode) {
      Get.snackbar(
        'تم التحديث',
        'تم حفظ التعديلات',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// Backward-compatible helper used by older UI.
  void updateThikrGoal(String id, int newGoal) {
    updateThikr(id: id, goal: newGoal);
  }

  void addExtraPresets() {
    final presets = [
      ..._storage.getDefaultAthkar(),
      ..._storage.getExtraPresets(),
    ];
    final existingNames = athkarList.map((t) => t.name).toSet();
    final toAdd =
        presets.where((t) => !existingNames.contains(t.name)).toList();
    if (toAdd.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'كل الأذكار الإضافية موجودة مسبقاً',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }
    athkarList.addAll(toAdd);
    _storage.saveAthkar(athkarList);
    Get.snackbar(
      'تمت الإضافة',
      'تم إضافة ${toAdd.length} ذكر/أذكار',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.primary.withValues(alpha: 0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<void> exportBackup() async {
    try {
      final json = _storage.exportBackupJson();
      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/athkar_backup_${StorageService.todayKey()}.json',
      );
      await file.writeAsString(json);
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'نسخة احتياطية من تطبيق أذكاري',
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'تعذر تصدير النسخة الاحتياطية',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  Future<void> importBackup() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      String raw;
      if (file.bytes != null) {
        raw = String.fromCharCodes(file.bytes!);
      } else if (file.path != null) {
        raw = await File(file.path!).readAsString();
      } else {
        throw Exception('تعذر قراءة الملف');
      }

      final count = _storage.importBackupJson(raw);
      athkarList.assignAll(_storage.loadAthkar());
      todayStats.value = _storage.getTodayStats();
      streak.value = _storage.currentStreak;
      selectedThikr.value = athkarList.isNotEmpty ? athkarList.first : null;
      _settings.reloadFromStorage();
      Get.changeThemeMode(_storage.themeMode);
      WidgetHelper.update(selectedThikr.value);

      Get.snackbar(
        'تم الاستيراد',
        'تم استعادة $count ذكر/أذكار',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'تعذر استيراد الملف: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  void showEditThikrDialog() {
    if (selectedThikr.value == null) return;
    final thikr = selectedThikr.value!;
    final nameController = TextEditingController(text: thikr.name);
    final goalController = TextEditingController(text: thikr.goal.toString());
    var selectedCategory = thikr.category;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'تعديل الذكر',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        labelText: 'اسم الذكر',
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF2A2A2A)
                            : const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: goalController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: 'الهدف',
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF2A2A2A)
                            : const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [33, 100, 1000].map((v) {
                        return ActionChip(
                          label: Text('$v'),
                          onPressed: () =>
                              goalController.text = v.toString(),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<ThikrCategory>(
                      initialValue: selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'التصنيف',
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF2A2A2A)
                            : const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: ThikrCategory.values
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.labelAr),
                            ),
                          )
                          .toList(),
                      onChanged: (c) {
                        if (c != null) {
                          setState(() => selectedCategory = c);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('إلغاء'),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              final name = nameController.text.trim();
                              final goal =
                                  int.tryParse(goalController.text) ?? 0;
                              if (name.isEmpty || goal <= 0) return;
                              Get.back();
                              updateThikr(
                                id: thikr.id,
                                name: name,
                                goal: goal,
                                category: selectedCategory,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4AF37),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('حفظ'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void showEditGoalDialog() => showEditThikrDialog();

  void _showGoalReachedDialog() {
    _settings.hapticHeavy();
    if (Get.testMode) return;

    Get.dialog(
      Builder(
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color:
                        Get.theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Get.theme.colorScheme.primary,
                          Get.theme.colorScheme.primary.withValues(alpha: 0.7),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'مبارك!',
                    style: Get.textTheme.displayLarge?.copyWith(
                      color: Get.theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'لقد أتممت الهدف المحدد',
                    style: Get.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'يمكنك الاستمرار في العد',
                    style: Get.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Get.theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'متابعة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      barrierDismissible: true,
    );
  }

  double get progress {
    if (selectedThikr.value == null) return 0;
    final thikr = selectedThikr.value!;
    if (thikr.goal == 0) return 0;
    return (thikr.count / thikr.goal).clamp(0.0, 1.0);
  }

  String get progressText {
    if (selectedThikr.value == null) return '0 / 0';
    final thikr = selectedThikr.value!;
    return '${thikr.count} / ${thikr.goal}';
  }

  int get weekTotal {
    return _storage.getWeekStats().fold(0, (sum, s) => sum + s.totalCounts);
  }

  List<DailyStats> get weekStats => _storage.getWeekStats();
}
