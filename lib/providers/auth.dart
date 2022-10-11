import 'dart:convert';
import 'dart:async'; // helps us in running code asynchronously and feature of timer.
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer authTimer;
  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=<API_KEY>';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      autologout();
      notifyListeners();
      //Now when the user is logged in successfully. we need to save data on device using shared preference. This is how we do it:
      final pref = await SharedPreferences.getInstance(); // This is a asynchronous method that fetches device storage.
      final userData = json.encode({
        'expiryDate': _expiryDate.toIso8601String(),
        'userId': _userId,
        'token': _token
      });
      pref.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
//Now we need  method to check if we have data stored in our Local device storage through Shared perferences. So:
  Future<bool> tryAutoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if(!pref.containsKey('userData')){
      return false;
    }
    final extractedUserData = json.decode(pref.getString('userData')) as Map<String,Object>;
    final expirydate = DateTime.parse(extractedUserData['expiryDate']);
    if(expirydate.isBefore(DateTime.now())){
      return false;
    }
    //else everything is fine and we need to save the variables _expiryDate, _userId and _token with values populated in Shared Preferences

    _expiryDate = expirydate;
    _userId = extractedUserData['userId'];
    _token = extractedUserData['token'];
    autologout();
    notifyListeners();
    return true;

  }


  Future<void> logout() async {
    _userId = null;
    _token = null;
    _expiryDate = null;
    if (authTimer != null) {
      authTimer.cancel();
      authTimer = null;
    }
    notifyListeners();
    //Now if we logout till this when we do not delete the storage of Shared preferences, we must get authScreen as a result of
    //opening the app. But as the shared preference is not deleted, tryAutoLogin method is called again and we directly get into the app.
    //This is not as desired. That is why we need to delete the storage of shared prefereces.
    final pref = await SharedPreferences.getInstance();
    //perf.remove('userData');
    pref.clear();
  }

  void autologout() {
    if (authTimer != null) {
      authTimer.cancel();
    }
    var timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
