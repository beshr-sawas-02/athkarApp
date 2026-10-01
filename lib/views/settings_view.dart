import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/athkar_controller.dart';
import '../controllers/settings_controller.dart';
import '../utils/app_theme.dart';
import '../widgets/app_icon_button.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();
    final athkar = Get.find<AthkarController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AtmosphereBackground(
        isDark: isDark,
        child: SafeArea(
          child: Column(
            children: [
              _header(isDark),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    _sectionTitle('المظهر', isDark),
                    Obx(() {
                      return _card(
                        isDark,
                        children: [
                          _themeTile(
                            settings,
                            ThemeMode.system,
                            'تلقائي (النظام)',
                            AppIcons.auto,
                          ),
                          _themeTile(
                            settings,
                            ThemeMode.light,
                            'نهاري',
                            AppIcons.day,
                          ),
                          _themeTile(
                            settings,
                            ThemeMode.dark,
                            'ليلي',
                            AppIcons.night,
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 16),
                    _sectionTitle('التفاعل', isDark),
                    Obx(() {
                      return _card(
                        isDark,
                        children: [
                          SwitchListTile(
                            secondary: const Icon(
                              AppIcons.vibrate,
                              color: AppTheme.primaryGold,
                            ),
                            title: Text(
                              'الاهتزاز',
                              style: TextStyle(
                                color: isDark
                                    ? AppTheme.darkText
                                    : AppTheme.lightText,
                              ),
                            ),
                            value: settings.vibrationEnabled.value,
                            activeThumbColor: AppTheme.primaryGold,
                            onChanged: settings.setVibrationEnabled,
                          ),
                          SwitchListTile(
                            secondary: const Icon(
                              AppIcons.sound,
                              color: AppTheme.primaryGold,
                            ),
                            title: Text(
                              'صوت النقر',
                              style: TextStyle(
                                color: isDark
                                    ? AppTheme.darkText
                                    : AppTheme.lightText,
                              ),
                            ),
                            value: settings.soundEnabled.value,
                            activeThumbColor: AppTheme.primaryGold,
                            onChanged: settings.setSoundEnabled,
                          ),
                          SwitchListTile(
                            secondary: const Icon(
                              AppIcons.resetDaily,
                              color: AppTheme.primaryGold,
                            ),
                            title: Text(
                              'إعادة تعيين يومية',
                              style: TextStyle(
                                color: isDark
                                    ? AppTheme.darkText
                                    : AppTheme.lightText,
                              ),
                            ),
                            subtitle: Text(
                              'تصفير العدادات عند منتصف الليل',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppTheme.darkTextSecondary
                                    : AppTheme.lightTextSecondary,
                              ),
                            ),
                            value: settings.dailyResetEnabled.value,
                            activeThumbColor: AppTheme.primaryGold,
                            onChanged: settings.setDailyResetEnabled,
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 16),
                    _sectionTitle('حجم الخط', isDark),
                    Obx(() {
                      return _card(
                        isDark,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Column(
                              children: [
                                Slider(
                                  value: settings.fontScale.value,
                                  min: 0.85,
                                  max: 1.3,
                                  divisions: 9,
                                  label:
                                      '${(settings.fontScale.value * 100).round()}%',
                                  activeColor: AppTheme.primaryGold,
                                  onChanged: settings.setFontScale,
                                ),
                                Text(
                                  'معاينة حجم النص',
                                  style: AppTheme.arabicBodyStyle.copyWith(
                                    fontSize: 18 * settings.fontScale.value,
                                    color: isDark
                                        ? AppTheme.darkText
                                        : AppTheme.lightText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 16),
                    _sectionTitle('البيانات', isDark),
                    _card(
                      isDark,
                      children: [
                        ListTile(
                          leading: const Icon(
                            AppIcons.backup,
                            color: AppTheme.primaryGold,
                          ),
                          title: Text(
                            'تصدير نسخة احتياطية',
                            style: TextStyle(
                              color: isDark
                                  ? AppTheme.darkText
                                  : AppTheme.lightText,
                            ),
                          ),
                          onTap: athkar.exportBackup,
                        ),
                        ListTile(
                          leading: const Icon(
                            AppIcons.restore,
                            color: AppTheme.primaryGold,
                          ),
                          title: Text(
                            'استيراد نسخة احتياطية',
                            style: TextStyle(
                              color: isDark
                                  ? AppTheme.darkText
                                  : AppTheme.lightText,
                            ),
                          ),
                          onTap: athkar.importBackup,
                        ),
                        ListTile(
                          leading: const Icon(
                            AppIcons.presets,
                            color: AppTheme.primaryGold,
                          ),
                          title: Text(
                            'إضافة أذكار جاهزة إضافية',
                            style: TextStyle(
                              color: isDark
                                  ? AppTheme.darkText
                                  : AppTheme.lightText,
                            ),
                          ),
                          onTap: athkar.addExtraPresets,
                        ),
                      ],
                    ),
                  ],
                ),
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
            'الإعدادات',
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

  Widget _sectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark
              ? AppTheme.darkTextSecondary
              : AppTheme.lightTextSecondary,
        ),
      ),
    );
  }

  Widget _card(bool isDark, {required List<Widget> children}) {
    return Material(
      color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: Column(children: children),
    );
  }

  Widget _themeTile(
    SettingsController settings,
    ThemeMode mode,
    String label,
    IconData icon,
  ) {
    final selected = settings.themeMode.value == mode;
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryGold),
      title: Text(label),
      trailing: selected
          ? const Icon(Icons.check_circle, color: AppTheme.primaryGold)
          : null,
      onTap: () => settings.setThemeMode(mode),
    );
  }
}
