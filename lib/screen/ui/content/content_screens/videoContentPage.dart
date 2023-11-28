//
// import 'dart:async';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mindandsoul/constants/iconconstants.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
//
// import '../../../../helper/components.dart';
// import '../../../../provider/themeProvider.dart';
//
// class VideoContent extends StatefulWidget {
//   final Map data;
//   final String title;
//   const VideoContent({super.key,required this.data,required this.title});
//
//   @override
//   State<VideoContent> createState() => _VideoContentState();
// }
//
// class _VideoContentState extends State<VideoContent> {
//   late  VideoPlayerController videoPlayerController ;
//   late ChewieController chewieController;
//
//   bool loader = true;
//   bool showControls = true;
//   //late Future<void> _future;
//
//   Future<void> initVideo()async{
//     videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.data['video']),);
//     await videoPlayerController.initialize();
//     setState(() {
//       chewieController = ChewieController(
//           autoInitialize: true,
//           autoPlay: true,
//           showControls: true,
//           showControlsOnInitialize: true,
//           videoPlayerController: videoPlayerController,
//           allowedScreenSleep: false,
//           allowFullScreen: true,
//           deviceOrientationsAfterFullScreen: [
//             DeviceOrientation.landscapeRight,
//             DeviceOrientation.landscapeLeft,
//             DeviceOrientation.portraitUp,
//             DeviceOrientation.portraitDown,
//           ],
//           showOptions: false
//       );
//       chewieController.addListener(() {
//
//         if (chewieController.isFullScreen) {
//           SystemChrome.setPreferredOrientations([
//             DeviceOrientation.landscapeRight,
//             DeviceOrientation.landscapeLeft,
//           ]);
//         } else {
//           SystemChrome.setPreferredOrientations([
//             DeviceOrientation.portraitUp,
//             DeviceOrientation.portraitDown,
//           ]);
//         }
//       });
//     });
//
//     setState(() {
//       loader = false;
//     });
//   }
//
//   @override
//   void initState() {
//
//     // TODO: implement initState
//     initVideo();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     videoPlayerController.dispose();
//     chewieController.dispose();
//     chewieController.removeListener(() {});
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeRight,
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     super.dispose();
//   }
//
//   List taglist = [
//     'Mindfulness',
//     'Spiritual',
//     'Sleep',
//     'Food',
//   ];
//
//   bool like = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeProvider>(
//       builder: (context,theme,child) =>
//       Scaffold(
//          backgroundColor:theme.themeColorA,
//         body: (loader)
//             ?Components(context).Loader(textColor: theme.textColor)
//             :SafeArea(
//           top: true,
//           child: Container(
//             color: Colors.white,
//            /* decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       theme.themeColorA,
//                       theme.themeColorB,
//                       theme.themeColorA,
//                     //  theme.themeColorA,
//                     ]
//                 )
//             ),*/
//             child: Column(
//               children: [
//                 Container(
//                   color: theme.themeColorA,
//                   padding: const EdgeInsets.all(15),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Components(context).tags(
//                         title:widget.title,
//                         context: context,
//                         textcolor: theme.textColor.withOpacity(0.7)
//                       ),
//                       const SizedBox(height: 10,),
//                       Text(widget.data['title'],style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: theme.textColor,fontWeight: FontWeight.w800,fontSize: 19),),
//                       const SizedBox(height: 20,),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.headphones_outlined,color: theme.textColor.withOpacity(0.7),size: 13,),
//                               SizedBox(width: 5,),
//                               Text('34.8k listens • ❤️ 12.2k likes',
//                                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 11,
//                                     //letterSpacing: 1.3,
//                                     color: theme.textColor.withOpacity(0.7)
//                                 ),),
//                             ],
//                           ),
//                           const SizedBox(width: 35,),
//                           Row(
//                             children: [
//                               Icon(Icons.watch_later_outlined,color: theme.textColor.withOpacity(0.7),size: 13,),
//                               SizedBox(width: 5,),
//                               Text('August 18, 2023',
//                                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 11,
//                                     //letterSpacing: 1.3,
//                                     color: theme.textColor.withOpacity(0.7)
//                                 ),),
//                             ],
//                           )
//
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//                 AspectRatio(
//                   aspectRatio: videoPlayerController.value.aspectRatio,
//                   child: Chewie(
//                       controller: chewieController
//                   ),
//                 ),
//                /* Padding(
//                     padding: const EdgeInsets.only(top: 10,left: 10,bottom: 10),
//                   child: Row(
//                     mainAxisAlignment:MainAxisAlignment.start,
//                     children: [
//                       _buildBox(
//                         context: context,
//                         label: '  12.1k',
//                           icon: Components(context).myIconWidget(icon: (like)?MyIcons.like:MyIcons.like_filled),
//                               onTap: (){
//                         HapticFeedback.selectionClick();
//                         setState(() {
//                         like = !like;
//                       });}),
//                       const SizedBox(width: 15,),
//                       _buildBox(context: context,icon:  Icon(Icons.share_outlined,color: theme.textColor.withOpacity(0.7),size: 20,),label: '  Share'),
//                       const SizedBox(width: 15,),
//                       _buildBox(context: context,icon:  Icon(Icons.favorite_outline,color: theme.textColor.withOpacity(0.7),size: 20,),label: '  Add to favourites'),
//
//                     ],
//                   ),
//                 ),*/
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.fromLTRB(15.0,15.0,15.0,15),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                       //  Text('Tags:\n',style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: theme.textColor,fontWeight: FontWeight.w800,fontSize: 15.5),),
//                         Wrap(
//                             spacing: 5,
//                             children:
//                             taglist.map((e) => Components(context).tags(
//                                 title:e,
//                                 context: context,
//                                 textcolor: Theme.of(context).colorScheme.onSurface
//
//                             )).toList()
//                         ),
//                         SizedBox(height: 15,),
//                       //  Text('Description:\n',style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: theme.textColor,fontWeight: FontWeight.w800,fontSize: 15.5),),
//                         Text('${widget.data['desc']}\n',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),),
//
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// Widget _buildBox({
//   required BuildContext context,
//   required Widget icon,
//   VoidCallback? onTap,
//   String label = ''
// }){
//   double radius = 15;
//   ThemeProvider theme = Provider.of<ThemeProvider>(context,listen: false);
//   return GestureDetector(
//     onTap: onTap,
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(radius),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 15,sigmaY: 15),
//         child: Container(
//           padding: const EdgeInsets.all(10),
//          // height: 50,
//          // width: 50,
//           decoration: BoxDecoration(
//             color: Colors.black26,
//             borderRadius: BorderRadius.circular(radius)
//           ),
//           child: Row(
//             children: [
//               icon,
//               Text(label,style: Theme.of(context).textTheme.labelLarge?.copyWith(color: theme.textColor.withOpacity(0.8),fontSize: 12),),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
//
// class Delegate extends SliverPersistentHeaderDelegate {
//   final Widget child;
//
//   Delegate(this.child);
//
//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return child;
//   }
//
//   @override
//   double get maxExtent => 80;
//
//   @override
//   double get minExtent => 50;
//
//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
//     return true;
//   }
// }
//



