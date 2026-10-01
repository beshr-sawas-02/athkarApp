import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/athkar_controller.dart';
import '../utils/app_theme.dart';

class StatsView extends StatelessWidget {
  const StatsView({super.key});

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
          child: Column(
            children: [
              _header(isDark),
              Expanded(
                child: Obx(() {
                  final today = controller.todayStats.value;
                  final week = controller.weekStats;
                  final weekTotal = controller.weekTotal;

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _statCard(
                              isDark,
                              title: 'اليوم',
                              value: '${today.totalCounts}',
                              icon: Icons.today,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _statCard(
                              isDark,
                              title: 'هذا الأسبوع',
                              value: '$weekTotal',
                              icon: Icons.date_range,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _statCard(
                              isDark,
                              title: 'سلسلة الأيام',
                              value: '${controller.streak.value}',
                              icon: Icons.local_fire_department,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _statCard(
                              isDark,
                              title: 'أكثر ذكر اليوم',
                              value: today.topThikrName ?? '—',
                              icon: Icons.star,
                              valueSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'آخر 7 أيام',
                        style: AppTheme.arabicTitleStyle.copyWith(
                          fontSize: 18,
                          color: isDark
                              ? AppTheme.darkText
                              : AppTheme.lightText,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...week.map((day) {
                        final max = week
                            .map((e) => e.totalCounts)
                            .fold<int>(1, (a, b) => a > b ? a : b);
                        final ratio = day.totalCounts / max;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.darkSurface
                                : AppTheme.lightSurface,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    day.date,
                                    style: TextStyle(
                                      color: isDark
                                          ? AppTheme.darkTextSecondary
                                          : AppTheme.lightTextSecondary,
                                    ),
                                  ),
                                  Text(
                                    '${day.totalCounts}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryGold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: ratio.clamp(0.0, 1.0),
                                  minHeight: 8,
                                  backgroundColor: isDark
                                      ? AppTheme.darkDivider
                                      : AppTheme.lightDivider,
                                  color: AppTheme.primaryGold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.darkSurfaceVariant
                    : AppTheme.lightSurface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: AppTheme.primaryGold,
                size: 22,
              ),
            ),
          ),
          const Spacer(),
          Text(
            'الإحصائيات',
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

  Widget _statCard(
    bool isDark, {
    required String title,
    required String value,
    required IconData icon,
    double valueSize = 28,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryGold, size: 22),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppTheme.darkTextSecondary
                  : AppTheme.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: valueSize,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.darkText : AppTheme.lightText,
            ),
          ),
        ],
      ),
    );
  }
}
