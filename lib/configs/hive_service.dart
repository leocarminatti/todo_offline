import 'package:hive_flutter/hive_flutter.dart';

import '../data/data.dart';
import 'configs.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      HiveAdapters.registerAdapters();
    }
  }

  static Future<void> openBoxes() async {
    if (!Hive.isBoxOpen('tasks')) {
      await Hive.openBox<TaskModel>('tasks');
    }
  }

  static Box<T> getBox<T>(String boxName) {
    if (!Hive.isBoxOpen(boxName)) {
      throw HiveError('A box "$boxName" ainda não foi aberta.');
    }
    return Hive.box<T>(boxName);
  }
}