import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:like_button/like_button.dart';
import 'package:mindandsoul/constants/iconconstants.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../../../../helper/components.dart';
import '../../../../provider/themeProvider.dart';
import '../../../../provider/userProvider.dart';
import '../../../../services/services.dart';

class VideoContent extends StatefulWidget {
  final String id;
  const VideoContent({super.key,required this.id});

  @override
  State<VideoContent> createState() => _VideoContentState();
}

class _VideoContentState extends State<VideoContent> {
  late  VideoPlayerController videoPlayerController ;
  late ChewieController chewieController;

  bool loader = true;
  bool showControls = true;
  //late Future<void> _future;

  Future<void> initVideo()async{
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(data['video']),);
    await videoPlayerController.initialize();
    setState(() {
      chewieController = ChewieController(
          autoInitialize: true,
          autoPlay: true,
          showControls: true,
          showControlsOnInitialize: true,
          videoPlayerController: videoPlayerController,
          allowedScreenSleep: false,
          allowFullScreen: true,
          deviceOrientationsAfterFullScreen: [
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ],
          showOptions: false
      );
      chewieController.addListener(() {

        if (chewieController.isFullScreen) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
          ]);
        } else {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
        }
      });
    });

    setState(() {
      loader = false;
      videoInitialized = true;
    });
  }

  Map data = {};
  bool videoInitialized = false;


  getData()async{
    User user = Provider.of<User>(context,listen: false);
    var lst = await Services(user.token).getContentDetails(widget.id);
    print(lst);
    setState(() {
      data = lst['data'];
      print(data);
    });
    if(!videoInitialized){
      initVideo();
    }

  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      // navigation bar color
      statusBarColor: Colors.black,
     statusBarIconBrightness: Brightness.light
     // status bar color
    ));

    // TODO: implement initState
   getData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    videoPlayerController.dispose();
    chewieController.dispose();
    chewieController.removeListener(() {});
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  List taglist = [
    'Mindfulness',
    'Spiritual',
    'Sleep',
    'Food',
  ];

  bool like = false;

  int likes = 57;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,theme,child) =>
          Scaffold(
            backgroundColor:(loader)?theme.themeColorA:Colors.transparent,
            body: (loader)
                ?Components(context).Loader(textColor: theme.textColor)
                :SafeArea(
              top: true,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: videoPlayerController.value.aspectRatio,
                              child: Chewie(
                                  controller: chewieController
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: CustomScrollView(
                          // padding: const EdgeInsets.all(15),
                            slivers: [
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(15.0,15.0,15,10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Components(context).tags(
                                        title: data['category'],
                                        context: context,
                                        //textcolor: Theme.of(context).colorScheme.onSurface,
                                        textcolor: theme.themeColorB,
                                      ),
                                      const SizedBox(height: 10,),
                                      Text(data['title'],style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface,fontWeight: FontWeight.w800,fontSize: 19),),
                                      const SizedBox(height: 20,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.headphones_outlined,color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),size: 13,),
                                              const SizedBox(width: 5,),
                                              Text('34.8k listens',
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                    //letterSpacing: 1.3,
                                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                                                ),),
                                            ],
                                          ),
                                          const SizedBox(width: 35,),
                                          Row(
                                            children: [
                                              Icon(Icons.watch_later_outlined,color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),size: 13,),
                                              const SizedBox(width: 5,),
                                              Text('August 18, 2023',
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                    //letterSpacing: 1.3,
                                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                                                ),),
                                            ],
                                          )

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SliverPersistentHeader(
                                pinned: true,
                                floating: true,
                                  delegate: MyDelegate(child:  PreferredSize(
                                    preferredSize: const Size(double.infinity, kToolbarHeight),
                                    child: Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius: BorderRadius.circular(25)
                                            ),
                                            child: LikeButton(
                                              likeCount: data['likes'],
                                              //countPostion: CountPostion.bottom,
                                              onTap: (isLiked) async {

                                                User user = Provider.of<User>(context,listen: false);
                                                String message = await Services(user.token).likeContent(widget.id);
                                                // Components(context).showSuccessSnackBar(message);
                                                if(data['liked'] == true){
                                                  HapticFeedback.mediumImpact();
                                                }
                                                else{
                                                  HapticFeedback.lightImpact();
                                                }
                                                getData();

                                                return !isLiked;
                                              },

                                              padding: EdgeInsets.zero,
                                            //  likeCountPadding: EdgeInsets.zero,
                                              countBuilder: (count,  liked, str){
                                                return Text(count.toString(),style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),fontSize: 13.5),);
                                              },
                                              size: 22,
                                              isLiked : data['liked'],
                                              likeBuilder: (bool isLiked) {
                                                return Components(context).myIconWidget(
                                                  icon: (isLiked)?MyIcons.favorite_filled:MyIcons.favorite,
                                                  //color: (isLiked) ? Colors.redAccent.shade200 : Colors.white,
                                                  color: Colors.black87,
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 5,),
                                          Components(context).BlurBackgroundCircularButton(
                                            iconColor: Colors.black87,
                                              backgroundColor: Colors.black12,
                                              svg: MyIcons.share)
                                        ],
                                      ),
                                    ),
                                  ),)
                              ),
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(15,7,15,0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                          spacing: 5,
                                          children:
                                          taglist.map((e) => Components(context).tags(
                                              title:e,
                                              context: context,
                                              textcolor: Theme.of(context).colorScheme.onSurface

                                          )).toList()
                                      ),
                                      const SizedBox(height: 15,),
                                      //  Text('Description:\n',style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: theme.textColor,fontWeight: FontWeight.w800,fontSize: 15.5),),
                                      Text('${data['desc']}',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),),
                                      const SizedBox(height: 30 ,)

                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
    );
  }
}

Widget _buildBox({
  required BuildContext context,
  required Widget icon,
  VoidCallback? onTap,
  String label = ''
}){
  double radius = 35;
  //ThemeProvider theme = Provider.of<ThemeProvider>(context,listen: false);
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
      // height: 50,
      // width: 50,
      decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(radius)
      ),
      child: Row(
        children: [
          icon,
          SizedBox(width: (label == '')?0:7,),
          Text(label,style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),fontSize: 12),),
        ],
      ),
    ),
  );
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSizeWidget child;

  MyDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}



