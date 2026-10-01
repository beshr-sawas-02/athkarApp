import 'package:flutter/material.dart';

import '../models/thikr_model.dart';
import '../utils/app_theme.dart';

class ThikrCard extends StatelessWidget {
  final Thikr thikr;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final bool isDark;

  const ThikrCard({
    super.key,
    required this.thikr,
    required this.isSelected,
    required this.onTap,
    this.onDelete,
    this.onEdit,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final progress = thikr.goal > 0
        ? (thikr.count / thikr.goal).clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryGold.withValues(alpha: isDark ? 0.2 : 0.1)
              : isDark
                  ? AppTheme.darkSurface
                  : AppTheme.lightSurface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryGold
                : isDark
                    ? AppTheme.darkDivider
                    : AppTheme.lightDivider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: AppTheme.softShadow(isDark),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 4,
                    backgroundColor: isDark
                        ? AppTheme.darkDivider
                        : AppTheme.lightDivider,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      thikr.goalReached
                          ? AppTheme.success
                          : AppTheme.primaryGold,
                    ),
                  ),
                  if (thikr.goalReached)
                    const Icon(
                      Icons.check_rounded,
                      color: AppTheme.success,
                      size: 24,
                    )
                  else
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppTheme.darkText
                            : AppTheme.lightText,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    thikr.name,
                    style: AppTheme.arabicBodyStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppTheme.darkText
                          : AppTheme.lightText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${thikr.count} / ${thikr.goal} · ${thikr.category.labelAr}',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppTheme.darkTextSecondary
                          : AppTheme.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (onEdit != null)
              IconButton(
                onPressed: onEdit,
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppTheme.primaryGold,
                  size: 20,
                ),
              ),
            if (!thikr.isDefault && onDelete != null)
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: AppTheme.error.withValues(alpha: 0.7),
                  size: 22,
                ),
              ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppTheme.primaryGold,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
