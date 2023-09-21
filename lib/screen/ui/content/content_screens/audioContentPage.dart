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
   //audioPlayer.play();
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

  int likes= 56;


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
          color: Theme.of(context).colorScheme.surface,
          // decoration: BoxDecoration(
          //     gradient:  LinearGradient(
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //         colors: [
          //           theme.themeColorB,
          //
          //           //Colors.transparent,
          //           //Theme.of(context).colorScheme.primary,
          //           theme.themeColorA,
          //         ]
          //     )
          // ),
          child: Column(
            children: [
              Expanded(
                flex:9,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        //width: double.infinity,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Hero(
                                tag: widget.data['_id'],
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Image.network(widget.data['image'],fit: BoxFit.cover,),
                                  ),
                                ),
                              ),
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
                                            title:widget.title,
                                            context: context,
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.watch_later_outlined,color: Theme.of(context).colorScheme.surface.withOpacity(0.7),size: 13,),
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
                                      ),
                                      const SizedBox(height: 10,),
                                      Text(widget.data['title'],style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white.withOpacity(0.9),fontWeight: FontWeight.w800,fontSize: 19),),
                                      const SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Components(context).BlurBackgroundCircularButton(svg: (!like)?MyIcons.like:MyIcons.like_filled,onTap: (){
                                                HapticFeedback.lightImpact();
                                                setState(() {
                                                  like = !like;
                                                  if(like == false){
                                                    likes--;
                                                  }
                                                  else{
                                                    likes++;
                                                  }
    });
                                              }),
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
                                child: Row(
                                  children: [
                                    Components(context).BlurBackgroundCircularButton(svg: MyIcons.share,onTap: (){}),
                                    const SizedBox(width: 5,),
                                    Components(context).BlurBackgroundCircularButton(svg: MyIcons.favorite,onTap: (){}),
                                  ],
                                )
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
                                     textcolor: Theme.of(context).colorScheme.onSurface,
                                  )).toList()
                              ),
                              const SizedBox(height: 25,),
                            //  Text('Description:\n',style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: theme.textColor,fontWeight: FontWeight.w800,fontSize: 15.5),),
                              Text('${widget.data['desc']}\n',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),),
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
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.white,blurRadius: 10,spreadRadius: 10),
                      ]
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
                                Text(_getDurationString(audioPlayer.position),style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface),),
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
                                Text(_getDurationString(_duration),style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface),),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //SizedBox(width: 25,),
                                InkWell(
                                  onTap: (){
                                    if(_position.inSeconds/_duration.inSeconds > 0){
                                      audioPlayer.seek(Duration(seconds:(audioPlayer.position.inSeconds - 10).toInt()));
                                    }
                                    if(_position.inSeconds/_duration.inSeconds < 0.08){
                                      audioPlayer.seek(const Duration(seconds:0));
                                    }

                                  },
                                  child: SvgPicture.asset('assets/home/backward_skip.svg',color: Theme.of(context).colorScheme.onSurface,height: 46.5,width: 46.5,),
                                ),
                                const SizedBox(width: 25,),
                                StreamBuilder<PlayerState>(
                                    stream: audioPlayer.playerStateStream,
                                    builder: (context, snapshot) {
                                    final playerState = snapshot.data;
                                    final processingState =
                                        playerState?.processingState;
                                    final playing = playerState?.playing;
                                    if (processingState == ProcessingState.loading ||
                                        processingState ==
                                            ProcessingState.buffering) {
                                      return CircleAvatar(
                                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.38),
                                        radius: 38,
                                        child: CircularProgressIndicator()
                                      );
                                    } else if (playing != true) {
                                      return InkWell(
                                        onTap: (){audioPlayer.play();},
                                        child: CircleAvatar(
                                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.38),
                                          radius: 38,
                                          child: Icon(Icons.play_arrow_rounded,size: 45,),
                                        ),
                                      );
                                    } else if (processingState !=
                                        ProcessingState.completed) {
                                      return InkWell(
                                        onTap: (){audioPlayer.pause();},
                                        child: CircleAvatar(
                                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.38),
                                          radius: 38,
                                          child: Icon(Icons.pause_rounded,size: 45,),
                                        ),
                                      );
                                    } else {
                                      return InkWell(
                                        child: CircleAvatar(
                                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.38),
                                          radius: 38,
                                          child: Icon((audioPlayer.playerState.playing)?Icons.pause_rounded:Icons.play_arrow_rounded,size: 45,),
                                        ),
                                      );
                                    }
                                  },
                                ),

                                const SizedBox(width: 25,),
                                InkWell(
                                  onTap: (){
                                    if(_position.inSeconds/_duration.inSeconds < 1){
                                      audioPlayer.seek(Duration(seconds:(_position.inSeconds + 10).toInt()));
                                    }
                                    if(_position.inSeconds/_duration.inSeconds > 0.9){
                                      audioPlayer.seek(Duration(seconds:(audioPlayer.duration!.inSeconds).toInt()));
                                    }
                                  },
                                  child: SvgPicture.asset('assets/home/forward_skip.svg',color: Theme.of(context).colorScheme.onSurface,height: 46.5,width: 46.5,),
                                ),
                               // SizedBox(width: 25,),
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
