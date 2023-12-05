import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mindandsoul/provider/userProvider.dart';
import 'package:mindandsoul/screen/ui/auth/login.dart';
import 'package:mindandsoul/screen/ui/home/bottomNavigationbarScreen.dart';
import 'package:mindandsoul/screen/ui/selectlanguage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../provider/themeProvider.dart';
import '../../services/services.dart';



class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin{

 /* late AnimationController motionController;
  late Animation motionAnimation;
  double size = 20;*/



  /*static const androidIdPlugin = AndroidId();
  var androidId = '';
  var iosId = '';*/

  String deviceId = "", deviceType = "",fcmToken = "";

  setTheme()async{

    //Get all themes from JSON
    var data =  await Services('').getThemes();

    ThemeProvider theme = Provider.of<ThemeProvider>(context,listen: false);
    await theme.addThemes(data);
   //await theme.updateBaseURL(data['base_url']);
    // }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var _theme = sharedPreferences.getString('defaultTheme');
    if(_theme == null){
      print('No default theme');
      await theme.updateTheme(theme.themesList[0]);
    }
    else{
      print('already has theme');
      await theme.updateTheme(json.decode(_theme));
    }

  }

  late VideoPlayerController videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    setState(() {
      videoPlayerController = VideoPlayerController.asset('assets/splash/splash.mp4',videoPlayerOptions: VideoPlayerOptions());
      _initializeVideoPlayerFuture = videoPlayerController.initialize();

    });
  //  initVideo();
    setTheme();
    //getdevicedata();
    getData();

    super.initState();
  }


   initVideo(){
    //ThemeProvider themeProvider = Provider.of<ThemeProvider>(context,listen: false);
    //MusicPlayerProvider player = Provider.of<MusicPlayerProvider>(context,listen: false);
    videoPlayerController = VideoPlayerController.asset('assets/splash/splash.mp4')..initialize()
        .then((_) {
      /*setState(() {
        videoPlayerController.play();
      });*/
     /* videoPlayerController.addListener(() async{
        if(videoPlayerController.value.position == videoPlayerController.value.duration) {
          await setTheme();
          getData();
        }
      });*/
    });


   // videoPlayerController.setVolume(0.60);

  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }



  getData() async {
    User user = Provider.of<User>(context, listen: false);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data = sharedPreferences.getString('loginData');
    var lang = sharedPreferences.getString('lang');

    await user.getAllLanguages();

    /*notificationService.requestNotificationPermission();
    notificationService.firebaseInit(context);
    notificationService.isTokenFresh();
    notificationService.getDeviceToken().then((value) {
      print('hello token-----$value');
      fcmToken = value!;
    });*/
   // await user.updateSplashData(deviceId, fcmToken);
    if (data == null) {
      if(lang == null){
        user.changeUserLanguage('en');
        Timer(
            const Duration(milliseconds: 6200),
                () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: ((context) =>  SelectLanguage(source: 'Splash',)))));
      }
      else{
        user.changeUserLanguage(lang);
        Timer(
            const Duration(milliseconds: 6200),
                () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: ((context) => const Login()))));
      }
    }
    else {
      user.changeUserLanguage((lang == null) ? 'en':lang );
      print(data);
      await user.fromJson(json.decode(data));
      await user.updateLoginStatus(true);
      print('my token ${user.token}');
      Timer(
          const Duration(milliseconds: 6200),
              () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: ((context) => const BottomNavScreen()))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,theme,child) =>
       Scaffold(
         backgroundColor: theme.themeColorA,
        extendBody: true,
        body: SizedBox.expand(
          child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context,snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                videoPlayerController.play();
                return Stack(
                  children: [
                    Positioned.fill(child: VideoPlayer(videoPlayerController)),
                    Positioned(
                      bottom: 85,
                        child: Visibility(
                          visible: videoPlayerController.value.duration == videoPlayerController.value.position,
                            child: const SpinKitSpinningLines(color: Colors.deepOrangeAccent,)))
                  ],
                );
              }
              else{
                return Container();
              }

            }
          ),
        )
      ),
    );
  }
}
