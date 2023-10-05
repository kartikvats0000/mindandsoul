import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:just_audio/just_audio.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:provider/provider.dart';

import '../../../../constants/iconconstants.dart';
import '../../../../helper/components.dart';
import '../../../../provider/playerProvider.dart';


class WellnessPlayer extends StatefulWidget {
  const WellnessPlayer({super.key});

  @override
  State<WellnessPlayer> createState() => _WellnessPlayerState();
}

class _WellnessPlayerState extends State<WellnessPlayer> {

  bool showVolumeSlider = false;

  @override
  Widget build(BuildContext context) {
    return Consumer2<MusicPlayerProvider,ThemeProvider>(
        builder: (context,musicPlayerProvider,theme,child) {
          return GestureDetector(
            child: Scaffold(
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
                    child: RotatedBox(quarterTurns: -1,child: Components(context).BlurBackgroundCircularButton(
                      icon: Icons.chevron_left,
                      onTap: (){Navigator.pop(context);},
                    ),),
                  ),
                  actions: [
                    Padding(padding: const EdgeInsets.all(5),child:Components(context).BlurBackgroundCircularButton(svg: MyIcons.favorite),),
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
                    decoration: const BoxDecoration(
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
                                      Components(context).BlurBackgroundCircularButton(
                                          backgroundColor: (musicPlayerProvider.audioPlayer.loopMode == LoopMode.all)?Colors.white38:Colors.black38,
                                          buttonRadius: 28,
                                          onTap: (){
                                            setState((){
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
                                              child: SpinKitSpinningLines(color: Theme.of(context).colorScheme.primary),
                                            );
                                          } else if (playing != true) {
                                            return  Components(context).BlurBackgroundCircularButton(
                                                buttonRadius: 28,
                                                onTap: (){

                                                  musicPlayerProvider.audioPlayer.play();

                                                },
                                                icon:Icons.play_arrow_rounded,
                                                iconSize: 28
                                            );
                                          } else if (processingState !=
                                              ProcessingState.completed) {
                                            return  Components(context).BlurBackgroundCircularButton(
                                                buttonRadius: 28,
                                                onTap: (){
                                                  musicPlayerProvider.pause();
                                                },
                                                icon:Icons.pause_rounded,
                                                iconSize: 28
                                            );
                                          } else {
                                            return  Components(context).BlurBackgroundCircularButton(
                                                buttonRadius: 28,
                                                onTap: (){

                                                },
                                                icon: (musicPlayerProvider.audioPlayer.playerState.playing == false)?Icons.play_arrow_rounded:Icons.pause,
                                                iconSize: 28
                                            );
                                          }
                                        },
                                      ),
                                      /*Components(context).BlurBackgroundCircularButton(
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
                                      Components(context).BlurBackgroundCircularButton(
                                          onTap: (){
                                            setState((){
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
                                    setState((){
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
            ),
          );
        }

    );
  }
}
