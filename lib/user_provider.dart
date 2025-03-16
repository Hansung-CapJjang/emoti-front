import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _nickname = "";
  String _email = "";
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
    notifyListeners(); // UI ������Ʈ
  }

  void updateNickname(String newNickname) {
    _nickname = newNickname;
    notifyListeners(); // UI ������Ʈ
  }

  void updateGender(String newGender) {
    _gender = newGender;
    notifyListeners(); // UI ������Ʈ
  }

  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners(); // UI ������Ʈ
  }

  void updateConcerns(List newConcerns) {
    _concerns = newConcerns;
    notifyListeners(); // UI ������Ʈ
  }
}