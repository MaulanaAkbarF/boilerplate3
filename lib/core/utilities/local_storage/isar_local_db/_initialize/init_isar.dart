import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../global_values/global_data.dart';
import '../../../functions/logger_func.dart';
import '../collections/_setting_collection/log_app.dart';
import '../../sqflite/_initialize/init_sqflite.dart';

Future<Isar> openIsarDB() async {
  try{
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [
          LogAppCollectionSchema,
        ],
        directory: dir.path,
        inspector: kDebugMode ? true : false,
      );
    }
    return Future.value(Isar.getInstance());
  } catch (e, s){
    GlobalData.isarOpenFailedMessage = 'Terjadi masalah saat mengisiasi Isar DB: $e';
    clog('Terjadi masalah saat mengisiasi Isar DB: $e\n$s');
    await SqfliteDatabaseHelper.initializeSqflite();
    await Future.delayed(Duration(seconds: 3));
    return Future.value(Isar.getInstance());
  }
}