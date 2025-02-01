import 'package:hive/hive.dart';

import '../data/data.dart';

class HiveAdapters {
  static void registerAdapters() {
    Hive.registerAdapter(TaskModelAdapter());
  }
}
