import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../provider/playerProvider.dart';


String _getDurationString(Duration duration) {
  String minutes = duration.inMinutes.toString().padLeft(2,'0');
  String seconds = (duration.inSeconds % 60).toString().padLeft(2,'0');

  if (minutes == 0) {
    return '00:$seconds';
  } else {
    return '$minutes:$seconds';
  }
}

class Components{
  BuildContext context;

  Components(this.context);

  BlurBackgroundCircularButton({
    required IconData icon,
    VoidCallback? onTap,
    double buttonRadius = 20,
    double iconSize = 22,

  }){
    return ClipRRect(
      borderRadius: BorderRadius.circular(45),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: CircleAvatar(
          backgroundColor:Colors.black38,
          //Colors.black54.withOpacity(0.75),
          radius: buttonRadius,
          child: InkWell(
            onTap: onTap,
            child: Icon(
              icon,color: Colors.white.withOpacity(0.9),size: iconSize,
            ),
            //child: SvgPicture.asset('assets/home/menu.svg',color: Colors.white,height: 20,width: 20,),
          ),
        ),
      ),
    );
  }

  showSuccessSnackBar(String content){
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(content),
      elevation: 0.0,
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.9),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 6),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.inversePrimary, width: 0.75),
        borderRadius: BorderRadius.circular(24),
      ),
    )
    );
  }

  showErrorSnackBar(String content){
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(content),
      elevation: 0.0,
      backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.65),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 6),
      onVisible: (){},
      shape:RoundedRectangleBorder(
        side: BorderSide(color: Colors.redAccent, width: 0.75),
        borderRadius: BorderRadius.circular(24),
      ),
    )
    );
  }

  showPlayerSheet(){
    final ThemeProvider theme = Provider.of<ThemeProvider>(context,listen: false);
    showModalBottomSheet(
      isScrollControlled : true,
      context: context,
      builder: (context) =>Consumer<MusicPlayerProvider>(
        builder: (context,musicPlayerProvider,child) =>
            Scaffold(
              backgroundColor: theme.themeColorA,
              extendBodyBehindAppBar: true,
              extendBody: true,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight+40),
                child: AppBar(
                  toolbarHeight: kToolbarHeight+40,
                  backgroundColor: Colors.transparent,
                 automaticallyImplyLeading: false,
                  title: RotatedBox(quarterTurns: -1,child: Components(context).BlurBackgroundCircularButton(
                    icon: Icons.chevron_left ,
                    onTap: (){Navigator.pop(context);},
                  ),),
                  actions: [
                    Padding(padding: const EdgeInsets.all(5),child: Components(context).BlurBackgroundCircularButton(icon: Icons.bookmark),)
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                      flex: 7,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                          child: Image.network(musicPlayerProvider.currentTrack!.thumbnail,fit: BoxFit.cover,))
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.themeColorA,
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                theme.themeColorA,
                                theme.themeColorB
                              ]
                          ),
                          //backgroundBlendMode: BlendMode.color,
                          boxShadow: [
                            BoxShadow(
                                color: theme.themeColorA,
                                blurRadius: 50,
                                spreadRadius: 85,
                                blurStyle: BlurStyle.normal
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: Text(musicPlayerProvider.currentTrack!.title,style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                fontSize: 27,
                                color: theme.textColor,
                                fontWeight: FontWeight.w900
                              ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                          Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Slider(
                                                value: musicPlayerProvider.position.inSeconds/musicPlayerProvider.duration.inSeconds,
                                                onChanged: (value){
                                                  musicPlayerProvider.seek(Duration(milliseconds:(musicPlayerProvider.duration.inSeconds * value * 1000).toInt()));
                                                }
                                            ),
                                            Text("    ${_getDurationString(musicPlayerProvider.position)} / ${_getDurationString(musicPlayerProvider.duration)} ",style: Theme.of(context).textTheme.labelLarge,),
                                          ],
                                        ),),
                                      Expanded(
                                        flex:2,
                                        child: Components(context).BlurBackgroundCircularButton(
                                            buttonRadius: 35,
                                            onTap: (){
                                              if (musicPlayerProvider.audioPlayer.playerState.playing == true) {
                                                musicPlayerProvider.pause();
                                              } else {
                                                musicPlayerProvider.audioPlayer.play();
                                              }
                                            },
                                            icon: (musicPlayerProvider.audioPlayer.playerState.playing == true)?Icons.pause:Icons.play_arrow,
                                            iconSize: 30
                                        ),),

                                    ],
                                  ),
                                  Spacer(),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.6,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.volume_mute_outlined,color: theme.textColor,),
                                          Expanded(child: Slider(
                                              activeColor: Theme.of(context).colorScheme.inversePrimary,
                                              value: musicPlayerProvider.audioPlayer.volume,
                                              onChanged: (value){
                                                //musicPlayerProvider.seek(Duration(milliseconds:(musicPlayerProvider.duration.inSeconds * value * 1000).toInt()));
                                                musicPlayerProvider.audioPlayer.setVolume(value);
                                              }
                                          ),),
                                          Icon(Icons.volume_up_outlined,color: theme.textColor,),
                                        ],
                                      )),
                                ],
                              ))
                          ],
                        )

                    ),
                  )
                ],
              ),
            ),
      ),
    );
  }
}

