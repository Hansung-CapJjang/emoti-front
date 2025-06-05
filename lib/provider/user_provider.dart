import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/dto/user_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserProvider with ChangeNotifier {
  String _id = "";
  String _nickname = "";
  String _gender = "";
  List<String> _concerns = [];
  String _pet = "";
  int _level = 0;
  List<String> _stamp = [];

  // Getter
  String get id => _id;
  String get nickname => _nickname;
  String get gender => _gender;
  List<String> get concerns => _concerns;
  String get pet => _pet;
  int get level => _level;
  List<String> get stamp => _stamp;

  // Setter
  void setId(String id) {
    _id = id;
    notifyListeners();
  }

  void setNickname(String nickname) {
    _nickname = nickname;
    notifyListeners();
  }

  void setGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  void setConcerns(List<String> concerns) {
    _concerns = concerns;

    // 초기화
    _pet = Random().nextBool() ? "baebse" : "penguin";
    _level = 1;
    _stamp = [];

    notifyListeners();
  }

  void clear() {
    _id = "";
    _nickname = "";
    _gender = "";
    _concerns = [];
    _pet = "";
    _level = 0;
    _stamp = [];
  }

  void updateNickname(String newNickname) {
    _nickname = newNickname;
    notifyListeners();
  }

  void updateConcerns(List<String> newConcerns) {
    _concerns = newConcerns;
    notifyListeners();
  }

  void updateLevel(int newLevel) {
    _level = newLevel;
    notifyListeners();
  }

  void addStamp(String newStamp) {
    _stamp.add(newStamp);
    notifyListeners();
  }

  void updateStamp(List<String> newStamp) {
  _stamp = newStamp;
  notifyListeners();
}
  void updatePet(String newPet) {
  _pet = newPet;
  notifyListeners();
}


  void loadFromDTO(UserDTO dto) {
    _id = dto.id;
    _nickname = dto.nickname ?? "";
    _gender = dto.gender ?? "";
    _pet = dto.pet ?? "";
    _level = dto.level ?? 0;
    _concerns = dto.concerns ?? [];
    _stamp = dto.stamp ?? [];
    notifyListeners();
  }

  UserDTO toDTO() {
    return UserDTO(
      id: _id,
      nickname: _nickname.isEmpty ? null : _nickname,
      gender: _gender.isEmpty ? null : _gender,
      pet: _pet.isEmpty ? null : _pet,
      level: _level,
      concerns: _concerns.isEmpty ? null : _concerns,
      stamp: _stamp.isEmpty ? null : _stamp,
    );
  }

  void loadFromMap(Map<String, dynamic> data) {
    _id = data['id'] ?? "";
    _nickname = data['nickname'] ?? "";
    _gender = data['gender'] ?? "";
    _concerns = List<String>.from(data['concerns'] ?? []);
    _pet = data['pet'] ?? "";
    _level = data['level'] ?? 0;
    _stamp = List<String>.from(data['stamp'] ?? []);

    notifyListeners();
  }
  void updateGender(String gender) {
  _gender = gender;
  notifyListeners();
}

Future<void> loadUserData() async {
  final prefs = await SharedPreferences.getInstance();
  _id = prefs.getString('userId') ?? '';
  _pet = prefs.getString('pet') ?? 'Egg';
  _level = prefs.getInt('level') ?? 1;
  _stamp = prefs.getStringList('stamp') ?? [];
  notifyListeners();
}

Future<void> saveUserData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', _id);
  await prefs.setString('pet', _pet);
  await prefs.setInt('level', _level);
  await prefs.setStringList('stamp', _stamp);
}


}

