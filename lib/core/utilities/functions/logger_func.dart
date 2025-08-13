import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

void clog(dynamic object) {
  if (kDebugMode) {
    if (object is Map || object is List) {
      try {
        log(const JsonEncoder.withIndent("   ").convert(object));
        return;
      } catch (_) {}
    }
    log(object.toString());
  } else {
    // FirebaseCrashlytics.instance.log(object.toString());
    // FirebaseAnalytics.instance.logEvent(name: "console", parameters: {"value": object.toString()});
  }
}

void cprint(dynamic object) => kDebugMode ? debugPrint(object.toString()) : null;