// import 'package:flutter/foundation.dart';
// import 'package:flutter_application_1/dto/chat_dto.dart';
// import 'package:flutter_application_1/dto/message_dto.dart';

// class ChatProvider with ChangeNotifier {
//   List<ChatDTO> _chatRecords = [];

//   List<ChatDTO> get chatRecords => _chatRecords;

//   void setChats(List<ChatDTO> chats) {
//     _chatRecords = chats;
//     notifyListeners();
//   }

//   void addChat(ChatDTO chat) {
//     _chatRecords.add(chat);
//     notifyListeners();
//   }

//   void updateMessages(String chatId, List<MessageDTO> newMessages) {
//     final index = _chatRecords.indexWhere((chat) => chat.id.toString() == chatId);
//     if (index != -1) {
//       final oldChat = _chatRecords[index];
//       final updatedChat = ChatDTO(
//         id: oldChat.id,
//         userId: oldChat.userId,
//         counselorType: oldChat.counselorType,
//         stamp: oldChat.stamp,
//         timestamp: oldChat.timestamp,
//         messages: newMessages,
//       );
//       _chatRecords[index] = updatedChat;
//       notifyListeners();
//     }
//   }

//   void deleteChatsByUserId(String userId) {
//     _chatRecords.removeWhere((chat) => chat.userId == userId);
//     notifyListeners();
//   }

//   void clear() {
//     _chatRecords = [];
//     notifyListeners();
//   }
// }