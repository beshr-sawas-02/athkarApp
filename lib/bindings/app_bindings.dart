import 'package:get/get.dart';
import '../controllers/athkar_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AthkarController>(() => AthkarController());
  }
}