import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:just_audio/just_audio.dart';

import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:provider/provider.dart';

import '../constants/iconconstants.dart';
import '../provider/playerProvider.dart';


export 'contentviewroute.dart';



class Components{
  BuildContext context;

  Components(this.context);

  bool showVolumeSlider = false;

  Widget customAppBar({
    required List<Widget> actions ,
    Color topColor = Colors.transparent,
    Color scrolledColor = Colors.white54,
    required Widget title,
    required bool isScrolling,
    Duration duration = const Duration(milliseconds: 450)
  }){
    return ClipRRect(
      child: BackdropFilter(
        filter: (isScrolling)?ImageFilter.blur(sigmaY: 10,sigmaX: 10):ImageFilter.dilate(),
        child: AnimatedContainer(
          duration: duration,
          color: (isScrolling)?scrolledColor:topColor,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+10,bottom: 13,left: 7,right: 7),
          child: Row(
          children: [
            Components(context).BlurBackgroundCircularButton(icon: Icons.chevron_left,onTap: (){
              Navigator.pop(context);
            }),
            const SizedBox(width: 10,),
            Expanded(
                child: AnimatedOpacity(
                  duration: duration,
                    opacity: (isScrolling)?1:0,
                    child: title)
            ),
            const SizedBox(width: 7,),
            Row(
              children: actions,
            )
          ],
        ),
        //  height: kToolbarHeight+25,
        ),
      ),
    );
  }

  Widget myIconWidget({required String icon, Color color = Colors.white70, double size = 23}){
    return SvgPicture.asset(icon,color: color,height: size,width: size,);
  }

  Widget tags({required String title, required BuildContext context, Color textcolor = Colors.white})
  {ThemeProvider theme = Provider.of<ThemeProvider>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 5,sigmaX: 5),
        child: Container(
          //height: 25,
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black12,
            border: Border.all(
                width: 0.4,
                color: theme.textColor
            ),
            borderRadius: BorderRadius.circular(15),

          ),
          child: Text(title, style: Theme
              .of(context)
              .textTheme
              .bodySmall
              ?.copyWith(
              color: textcolor.withOpacity(0.9),
              fontWeight: FontWeight.w900,
              fontSize: 11
          ),),
        ),
      ),
    );
  }

  Widget Loader({String title = 'Patience Breeds\nPeace',required Color textColor}){
    return Center(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitSpinningLines(color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 15,),
            Text(title,style: TextStyle(
                color: textColor
            ),textAlign: TextAlign.center,)
          ],
        ));
  }

  Widget WeatherDetailCard(String title, String value){
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context,listen: false);
    return Container(
      //  height: 20,
      padding: const EdgeInsets.all(7),
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.825),
          borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: const TextStyle(color: Colors.white70,fontSize: 12),),
          const SizedBox(height: 5,),
          Text(value,style: TextStyle(color: themeProvider.textColor,fontSize: 14,fontWeight: FontWeight.w600),),
        ],
      ),
    );
  }

  Widget WeatherDetailCard2(String title, String value){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(title,style: TextStyle(color: Colors.grey.shade700,fontSize: 12,fontWeight: FontWeight.w600),)),
        Text(value,style: const TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w700),),
      ],
    );
  }

  Widget BlurBackgroundCircularButton({
    Color iconColor =  Colors.white,
    IconData? icon,
    String? svg,
    VoidCallback? onTap,
    double buttonRadius = 20,
    double iconSize = 22,
    Color backgroundColor = Colors.black38
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: CircleAvatar(
            backgroundColor:backgroundColor,
            //Colors.black54.withOpacity(0.75),
            radius: buttonRadius,
            child: (svg == null)
                ?Icon(icon,color: iconColor,size: iconSize,)
                :Components(context).myIconWidget(icon: svg,color: iconColor,size: iconSize)
          ),
        ),
      ),
    );
  }

  showSuccessSnackBar(String content, {EdgeInsetsGeometry margin = const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0)}){
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(
          padding: const EdgeInsets.all(18.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            gradient:  LinearGradient(
              colors: [Theme.of(context).colorScheme.secondary.withOpacity(0.9),Theme.of(context).colorScheme.primary,], // Define your gradient colors
              begin: Alignment.centerLeft, // Adjust the gradient's starting position
              end: Alignment.centerRight, // Adjust the gradient's ending position
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(content,style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),),
        ),
      margin: margin,
      padding: const EdgeInsets.all(0),
      elevation: 0.0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 4),
      shape: RoundedRectangleBorder(
       // side: BorderSide(color: Theme.of(context).colorScheme.inversePrimary, width: 0.75),
        borderRadius: BorderRadius.circular(13),
      ),
    )
    );
  }

  showErrorSnackBar(String content){
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      padding: const EdgeInsets.all(0),
      content: Container(
        padding: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [ Color(0xff800000),Color(0xffD32121)], // Define your gradient colors
            begin: Alignment.centerLeft, // Adjust the gradient's starting position
            end: Alignment.centerRight, // Adjust the gradient's ending position
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(content,style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),),
      ),
      elevation: 0.0,
      backgroundColor: Theme.of(context).colorScheme.error,
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 4),
      onVisible: (){},
      shape:RoundedRectangleBorder(
       //side: const BorderSide(color: Colors.redAccent, width: 0.75),
        borderRadius: BorderRadius.circular(13),
      ),
    )
    );
  }
  showPlayerSheet(){
    final ThemeProvider theme = Provider.of<ThemeProvider>(context,listen: false);
    showModalBottomSheet(
      isScrollControlled : true,
      context: context,
      builder: (context) =>StatefulBuilder(
        builder: (context,_setState) =>
            Consumer<MusicPlayerProvider>(
                builder: (context,musicPlayerProvider,child) {
                  return Scaffold(
                    backgroundColor: theme.themeColorA,
                    extendBodyBehindAppBar: true,
                    extendBody: true,
                    appBar: PreferredSize(
                      preferredSize: const Size.fromHeight(kToolbarHeight+40),
                      child: AppBar(
                        toolbarHeight: kToolbarHeight+40,
                        backgroundColor: Colors.transparent,
                        automaticallyImplyLeading: false,
                        leading:  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RotatedBox(quarterTurns: -1,child: BlurBackgroundCircularButton(
                            icon: Icons.chevron_left ,
                            onTap: (){Navigator.pop(context);},
                          ),),
                        ),
                        actions: [
                          Padding(padding: const EdgeInsets.all(5),child:BlurBackgroundCircularButton(svg: MyIcons.favorite),),
                        ],
                      ),
                    ),
                    body: Stack(
                      children: [
                        Positioned.fill(child: CachedNetworkImage(imageUrl: musicPlayerProvider.currentTrack!.gif,fit: BoxFit.cover,
                          placeholder: (context,url) => Image.network(musicPlayerProvider.currentTrack!.thumbnail,fit: BoxFit.cover,),
                        )
                        ),
                        Positioned.fill(child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black26
                          ),
                        ),),
                        Positioned.fill(
                          child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    //color: Colors.red,
                                    padding: const EdgeInsets.only(top: 125),
                                    child: Column(
                                      children: [
                                        Text(musicPlayerProvider.currentTrack!.title,style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                            fontSize: 27,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900
                                        ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 15,),
                                        Text('${musicPlayerProvider.duration.inMinutes} Minutes ${musicPlayerProvider.duration.inSeconds%60} Seconds Healing',style: Theme.of(context).textTheme.labelLarge?.copyWith(

                                            color: Colors.white.withOpacity(0.7),
                                            fontWeight: FontWeight.w900
                                        ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical:10),
                                    decoration: BoxDecoration(
                                        color: Colors.black38,
                                        borderRadius: BorderRadius.circular(25)
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            //SizedBox(width: 25,),
                                            BlurBackgroundCircularButton(
                                                backgroundColor: (musicPlayerProvider.audioPlayer.loopMode == LoopMode.all)?Colors.white38:Colors.black38,
                                                buttonRadius: 28,
                                                onTap: (){
                                                  _setState((){
                                                    (musicPlayerProvider.audioPlayer.loopMode == LoopMode.off)?musicPlayerProvider.audioPlayer.setLoopMode(LoopMode.all):musicPlayerProvider.audioPlayer.setLoopMode(LoopMode.off);
                                                    // showSuccessSnackBar('Loop Mode ${(musicPlayerProvider.audioPlayer.loopMode == LoopMode.off)?'off':'on'}');
                                                  });
                                                },
                                                svg: MyIcons.loop,
                                                iconColor: (musicPlayerProvider.audioPlayer.loopMode == LoopMode.all)?Colors.black:Colors.white,
                                                iconSize: 28
                                            ),
                                            StreamBuilder<just_audio.PlayerState>(
                                                stream: musicPlayerProvider.audioPlayer.playerStateStream,
                                              builder: (context, snapshot) {
                                                final playerState = snapshot.data;
                                                final processingState =
                                                    playerState?.processingState;
                                                final playing = playerState?.playing;
                                                if (processingState == ProcessingState.loading ||
                                                    processingState ==
                                                        ProcessingState.buffering) {
                                                  return SizedBox(
                                                    height: 50,
                                                    width: 50,
                                                    child: const CircularProgressIndicator(),
                                                  );
                                                } else if (playing != true) {
                                                  return  BlurBackgroundCircularButton(
                                                      buttonRadius: 28,
                                                      onTap: (){

                                                          musicPlayerProvider.audioPlayer.play();

                                                      },
                                                      icon:Icons.play_arrow_rounded,
                                                      iconSize: 28
                                                  );
                                                } else if (processingState !=
                                                    ProcessingState.completed) {
                                                  return  BlurBackgroundCircularButton(
                                                      buttonRadius: 28,
                                                      onTap: (){
                                                          musicPlayerProvider.pause();
                                                      },
                                                      icon:Icons.pause,
                                                      iconSize: 28
                                                  );
                                                } else {
                                                  return  BlurBackgroundCircularButton(
                                                      buttonRadius: 28,
                                                      onTap: (){

                                                      },
                                                      icon: (musicPlayerProvider.audioPlayer.playerState.playing == false)?Icons.play_arrow_rounded:Icons.pause,
                                                      iconSize: 28
                                                  );
                                                }
                                              },
                                            ),
                                            /*BlurBackgroundCircularButton(
                                                buttonRadius: 28,
                                                onTap: (){
                                                  if (musicPlayerProvider.audioPlayer.playerState.playing == true) {
                                                    musicPlayerProvider.pause();
                                                  } else {
                                                    musicPlayerProvider.audioPlayer.play();
                                                  }
                                                },
                                                icon: (musicPlayerProvider.audioPlayer.playerState.playing == false)?Icons.play_arrow_rounded:Icons.pause,
                                                iconSize: 28
                                            ),*/
                                            BlurBackgroundCircularButton(
                                                onTap: (){
                                                  _setState((){
                                                    showVolumeSlider = !showVolumeSlider;
                                                  });
                                                },
                                              iconSize: 28,
                                              buttonRadius: 28,
                                                svg: (musicPlayerProvider.audioPlayer.volume>0)?MyIcons.volume_high:MyIcons.volume_low),

                                            // SizedBox(width: 25,),
                                          ],
                                        ),
                                        /*  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Row(
                                      children: [
                                        Text(getDurationString(musicPlayerProvider.position),style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),),
                                        Expanded(
                                          child: Slider(
                                              min: 0.0,
                                              value: musicPlayerProvider.duration.inSeconds.isNaN==true ? 0 :musicPlayerProvider.position.inSeconds/musicPlayerProvider.duration.inSeconds,
                                              onChanged: (value){
                                                musicPlayerProvider.seek(Duration(milliseconds:(musicPlayerProvider.duration.inSeconds * value * 1000).toInt()));
                                              }
                                          ),
                                        ),
                                        Text(getDurationString(musicPlayerProvider.duration),style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),),
                                      ],
                                    ),
                                  ),*/
                                      ],
                                    ),
                                  ),
                                  //const SizedBox(height: 20,)
                                ],
                              )

                          ),
                        ),
                        AnimatedPositioned(
                            bottom: 120,
                            right: (showVolumeSlider)?5:-50, duration: const Duration(milliseconds: 300),
                            child: Container(
                              width: 50,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(25)
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Components(context).myIconWidget(icon: MyIcons.volume_high),
                                  RotatedBox(
                                    quarterTurns: -1,
                                    child:  Slider(
                                        activeColor: Theme.of(context).colorScheme.inversePrimary,
                                        value: musicPlayerProvider.audioPlayer.volume,
                                        onChanged: (value){
                                          _setState((){
                                            musicPlayerProvider.audioPlayer.setVolume(value);
                                          });
                                          //musicPlayerProvider.seek(Duration(milliseconds:(musicPlayerProvider.duration.inSeconds * value * 1000).toInt()));

                                        }
                                    ),
                                  ),
                                  Components(context).myIconWidget(icon: MyIcons.volume_low),

                                ],
                              ),
                            ))
                      ],
                    ),
                  );
                }

            ),
      ),
    );
  }

  confirmationDialog(BuildContext context,{
    required String title,
    required String message,
    required List<Widget> actions,
  }) => ClipRRect(
    borderRadius: BorderRadius.circular(15),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
      child: AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.65),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
        title: Text(title),
        content: Text(message),
        titleTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 19,fontWeight: FontWeight.w700),
        actions: actions
      ),
    ),
  );

}

String getDurationString(Duration duration) {
  String minutes = duration.inMinutes.toString().padLeft(2,'0');
  String seconds = (duration.inSeconds % 60).toString().padLeft(2,'0');

  if (minutes == 0) {
    return '00:$seconds';
  } else {
    return '$minutes:$seconds';
  }
}


