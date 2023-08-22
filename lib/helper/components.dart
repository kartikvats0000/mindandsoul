import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:provider/provider.dart';

import '../constants/iconconstants.dart';
import '../provider/playerProvider.dart';


export 'contentviewroute.dart';


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

  Widget myIconWidget({required String icon, Color color = Colors.white70, double size = 23}){
    return SvgPicture.asset(icon,color: color,height: size,width: size,);
  }

  Widget tags(
      {required String title, required BuildContext context, Color textcolor = Colors.white}) {
    ThemeProvider theme = Provider.of<ThemeProvider>(context,listen: false);
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
    IconData? icon,
    String? svg,
    VoidCallback? onTap,
    double buttonRadius = 20,
    double iconSize = 22,
  })
  {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(45),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: CircleAvatar(
            backgroundColor:Colors.black38,
            //Colors.black54.withOpacity(0.75),
            radius: buttonRadius,
            child: (svg == null)
                ?Icon(icon,color: Colors.white.withOpacity(0.9),size: iconSize,)
                :Components(context).myIconWidget(icon: svg,color: Colors.white.withOpacity(0.9))
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
        side: const BorderSide(color: Colors.redAccent, width: 0.75),
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
                    Padding(padding: const EdgeInsets.all(5),child: Components(context).BlurBackgroundCircularButton(svg: MyIcons.favorite),)
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                      flex: 7,
                      child: SizedBox(
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
                                    const Spacer(),
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

