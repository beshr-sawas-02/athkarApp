import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/thikr_model.dart';
import '../utils/storage_service.dart';

class AthkarController extends GetxController {
  final StorageService _storage = StorageService();

  final RxList<Thikr> athkarList = <Thikr>[].obs;
  final Rx<Thikr?> selectedThikr = Rx<Thikr?>(null);
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAthkar();
  }

  void _initializeAthkar() {
    if (_storage.isFirstRun) {
      // First run - load default athkar
      athkarList.assignAll(_storage.getDefaultAthkar());
      _storage.saveAthkar(athkarList);
      _storage.setFirstRunComplete();
    } else {
      // Load saved athkar
      athkarList.assignAll(_storage.loadAthkar());
    }

    if (athkarList.isNotEmpty) {
      selectedThikr.value = athkarList.first;
    }

    isLoading.value = false;
  }

  void selectThikr(Thikr thikr) {
    selectedThikr.value = thikr;
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

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Show celebration if goal just reached
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

    HapticFeedback.selectionClick();
  }

  void resetCount() {
    if (selectedThikr.value == null) return;

    final thikr = selectedThikr.value!;
    final updatedThikr = thikr.copyWith(count: 0, goalReached: false);
    _updateThikrInList(updatedThikr);

    HapticFeedback.mediumImpact();
  }

  void _updateThikrInList(Thikr updatedThikr) {
    final index = athkarList.indexWhere((t) => t.id == updatedThikr.id);
    if (index != -1) {
      athkarList[index] = updatedThikr;
      selectedThikr.value = updatedThikr;
      _storage.saveAthkar(athkarList);
    }
  }

  void addNewThikr(String name, int goal) {
    final newThikr = Thikr(
      id: _storage.generateId(),
      name: name,
      goal: goal,
      isDefault: false,
    );

    athkarList.add(newThikr);
    _storage.saveAthkar(athkarList);
    selectedThikr.value = newThikr;

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

  void deleteThikr(String id) {
    final thikr = athkarList.firstWhereOrNull((t) => t.id == id);
    if (thikr == null) return;

    athkarList.removeWhere((t) => t.id == id);
    _storage.saveAthkar(athkarList);

    // Update selected thikr if needed
    if (selectedThikr.value?.id == id) {
      selectedThikr.value = athkarList.isNotEmpty ? athkarList.first : null;
    }

    Get.snackbar(
      'تم الحذف',
      'تم حذف "${thikr.name}" بنجاح',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withValues(alpha: 0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  void updateThikrGoal(String id, int newGoal) {
    final index = athkarList.indexWhere((t) => t.id == id);
    if (index != -1) {
      final thikr = athkarList[index];
      final updatedThikr = thikr.copyWith(
        goal: newGoal,
        goalReached: thikr.count >= newGoal ? thikr.goalReached : false,
      );
      athkarList[index] = updatedThikr;
      if (selectedThikr.value?.id == id) {
        selectedThikr.value = updatedThikr;
      }
      _storage.saveAthkar(athkarList);

      Get.snackbar(
        'تم التحديث',
        'تم تغيير الهدف إلى $newGoal',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void showEditGoalDialog() {
    if (selectedThikr.value == null) return;

    final TextEditingController goalController = TextEditingController(
      text: selectedThikr.value!.goal.toString(),
    );

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
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE8C547), Color(0xFFD4AF37)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.flag_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'تعديل الهدف',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Get.theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    selectedThikr.value!.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: Get.theme.brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Goal input
                  TextField(
                    controller: goalController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Get.theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Get.theme.brightness == Brightness.dark
                          ? const Color(0xFF2A2A2A)
                          : const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFFD4AF37),
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick select buttons
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [33, 50, 100, 200, 500, 1000].map((value) {
                      return GestureDetector(
                        onTap: () => goalController.text = value.toString(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Get.theme.brightness == Brightness.dark
                                ? const Color(0xFF2A2A2A)
                                : const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            '$value',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Get.theme.brightness == Brightness.dark
                                  ? Colors.white70
                                  : Colors.black54,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'إلغاء',
                            style: TextStyle(
                              fontSize: 16,
                              color: Get.theme.brightness == Brightness.dark
                                  ? Colors.white54
                                  : Colors.black45,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            final newGoal = int.tryParse(goalController.text);
                            if (newGoal != null && newGoal > 0) {
                              Navigator.of(context).pop();
                              updateThikrGoal(selectedThikr.value!.id, newGoal);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4AF37),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'حفظ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showGoalReachedDialog() {
    HapticFeedback.heavyImpact();

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
                    color: Get.theme.colorScheme.primary.withValues(alpha: 0.3),
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
                    'مبارك! 🎉',
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
}