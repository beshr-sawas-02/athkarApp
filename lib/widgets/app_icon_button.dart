import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  final double size;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.isDark,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? AppTheme.darkSurfaceVariant : AppTheme.lightSurface,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      elevation: 0,
      shadowColor: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            boxShadow: AppTheme.softShadow(isDark),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryGold,
            size: size < 48 ? 20 : 24,
          ),
        ),
      ),
    );
  }
}

/// Semantic icons used across the app for a more spiritual feel.
class AppIcons {
  static const mosque = Icons.mosque_rounded;
  static const beads = Icons.spa_rounded;
  static const menu = Icons.menu_book_rounded;
  static const stats = Icons.insights_rounded;
  static const settings = Icons.tune_rounded;
  static const add = Icons.add_circle_outline_rounded;
  static const edit = Icons.edit_note_rounded;
  static const night = Icons.nightlight_round;
  static const day = Icons.wb_sunny_rounded;
  static const auto = Icons.brightness_auto_rounded;
  static const vibrate = Icons.vibration_rounded;
  static const sound = Icons.music_note_rounded;
  static const resetDaily = Icons.event_repeat_rounded;
  static const backup = Icons.cloud_upload_rounded;
  static const restore = Icons.cloud_download_rounded;
  static const presets = Icons.auto_awesome_rounded;
  static const streak = Icons.local_fire_department_rounded;
  static const star = Icons.star_rounded;
  static const today = Icons.today_rounded;
  static const week = Icons.calendar_view_week_rounded;
}
