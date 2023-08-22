import 'dart:convert';

import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier{

  String id = '';
  bool isLogged = false;
  String name = '';
  String email = '';
  String profilePicture = '';
  String token = '';
  String deviceId='';
  String fcmToken = '';

  updateUserData(String _id,String _name, String _email, String _profilePicture, String _token){
    id = _id;
    name = _name;
    email = _email;
    profilePicture = _profilePicture;
    token = _token;
  }


  updateLoginStatus(bool loginStatus){
    isLogged = loginStatus;
    notifyListeners();
  }

  fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    name =  json["name"];
    email =  json["email"];
    token =  json["token"];
    profilePicture =  json["profile_picture"];
    notifyListeners();
  }

  String toEncodedJson() => json.encode({
      "_id": id,
      "name": name,
      "email": email,
      "token": token,
      "profile_picture": profilePicture,
      }
  );

  updateSplashData(String _deviceId, String _fcmToken){
    deviceId = _deviceId;
    fcmToken = _fcmToken;
    notifyListeners();
  }

  clear(){
    id = '';
    name = '';
    email = '';
    profilePicture = '';
    token = '';
    notifyListeners();
  }

}