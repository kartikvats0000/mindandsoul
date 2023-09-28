import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screen/ui/content/content_screens/audioContentPage.dart';
import '../screen/ui/content/content_screens/infoContentPage.dart';
import '../screen/ui/content/content_screens/textContentPage.dart';
import '../screen/ui/content/content_screens/videoContentPage.dart';

contentViewRoute(
    {required String type, required String id, required BuildContext context}){


  if( type == 'Text'){
    Navigator.push(context, MaterialPageRoute(builder: (context) => TextContent(id: id)));
  }
  if(type == 'Info'){

    Navigator.push(context, MaterialPageRoute(builder: (context) => InfoGraphic(id: id)));
  }
  if(type == 'Video'){
    Navigator.of(context).push(
        CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => VideoContent(id: id,)));
  }
  if(type == 'Audio'){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AudioContent(id:id)));
  }
}

