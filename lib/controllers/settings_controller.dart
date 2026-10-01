import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../utils/storage_service.dart';

class SettingsController extends GetxController {
  final StorageService _storage = StorageService();

  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  final RxBool vibrationEnabled = true.obs;
  final RxBool soundEnabled = false.obs;
  final RxDouble fontScale = 1.0.obs;
  final RxBool dailyResetEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    reloadFromStorage();
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    _storage.setThemeMode(mode);
    Get.changeThemeMode(mode);
  }

  void setVibrationEnabled(bool value) {
    vibrationEnabled.value = value;
    _storage.setVibrationEnabled(value);
  }

  void setSoundEnabled(bool value) {
    soundEnabled.value = value;
    _storage.setSoundEnabled(value);
  }

  void setFontScale(double value) {
    fontScale.value = value;
    _storage.setFontScale(value);
  }

  void setDailyResetEnabled(bool value) {
    dailyResetEnabled.value = value;
    _storage.setDailyResetEnabled(value);
  }

  void hapticLight() {
    if (vibrationEnabled.value) {
      HapticFeedback.lightImpact();
    }
  }

  void hapticSelection() {
    if (vibrationEnabled.value) {
      HapticFeedback.selectionClick();
    }
  }

  void hapticMedium() {
    if (vibrationEnabled.value) {
      HapticFeedback.mediumImpact();
    }
  }

  void hapticHeavy() {
    if (vibrationEnabled.value) {
      HapticFeedback.heavyImpact();
    }
  }

  void playClickSound() {
    if (soundEnabled.value) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  void reloadFromStorage() {
    themeMode.value = _storage.themeMode;
    vibrationEnabled.value = _storage.vibrationEnabled;
    soundEnabled.value = _storage.soundEnabled;
    fontScale.value = _storage.fontScale;
    dailyResetEnabled.value = _storage.dailyResetEnabled;
    Get.changeThemeMode(themeMode.value);
  }
}
