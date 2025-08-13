import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constant_values/_setting_value/log_app_values.dart';
import '../../../constant_values/list_string_values.dart';
import '../../../models/features/chatbot_ai.dart';
import '../../../state_management/providers/auth/user_provider.dart';
import '../../../utilities/functions/input_func.dart';
import '../../../utilities/functions/logger_func.dart';
import '../../../utilities/local_storage/isar_local_db/services/_setting_services/log_app_services.dart';

class FirestoreChatbot{
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final String mainCollection = 'chatbot';
  static final String metadataCollection = 'chatbot_metadata';

  static Future<(ChatbotData?, List<ChatbotConversation>?)?> initializeLastConversation({required BuildContext context}) async {
    try {
      if (UserProvider.read(context).user != null){
        ChatbotData? chatbotData;
        final ref = _db.collection(mainCollection).doc(UserProvider.read(context).user?.email ?? '')
            .withConverter(fromFirestore: ChatbotData.fromFirestore, toFirestore: (ChatbotData chatbotData, _) => chatbotData.toJson());
        await ref.get().then((docSnap) => chatbotData = docSnap.data());
        if (chatbotData == null) return await addNewConversation(context: context).then((value) => (value != null ? (value.$1, value.$2) : null));
        if (chatbotData != null) {
          clog('Data percakapan pengguna pada Firestore ditemukan!');
          return (chatbotData, chatbotData?.conversations);
        }
      }
      clog('Data percakapan pengguna pada Firestore tidak ditemukan!');
      return null;
    } catch (e, s){
      clog('Tidak dapat mengecek percakapan pertama pada FirestoreChatbot.\n$e\n$s');
      await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      return null;
    }
  }

  static Future<(ChatbotData, List<ChatbotConversation>?)?> addNewConversation({required BuildContext context}) async {
    try {
      clog('Run addNewConversation');
      if (UserProvider.read(context).user != null){
        ChatbotData? chatbotData;
        final ref = _db.collection(mainCollection).doc(UserProvider.read(context).user?.email ?? '')
            .withConverter(fromFirestore: ChatbotData.fromFirestore, toFirestore: (ChatbotData chatbotData, _) => chatbotData.toJson());
        await ref.get().then((docSnap) => chatbotData = docSnap.data());

        String randomId = generateRandomString(10);
        String initSender = 'Gemini AI';
        String initDialog = getOneRandomString(firebaseAiGreeting);
        ChatbotConversation newConversation = ChatbotConversation(
          conversationId: randomId,
          messages: [
            ChatbotMessage(sender: initSender, dialog: initDialog, createdAt: DateTime.now().toString()),
          ]
        );

        ChatbotData updatedChatbotData;
        if ((chatbotData != null) && chatbotData!.conversations != null) {
          updatedChatbotData = ChatbotData(conversations: [...chatbotData!.conversations!, newConversation]);
        } else {
          updatedChatbotData = ChatbotData(conversations: [newConversation]);
        }

        ChatbotMetadata chatbotMetadata = ChatbotMetadata(lastChatbotConversationId: randomId);
        await _db.collection(metadataCollection).doc(UserProvider.read(context).user?.email ?? '').set(chatbotMetadata.toJson(), SetOptions(merge: true));
        await _db.collection(mainCollection).doc(UserProvider.read(context).user?.email ?? '').set(updatedChatbotData.toJson(), SetOptions(merge: true));

        clog('Percakapan baru berhasil ditambahkan pada Firestore');
        return (updatedChatbotData, updatedChatbotData.conversations);
      }
      clog('Data pengguna kosong! Tidak dapat menambahkan percakapan ke dalam Firestore');
      return null;
    } catch (e, s){
      clog('Tidak dapat mengeksekusi fungsi addNewConversation pada FirestoreChatbot.\n$e\n$s');
      await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      return null;
    }
  }

  static Future<(ChatbotData?, ChatbotConversation)?> getConversation({required BuildContext context, required ChatbotData chatbotData, required String conversationId}) async {
    try {
      if (UserProvider.read(context).user != null){
        if (chatbotData.conversations != null) return (chatbotData, chatbotData.conversations!.firstWhere((conv) => conv.conversationId == conversationId));
      }
      clog('Terjadi masalah, percakapan tidak ditemukan pada Firestore!');
      return null;
    } catch (e, s){
      clog('Tidak dapat mengeksekusi fungsi addChat pada FirestoreChatbot.\n$e\n$s');
      await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      return null;
    }
  }

  static Future<ChatbotData?> addChat({required BuildContext context, required String conversationId, required String sender, required String dialog}) async {
    try {
      if (UserProvider.read(context).user != null){
        ChatbotData? chatbotData;
        final ref = _db.collection(mainCollection).doc(UserProvider.read(context).user?.email ?? '')
            .withConverter(fromFirestore: ChatbotData.fromFirestore, toFirestore: (ChatbotData chatbotData, _) => chatbotData.toJson());
        await ref.get().then((docSnap) => chatbotData = docSnap.data());
        if ((chatbotData != null) && chatbotData!.conversations != null) {
          int conversationIndex = chatbotData!.conversations!.indexWhere((conv) => conv.conversationId == conversationId);
          if (conversationIndex != -1){
            chatbotData!.conversations![conversationIndex].messages!.add(ChatbotMessage(
              sender: sender,
              dialog: dialog,
              createdAt: DateTime.now().toString(),
            ));
            await _db.collection(mainCollection).doc(UserProvider.read(context).user?.email ?? '').set(chatbotData!.toJson(), SetOptions(merge: false));
            return chatbotData;
          }
        }
      }
      clog('Terjadi masalah, percakapan tidak ditemukan pada Firestore!');
      return null;
    } catch (e, s){
      clog('Tidak dapat mengeksekusi fungsi addChat pada FirestoreChatbot.\n$e\n$s');
      await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      return null;
    }
  }
}