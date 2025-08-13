import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constant_values/list_string_values.dart';
import '../../../models/features/chatbot_ai.dart';
import '../../../services/firebase/cloud_firestore/chatbot.dart';
import '../../../services/firebase/firebase_ai_logic.dart';
import '../../../utilities/functions/input_func.dart';
import '../auth/user_provider.dart';

class FirebaseAIProvider extends ChangeNotifier{
  final TextEditingController _tecConversation = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  ChatbotData? _chatbotData;
  List<ChatbotConversation> _listChatbotConversation = [];
  List<ChatbotMessage> _listChatbotMessage = [];
  String dialog = '';
  bool _conversationLoading = true;
  bool _chatLoading = false;

  TextEditingController get tecConversation => _tecConversation;
  ScrollController get scrollController => _scrollController;
  ChatbotData? get chatbotData => _chatbotData;
  List<ChatbotConversation> get listChatbotConversation => _listChatbotConversation;
  List<ChatbotMessage> get listChatbotMessage => _listChatbotMessage;
  bool get conversationLoading => _conversationLoading;
  bool get chatLoading => _chatLoading;

  /// Fungsi untuk mengisiasi data awal saat halaman Chatbot dimuat
  Future<void> init(BuildContext context) async {
    await FirestoreChatbot.initializeLastConversation(context: context).then((value) => value != null ? _chatbotData = value.$1 : null);
    if ((chatbotData != null) && chatbotData!.conversations != null){
      _listChatbotConversation = chatbotData!.conversations!;
      ChatbotConversation chatbotConversation = chatbotData!.conversations!.last;
      if (chatbotConversation.messages != null) {
        for (final index in chatbotConversation.messages!){
          _listChatbotMessage.add(index);
        }
      }
    }
    _conversationLoading = !_conversationLoading;
    notifyListeners();
  }

  /// Fungsi untuk mengisiasi data awal saat halaman Chatbot dimuat
  Future<void> addDialog(BuildContext context) async {
    String aiName = 'Gemini AI';
    dialog = _tecConversation.text; // menetapkan prompt/dialog terlebih dahulu sebelum menghapus teks pada TextField
    _tecConversation.clear();
    _listChatbotMessage.add(ChatbotMessage(sender: UserProvider.read(context).user?.name ?? '', dialog: dialog, createdAt: DateTime.now().toString()));
    if ((chatbotData != null) && chatbotData!.conversations != null){
      notifyListeners(); // Perbarui terlebih dahulu UI dengan prompt dari pengguna
      _chatLoading = !_chatLoading;
      await FirestoreChatbot.addChat(
          context: context,
          conversationId: chatbotData!.conversations!.last.conversationId,
          sender: UserProvider.read(context).user?.name ?? '',
          dialog: dialog
      ).then((value) async {
        _listChatbotMessage.add(ChatbotMessage(sender: aiName, dialog: getOneRandomString(firebaseAiProcessing), createdAt: DateTime.now().toString())); // Tampilkan loading dulu dari Gemini AI
        notifyListeners(); // Perbarui terlebih dahulu UI untuk menampilkan loading
        await askToFirebaseAI(dialog).then((value) async =>
        value != null
          ? _chatbotData = await FirestoreChatbot.addChat(
          context: context,
          conversationId: chatbotData!.conversations!.last.conversationId,
          sender: aiName,
          dialog: value.text ?? 'dialog error!')
          : null);
      });
      if ((chatbotData != null) && chatbotData!.conversations != null){
        ChatbotConversation chatbotConversation = chatbotData!.conversations!.last;
        if (chatbotConversation.messages != null) {
          _listChatbotMessage = chatbotConversation.messages!;
        };
      }

    }
    _chatLoading = !_chatLoading;
    notifyListeners();
  }

  /// Fungsi untuk mebuat percakapan baru
  Future<void> createNewConversation(BuildContext context) async {
    print('ConvLength: ${_listChatbotConversation.last.messages!.length}');
    // Cek dulu apakah percakapan terakhir ada prompt dari pengguna atau masih default response awal dari Gemini AI
    // Hal ini untuk mencegah pembuatan percakapan kosong
    if (_listChatbotConversation.last.messages!.length >= 2){
      // Jika percakapan terakhir ada prompt dari pengguna, buat percakapan baru
      _conversationLoading = !_conversationLoading;
      notifyListeners();
      await FirestoreChatbot.addNewConversation(context: context).then((value) => value != null ? _chatbotData = value.$1 : null);
      if ((chatbotData != null) && chatbotData!.conversations != null){
        _listChatbotConversation = chatbotData!.conversations!;
        ChatbotConversation chatbotConversation = chatbotData!.conversations!.last;
        if (chatbotConversation.messages != null) {
          _listChatbotMessage.clear();
          for (final index in chatbotConversation.messages!){
            _listChatbotMessage.add(index);
          }
        }
      }
      _conversationLoading = !_conversationLoading;
      notifyListeners();
    } else {
      // Jika percakapan terakhir tidak ada prompt dari pengguna, ambil percakapan terakhir yang dimana baru default response awal dari Gemini AI
      await getConversation(context, _listChatbotConversation.last.conversationId);
    }
  }

  /// Fungsi untuk mengambil data percakapan dari daftar
  Future<void> getConversation(BuildContext context, String conversationId) async {
    _conversationLoading = !_conversationLoading;
    notifyListeners();
    await FirestoreChatbot.getConversation(context: context, conversationId: conversationId, chatbotData: _chatbotData!).then((value){
      if (value != null){
        _chatbotData = value.$1;
        _listChatbotConversation = chatbotData!.conversations!;
        ChatbotConversation chatbotConversation = value.$2;
        if (chatbotConversation.messages != null) {
          _listChatbotMessage.clear();
          for (final index in chatbotConversation.messages!){
            _listChatbotMessage.add(index);
          }
        }
      }
    });
    _conversationLoading = !_conversationLoading;
    notifyListeners();
    scrollToTop();
  }

  /// Fungsi untuk membersihkan percakapan
  void clearConversation(){
    _listChatbotMessage.clear();
    _conversationLoading = !_conversationLoading;
    notifyListeners();
  }

  /// Fungsi untuk menggulir chat ke paling atas (sebagian besar digunakan setelah membuka obrolan lain)
  void scrollToTop() {
    if (scrollController.hasClients) scrollController.jumpTo(scrollController.position.minScrollExtent);
  }

  /// Fungsi untuk menggulir chat ke paling bawah
  void scrollToBottom() {
    if (scrollController.hasClients) scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  static FirebaseAIProvider read(BuildContext context) => context.read();
  static FirebaseAIProvider watch(BuildContext context) => context.watch();
}