import 'message_dto.dart';

class ChatDTO {
  final int? id;
  final String userId;
  final String counselorType;
  final String stamp;
  final DateTime timestamp;
  final List<MessageDTO> messages;

  ChatDTO({
    this.id,
    required this.userId,
    required this.counselorType,
    required this.stamp,
    DateTime? timestamp,
    required this.messages,
  }) : timestamp = timestamp ?? DateTime.now();

  factory ChatDTO.fromJson(Map<String, dynamic> json) => ChatDTO(
        id: json['id'],
        userId: json['userId'],
        counselorType: json['counselorType'],
        stamp: json['stamp'],
        timestamp: DateTime.parse(json['timestamp']),
        messages: (json['messages'] as List)
            .map((m) => MessageDTO.fromJson(m))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'userId': userId,
        'counselorType': counselorType,
        'stamp': stamp,
        'timestamp': timestamp.toIso8601String(),
        'messages': messages.map((m) => m.toJson()).toList(),
      };
}