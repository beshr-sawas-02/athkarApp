import 'package:get_storage/get_storage.dart';
import '../models/thikr_model.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final GetStorage _box = GetStorage();
  final String _athkarKey = 'athkar_list';
  final String _isFirstRunKey = 'is_first_run';
  final Uuid _uuid = const Uuid();

  Future<void> init() async {
    await GetStorage.init();
  }

  bool get isFirstRun => _box.read(_isFirstRunKey) ?? true;

  void setFirstRunComplete() {
    _box.write(_isFirstRunKey, false);
  }

  List<Thikr> getDefaultAthkar() {
    return [
      Thikr(
        id: _uuid.v4(),
        name: 'أستغفر الله',
        goal: 100,
        isDefault: true,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'الحمد لله',
        goal: 100,
        isDefault: true,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'سبحان الله',
        goal: 100,
        isDefault: true,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'الله أكبر',
        goal: 100,
        isDefault: true,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'لا إله إلا الله',
        goal: 100,
        isDefault: true,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'اللهم صلِّ على سيدنا محمد',
        goal: 100,
        isDefault: true,
      ),
      Thikr(
        id: _uuid.v4(),
        name: 'سبحان الله وبحمده، سبحان الله العظيم',
        goal: 100,
        isDefault: true,
      ),
    ];
  }

  List<Thikr> loadAthkar() {
    final data = _box.read<List>(_athkarKey);
    if (data == null) return [];
    return data
        .map((item) => Thikr.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  void saveAthkar(List<Thikr> athkar) {
    final data = athkar.map((item) => item.toJson()).toList();
    _box.write(_athkarKey, data);
  }

  void addThikr(List<Thikr> athkar, Thikr thikr) {
    athkar.add(thikr);
    saveAthkar(athkar);
  }

  void updateThikr(List<Thikr> athkar, Thikr updatedThikr) {
    final index = athkar.indexWhere((t) => t.id == updatedThikr.id);
    if (index != -1) {
      athkar[index] = updatedThikr;
      saveAthkar(athkar);
    }
  }

  void deleteThikr(List<Thikr> athkar, String id) {
    athkar.removeWhere((t) => t.id == id);
    saveAthkar(athkar);
  }

  String generateId() => _uuid.v4();
}