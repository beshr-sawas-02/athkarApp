enum ThikrCategory {
  general,
  morning,
  evening,
  afterPrayer,
  sleep,
  travel,
  custom;

  String get labelAr {
    switch (this) {
      case ThikrCategory.general:
        return 'عامة';
      case ThikrCategory.morning:
        return 'الصباح';
      case ThikrCategory.evening:
        return 'المساء';
      case ThikrCategory.afterPrayer:
        return 'بعد الصلاة';
      case ThikrCategory.sleep:
        return 'النوم';
      case ThikrCategory.travel:
        return 'السفر';
      case ThikrCategory.custom:
        return 'مخصصة';
    }
  }

  static ThikrCategory fromName(String? name) {
    return ThikrCategory.values.firstWhere(
      (c) => c.name == name,
      orElse: () => ThikrCategory.general,
    );
  }
}
