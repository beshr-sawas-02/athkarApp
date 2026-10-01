import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/athkar_controller.dart';
import '../utils/app_theme.dart';
import '../widgets/app_icon_button.dart';

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  String _friendlyDate(String iso) {
    final parts = iso.split('-');
    if (parts.length != 3) return iso;
    final date = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return 'اليوم';
    if (diff == 1) return 'أمس';

    const weekdays = [
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    return weekdays[date.weekday - 1];
  }

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
              _header(isDark),
              Expanded(
                child: Obx(() {
                  final today = controller.todayStats.value;
                  final week = controller.weekStats;
                  final weekTotal = controller.weekTotal;
                  final max = week
                      .map((e) => e.totalCounts)
                      .fold<int>(1, (a, b) => a > b ? a : b);

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
                              icon: AppIcons.today,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _statCard(
                              isDark,
                              title: 'هذا الأسبوع',
                              value: '$weekTotal',
                              icon: AppIcons.week,
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
                              icon: AppIcons.streak,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _statCard(
                              isDark,
                              title: 'أكثر ذكر اليوم',
                              value: today.topThikrName ?? '—',
                              icon: AppIcons.star,
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
                          color:
                              isDark ? AppTheme.darkText : AppTheme.lightText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 180,
                        padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppTheme.darkSurface
                              : AppTheme.lightSurface,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMd),
                          boxShadow: AppTheme.softShadow(isDark),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (final day in week.reversed)
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${day.totalCounts}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryGold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Flexible(
                                        child: FractionallySizedBox(
                                          heightFactor: (day.totalCounts / max)
                                              .clamp(0.05, 1.0),
                                          widthFactor: 1,
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: AppTheme.goldGradient,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _friendlyDate(day.date),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isDark
                                              ? AppTheme.darkTextSecondary
                                              : AppTheme.lightTextSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...week.map((day) {
                        final ratio = day.totalCounts / max;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.darkSurface
                                : AppTheme.lightSurface,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMd),
                            boxShadow: AppTheme.softShadow(isDark),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _friendlyDate(day.date),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppTheme.darkText
                                          : AppTheme.lightText,
                                    ),
                                  ),
                                  Text(
                                    '${day.totalCounts} تسبيحة',
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
          AppIconButton(
            icon: Icons.arrow_back_ios_rounded,
            onTap: () => Get.back(),
            isDark: isDark,
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
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: AppTheme.softShadow(isDark),
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
