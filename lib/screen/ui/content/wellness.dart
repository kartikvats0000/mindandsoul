import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/provider/playerProvider.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:provider/provider.dart';

import '../../../helper/miniplayer.dart';

class Wellness extends StatefulWidget {
  final String title;
  final List data;
   Wellness({required this.title,required this.data});

  @override
  State<Wellness> createState() => _WellnessState();
}

class _WellnessState extends State<Wellness> {

  List taglist = [
    'Mindfulness',
    'Spiritual',
    'Sleep',
    'Meditation',
    'Study',

  ];


  List<Track> tracks = [];
  /*
  @override
  void initState() {
    // TODO: implement initState
    tracks = List.generate(widget.data.length, (index) => Track(title: widget.data[index]['title'], thumbnail: widget.data[index]['image'], audioUrl: widget.data[index]['title']))
    super.initState();
  }*/

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
              scrolledUnderElevation: 0.0,
              automaticallyImplyLeading: false,
              leading: Padding(
                padding: EdgeInsets.all(7),
                child: Components(context).BlurBackgroundCircularButton(icon: Icons.chevron_left,onTap: ()=>Navigator.pop(context)),
              ),
              title: Text(widget.title,style: Theme.of(context).textTheme.displayLarge?.copyWith(color: theme.textColor,fontSize: 30),),
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

            child: Stack(
              children: [
                ListView.separated(
                    shrinkWrap: true,
                    itemCount: widget.data.length,
                    separatorBuilder: (context,index) =>  Divider(indent: 20,endIndent: 20,thickness: 0.65,color: theme.textColor.withOpacity(0.2),),
                    itemBuilder: (context,index){
                      tracks = List.generate(widget.data.length, (i) => Track(title: widget.data[i]['title'], thumbnail: widget.data[i]['image'], audioUrl: 'https://eeasy.s3.ap-south-1.amazonaws.com/balaji/story/1690630201180.mp3' ));
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 3.5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                            child: Consumer<MusicPlayerProvider>(
                              builder: (context,player,child) =>
                              GestureDetector(
                                onTap: (){
                                   player.play(Track(title: widget.data[index]['title'], thumbnail: widget.data[index]['image'], audioUrl: widget.data[index]['audio']));
                                   Timer(const Duration(milliseconds: 1000),(){
                                     Components(context).showPlayerSheet();
                                   });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                   // color: Colors.black12,
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  padding: const EdgeInsets.only(bottom: 5),
                                 // height: MediaQuery.of(context).size.height * 0.15,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                              child: Stack(
                                                children: [
                                                  AspectRatio(
                                                    aspectRatio: 1,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(20),
                                                        child: CachedNetworkImage(imageUrl: widget.data[index]['image'],fit: BoxFit.cover,)
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: (player.currentTrack != null && widget.data[index]['image'] == player.currentTrack?.thumbnail),
                                                    child: Positioned(
                                                      top: 22,
                                                      right: 22,
                                                      left: 22,
                                                      bottom: 22,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(50),
                                                        child: BackdropFilter(
                                                          filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                                                          child: const CircleAvatar(
                                                            backgroundColor: Colors.black12,
                                                            child: Icon(Icons.volume_up_outlined,color: Colors.white70,),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                      Expanded(
                                        flex: 7,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                Text(widget.data[index]['title'],style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16,fontWeight: FontWeight.bold),),
                                                SizedBox(height: 10,),
                                                Wrap(
                                                  children:
                                                    taglist.map((e) => Text(
                                                      '$e • ' ,
                                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 11,
                                                          //letterSpacing: 1.3,
                                                          color: theme.textColor.withOpacity(0.6)
                                                      ),)).toList()

                                                )
                                              ],
                                            ),
                                          )),
                                      Expanded(
                                          child: Icon(CupertinoIcons.ellipsis,color: theme.textColor.withOpacity(0.6),)
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                ),
                const Positioned(
                  bottom: 10,
                    right: 0,
                    left: 0,
                    child: MiniPlayer()
                )
              ],
            ),
          ),
        )
    );
  }
}


