import 'package:firebase_ai/firebase_ai.dart';

import '../../constant_values/_setting_value/log_app_values.dart';
import '../../utilities/functions/logger_func.dart';
import '../../utilities/local_storage/isar_local_db/services/_setting_services/log_app_services.dart';

Future<GenerateContentResponse?> askToFirebaseAI(String prompt) async {
  try {
    clog('Prompt saya: $prompt');
    // await Future.delayed(Duration(seconds: 4));
    // return null;
    return await FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash').generateContent([Content.text(prompt)]);
  } catch (e, s) {
    clog('Tidak dapat memproses prompt ke Firebase AI.\n$e\n$s');
    addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    return null;
  }
}