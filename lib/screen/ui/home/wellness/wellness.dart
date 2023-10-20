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

import '../../../../constants/iconconstants.dart';
import '../../../../helper/miniplayer.dart';
import '../../../../provider/userProvider.dart';
import '../../../../services/services.dart';

class Wellness extends StatefulWidget {
  const Wellness({super.key});


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


   getWellness()async{
     User user = Provider.of<User>(context,listen: false);
    final lst = await Services(user.token).getWellnessContent();
    setState(() {
      data = lst;
      print(data);
    });
  }

  showOptionSheet(ThemeProvider theme, int index){
     User user  = Provider.of<User>(context,listen: false);
     showModalBottomSheet(
       //showDragHandle: true,
         backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
                       Text('Options',style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 20,color: Theme.of(context).colorScheme.onPrimaryContainer),),
                       Components(context).BlurBackgroundCircularButton(buttonRadius: 15,icon: Icons.clear)
                     ],
                   ),
                   const SizedBox(height: 15,),
                   Container(
                     decoration: BoxDecoration(
                       color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                       borderRadius: BorderRadius.circular(15)
                     ),
                     child: Column(
                       children: [
                         ListTile(
                           onTap: ()async{
                             String message = await Services(user.token).likeWellness(data[index]['_id']);
                             Navigator.pop(context);
                             getWellness();
                            // Components(context).showSuccessSnackBar(message);
                           },
                           leading: Components(context).BlurBackgroundCircularButton(
                             backgroundColor: Colors.white12,
                         svg: (data[index]['liked'])?MyIcons.favorite_filled : MyIcons.favorite,
                       iconColor: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.9)
                     ),
                           title: Text((data[index]['liked'])?'Remove from Favourites':'Add to Favourites',style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14,color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.9)),),
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
          appBar: Components(context).myAppBar('Wellness'),
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.themeColorA,
                          theme.themeColorB,
                        ]
                    )
                ),

                child: RefreshIndicator(
                  onRefresh: ()async{
                    await getWellness();
                  },
                  child: (data.isEmpty)? Components(context).Loader(textColor: theme.textColor): ListView.separated(
                  shrinkWrap: true,
                  padding: (Provider.of<MusicPlayerProvider>(context,listen: false).currentTrack != null)
                      ?const EdgeInsets.only(bottom: kToolbarHeight+25)
                      :EdgeInsets.zero,
                  itemCount: data.length,
                  separatorBuilder: (context,index) =>  Divider(indent: 20,endIndent: 20,thickness: 0.65,color: theme.textColor.withOpacity(0.2),),
                  itemBuilder: (context,index){
                    tracks = List.generate(data.length, (i) => Track(id:data[i]['title'],title: data[i]['title'], thumbnail: data[i]['image'], audioUrl: data[i]['audio'],gif: data[index]['anim'],liked: data[index]['liked'] ));
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 3.5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Consumer<MusicPlayerProvider>(
                          builder: (context,player,child) =>
                              GestureDetector(
                                onTap: (){
                                  if(player.currentTrack != null && data[index]['image'] == player.currentTrack?.thumbnail){
                                    if(mounted){
                                      showPlayerSheet(context);
                                    }
                                  }else{
                                    player.play(Track(id : data[index]['title'],gif: data[index]['anim'],title: data[index]['title'], thumbnail: data[index]['image'], audioUrl: data[index]['audio'],liked: data[index]['liked'] ));
                                    if(player.duration.inSeconds.isNaN == false){
                                      showPlayerSheet(context);
                                    }
                                    else{
                                      debugPrint('please wait!');
                                    }
                                  }

                                },
                                onLongPress: (){
                                  HapticFeedback.lightImpact();
                                  showOptionSheet(theme,index);
                                },
                                child: Container(
                                  //height: MediaQuery.of(context).size.height * 0.12,
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
                                        flex:3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Stack(
                                            children: [
                                              AspectRatio(
                                                aspectRatio: 1,
                                                //height: 70,
                                               // width: 70,
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(15),
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
                                                  top: 20,
                                                  right: 20,
                                                  left: 20,
                                                  bottom: 20,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(50),
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                                                      child:  CircleAvatar(
                                                        backgroundColor: Colors.black12,
                                                        child: Components(context).myIconWidget(icon: MyIcons.volume_high)
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
                                                Row(
                                                  children: [
                                                    Text(data[index]['title'],style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16,fontWeight: FontWeight.bold),),
                                                    const SizedBox(width: 10,),
                                                    Visibility(
                                                      visible:  data[index]['isPaid'] == true ,
                                                        child: Components(context).myIconWidget(icon: MyIcons.premium,size: 17,color: theme.textColor)
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(height: 10,),
                                                _buildhms(data[index]['duration']),
                                                const SizedBox(height: 15,),
                                               Wrap(
                                                 children: [
                                                   for(int i =0;i<taglist.length;i++)
                                                     Text((i!=taglist.length-1)?'${taglist[i]}  •  ':'${taglist[i]}  ',
                                                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                         color: theme.textColor.withOpacity(0.6),
                                                         fontWeight: FontWeight.bold,
                                                         fontSize: 11
                                                       ),
                                                     )
                                                 ]
                                               )
                                              ],
                                            ),
                                          )),
                                      Expanded(
                                          child: IconButton(onPressed: (){
                                            HapticFeedback.lightImpact();
                                            showOptionSheet(theme,index);
                                          },icon: const Icon(CupertinoIcons.ellipsis),color: theme.textColor.withOpacity(0.6),)
                                      )
                                    ],
                                  ),
                                ),
                              ),
                        ),
                      ),
                    );
                  }
                  ),
                ),
              ),
              const Positioned(
                  bottom: 10,
                  right: 0,
                  left: 0,
                  child: MiniPlayer()
              )

            ],
          ),
        )
    );

  }
  _buildhms(Map obj){
     ThemeProvider theme = Provider.of<ThemeProvider>(context,listen:false);
    TextStyle textStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 12,
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
      return Text('${obj['hour']} $hr ${obj['minute']} $min',style: textStyle,);
    }
  }
}




