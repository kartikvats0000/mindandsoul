import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';


class ThemeProvider extends ChangeNotifier {


  List<dynamic> themesList = [];
  String baseurl = '';
  String id = '';
  String videoName = '';
  String videoUrl = '';
  Color themeColorA = Color(0xfffffff);
  Color themeColorB = Color(0xfffffff);
//  String themeColorC = '';
  Color textColor = Color(0xfffffff);

  addThemes(List<dynamic> list){
    themesList = list;
    notifyListeners();
  }


  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": videoName,
    "video": videoUrl,
    "baseColor1": themeColorA,
    "baseColor2": themeColorB,
   // "theme_color_c": themeColorC,
    "textColor": textColor,
  };

  String toEncodedJson() => json.encode({
    "_id": id,
    "title": videoName,
    "video": videoUrl,
    "baseColor1": themeColorA,
    "baseColor2": themeColorB,
    // "theme_color_c": themeColorC,
    "textColor": textColor,
  });


  updateBaseURL(String _url){
    baseurl = _url;
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