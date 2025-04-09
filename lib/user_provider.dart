import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _nickname = "";
  String _email = "bob_the_builder@example.com";
  String _gender = "";
  List _concerns = [];

  String get nickname => _nickname;
  String get email => _email;
  String get gender => _gender;
  List get concerns => _concerns;

  void setUser(String newNickname, String newEmail, String newGender, List newConcerns) {
    _nickname = newNickname;
    _email = newEmail;
    _gender = newGender;
    _concerns = newConcerns;
    notifyListeners(); // UI 업데이트
  }

  void updateNickname(String newNickname) {
    _nickname = newNickname;
    notifyListeners(); // UI 업데이트
  }

  void updateGender(String newGender) {
    _gender = newGender;
    notifyListeners(); // UI 업데이트
  }

  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners(); // UI 업데이트
  }

  void updateConcerns(List newConcerns) {
    _concerns = newConcerns;
    notifyListeners(); // UI 업데이트
  }
}