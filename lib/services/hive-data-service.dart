import 'package:hive/hive.dart';

class HiveDatabaseService {
  HiveDatabaseService._();

  static final HiveDatabaseService db = HiveDatabaseService._();

  Future<Box> getBox(String name) async {
    var boxOpen = Hive.isBoxOpen(name);
    var box;
    if (boxOpen) {
      box = Hive.box(name);
    } else {
      box = await Hive.openBox(name);
    }
    return box;
  }

  Future<void> delete() async {
    Hive.deleteFromDisk();
  }
}
