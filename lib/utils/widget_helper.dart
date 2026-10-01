import 'package:home_widget/home_widget.dart';

import '../models/thikr_model.dart';

class WidgetHelper {
  static const androidName = 'AthkarWidgetProvider';
  static const iOSName = 'AthkarWidget';

  static Future<void> update(Thikr? thikr) async {
    try {
      await HomeWidget.saveWidgetData<String>(
        'thikr_name',
        thikr?.name ?? 'أذكاري',
      );
      await HomeWidget.saveWidgetData<String>(
        'thikr_count',
        thikr == null ? '0 / 0' : '${thikr.count} / ${thikr.goal}',
      );
      await HomeWidget.updateWidget(
        androidName: androidName,
        iOSName: iOSName,
      );
    } catch (_) {
      // Widget may be unavailable on some platforms/emulators.
    }
  }
}
