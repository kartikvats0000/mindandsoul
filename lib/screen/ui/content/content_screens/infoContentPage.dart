import 'dart:ui';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:mindandsoul/constants/iconconstants.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:provider/provider.dart';

import '../../../../helper/components.dart';
import '../../../../provider/userProvider.dart';
import '../../../../services/services.dart';

class InfoGraphic extends StatefulWidget {
  final String id;
  const InfoGraphic({super.key, required this.id});

  @override
  State<InfoGraphic> createState() => _InfoGraphicState();
}

class _InfoGraphicState extends State<InfoGraphic> {

  List infographics =[];

  ScrollController scrollController = ScrollController();
  bool isScrolling = false;

  Map data = {};

  getData()async{
    User user = Provider.of<User>(context,listen: false);
    var lst = await Services(user.token).getContentDetails(widget.id);
    print(lst);
    setState(() {
      data = lst['data'];
      print(data);
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    getData();
    // infographics = widget.data['infoData'];
    // infographics = infographics.reversed.toList();
    scrollController.addListener(() {
      if(scrollController.position.pixels < MediaQuery.of(context).size.height * 0.45){
        if(isScrolling == true){setState(() {
          isScrolling = false;
        });}
      }
      else{
        if(isScrolling == false){setState(() {
          isScrolling = true;
        });}
      }
    });
    super.initState();
  }


  List taglist = [
    'Mindfulness',
    'Spiritual',
    'Sleep',
    'Food',
  ];

  bool like = false;

  AudioPlayer audioPlayer = AudioPlayer();

  popSound(){
    audioPlayer.setAsset('assets/data/pop.mp3');
    audioPlayer.play();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,theme,child){
        if(data.isEmpty){
          return Scaffold(
            body: Components(context).Loader(textColor: Colors.black),
          );
        }
        else{
          infographics = data['infoData'];
          infographics = infographics.reversed.toList();
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight+10),
                child: Components(context).customAppBar(
                    duration: const Duration(milliseconds: 200),
                    scrolledColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    actions: [
                      CircleAvatar(
                        backgroundColor: Colors.black38,
                        child: LikeButton(
                          onTap: (isLiked) async {
                            User user = Provider.of<User>(context,listen: false);
                            String message = await Services(user.token).likeContent(widget.id);
                            // Components(context).showSuccessSnackBar(message);
                            if(data['liked'] == false){
                              HapticFeedback.mediumImpact();
                              popSound();
                            }
                            else{
                              HapticFeedback.lightImpact();
                            }
                            getData();
                            return !isLiked;
                          },

                          padding: EdgeInsets.zero,
                          likeCountPadding: EdgeInsets.zero,

                          size: 22,
                          isLiked : data['liked'],
                          likeBuilder: (bool isLiked) {
                            return Components(context).myIconWidget(
                              icon: (isLiked)?MyIcons.favorite_filled:MyIcons.favorite,
                              //color: (isLiked) ? Colors.redAccent.shade200 : Colors.white,
                              color: Colors.white,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 5,),
                      Components(context).BlurBackgroundCircularButton(svg: MyIcons.share),
                    ],
                    title: Text(data['title'],style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white.withOpacity(0.9),fontWeight: FontWeight.w800,fontSize: 15.5,),maxLines: 2,overflow: TextOverflow.ellipsis,),
                    isScrolling: isScrolling
                )
            ),
            //backgroundColor: theme.themeColorB,
            body: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                // gradient: LinearGradient(
                //     begin: Alignment.topCenter,
                //     end: Alignment.bottomCenter,
                //     colors: [
                //       theme.themeColorB,
                //       theme.themeColorA,
                //     ]
                // )
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          //width: double.infinity,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Hero(
                                  tag: data['_id'],
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Image.network(data['image'],fit: BoxFit.cover,),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration:  BoxDecoration(
                                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
                                        gradient:  LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black26,
                                              //Colors.transparent,
                                              Colors.black.withOpacity(0.92)
                                            ]
                                        )
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Components(context).tags(
                                              title: data['category'],
                                              context: context,
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.watch_later_outlined,color: Theme.of(context).colorScheme.surface.withOpacity(0.7),size: 13,),
                                                const SizedBox(width: 5,),
                                                Text(DateFormat('MMMM d, yyyy').format(DateTime.parse(data['updatedAt'])),
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 11,
                                                      //letterSpacing: 1.3,
                                                      color: Colors.white.withOpacity(0.7)
                                                  ),),
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Text(data['title'],style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white.withOpacity(0.9),fontWeight: FontWeight.w800,fontSize: 19),),
                                        const SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.remove_red_eye_outlined,color: Colors.grey.withOpacity(0.7),size: 13,),
                                                const SizedBox(width: 5,),
                                                Text('34.8k reads • ❤️ ${data['likes']} likes',
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 11,
                                                      //letterSpacing: 1.3,
                                                      color: Colors.white.withOpacity(0.7)
                                                  ),),
                                              ],
                                            ),

                                          ],
                                        )
                                      ],
                                    ),
                                  )
                              ),
                              /*Positioned(
                              top: 30,
                              left: 5,
                              child: Components(context).BlurBackgroundCircularButton(icon: Icons.chevron_left,onTap: (){Navigator.pop(context);})
                          ),
                          Positioned(
                              top: 30,
                              right: 5,
                              child: Components(context).BlurBackgroundCircularButton(svg: MyIcons.favorite,onTap: (){})
                          ),*/
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text('Tags:\n',style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface,fontWeight: FontWeight.w800,fontSize: 15.5),),
                              Wrap(
                                  spacing: 5,
                                  runSpacing: 5,
                                  children:
                                  taglist.map((e) => Components(context).tags(
                                    title:e,
                                    context: context,
                                    textcolor: Theme.of(context).colorScheme.onSurface,
                                  )).toList()
                              ),
                              const SizedBox(height: 15,),
                              // Text('Description:\n',style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface,fontWeight: FontWeight.w800,fontSize: 15.5),),
                              Text('${data['desc']}\n',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface,fontSize: 13.5),),
                              //  Text('Instructions:\n',style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface,fontWeight: FontWeight.w800,fontSize: 15.5),),

                            ],
                          ),

                        ),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: infographics.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context,index){
                            var itemList = [
                              Expanded(
                                  flex: 5,
                                  child: AspectRatio(aspectRatio: 16/12,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(infographics[index]['image'],fit: BoxFit.cover,)),)
                              ),
                              const SizedBox(width:10),
                              Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment : CrossAxisAlignment.start,
                                    children: [
                                      Text('Step ${index+1}:',style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface,fontWeight: FontWeight.w800,fontSize: 13.5),),
                                      const SizedBox(height: 5,),
                                      Text('${infographics[index]['desc']}',style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface,fontSize: 13),
                                      ),
                                    ],
                                  )
                              ),
                            ];

                            return Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(bottom: 10),
                              child:  Row(
                                  children:(index%2 == 0)?itemList:itemList.reversed.toList()
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  /*  AnimatedPositioned(
                duration: Duration(milliseconds: 350),
                top: (isScrolling)?0:-kToolbarHeight-35,
                right: 0,
                left: 0,
                curve: Curves.easeOut,
                child: Components(context).customAppBar(
                  actions: [
                    Components(context).BlurBackgroundCircularButton(svg: MyIcons.favorite),
                    const SizedBox(width: 5,),
                    Components(context).BlurBackgroundCircularButton(svg: MyIcons.share),
                  ],
                  title: Text(widget.data['title'],style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white.withOpacity(0.9),fontWeight: FontWeight.w800,fontSize: 15.5,),maxLines: 2,overflow: TextOverflow.ellipsis,),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
              )*/
                ],
              ),
            ),
          );
        }
      }

    );
  }
}
