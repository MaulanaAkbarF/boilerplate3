import 'package:cloud_firestore/cloud_firestore.dart';

class ChatbotData {
  final List<ChatbotConversation>? conversations;

  ChatbotData({
    this.conversations,
  });

  factory ChatbotData.fromJson(Map<String, dynamic> json) {
    return ChatbotData(conversations: json['conversations'] != null ? (json['conversations'] as List).map((item) => ChatbotConversation.fromJson(item)).toList() : null);
  }

  factory ChatbotData.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    if (data == null) return ChatbotData(conversations: null);
    return ChatbotData.fromJson(data);
  }

  Map<String, dynamic> toJson() {
    return {
      if (conversations != null) 'conversations': conversations!.map((item) => item.toJson()).toList(),
    };
  }
}

class ChatbotMetadata {
  final String? lastChatbotConversationId;

  ChatbotMetadata({this.lastChatbotConversationId});

  factory ChatbotMetadata.fromJson(Map<String, dynamic> json) {
    return ChatbotMetadata(lastChatbotConversationId: json['last_conversation_id']);
  }

  Map<String, dynamic> toJson() {
    return {
      if (lastChatbotConversationId != null) 'last_conversation_id': lastChatbotConversationId,
    };
  }
}

class ChatbotConversation {
  final String conversationId;
  final List<ChatbotMessage>? messages;

  ChatbotConversation({required this.conversationId, this.messages});

  factory ChatbotConversation.fromJson(Map<String, dynamic> json) {
    return ChatbotConversation(conversationId: json['conversationId'],
        messages: json['messages'] != null ? (json['messages'] as List).map((item) => ChatbotMessage.fromJson(item)).toList() : null);
  }

  factory ChatbotConversation.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    if (data == null) return ChatbotConversation(conversationId: '', messages: []);
    return ChatbotConversation.fromJson(data);
  }

  Map<String, dynamic> toJson() {
    return {
      "conversationId": conversationId,
      if (messages != null) 'messages': messages!.map((item) => item.toJson()).toList(),
    };
  }
}

class ChatbotMessage {
  final String? sender;
  final String? dialog;
  final String? createdAt;

  ChatbotMessage({
    this.sender,
    this.dialog,
    this.createdAt,
  });

  factory ChatbotMessage.fromJson(Map<String, dynamic> json) {
    return ChatbotMessage(
      sender: json['sender'],
      dialog: json['dialog'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (sender != null) 'sender': sender,
      if (dialog != null) 'dialog': dialog,
      if (createdAt != null) 'created_at': createdAt,
    };
  }
}