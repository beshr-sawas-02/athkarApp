import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/athkar_controller.dart';
import '../models/thikr_category.dart';
import '../utils/app_theme.dart';
import '../widgets/add_thikr_dialog.dart';
import '../widgets/app_icon_button.dart';
import '../widgets/thikr_card.dart';

class AthkarListView extends StatelessWidget {
  const AthkarListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AthkarController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AtmosphereBackground(
        isDark: isDark,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isDark),
              _buildCategoryChips(controller, isDark),
              Expanded(
                child: Obx(() {
                  final list = controller.filteredAthkar;
                  if (list.isEmpty) {
                    return _buildEmptyState(isDark);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 100),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final thikr = list[index];
                      return ThikrCard(
                        thikr: thikr,
                        isSelected:
                            controller.selectedThikr.value?.id == thikr.id,
                        onTap: () {
                          controller.selectThikr(thikr);
                          Get.back();
                        },
                        onDelete: thikr.isDefault
                            ? null
                            : () => _showDeleteConfirmation(
                                  controller,
                                  thikr.id,
                                  thikr.name,
                                ),
                        onEdit: () {
                          controller.selectThikr(thikr);
                          controller.showEditThikrDialog();
                        },
                        isDark: isDark,
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(controller),
        backgroundColor: AppTheme.primaryGold,
        foregroundColor: Colors.white,
        elevation: 8,
        icon: const Icon(AppIcons.add),
        label: const Text(
          'إضافة ذكر',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCategoryChips(AthkarController controller, bool isDark) {
    return Obx(() {
      final selected = controller.categoryFilter.value;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            _chip(
              label: 'الكل',
              selected: selected == null,
              onTap: () => controller.setCategoryFilter(null),
              isDark: isDark,
            ),
            ...ThikrCategory.values.map(
              (c) => _chip(
                label: c.labelAr,
                selected: selected == c,
                onTap: () => controller.setCategoryFilter(c),
                isDark: isDark,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppTheme.primaryGold.withValues(alpha: 0.25),
        labelStyle: TextStyle(
          color: selected
              ? AppTheme.primaryGold
              : (isDark ? AppTheme.darkText : AppTheme.lightText),
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor:
            isDark ? AppTheme.darkSurfaceVariant : AppTheme.lightSurface,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          AppIconButton(
            icon: Icons.arrow_back_ios_rounded,
            onTap: () => Get.back(),
            isDark: isDark,
          ),
          const Spacer(),
          Text(
            'قائمة الأذكار',
            style: AppTheme.arabicTitleStyle.copyWith(
              color: AppTheme.primaryGold,
              fontSize: 22,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
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
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryGold.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                AppIcons.beads,
                size: 64,
                color: AppTheme.primaryGold.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'لا توجد أذكار في هذا التصنيف',
              style: AppTheme.arabicTitleStyle.copyWith(
                color: isDark ? AppTheme.darkText : AppTheme.lightText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'أضف ذكراً جديداً أو غيّر التصنيف',
              style: AppTheme.arabicBodyStyle.copyWith(
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.lightTextSecondary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () =>
                  _showAddDialog(Get.find<AthkarController>()),
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
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(AthkarController controller) {
    Get.dialog(
      AddThikrDialog(
        onAdd: (name, goal, category) {
          controller.addNewThikr(name, goal, category: category);
        },
      ),
    );
  }

  void _showDeleteConfirmation(
    AthkarController controller,
    String id,
    String name,
  ) {
    final isDark = Get.theme.brightness == Brightness.dark;

    Get.dialog(
      AlertDialog(
        backgroundColor: Get.theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppTheme.error,
                size: 28,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'حذف الذكر',
              style: AppTheme.arabicTitleStyle.copyWith(
                color: isDark ? AppTheme.darkText : AppTheme.lightText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'هل تريد حذف "$name"؟',
              style: AppTheme.arabicBodyStyle.copyWith(
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'يمكنك التراجع من الإشعار بعد الحذف',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.primaryGold.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark
                          ? AppTheme.darkTextSecondary
                          : AppTheme.lightTextSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    controller.deleteThikr(id);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.error,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'حذف',
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
    );
  }
}
