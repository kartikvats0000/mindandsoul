import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../../../../constants/iconconstants.dart';
import '../../../../../../helper/components.dart';
import '../../../../../../provider/playerProvider.dart';
import '../../../../../../provider/themeProvider.dart';
import '../../../../../../provider/userProvider.dart';
import '../../../../../../services/services.dart';

class FavouriteWellnes extends StatefulWidget {
  const FavouriteWellnes({super.key});

  @override
  State<FavouriteWellnes> createState() => _FavouriteWellnesState();
}

class _FavouriteWellnesState extends State<FavouriteWellnes> {

  bool loader = true;

  List data = [];

  getData()async{
    User user = Provider.of<User>(context,listen: false);
    print('getting your favorites');
    var lst = await Services(user.token).getFavouriteWellness();
    setState(() {
      data = lst;
      loader = false;
    });
  }

  List<Track> tracks = [];

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context,theme,child){
          return Scaffold(
            body: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: theme.themeColorA,
                ),
                child: Center(
                    child: (!loader)
                        ? RefreshIndicator(
                      onRefresh: ()async{
                        getData();
                      },
                      child:  ListView.separated(
                          separatorBuilder: (context,index) =>  Divider(indent: 20,endIndent: 20,thickness: 0.65,color: theme.textColor.withOpacity(0.2),),
                          itemCount: data.length,
                          itemBuilder: (context,index){
                            tracks = List.generate(data.length, (i) => Track(title: data[i]['title'], thumbnail: data[i]['image'], audioUrl: data[i]['audio'],gif: data[index]['anim'] ));
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
                                                     /*   Wrap(
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
                                                        )*/
                                                      ],
                                                    ),
                                                  )),
                                              Expanded(
                                                  child: IconButton(onPressed: (){
                                                    HapticFeedback.lightImpact();
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
                      )
                    )
                        : Components(context).Loader(textColor: theme.textColor)
                )
            ),
          );
        }
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


