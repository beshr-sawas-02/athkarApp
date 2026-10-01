import 'package:get/get.dart';

import '../controllers/athkar_controller.dart';
import '../controllers/settings_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<SettingsController>(SettingsController(), permanent: true);
    Get.lazyPut<AthkarController>(() => AthkarController());
  }
}
