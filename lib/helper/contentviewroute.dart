import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screen/ui/content/content_screens/audioContentPage.dart';
import '../screen/ui/content/content_screens/infoContentPage.dart';
import '../screen/ui/content/content_screens/textContentPage.dart';
import '../screen/ui/content/content_screens/videoContentPage.dart';

Future<void> contentViewRoute(
    {required String type, required String id, required BuildContext context, VoidCallback? then}) async {


  if( type == 'Text'){
    Navigator.push(context, MaterialPageRoute(builder: (context) => TextContent(id: id))).whenComplete((then != null)?then:(){});
  }
  if(type == 'Info'){

    Navigator.push(context, MaterialPageRoute(builder: (context) => InfoGraphic(id: id))).whenComplete((then != null)?then:(){});
  }
  if(type == 'Video'){
    Navigator.of(context).push(
        CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => VideoContent(id: id,))).whenComplete((then != null)?then:(){});
  }
  if(type == 'Audio'){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AudioContent(id:id))).whenComplete((then != null)?then:(){});
  }


}

