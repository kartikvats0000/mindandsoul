import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindandsoul/provider/userProvider.dart';
import 'package:mindandsoul/screen/ui/auth/login.dart';
import 'package:mindandsoul/screen/ui/home/bottomNavigationbarScreen.dart';
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

  late AnimationController motionController;
  late Animation motionAnimation;
  double size = 20;



  /*static const androidIdPlugin = AndroidId();
  var androidId = '';
  var iosId = '';*/

  String deviceId = "", deviceType = "",fcmToken = "";

  setTheme()async{
    //Get all themes from JSON
    var data =  await Services().getThemes();

    ThemeProvider theme = Provider.of<ThemeProvider>(context,listen: false);
    await theme.addThemes(data);
   //await theme.updateBaseURL(data['base_url']);
    // }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var _theme = sharedPreferences.getString('defaultTheme');
    if(_theme == null){

      await theme.updateTheme(theme.themesList[0]);
    }
    else{
      await theme.updateTheme(json.decode(_theme));
    }

  }

  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    initVideo();
    setTheme();
   // getdevicedata();
    getData();

    super.initState();
  }


  void initVideo(){
    /*ThemeProvider themeProvider = Provider.of<ThemeProvider>(context,listen: false);
    MusicPlayerProvider player = Provider.of<MusicPlayerProvider>(context,listen: false);*/
    videoPlayerController = VideoPlayerController.asset('assets/splash/splash.mp4')..initialize()
        .then((_) {
      videoPlayerController.play();
      videoPlayerController.addListener(() {
        if(videoPlayerController.value.position == videoPlayerController.value.duration) {
          print('video Ended');
        }
      });
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
    /*notificationService.requestNotificationPermission();
    notificationService.firebaseInit(context);
    notificationService.isTokenFresh();
    notificationService.getDeviceToken().then((value) {
      print('hello token-----$value');
      fcmToken = value!;
    });*/
   // await user.updateSplashData(deviceId, fcmToken);
    if (data == null) {
      Timer(
          const Duration(milliseconds: 6500),
              () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: ((context) => Login()))));
    } else {
      print(data);
      await user.fromJson(json.decode(data));
      await user.updateLoginStatus(true);

      Timer(
          const Duration(milliseconds: 6500),
              () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: ((context) => BottomNavScreen()))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,theme,child) =>
       Scaffold(
         backgroundColor: theme.themeColorA.withOpacity(0.3),
        extendBody: true,
        body: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: videoPlayerController.value.size.width,
              height: videoPlayerController.value.size.height,
              child: VideoPlayer(
                videoPlayerController
              ),
            ),
          ),
        )
      ),
    );
  }
}
