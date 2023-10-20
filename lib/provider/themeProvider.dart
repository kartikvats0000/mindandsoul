import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';


class ThemeProvider extends ChangeNotifier {

  bool isScrolling = false;

  void changeScrollStatus(bool status){
    isScrolling = status;
    notifyListeners();
  }


  List<dynamic> themesList = [];
  String baseurl = '';
  String id = '';
  String videoName = '';
  String videoUrl = '';
  Color themeColorA = const Color(0x0fffffff);
  Color themeColorB = const Color(0x0fffffff);
//  String themeColorC = '';
  Color textColor = const Color(0x00000000);

  addThemes(List<dynamic> list){
    themesList = list;
    notifyListeners();
  }

  clearThemes(){
    themesList.clear();
    notifyListeners();
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": videoName,
    "video": videoUrl,
    "baseColor1": themeColorA,
    "baseColor2": themeColorB,
    "textColor": textColor,
  };

  String toEncodedJson() => json.encode({
    "_id": id,
    "title": videoName,
    "video": videoUrl,
    "baseColor1": themeColorA,
    "baseColor2": themeColorB,
    "textColor": textColor,
  });

  updateBaseURL(String newurl){
    baseurl = newurl;
    notifyListeners();
  }

   updateTheme(Map<String,dynamic> themeData) {
    id = themeData['_id'];
    videoName = themeData['title'];
    videoUrl = themeData['video'];
    themeColorA = Color(int.parse('0xff' + themeData['baseColor1']));
    themeColorB = Color(int.parse('0xff' + themeData['baseColor2']));
    //themeColorC = themeData['theme_color_c'];
    textColor = Color(int.parse('0xff' + themeData['textColor']));

    print('provider----$videoUrl');
    notifyListeners();
}

}