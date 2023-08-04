import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:provider/provider.dart';

class Wellness extends StatefulWidget {
  final List data;
   Wellness({required this.data});

  @override
  State<Wellness> createState() => _WellnessState();
}

class _WellnessState extends State<Wellness> {

  List taglist = [
    'Mindfulness',
    'Spiritual',
    'Sleep',
    'Meditation',
    'Concentration',
    'Study',
    'Work',

  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context,theme,child) => Scaffold(
          backgroundColor: theme.themeColorA,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight + 20),

            child: AppBar(
              toolbarHeight: kToolbarHeight + 20,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              automaticallyImplyLeading: false,
              leading: Padding(
                padding: EdgeInsets.all(7),
                child: Components(context).BlurBackgroundCircularButton(icon: Icons.chevron_left,onTap: ()=>Navigator.pop(context)),
              ),
              title: Text('Wellness',style: TextStyle(color: theme.textColor),),
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.themeColorA.withOpacity(0.2),
                      theme.themeColorB,
                    ]
                )
            ),

            child: ListView.builder(
               // physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.data.length,
                itemBuilder: (context,index){
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8,vertical: 6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                        child: Container(

                         // padding: EdgeInsets.only(top: 5,right: 5,bottom: 5),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(15)
                          ),
                         // margin: EdgeInsets.symmetric(horizontal: 8,vertical: 6),
                          padding: EdgeInsets.only(bottom: 4),
                          height: MediaQuery.of(context).size.height * 0.21,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                            child: CachedNetworkImage(imageUrl: widget.data[index]['image'],fit: BoxFit.cover,height: MediaQuery.of(context).size.height * 0.13,))),
                                    Expanded(
                                      flex: 7,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                              Text(widget.data[index]['title'],style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 17),),
                                              SizedBox(height: 10,),
                                              Expanded(child: Text(widget.data[index]['desc'],style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70,fontSize: 12),maxLines:2 ,overflow: TextOverflow.ellipsis,)),
                                              SizedBox(height: 5,),
                                              Text('17 min',style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),)
                                            ],
                                          ),
                                        )),
                                    Expanded(
                                      flex: 3,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.bookmark_add,color: Colors.white70,),
                                            Components(context).BlurBackgroundCircularButton(icon: Icons.play_arrow_rounded)
                                          ],
                                        )
                                    )
                                  ],
                                ),
                              ),
                              Container(
                               // height: 25,
                                child: Wrap(
                                  //spacing: 5,
                                  alignment: WrapAlignment.start,
                                  children: taglist.map((e) => tags(e, context)).toList(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
            ),
          ),
        )
    );
  }
}

Widget tags(String title,BuildContext context) => Container(
  //height: 25,
  padding: const EdgeInsets.all(3),
  margin: const EdgeInsets.all(1.5),
  decoration: BoxDecoration(
    border: Border.all(
      width: 0.65,
      color: Colors.white70,
    ),
    borderRadius: BorderRadius.circular(10)
  ),
  child: Text(title,style: Theme.of(context).textTheme.labelSmall,),
);
