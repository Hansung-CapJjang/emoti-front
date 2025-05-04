import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  // --- Private 상태 변수들 ---
  String _nickname = "";
  String _email = "alice123@example.com";
  String _gender = "";
  List _concerns = [];

  int _level = 1; // 도장판 레벨
  List<String> _stamp = []; // 도장 리스트

  // --- Getter ---
  String get nickname => _nickname;
  String get email => _email;
  String get gender => _gender;
  List get concerns => _concerns;
  int get level => _level;
  List<String> get stamp => _stamp;

  // --- 전체 사용자 정보 설정 ---
  void setUser(String newNickname, String newEmail, String newGender, List newConcerns) {
    _nickname = newNickname;
    _email = newEmail;
    _gender = newGender;
    _concerns = newConcerns;
    notifyListeners();
  }

  // --- 개별 속성 업데이트 ---
  void updateNickname(String newNickname) {
    _nickname = newNickname;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  void updateGender(String newGender) {
    _gender = newGender;
    notifyListeners();
  }

  void updateConcerns(List newConcerns) {
    _concerns = newConcerns;
    notifyListeners();
  }

  void updateLevel(int newLevel) {
    _level = newLevel;
    notifyListeners();
  }

  void updateStamp(List<String> newStamp) {
    _stamp = newStamp;
    notifyListeners();
  }
}