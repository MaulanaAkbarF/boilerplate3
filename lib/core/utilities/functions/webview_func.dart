import 'package:url_launcher/url_launcher.dart';

import '../../constant_values/_setting_value/log_app_values.dart';
import '../local_storage/isar_local_db/services/_setting_services/log_app_services.dart';
import 'logger_func.dart';

Future<void> launchURL(String url) async {
  final Uri uri = Uri.parse(url);

  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  } catch (e, s) {
    clog('Terjadi kesalahan saat membuka URL: $e');
    await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
  }
}

Future<void> sendEmail({required String toEmail, String? subject, String? body, List<String>? ccEmails, List<String>? bccEmails}) async {
  Map<String, String> params = {};
  String paramToString = '';
  if (subject != null && subject.isNotEmpty) params['subject'] = subject;
  if (body != null && body.isNotEmpty) params['body'] = body;
  if (ccEmails != null && ccEmails.isNotEmpty) params['cc'] = ccEmails.join(',');
  if (bccEmails != null && bccEmails.isNotEmpty) params['bcc'] = bccEmails.join(',');
  if (params.isNotEmpty) paramToString = params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
  final Uri uri = Uri.parse('mailto:$toEmail?$paramToString');

  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  } catch (e, s) {
    clog('Terjadi kesalahan saat membuka URL: $e');
    await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
  }
}