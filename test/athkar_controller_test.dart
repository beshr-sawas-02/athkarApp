import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:athkar_app/controllers/athkar_controller.dart';
import 'package:athkar_app/controllers/settings_controller.dart';
import 'package:athkar_app/models/thikr_category.dart';
import 'package:athkar_app/models/thikr_model.dart';
import 'package:athkar_app/utils/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AthkarController controller;

  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async => '.',
    );
    await GetStorage.init();
  });

  setUp(() async {
    Get.reset();
    Get.testMode = true;
    final box = GetStorage();
    await box.erase();
    Get.put(SettingsController());
    controller = AthkarController();
    Get.put(controller);
    controller.athkarList.assignAll([
      Thikr(
        id: '1',
        name: 'سبحان الله',
        goal: 3,
        isDefault: true,
        category: ThikrCategory.general,
      ),
      Thikr(
        id: '2',
        name: 'الحمد لله',
        goal: 100,
        isDefault: false,
        category: ThikrCategory.custom,
      ),
    ]);
    controller.selectedThikr.value = controller.athkarList.first;
    controller.isLoading.value = false;
  });

  tearDown(() {
    Get.reset();
  });

  test('incrementCount increases selected thikr count', () {
    expect(controller.selectedThikr.value!.count, 0);
    controller.incrementCount();
    expect(controller.selectedThikr.value!.count, 1);
    expect(controller.progressText, '1 / 3');
  });

  test('decrementCount does not go below zero', () {
    controller.decrementCount();
    expect(controller.selectedThikr.value!.count, 0);
    controller.incrementCount();
    controller.decrementCount();
    expect(controller.selectedThikr.value!.count, 0);
  });

  test('resetCount clears count and goalReached', () {
    controller.incrementCount();
    controller.incrementCount();
    controller.incrementCount();
    expect(controller.selectedThikr.value!.goalReached, isTrue);
    controller.resetCount();
    expect(controller.selectedThikr.value!.count, 0);
    expect(controller.selectedThikr.value!.goalReached, isFalse);
  });

  test('updateThikr changes name and goal', () {
    controller.updateThikr(id: '1', name: 'ذكر معدل', goal: 10);
    expect(controller.selectedThikr.value!.name, 'ذكر معدل');
    expect(controller.selectedThikr.value!.goal, 10);
  });

  test('deleteThikr and undoDelete restore item', () {
    final before = controller.athkarList.length;
    controller.deleteThikr('2');
    expect(controller.athkarList.length, before - 1);
    controller.undoDelete();
    expect(controller.athkarList.length, before);
    expect(controller.athkarList.any((t) => t.id == '2'), isTrue);
  });

  test('addNewThikr appends custom thikr', () {
    final before = controller.athkarList.length;
    controller.addNewThikr('ذكر جديد', 33, category: ThikrCategory.morning);
    expect(controller.athkarList.length, before + 1);
    expect(controller.selectedThikr.value!.name, 'ذكر جديد');
    expect(controller.selectedThikr.value!.category, ThikrCategory.morning);
  });

  test('category filter works', () {
    controller.setCategoryFilter(ThikrCategory.custom);
    expect(controller.filteredAthkar.length, 1);
    expect(controller.filteredAthkar.first.id, '2');
    controller.setCategoryFilter(null);
    expect(controller.filteredAthkar.length, 2);
  });

  test('backup export/import roundtrip', () {
    final storage = StorageService();
    storage.saveAthkar(controller.athkarList);
    final json = storage.exportBackupJson();
    expect(json.contains('سبحان الله'), isTrue);
    final count = storage.importBackupJson(json);
    expect(count, greaterThan(0));
  });
}
