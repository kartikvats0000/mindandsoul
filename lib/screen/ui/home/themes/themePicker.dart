
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:provider/provider.dart';

import '../../../../provider/themeProvider.dart';
import 'Themepreview.dart';

class ThemePicker extends StatefulWidget {
  const ThemePicker({Key? key}) : super(key: key);

  @override
  State<ThemePicker> createState() => _ThemePickerState();
}

class _ThemePickerState extends State<ThemePicker> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,themeData,child) =>
       Scaffold(
         backgroundColor: themeData.themeColorA,
        //extendBody: true,
        //extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text('Essence',style: TextStyle(color: themeData.textColor),),
          leading: Padding(
              padding: EdgeInsets.all(7),
              child: Components(context).BlurBackgroundCircularButton(
                icon: Icons.close,
                onTap: (){Navigator.pop(context);},
              )
          ),

        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: themeData.themeColorA,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    themeData.themeColorA.withOpacity(0.2),
                    themeData.themeColorB,
                    themeData.themeColorA,
                  ]
              )
          ),
          child: RefreshIndicator(
            onRefresh: ()async{},
            child: GridView.builder(
            physics: const BouncingScrollPhysics(
              // parent: AlwaysScrollableScrollPhysics()
            ),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1/1.25,
                crossAxisSpacing: 15,
                mainAxisSpacing: 0,
               // mainAxisExtent: 220
            ),
            itemCount: themeData.themesList.length,
            itemBuilder: (context,index) =>
                InkWell(
                  onTap: (){
                    HapticFeedback.selectionClick();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ThemePreview(themeDetails: themeData.themesList[index])));
                  },
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            height: 180,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: CachedNetworkImage(
                                placeholder: (context,string)=> Container(
                                    padding: const EdgeInsets.all(30),
                                    alignment: Alignment.center,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 1,
                                    )),
                                imageUrl: themeData.themesList[index]['image'],fit: BoxFit.cover,),
                            ),

                          ),
                          Visibility(
                            visible: themeData.videoUrl == themeData.themesList[index]['video'],
                            child: Positioned(
                                top: 5,
                                right: 5,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 15,sigmaY: 15),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black.withOpacity(0.2),
                                      radius: 16,
                                      child: Icon(Icons.check,color: Colors.white,),
                                    ),
                                  ),
                                )
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 8,),

                      Text(themeData.themesList[index]['title'],style: TextStyle(color: themeData.textColor,fontWeight: FontWeight.w700),)
                    ],
                  ),
                ),
            ),
          )
        ),
      ),
    );
  }
}
