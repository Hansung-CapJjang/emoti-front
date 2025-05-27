class UserDTO {
  final String id;
  final String? nickname;
  final String? gender;
  final String? pet;
  final int? level;
  final List<String>? concerns;
  final List<String>? stamp;

  UserDTO({
    required this.id,
    this.nickname,
    this.gender,
    this.pet,
    this.level,
    this.concerns,
    this.stamp,
  });

  // JSON → UserDTO
  factory UserDTO.fromJson(Map<String, dynamic> json) => UserDTO(
        id: json['id'],
        nickname: json['nickname'],
        gender: json['gender'],
        pet: json['pet'],
        level: json['level'],
        concerns: (json['concerns'] as List?)?.map((e) => e.toString()).toList(),
        stamp: (json['stamp'] as List?)?.map((e) => e.toString()).toList(),
      );

  // UserDTO → JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        if (nickname != null) 'nickname': nickname,
        if (gender != null) 'gender': gender,
        if (pet != null) 'pet': pet,
        if (level != null) 'level': level,
        if (concerns != null) 'concerns': concerns,
        if (stamp != null) 'stamp': stamp,
      };
}