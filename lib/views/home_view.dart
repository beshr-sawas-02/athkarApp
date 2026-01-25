import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/athkar_controller.dart';
import '../utils/app_theme.dart';
import '../widgets/counter_button.dart';
import '../widgets/progress_widget.dart';
import 'athkar_list_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AthkarController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.darkGradient : AppTheme.lightGradient,
        ),
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryGold,
                ),
              );
            }

            final selectedThikr = controller.selectedThikr.value;

            if (selectedThikr == null) {
              return _buildEmptyState(isDark);
            }

            return Column(
              children: [
                // Header
                _buildHeader(context, isDark),

                // Thikr Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    selectedThikr.name,
                    style: AppTheme.arabicDisplayStyle.copyWith(
                      color: isDark ? AppTheme.darkText : AppTheme.lightText,
                      fontSize: 28,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 8),

                // Goal reached badge
                if (selectedThikr.goalReached)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.success.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppTheme.success,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'تم الوصول للهدف',
                          style: TextStyle(
                            color: AppTheme.success,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                const Spacer(),

                // Progress Ring & Counter
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressWidget(
                      progress: controller.progress,
                      progressText: controller.progressText,
                      isDark: isDark,
                    ),
                    CounterButton(
                      count: selectedThikr.count,
                      onTap: controller.incrementCount,
                      isDark: isDark,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Progress text
                Text(
                  controller.progressText,
                  style: AppTheme.goalStyle.copyWith(
                    color: isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary,
                  ),
                ),

                const SizedBox(height: 8),

                // Edit goal button
                GestureDetector(
                  onTap: () => controller.showEditGoalDialog(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.darkSurfaceVariant
                          : AppTheme.lightSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.primaryGold.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit_rounded,
                          color: AppTheme.primaryGold,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'تعديل الهدف',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.primaryGold,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Control buttons
                _buildControlButtons(controller, isDark),

                const SizedBox(height: 24),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu button
          _buildIconButton(
            icon: Icons.menu_rounded,
            onTap: () => Get.to(() => const AthkarListView()),
            isDark: isDark,
          ),
          // Title
          Text(
            'أذكاري',
            style: AppTheme.arabicTitleStyle.copyWith(
              color: AppTheme.primaryGold,
              fontSize: 22,
            ),
          ),
          // Placeholder for symmetry
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.darkSurfaceVariant
              : AppTheme.lightSurface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryGold,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildControlButtons(AthkarController controller, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Decrement button
          _buildControlButton(
            icon: Icons.remove_rounded,
            label: 'إنقاص',
            onTap: controller.decrementCount,
            isDark: isDark,
          ),
          // Reset button
          _buildControlButton(
            icon: Icons.refresh_rounded,
            label: 'إعادة',
            onTap: () => _showResetConfirmation(controller),
            isDark: isDark,
            isReset: true,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
    bool isReset = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.darkSurfaceVariant
              : AppTheme.lightSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isReset ? AppTheme.error : AppTheme.primaryGold,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isReset
                    ? AppTheme.error
                    : (isDark ? AppTheme.darkText : AppTheme.lightText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetConfirmation(AthkarController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Get.theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'إعادة العداد',
          style: AppTheme.arabicTitleStyle.copyWith(
            color: Get.theme.brightness == Brightness.dark
                ? AppTheme.darkText
                : AppTheme.lightText,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'هل تريد إعادة العداد إلى الصفر؟',
          style: AppTheme.arabicBodyStyle.copyWith(
            color: Get.theme.brightness == Brightness.dark
                ? AppTheme.darkTextSecondary
                : AppTheme.lightTextSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: Get.theme.brightness == Brightness.dark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.lightTextSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.resetCount();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('إعادة'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 80,
            color: AppTheme.primaryGold.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد أذكار',
            style: AppTheme.arabicTitleStyle.copyWith(
              color: isDark ? AppTheme.darkText : AppTheme.lightText,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'اضغط على القائمة لإضافة ذكر جديد',
            style: AppTheme.arabicBodyStyle.copyWith(
              color: isDark
                  ? AppTheme.darkTextSecondary
                  : AppTheme.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}