import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:mindandsoul/services/services.dart';

class User extends ChangeNotifier{



  String id = '';
  bool isLogged = false;
  String name = '';
  String email = '';
  String profilePicture = '';
  String country = '';
  String token = '';
  String deviceId='';
  String fcmToken = '';
  String selectedLanguage = 'en';

  Map languages = {};

  getAllLanguages ()async{
    languages = await Services('').getLanguagesContent();
    log(languages.toString());
    notifyListeners();
  }

  changeUserLanguage(String code){
    selectedLanguage = code;
    notifyListeners();
  }

  updateUserData(String _id,String _name, String _email,String _country,String _profilePicture, String _token){
    id = _id;
    name = _name;
    email = _email;
    country = _country;
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
    country =  json["country"];
    token =  json["token"];
    profilePicture =  json["profile_picture"];
    notifyListeners();
  }

  String toEncodedJson() => json.encode({
      "_id": id,
      "name": name,
      "email": email,
      "country" : country,
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
    country = '';
    profilePicture = '';
    token = '';
    notifyListeners();
  }

}