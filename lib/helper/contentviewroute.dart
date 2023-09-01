import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screen/ui/content/content_screens/audioContentPage.dart';
import '../screen/ui/content/content_screens/infoContentPage.dart';
import '../screen/ui/content/content_screens/textContentPage.dart';
import '../screen/ui/content/content_screens/videoContentPage.dart';

contentViewRoute(
    {required String type, required dynamic data, required BuildContext context, required String title}){
  if( type == 'Text'){
    Navigator.push(context, MaterialPageRoute(builder: (context) => TextContent(data: data,title: title,)));

  }
  if(type == 'Info'){
    /*Navigator.of(context).push(
        CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => InfoGraphic(data: data,title: title,)));*/
    Navigator.push(context, MaterialPageRoute(builder: (context) => InfoGraphic(data: data,title: title,)));
  }
  if(type == 'Video'){
    Navigator.of(context).push(
        CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => VideoContent(data: data,title: title,)));
  }
  if(type == 'Audio'){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AudioContent(data: data,title: title,)));
  }
}

