import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mindandsoul/constants/iconconstants.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:provider/provider.dart';

import '../../../../helper/components.dart';

class AudioContent extends StatefulWidget {
  final Map data;
  final String title;
  const AudioContent({super.key, required this.data,required this.title});

  @override
  State<AudioContent> createState() => _AudioContentState();
}

class _AudioContentState extends State<AudioContent> {

  List taglist = [
    'Mindfulness',
    'Spiritual',
    'Sleep',
    'Food',
    'Focus',
    'Study'
  ];

  AudioPlayer audioPlayer = AudioPlayer();
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  initAudio()async{
    var _playlist;
    _playlist = ConcatenatingAudioSource(children: [
      AudioSource.uri(
          Uri.parse(widget.data['audio']),
          tag: MediaItem(
              id: '1',
              title: widget.data['title'],
              artist: 'Mind n Soul',
              artUri: Uri.parse(widget.data['image'])
          )
      ),
    ]);
    await audioPlayer.setAudioSource(_playlist);

    audioPlayer.positionStream.listen((position) {
     setState(() {
       _position = position;
     });
   });
   audioPlayer.durationStream.listen((duration) {
     setState(() {
       if(duration != null){
         _duration = duration;
       }
     });
   });
   audioPlayer.play();
  }

  @override
  void initState() {
    // TODO: implement initState
    initAudio();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer.dispose();
    super.dispose();
  }


