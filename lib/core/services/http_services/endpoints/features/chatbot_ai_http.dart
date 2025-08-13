import 'dart:convert';

import 'package:http/http.dart';

import '../../../../constant_values/_utlities_values.dart';
import '../../http_connection.dart';

class ChatbotAiHttp extends HttpConnection{
  ChatbotAiHttp(super.context);

  Future<String?> sendPrompt(String prompt) async {
    Response? response = await dioRequest(DioMethod.post, "https://api.deepseek.com/chat/completions", body: {
      'model': 'deepseek-chat',
      'messages': [
        {'role': 'system', 'content': 'You are a helpful assistant.'},
        {'role': 'user', 'content': prompt},
      ],
    }, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer sk-af4bad80b3544c7691bcd10e219ab47e',
    }, pure: true);

    if (response != null){
      if (response.statusCode >= 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      }
    }
    return null;
  }
}