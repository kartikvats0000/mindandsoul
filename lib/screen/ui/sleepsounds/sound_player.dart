import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindandsoul/constants/iconconstants.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/screen/ui/sleepsounds/soundlist.dart';
import 'package:mindandsoul/screen/ui/sleepsounds/soundmaker.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundPlayer extends StatefulWidget {
  dynamic data;
   SoundPlayer({super.key,required this.data});

  @override
  State<SoundPlayer> createState() => _SoundPlayerState();
}

class _SoundPlayerState extends State<SoundPlayer> {
  
  List<AudioPlayerModel> audioplayers = [];
  
  _initAll(){
    List playerslist = widget.data['sounds'];
    for(int i = 0;i<playerslist.length ; i++){
      AudioPlayer audioplayer = AudioPlayer();
      audioplayer.play(UrlSource(playerslist[i]['audio']));
      audioplayer.setReleaseMode(ReleaseMode.loop);
      audioplayer.setVolume(double.parse(playerslist[i]['volume'].toString()));
      audioplayers.add(AudioPlayerModel(
          id: playerslist[i]['_id'],
          name: playerslist[i]['title'],
          url: playerslist[i]['audio'],
          image: playerslist[i]['image'],
          player: audioplayer
      ));
    }
   Timer(const Duration(seconds: 4), () { setState(() {
     show = false;
   });});
  }

  
  @override
  void initState() {
    _initAll();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose(){
    for(int i = 0;i<audioplayers.length;i++){
      print('disposing ${audioplayers[i].name}');
      audioplayers[i].player.stop();
      audioplayers[i].player.dispose();
    }
    _timer?.cancel();
    showTimer?.cancel();
    super.dispose();
  }

  bool allplaying = false;

  pauseAll(){
    for(int i = 0;i<audioplayers.length;i++){
      if(audioplayers[i].player.state == PlayerState.playing){
        audioplayers[i].player.pause();
      }
    }
    setState(() {
      allplaying = true;
    });
  }

  stopAll(){
    for(int i = 0;i<audioplayers.length;i++){
      if(audioplayers[i].player.state == PlayerState.playing){
        audioplayers[i].player.stop();
      }
    }
    setState(() {
      allplaying = true;
    });
  }

  playAll(){
    for(int i = 0;i<audioplayers.length;i++){
      setState(() {
        allplaying = audioplayers[i].player.state == PlayerState.playing;
      });
      if(audioplayers[i].player.state == PlayerState.paused){
        audioplayers[i].player.resume();
      }

    }
    setState(() {
      allplaying = false;
    });
  }
  int timeleft  = 0;
  Timer? _timer;
  bool active = true;

  void startTimer(int duration){
    if(_timer !=null){
      if(_timer!.isActive){
        _timer?.cancel();
      }
    }
    playAll();
    _timer = Timer.periodic(const Duration(seconds: 1), ((timer){
     if(timeleft>0){
       if(active == true){
         setState(() {
           timeleft--;
           print('time left $timeleft');
         });
       }
     }
     else{
     pauseAll();
     timer.cancel();
     Components(context).showSuccessSnackBar('Timer Completed');
     HapticFeedback.heavyImpact();
     }
    }));
  }

  bool edited = false;

  bool showVolumeSlider = false;

  bool show = true;

  Timer? showTimer ;


  showOrHideButtons(){
    setState(() {
      show = !show;
      if(showTimer != null ){
        if(showTimer!.isActive){
          showTimer?.cancel();
        }
      }

      showTimer = Timer(const Duration(seconds: 4), () {
        setState(() {
          show = false;
        });
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: hexStringToColor(widget.data['moodId']['colorA']))
      ),
      child: Builder(
        builder: (context) =>
         Scaffold(
          body: Stack(
            children: [
          Positioned.fill(
            child: CachedNetworkImage(imageUrl: widget.data['moodId']["image"],fit: BoxFit.cover,),
          ),
              Positioned.fill(
                  child:  GestureDetector(
                    onTap: (){

                      showOrHideButtons();
                    },
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: (show)?1:0.1,
                      curve: Curves.ease,
                      child: Container(
                        decoration:  BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                hexStringToColor(widget.data['moodId']['colorA']).withOpacity(0.7),
                                hexStringToColor(widget.data['moodId']['colorA']).withOpacity(0.8),
                                hexStringToColor(widget.data['moodId']['colorB']).withOpacity(0.8),
                                hexStringToColor(widget.data['moodId']['colorB']).withOpacity(1)
                                /*Colors.black45,
                                Colors.black38,
                                Colors.black26,
                                Colors.black12,
                                Colors.black26,
                                Colors.black54,*/
                              ]
                          )
                        ),
                      ),
                    ),
                  ),
              ),
              Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(seconds: 1),
                            opacity: show ? 1 : 0.5,
                            curve: Curves.ease,
                            child: Text(widget.data['title'],style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 30,color: Colors.white),)),
                      //  SizedBox(height: 25,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 350),
                              opacity: show?1:0,
                              curve: Curves.ease,
                              child: GestureDetector(
                                onTap: (){
                                  showOrHideButtons();
                                  var temp = 0;
                                  showModalBottomSheet(
                                    // isDismissible : false,
                                    //useRootNavigator: false,
                                      backgroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
                                      context: context, builder: (context) => Wrap(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Set Timer',style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),textAlign: TextAlign.start,),
                                              Components(context).BlurBackgroundCircularButton(icon: Icons.clear,iconSize: 17,buttonRadius: 17,iconColor: Colors.white70,onTap: ()=>Navigator.pop(context))
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 30,),
                                        CupertinoTheme(
                                          data: const CupertinoThemeData(
                                            brightness: Brightness.dark,
                                          ),
                                          child: CupertinoTimerPicker(
                                              mode: CupertinoTimerPickerMode.ms,
                                              initialTimerDuration: (timeleft == 0)?Duration.zero:Duration(seconds: timeleft),
                                              onTimerDurationChanged: (timer){
                                                  temp = timer.inSeconds;
                                              }
                                          ),
                                        ),
                                        const SizedBox(height: 150,),
                                        FilledButton(
                                          onPressed: (){
                                            setState(() {
                                              timeleft = temp;
                                            });
                                            playAll();
                                            startTimer(timeleft);
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shadowColor: Theme.of(context).colorScheme.primary,
                                              fixedSize: Size(MediaQuery.of(context).size.width,kToolbarHeight-5),
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.vertical(top: Radius.circular(15))
                                              ),
                                              elevation: 1
                                          ),
                                          child: const Text('Start Timer'),
                                        )
                                      ]
                                  ));
                                },
                                  child: Components(context).myIconWidget(icon: MyIcons.timer,color: Colors.white70,size: 30)),
                            ),
                            InkWell(
                              onTap: (){
                                  for(int i = 0;i<audioplayers.length;i++){
                                    setState(() {
                                      allplaying = audioplayers[i].player.state == PlayerState.playing;
                                    });
                                    if(allplaying == true){
                                      audioplayers[i].player.pause();
                                    }
                                    else{
                                      audioplayers[i].player.resume();
                                    }
                                  }
                                },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: Colors.white70,
                                    width: 1
                                  ),
                                  shape: BoxShape.circle
                                ),
                                height: 140,
                                width: 140,
                                child:  Icon((allplaying)?Icons.play_arrow_rounded:Icons.pause_rounded,size: 70,color: Colors.white54,),
                              )
                            ),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 350),
                              opacity: show?1:0,
                              curve: Curves.ease,
                              child: GestureDetector(
                                onTap: (){
                                  showOrHideButtons();
                                  showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      enableDrag: true,
                                      context: context,
                                      builder: (context)=>
                                          StatefulBuilder(
                                            builder: (context,setState) =>
                                                ClipRRect(
                                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                                                  child: Container(
                                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
                                                    //height: MediaQuery.of(context).size.height * 0.85,
                                                    child: Wrap(
                                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text('Edit ${widget.data['title']}',style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),textAlign: TextAlign.start,),
                                                              Components(context).BlurBackgroundCircularButton(icon: Icons.clear,iconSize: 17,buttonRadius: 17,iconColor: Colors.white70,onTap: ()=>Navigator.pop(context))
                                                            ],
                                                          ),
                                                        ),
                                                        ListView.builder(
                                                            shrinkWrap: true,
                                                            scrollDirection: Axis.vertical,
                                                            itemCount: audioplayers.length,
                                                            itemBuilder: (context,position){
                                                              return ListTile(
                                                                // minLeadingWidth: MediaQuery.of(context).size.width * 0.25,
                                                                  horizontalTitleGap: 0,
                                                                  contentPadding: const EdgeInsets.all(10),
                                                                  leading: Container(
                                                                    width: MediaQuery.of(context).size.width * 0.17,
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Expanded(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(2),
                                                                            child: AspectRatio(
                                                                                aspectRatio: 1,
                                                                                child: SvgPicture.network(audioplayers[position].image,color: Colors.white,)),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 5,),
                                                                        Text(audioplayers[position].name,style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white,fontSize: 11.5),),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  title: Slider(
                                                                    thumbColor: Theme.of(context).colorScheme.inversePrimary,
                                                                    activeColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
                                                                    //inactiveColor: Colors.grey.shade200.withOpacity(0.35),
                                                                    value: audioplayers[position].player.volume, onChanged: (double value) {setState((){
                                                                    edited = true;
                                                                    audioplayers[position].player.setVolume(value);
                                                                  }) ;},),
                                                                  trailing: Components(context).BlurBackgroundCircularButton(svg: MyIcons.delete,onTap: (){
                                                                    if(audioplayers.length >1 ){
                                                                      setState(()  {
                                                                        audioplayers[position].player.stop();
                                                                        audioplayers[position].player.release();
                                                                        audioplayers[position].player.dispose();
                                                                        audioplayers.removeAt(position);
                                                                      });
                                                                    }
                                                                    else{
                                                                      Navigator.pop(context);
                                                                      Components(context).showErrorSnackBar('There should be Atleast 1 Harmony');
                                                                    }
                                                                    if(audioplayers.isEmpty) {
                                                                      Navigator.pop(context);
                                                                    }
                                                                  })
                                                              );
                                                            }),

                                                      ],
                                                    ),
                                                  ),
                                                ),
                                          )
                                  ).then((value) => setState((){}));
                                },
                                  child: Components(context).myIconWidget(icon: MyIcons.sound,color: Colors.white70,size: 30)),
                            )
                          ],
                        ),
                        Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: timeleft != 0,
                            child: Text(formatDuration(Duration(seconds: timeleft),showHours: timeleft>3599),style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white.withOpacity(0.8)),))
                      ],
                    ),
                  )
              ),
              Positioned(
                top: 40,
                //right: 10,
                left: 10,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 600),
                  opacity: show?1:0.35,
                  curve: Curves.ease,
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: Components(context).BlurBackgroundCircularButton(
                      buttonRadius: 23,
                      icon: Icons.chevron_left,
                      onTap: () => Navigator.pop(context)
                    ),
                  ),
                ),
          ),
              Positioned(
                bottom: 10,
                  right: 1,
                  left: 1,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 350),
                      opacity: show?1:0,
                      curve: Curves.ease,
                      child: Text('For Optimal Immersion, Wear Headphones',style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 14,color: Colors.white),textAlign: TextAlign.center,)))
            ],
          ),
        ),
      ),
    );
  }
  String formatDuration(Duration duration, {bool showHours = true}) {
    final hours = duration.inHours;
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    if (showHours) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }


}
