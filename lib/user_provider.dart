import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class UserProvider with ChangeNotifier {
  String _nickname = "";
  String _email = "alice123@example.com";
  String _gender = "";
  List _concerns = [];
  String _pet = "Egg"; 
  String get pet => _pet;

  int _level = 1;
  List<String> _stamp = [];

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

  // 오늘 도장을 받은 적 있는지 확인
  bool hasReceivedStampToday() {
  final today = DateTime.now();
  return _stamp.any((s) {
    final parts = s.split('|');
    if (parts.length != 2) return false;
    return parts[0] == '${today.year}-${today.month}-${today.day}';
  });
}

void updateStamp(List<String> newStampList) {
  _stamp = newStampList;
  notifyListeners();
}

// 날짜 포함해서 도장 추가 (하루 1회 제한용)
void addTodayStamp(String stampValue) {
  final today = DateTime.now();
  final stampEntry = '${today.year}-${today.month}-${today.day}|$stampValue';
  _stamp.add(stampEntry);
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

  // 단순 도장 추가 - 필요없으면 지울 것
  void addStamp(String newStamp) {
    _stamp.add(newStamp);
    notifyListeners();
  }

  void updatePet(String newPet) {
  _pet = newPet;
  notifyListeners();
}

  // JSON 저장
  Future<void> saveUserData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/user_data.json');

      String jsonString;
      if (await file.exists()) {
        jsonString = await file.readAsString();
      } else {
        jsonString = await rootBundle.loadString('assets/data/user_data.json');
      }

      List<dynamic> jsonData = json.decode(jsonString);

      final userIndex = jsonData.indexWhere((u) => u['email'] == _email);

      if (userIndex != -1) {
        jsonData[userIndex]['nickname'] = _nickname;
        jsonData[userIndex]['gender'] = _gender;
        jsonData[userIndex]['concerns'] = _concerns;
        jsonData[userIndex]['level'] = _level;
        jsonData[userIndex]['stamp'] = _stamp;
      } else {
        jsonData.add({
          'email': _email,
          'nickname': _nickname,
          'gender': _gender,
          'concerns': _concerns,
          'level': _level,
          'stamp': _stamp,
        });
      }

      await file.writeAsString(json.encode(jsonData));
    } catch (e) {
      if (kDebugMode) {
        print('❗ saveUserData 에러: $e');
      }
    }
  }
  
  Future<void> loadUserData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/user_data.json');

      String jsonString;
      if (await file.exists()) {
        jsonString = await file.readAsString();
      } else {
        jsonString = await rootBundle.loadString('assets/data/user_data.json');
      }

      List<dynamic> jsonData = json.decode(jsonString);

      final user = jsonData.cast<Map<String, dynamic>>().firstWhere(
        (u) => u['email'] == _email,
        orElse: () => {},
      );

      if (user.isNotEmpty) {
        _nickname = user['nickname'] ?? "";
        _gender = user['gender'] ?? "";
        _concerns = user['concerns'] ?? [];
        _level = user['level'] ?? 1;
        _stamp = List<String>.from(user['stamp'] ?? []);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('❗ loadUserData 에러: $e');
      }
    }
  }
}