import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/provider/playerProvider.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:provider/provider.dart';

import '../../../constants/iconconstants.dart';
import '../../../helper/miniplayer.dart';
import '../../../services/services.dart';

class Wellness extends StatefulWidget {

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

  List data = [
    /*{
      'title' : 'Galaxy',
      'audio' : 'https://www.rajmith.com/img/galaxy.mp3',
      'gif' : 'https://www.rajmith.com/img/galaxy.gif',
      'image' : 'https://www.rajmith.com/img/galaxy.jpg'
    },
    {
      'title' : 'Cassatte',
      'audio' : 'https://www.rajmith.com/img/cassatte.mp3',
      'gif' : 'https://www.rajmith.com/img/cassatte.gif',
      'image' : 'https://www.rajmith.com/img/cassatte.jpg'
    },
    {
      'title' : 'Glass',
      'audio' : 'https://www.rajmith.com/img/glass.mp3',
      'gif' : 'https://www.rajmith.com/img/glass.gif',
      'image' : 'https://www.rajmith.com/img/glass.jpg'
    },
    {
      'title' : 'Window',
      'audio' : 'https://www.rajmith.com/img/window.mp3',
      'gif' : 'https://www.rajmith.com/img/window.gif',
      'image' : 'https://www.rajmith.com/img/window.jpg'
    }*/
  ];


  List<Track> tracks = [];
  /*
  @override
  void initState() {
    // TODO: implement initState
    tracks = List.generate(widget.data.length, (index) => Track(title: widget.data[index]['title'], thumbnail: widget.data[index]['image'], audioUrl: widget.data[index]['title']))
    super.initState();
  }*/


   getWellness()async{
    final lst = await Services().getWellnessContent();
    setState(() {
      data = lst;
      print(data);
    });
  }

  showOptionSheet(ThemeProvider theme){
     showModalBottomSheet(
       //showDragHandle: true,
         backgroundColor: Theme.of(context).colorScheme.surfaceTint,
         context: context, builder: (context)=>
         Container(
           padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 15),
           child: Wrap(
             children: [
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const SizedBox(height: 10,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text('Options',style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 20,color: Theme.of(context).colorScheme.onPrimary),),
                       Components(context).BlurBackgroundCircularButton(buttonRadius: 15,icon: Icons.clear)
                     ],
                   ),
                   const SizedBox(height: 15,),
                   Container(
                     decoration: BoxDecoration(
                       color: Colors.white24,
                       borderRadius: BorderRadius.circular(15)
                     ),
                     child: Column(
                       children: [
                         ListTile(
                           leading: Components(context).myIconWidget(icon: MyIcons.favorite,color: theme.textColor),
                           title: Text('Add to Favourites',style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),),
                         ),
                         Divider(indent: 20,endIndent: 20,thickness: 0.3,color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),),
                         ListTile(
                           leading: Components(context).myIconWidget(icon: MyIcons.download,color: theme.textColor),
                           title: Text('Download',style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14)),
                         ),
                       ],
                     ),
                   )
                 ],
               )
             ],
           ),
         )
     );
  }

  @override
  void initState() {
    // TODO: implement initState
    getWellness();
    super.initState();
  }

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
              title: Text('Wellness',style: Theme.of(context).textTheme.displayLarge?.copyWith(color: theme.textColor,fontSize: 30),),
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
                (data.isEmpty)?Components(context).Loader(textColor: theme.textColor):ListView.separated(
                shrinkWrap: true,
                itemCount: data.length,
                separatorBuilder: (context,index) =>  Divider(indent: 20,endIndent: 20,thickness: 0.65,color: theme.textColor.withOpacity(0.2),),
                itemBuilder: (context,index){
                  tracks = List.generate(data.length, (i) => Track(title: data[i]['title'], thumbnail: data[i]['image'], audioUrl: data[i]['audio'],gif: data[index]['anim'] ));
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
                                  if(player.currentTrack != null && data[index]['image'] == player.currentTrack?.thumbnail){
                                    if(mounted){
                                      Components(context).showPlayerSheet();
                                    }
                                  }else{
                                    player.play(Track(gif: data[index]['anim'],title: data[index]['title'], thumbnail: data[index]['image'], audioUrl: data[index]['audio']));
                                    if(player.duration.inSeconds.isNaN == false){
                                      Components(context).showPlayerSheet();
                                    }
                                    else{
                                      print('please wait!');
                                    }
                                  }

                                },
                                onLongPress: (){
                                  HapticFeedback.lightImpact();
                                  showOptionSheet(theme);
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
                                                    child: CachedNetworkImage(imageUrl: data[index]['image'],fit: BoxFit.cover,placeholder: (context,url) => Center(
                                                      child: Container(
                                                          margin: EdgeInsets.all(20),
                                                          height: 60,
                                                          width: 60,
                                                          child: SpinKitSpinningLines(color: Theme.of(context).colorScheme.primary,)),
                                                    ),)
                                                ),
                                              ),
                                              Visibility(
                                                visible: (player.currentTrack != null && data[index]['image'] == player.currentTrack?.thumbnail),
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
                                                Text(data[index]['title'],style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16,fontWeight: FontWeight.bold),),
                                                const SizedBox(height: 10,),
                                                /*Wrap(
                                                    children:
                                                    taglist.map((e) => Text(
                                                      '$e • ' ,
                                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 11,
                                                          //letterSpacing: 1.3,
                                                          color: theme.textColor.withOpacity(0.6)
                                                      ),)).toList()

                                                )*/
                                                _buildhms(data[index]['duration'])
                                              ],
                                            ),
                                          )),
                                      Expanded(
                                          child: IconButton(onPressed: (){
                                            HapticFeedback.lightImpact();
                                            showOptionSheet(theme);
                                          },icon: const Icon(CupertinoIcons.ellipsis),color: theme.textColor.withOpacity(0.6),)
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
  _buildhms(Map obj){
     ThemeProvider theme = Provider.of<ThemeProvider>(context,listen:false);
    TextStyle textStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 11,
        //letterSpacing: 1.3,
        color: theme.textColor.withOpacity(0.6)
    );
    
    var min = obj['minute'] <= 1?'minute':'minutes'; 
    var hr = obj['hour'] <= 1?'hour':'hours'; 
    var sec = obj['second'] <= 1?'second':'seconds'; 
    if(obj['hour']<1){
      return Text('${obj['minute']} $min ${obj['second']} $sec',style: textStyle,);
    }
    if(obj['minute']<1){
      return Text('${obj['second']} $sec',style: textStyle,);
    }
    else{
      return Text('${obj['hour']} $hr ${obj['minute']} $min ${obj['second']} $sec',style: textStyle,);
    }
  }
}




