import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OfflineDBService {
  static String profileAuth = 'profileAuth';
  static String customerInsight = 'customerInsight';
  static String customerInsightDetail = 'customerInsightDetail';
  static String appManager = 'appManager';
  static String location = 'location';

  OfflineDBService._();

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(customerInsight);
    await Hive.openBox(profileAuth);
    await Hive.openBox(appManager);
    await Hive.openBox(location);

    await Hive.openBox(customerInsightDetail);
    print('Hive initiated');
  }

  static Future<dynamic> save(String storeKey, dynamic dataToSave,
      {String? id}) async {
    var box = await Hive.openBox(storeKey);
    id ??= storeKey;
    box.put(id, dataToSave);
    return dataToSave;
  }

  static Future<void> delete(String storeKey, String deleteId) async {
    var box = await Hive.openBox(storeKey);
    box.delete(deleteId);
  }

  static Future<dynamic> get(String storeKey, {String? getId}) async {
    var box = await Hive.openBox(storeKey);
    getId ??= storeKey;
    return box.get(getId);
  }

  static ValueListenable<Box> getBoxListener(String storeKey) {
    return Hive.box(storeKey).listenable();
  }

  static void deleteBox(String storeKey) {
    Hive.deleteBoxFromDisk(storeKey);
  }

  static Future<bool> checkBox(String storeKey, {String? getId}) async {
    var box = await Hive.openBox(storeKey);
    getId ??= storeKey;
    return box.containsKey(getId);
  }
}
