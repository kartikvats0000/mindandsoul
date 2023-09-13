import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindandsoul/constants/iconconstants.dart';
import 'package:mindandsoul/helper/components.dart';
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
    print(playerslist[1]['volume'].runtimeType);
    for(int i = 0;i<playerslist.length ; i++){
      AudioPlayer audioplayer = AudioPlayer();
      audioplayer.play(UrlSource(playerslist[i]['audio']));
      audioplayer.setReleaseMode(ReleaseMode.loop);
      audioplayer.setVolume(playerslist[i]['volume']);
      audioplayers.add(AudioPlayerModel(
          id: playerslist[i]['_id'],
          name: playerslist[i]['name'],
          url: playerslist[i]['audio'],
          image: playerslist[i]['icon'],
          player: audioplayer));
    }
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
       setState(() {
         allplaying = false;
       });

     }
    }));
  }

  bool edited = false;

  bool showVolumeSlider = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(int.parse('0xff${widget.data['themeColorA']}')))
      ),
      child: Builder(
        builder: (context) =>
         Scaffold(
          body: Stack(
            children: [
          Positioned.fill(
            child: CachedNetworkImage(imageUrl: widget.data["image"],fit: BoxFit.cover,),
          ),
              Positioned.fill(
                  child:  ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 7.5,sigmaX: 7.5),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black45,
                              Colors.black38,
                              Colors.black26,
                              Colors.black12,
                              Colors.black26,
                              Colors.black54,
                            ]
                        )
                      ),
                    ),
                  )
        ),
              ),
              Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(widget.data['title'],style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 30,color: Colors.white),),
                      //  SizedBox(height: 25,),
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
                          child: CircleAvatar(
                            radius: 71,
                            backgroundColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.7),
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.55),
                              radius: 70,
                              child: Icon((allplaying)?Icons.play_arrow_rounded:Icons.pause_rounded,size: 70,color: Colors.black54,),
                            ),
                          ),
                        ),
                        // Components(context).BlurBackgroundCircularButton(icon: (allplaying)?Icons.play_arrow_rounded:Icons.pause_rounded,
                        //     buttonRadius: 70,
                        //     iconSize: 65,
                        //     onTap: (){
                        //   for(int i = 0;i<audioplayers.length;i++){
                        //     setState(() {
                        //       allplaying = audioplayers[i].player.state == PlayerState.playing;
                        //     });
                        //     if(allplaying == true){
                        //       audioplayers[i].player.pause();
                        //     }
                        //     else{
                        //       audioplayers[i].player.resume();
                        //     }
                        //   }
                        // }
                        // ),
                        //SizedBox(height: 25,),
                        Column(
                          children: [
                            _buildButton(ontap: (){
                              var temp = 0;
                              showModalBottomSheet(
                               // isDismissible : false,
                               //useRootNavigator: false,
                               backgroundColor: Color(int.parse('0xff${widget.data['themeColorB']}')),
                                  context: context, builder: (context) => Wrap(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Set Timer',style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black.withOpacity(0.8)),textAlign: TextAlign.start,),
                                        Components(context).BlurBackgroundCircularButton(icon: Icons.clear,iconSize: 17,buttonRadius: 17,iconColor: Colors.white70,onTap: ()=>Navigator.pop(context))
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 30,),
                                  CupertinoTimerPicker(
                                      mode: CupertinoTimerPickerMode.hms,
                                      initialTimerDuration: (timeleft == 0)?Duration.zero:Duration(seconds: timeleft!),
                                      onTimerDurationChanged: (timer){ temp = timer.inSeconds;}
                                  ),
                                  const SizedBox(height: 100,),
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
                            }, icon: Components(context).myIconWidget(icon: MyIcons.timer,color: Theme.of(context).colorScheme.onSurface), label: (timeleft == 0)?'Timer':formatDuration(Duration(seconds: timeleft),showHours: timeleft>3599)),
                            const SizedBox(height: 15,),
                            _buildButton(
                                ontap: (){
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
                                                  child: BackdropFilter(
                                                    filter: ImageFilter.blur(sigmaY: 10,sigmaX: 10),
                                                    child: Container(
                                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
                                                      //height: MediaQuery.of(context).size.height * 0.85,
                                                      child: Wrap(
                                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text('Edit ${widget.data['title']}',style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white.withOpacity(0.8)),textAlign: TextAlign.start,),
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
                                                                    contentPadding: EdgeInsets.all(10),
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
                                                ),
                                          )
                                  ).then((value) => setState((){}));
                                },
                                icon: Components(context).myIconWidget(icon: MyIcons.edit,color: Theme.of(context).colorScheme.onSurface), label: 'Edit')

                          ],
                        )
                      ],
                    ),
                  )
              ),
              Positioned(
                top: 40,
                //right: 10,
                left: 10,
                child: RotatedBox(
                  quarterTurns: -1,
                  child: Components(context).BlurBackgroundCircularButton(
                    buttonRadius: 23,
                    icon: Icons.chevron_left,
                    onTap: () => Navigator.pop(context)
                  ),
                ),
          ),
              Positioned(
                bottom: 10,
                  right: 1,
                  left: 1,
                  child: Text('For Optimal Immersion, Wear Headphones',style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 14,color: Colors.white),textAlign: TextAlign.center,))
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

  _buildButton({required VoidCallback ontap,required Widget icon, required String label}){
    return FilledButton.tonal(
      onPressed: ontap,
      style: FilledButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width * 0.5,kToolbarHeight-5)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 4,
              child:icon,
          ),
          Expanded(
            flex: 6,
              child:  Text(label))],
      ),
    );
  }
}
