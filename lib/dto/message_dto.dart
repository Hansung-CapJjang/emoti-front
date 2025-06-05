class MessageDTO {
  final String text;
  final bool isUser;

  MessageDTO({required this.text, required this.isUser});

  factory MessageDTO.fromJson(Map<String, dynamic> json) => MessageDTO(
        text: json['text'],
        isUser: json['isUser'],
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
      };
}