  bool like = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,theme,child) =>
      Scaffold(
        backgroundColor: theme.themeColorA,
        extendBodyBehindAppBar: false,
        extendBody: false,
        body: Container(
          decoration: BoxDecoration(
              gradient:  LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.themeColorB,

                    //Colors.transparent,
                    //Theme.of(context).colorScheme.primary,
                    theme.themeColorA,
                  ]
              )
          ),
          child: Column(
            children: [
              Expanded(
                flex:9,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Stack(
                          children: [
                            Positioned.fill(child: Hero(
                              tag: widget.data['_id'],
                              child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
                                  child: CachedNetworkImage(imageUrl: widget.data['image'],fit: BoxFit.cover,)),
                            )
                            ),
                            Positioned.fill(
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration:  BoxDecoration(
                                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
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
                                      Components(context).tags(
                                        title:widget.title,
                                        context: context,


                                      ),
                                      const SizedBox(height: 10,),
                                      Text(widget.data['title'],style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white.withOpacity(0.9),fontWeight: FontWeight.w800,fontSize: 19),),
                                      const SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.headphones_outlined,color: Colors.grey.withOpacity(0.7),size: 13,),
                                              SizedBox(width: 5,),
                                              Text('34.8k listens • ❤️ 12.2k likes',
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                    //letterSpacing: 1.3,
                                                    color: Colors.white.withOpacity(0.7)
                                                ),),
                                            ],
                                          ),
                                          const SizedBox(width: 35,),
                                          Row(
                                            children: [
                                              Icon(Icons.watch_later_outlined,color: Colors.grey.withOpacity(0.7),size: 13,),
                                              SizedBox(width: 5,),
                                              Text('August 18, 2023',
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                    //letterSpacing: 1.3,
                                                    color: Colors.white.withOpacity(0.7)
                                                ),),
                                            ],
                                          )

                                        ],
                                      )
                                    ],
                                  ),
                                )
                            ),
                            Positioned(
                                top: 30,
                                left: 5,
                                child: Components(context).BlurBackgroundCircularButton(icon: Icons.chevron_left,onTap: (){Navigator.pop(context);})
                            ),
                            Positioned(
                                top: 30,
                                right: 5,
                                child: Components(context).BlurBackgroundCircularButton(svg: MyIcons.favorite,onTap: (){})
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                           //   Text('Tags:\n',style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: theme.textColor,fontWeight: FontWeight.w800,fontSize: 15.5),),
                              Wrap(
                                  spacing: 5,
                                  runSpacing: 5,
                                  children:
                                  taglist.map((e) => Components(context).tags(
                                      title:e,
                                      context: context,
                                      textcolor: theme.textColor.withOpacity(0.7)
                                  )).toList()
                              ),
                              const SizedBox(height: 25,),
                            //  Text('Description:\n',style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: theme.textColor,fontWeight: FontWeight.w800,fontSize: 15.5),),
                              Text('${widget.data['desc']}\n',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: theme.textColor.withOpacity(0.7)),),
                            ],
                          )
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex:2,
                  child:Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: theme.themeColorA,
                            blurRadius: 25,
                            spreadRadius: 25,
                            blurStyle: BlurStyle.normal
                        )
                      ],
                      color: theme.themeColorA,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Text(_getDurationString(audioPlayer.position),style: Theme.of(context).textTheme.labelLarge,),
                                 Expanded(
                                     child: Slider(
                                       min: 0.0,
                                         // max: _duration.inSeconds.toDouble()+1.0,
                                         value: _duration.inSeconds.isNaN==true || audioPlayer.duration?.inSeconds ==null ? 0 :_position.inSeconds/_duration.inSeconds,
                                         onChanged: (val){
                                           audioPlayer.seek(Duration(milliseconds:(audioPlayer.duration!.inSeconds * val * 1000).toInt()));
                                         }
                                     )
                                 ),
                                Text(_getDurationString(_duration),style: Theme.of(context).textTheme.labelLarge,),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(onPressed: (){}, child: Components(context).myIconWidget(icon: MyIcons.share,color: theme.textColor),),
                                SizedBox(width: 25,),
                                InkWell(
                                  onTap: (){
                                    if(_position.inSeconds/_duration.inSeconds > 0){
                                      audioPlayer.seek(Duration(seconds:(audioPlayer.position.inSeconds - 10).toInt()));
                                    }
                                    if(_position.inSeconds/_duration.inSeconds < 0.1){
                                      audioPlayer.seek(const Duration(seconds:0));
                                    }

                                  },
                                  child: SvgPicture.asset('assets/home/backward_skip.svg',color: theme.textColor,height: 46.5,width: 46.5,),
                                ),
                                SizedBox(width: 25,),
                                Components(context).BlurBackgroundCircularButton(
                                    icon: (audioPlayer.playerState.playing)?Icons.pause:Icons.play_arrow_rounded,
                                  buttonRadius: 38,
                                  iconSize: 38,
                                  onTap: (){
                                    (audioPlayer.playerState.playing)?
                                      audioPlayer.pause()
                                        :audioPlayer.play();
                                  }
                                ),
                                SizedBox(width: 25,),
                                InkWell(
                                  onTap: (){
                                    if(_position.inSeconds/_duration.inSeconds < 1){
                                      audioPlayer.seek(Duration(seconds:(_position.inSeconds + 10).toInt()));
                                    }
                                    if(_position.inSeconds/_duration.inSeconds > 0.9){
                                      audioPlayer.seek(Duration(seconds:(audioPlayer.duration!.inSeconds).toInt()));
                                    }
                                  },
                                  child: SvgPicture.asset('assets/home/forward_skip.svg',color: theme.textColor,height: 46.5,width: 46.5,),
                                ),
                                SizedBox(width: 25,),
                                TextButton(onPressed: (){
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    like = !like;
                                  });
                                }, child: Components(context).myIconWidget(icon: (like)?MyIcons.like:MyIcons.like_filled,color: theme.textColor))
                              ],
                            )
                        )
                      ],
                    ),
                  )
              )
            ],
          ),
        )
      ),
    );
  }
}

String _getDurationString(Duration duration) {
  String minutes = duration.inMinutes.toString().padLeft(2,'0');
  String seconds = (duration.inSeconds % 60).toString().padLeft(2,'0');

  if (minutes == 0) {
    return '00:$seconds';
  } else {
    return '$minutes:$seconds';
  }
}
