import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:mindandsoul/constants/iconconstants.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:provider/provider.dart';
import '../../../../provider/userProvider.dart';
import '../../../../services/services.dart';
import 'package:like_button/like_button.dart';

class TextContent extends StatefulWidget {
  final String id;
  const TextContent({super.key,required this.id});

  @override
  State<TextContent> createState() => _TextContentState();
}

class _TextContentState extends State<TextContent> {

  ScrollController scrollController = ScrollController();
  bool isScrolling = false;


  AudioPlayer audioPlayer = AudioPlayer();
  popSound(){
    audioPlayer.setAsset('assets/data/pop.mp3');
    audioPlayer.play();
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    scrollController.addListener(() {
      if(scrollController.position.pixels < MediaQuery.of(context).size.height * 0.45
      ){
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
    'Spiritual',
    'Sleep',
  ];

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

  bool like = false;

  @override
  Widget build(BuildContext context) {
    if(data.isEmpty){
      return Scaffold(
        body: Components(context).Loader(textColor: Colors.black),
      );
    }
    else{
      return Scaffold(
        backgroundColor:Theme.of(context).colorScheme.surface,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight+10),
            child: Components(context).customAppBar(
                duration: const Duration(milliseconds: 150),
                scrolledColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                actions: [
                  CircleAvatar(
                    backgroundColor: Colors.black38,
                    child: LikeButton(
                      onTap: (isLiked) async {
                        User user = Provider.of<User>(context,listen: false);
                        String message = await Services(user.token).likeContent(widget.id);
                        if(data['liked'] == false){
                          HapticFeedback.mediumImpact();
                          popSound();
                        }
                        else{
                          HapticFeedback.lightImpact();
                        }
                        getData();
                        print('isliked${!isLiked}');
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
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              // padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: Stack(
                      children: [
                        Positioned.fill(child: Hero(
                          tag: data['_id'],
                          child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
                              child: CachedNetworkImage(imageUrl: data['image'],fit: BoxFit.cover,)),
                        )
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
                                        Colors.black12,
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
                                        title:data['category'],
                                        context: context,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.watch_later_outlined,color: Colors.white.withOpacity(0.8),size: 13,),
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
                                          Icon(Icons.remove_red_eye_outlined,color: Colors.white.withOpacity(0.7),size: 13,),
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HtmlWidget(
                            data['html']
                        ),

                        const SizedBox(height: 15,),
                        Text('Tags:\n',style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 14),),
                        Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children:
                            taglist.map((e) => Components(context).tags(
                                title:e,
                                context: context,
                                textcolor: Colors.black87
                            )).toList()

                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            /*AnimatedPositioned(
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
      );
    }

  }
}
