import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _timer;
  bool get IsAuth {
    return token == null;
  }

  String get token {
    if (_token != null &&
        _userId != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }

    return null;
  }

  String get userId {
    if (_token != null &&
        _userId != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _userId;
    }

    return null;
  }

  void SignUp(String email, String passWord) async {
    await General(email, passWord, "signUp");
  }

  void LogIn(String email, String passWord) async {
    await General(email, passWord, "signInWithPassword");
    autoLogOut();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      "token": _token,
      "expiryDate": _expiryDate.toIso8601String(),
      "userId": _userId,
    });
    prefs.setString("userData", userData);
  }

  Future<bool> tryAutoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString("userData")) as Map<String, Object>;
    final expiryData = DateTime.parse(extractedData["expiryDate"]);
    if (expiryData.isBefore(DateTime.now())) {
      return false;
    }
    _expiryDate = expiryData;
    _token = extractedData["token"];
    _userId = extractedData["userId"];
    print("Hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    autoLogOut();
    notifyListeners();
    return true;
  }

  void General(String email, String passWord, String Str) async {
    var url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:${Str}?key=AIzaSyAAQ22LAjVTUZUMXz9y95iCVKBVzuzXUoM");
    var respond = await http.post(url,
        body: json.encode({
          "email": email,
          "password": passWord,
          "returnSecureToken": true,
        }));

    print(json.decode(respond.body));

    if ((json.decode(respond.body) as Map)["error"] != null) {
      print("json.decode(respond.body) as Map)[error]");
      print((json.decode(respond.body) as Map)["error"]);
      throw (json.decode(respond.body) as Map)["error"]["message"];
    }
    _token = ((json.decode(respond.body) as Map))["idToken"];
    _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse((json.decode(respond.body) as Map)["expiresIn"])));
    _userId = (json.decode(respond.body) as Map)["localId"];
    notifyListeners();
    print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
    print(_expiryDate.isBefore(DateTime.now()));
    print(_expiryDate);
  }

  void logout() async {
    _expiryDate = null;
    _token = null;
    _userId = null;
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");
    notifyListeners();
  }

  void autoLogOut() {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(
        Duration(seconds: _expiryDate.difference(DateTime.now()).inSeconds),
        logout);
  }
}
