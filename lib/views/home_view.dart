import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../controllers/athkar_controller.dart';
import '../controllers/settings_controller.dart';
import '../utils/app_theme.dart';
import '../widgets/app_icon_button.dart';
import '../widgets/celebration_burst.dart';
import '../widgets/counter_button.dart';
import '../widgets/progress_widget.dart';
import 'athkar_list_view.dart';
import 'settings_view.dart';
import 'stats_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  void _openMoreMenu(bool isDark) {
    Get.bottomSheet(
      Material(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLg),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkDivider : AppTheme.lightDivider,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              ListTile(
                leading:
                    const Icon(AppIcons.stats, color: AppTheme.primaryGold),
                title: const Text('الإحصائيات'),
                onTap: () {
                  Get.back();
                  Get.to(() => const StatsView());
                },
              ),
              ListTile(
                leading: const Icon(AppIcons.settings,
                    color: AppTheme.primaryGold),
                title: const Text('الإعدادات'),
                onTap: () {
                  Get.back();
                  Get.to(() => const SettingsView());
                },
              ),
              ListTile(
                leading:
                    const Icon(AppIcons.menu, color: AppTheme.primaryGold),
                title: const Text('قائمة الأذكار'),
                onTap: () {
                  Get.back();
                  Get.to(() => const AthkarListView());
                },
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AthkarController>();
    final settings = Get.find<SettingsController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AtmosphereBackground(
        isDark: isDark,
        child: SafeArea(
          child: Obx(() {
            final scale = settings.fontScale.value;
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryGold),
              );
            }

            final selectedThikr = controller.selectedThikr.value;
            if (selectedThikr == null) {
              return _buildEmptyState(isDark);
            }

            return Column(
              children: [
                _buildHeader(isDark),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: controller.incrementCount,
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            selectedThikr.name,
                            style: AppTheme.arabicDisplayStyle.copyWith(
                              color: isDark
                                  ? AppTheme.darkText
                                  : AppTheme.lightText,
                              fontSize: 28 * scale,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (selectedThikr.goalReached)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.success.withValues(alpha: 0.15),
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusLg),
                              border: Border.all(
                                color:
                                    AppTheme.success.withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: AppTheme.success,
                                  size: 18,
                                ),
                                SizedBox(width: 6),
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
                        ProgressRingPulse(
                          active: selectedThikr.goalReached,
                          child: Stack(
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
                                showHint: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'الهدف: ${selectedThikr.goal}',
                          style: AppTheme.goalStyle.copyWith(
                            fontSize: 16 * scale,
                            color: isDark
                                ? AppTheme.darkTextSecondary
                                : AppTheme.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => controller.showEditThikrDialog(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppTheme.darkSurfaceVariant
                                  : AppTheme.lightSurface,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusLg),
                              border: Border.all(
                                color: AppTheme.primaryGold
                                    .withValues(alpha: 0.3),
                              ),
                              boxShadow: AppTheme.softShadow(isDark),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  AppIcons.edit,
                                  color: AppTheme.primaryGold,
                                  size: 18,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'تعديل الذكر',
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
                        Text(
                          'اضغط في أي مكان للعد',
                          style: TextStyle(
                            fontSize: 13,
                            color: (isDark
                                    ? AppTheme.darkTextSecondary
                                    : AppTheme.lightTextSecondary)
                                .withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                _buildControlButtons(controller, isDark),
                const SizedBox(height: 20),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          AppIconButton(
            icon: AppIcons.menu,
            onTap: () => Get.to(() => const AthkarListView()),
            isDark: isDark,
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(AppIcons.mosque, color: AppTheme.primaryGold, size: 22),
              const SizedBox(width: 8),
              Text(
                'أذكاري',
                style: AppTheme.arabicTitleStyle.copyWith(
                  color: AppTheme.primaryGold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          const Spacer(),
          AppIconButton(
            icon: Icons.more_horiz_rounded,
            onTap: () => _openMoreMenu(isDark),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons(AthkarController controller, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.remove_rounded,
            label: 'إنقاص',
            onTap: controller.decrementCount,
            isDark: isDark,
          ),
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
    return Material(
      color: isDark ? AppTheme.darkSurfaceVariant : AppTheme.lightSurface,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            boxShadow: AppTheme.softShadow(isDark),
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
      ),
    );
  }

  void _showResetConfirmation(AthkarController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Get.theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
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
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.mosque,
              size: 80,
              color: AppTheme.primaryGold.withValues(alpha: 0.55),
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
              'ابدأ بإضافة ذكر جديد للمتابعة',
              style: AppTheme.arabicBodyStyle.copyWith(
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => Get.to(() => const AthkarListView()),
              icon: const Icon(AppIcons.add),
              label: const Text('إضافة ذكر'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
