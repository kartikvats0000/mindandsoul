import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mindandsoul/provider/userProvider.dart';
import 'package:mindandsoul/screen/ui/auth/login.dart';
import 'package:mindandsoul/screen/ui/home/bottomNavigationbarScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/themeProvider.dart';
import '../../services/services.dart';
import 'home/navscreens/Home.dart';



class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin{

  late AnimationController motionController;
  late Animation motionAnimation;
  double size = 20;



  static const androidIdPlugin = AndroidId();
  var androidId = '';
  var iosId = '';

  String deviceId = "", deviceType = "",fcmToken = "";

  setTheme()async{
    //Get all themes from JSON
    var data =  await Services().getThemes();
    print(data);
    ThemeProvider theme = Provider.of<ThemeProvider>(context,listen: false);
    await theme.addThemes(data);
   //await theme.updateBaseURL(data['base_url']);
    // }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var _theme = sharedPreferences.getString('defaultTheme');
    if(_theme == null){
      print(theme.themesList[0]);
      await theme.updateTheme(theme.themesList[1]);
    }
    else{
      await theme.updateTheme(json.decode(_theme));
    }

  }
  String madewithlovetext = '';

  @override
  void initState() {

    Future.delayed(Duration(seconds: 1),(){
      setState(() {
        madewithlovetext = 'Crafted with ❤️ by Rajmith';
      });
    });
    motionController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
      lowerBound: 0.5,
    );

    motionAnimation = CurvedAnimation(
      parent: motionController,
      curve: Curves.ease,
    );

    motionController.forward();
    motionController.addStatusListener((status) {
      setState(() {
        if (status == AnimationStatus.completed) {
          motionController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          motionController.forward();
        }
      });
    });

    motionController.addListener(() {
      setState(() {
        size = motionController.value * 200;
      });
    });
    setTheme();
    getdevicedata();
    getData();

    super.initState();
  }

  @override
  void dispose() {
    motionController.dispose();
    super.dispose();
  }

  getdevicedata() async {
    //device type and device id
    if (Platform.isAndroid) {
      deviceType = 'android';
      try {
        androidId = await androidIdPlugin.getId() ?? 'Unknown ID';
        print('android id $androidId');
      } on PlatformException {
        androidId = 'Failed to get Android ID.';
      }
      if (!mounted) return;

      setState(() {
        deviceId = androidId;
        deviceType = "android";
      });
    }
    else if (Platform.isIOS) {
      deviceType = "ios";
      try{
        var iosInfo = await DeviceInfoPlugin().iosInfo;
        iosId = iosInfo.identifierForVendor!;
      }
      on PlatformException{
        debugPrint('Cannot get ios id');
      }
    }

    //fcm token
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        provisional: false,
        sound: true
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized){
      await firebaseMessaging.getToken().then((value) {
        fcmToken = value!;
        debugPrint('my token value is $value');
      }
      );
    }
    if (settings.authorizationStatus == AuthorizationStatus.provisional){
      await firebaseMessaging.getToken().then((value) {
        fcmToken = value!;
        debugPrint('my token value is $value');
      }
      );
    }
    else{
      print('user Denied');
    }

    //hitting api
    var data = await Services().splashApi({
      'deviceId' : deviceId,
      'deviceType' : deviceType,
      'fcmToken' : fcmToken
    });

    User user = Provider.of<User>(context,listen: false);


    await user.updateSplashData(deviceId, fcmToken);
    print(user.deviceId);
  }

  getData() async {
    User user = Provider.of<User>(context,listen: false);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data = await sharedPreferences.getString('loginData');

    if(data == null){
      Timer(const Duration(seconds: 4), () =>Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) =>Login()))));
    }
    else{
      await user.fromJson(json.decode(data));
      await user.updateLoginStatus(true);
      Timer(const Duration(seconds: 4), () =>Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) =>BottomNavScreen()))));
    }


  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,theme,child) =>
       Scaffold(
         backgroundColor: theme.themeColorA.withOpacity(0.3),
        extendBody: true,
        body: Stack(
          children: [
            AnimatedContainer(
              alignment: Alignment.center,
              duration: Duration(milliseconds: 555),
              color: theme.themeColorB.withOpacity(0.35),
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(50),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: theme.themeColorB.withOpacity(0.55),blurRadius: 200,spreadRadius: 200
                    )
                  ],
                    shape: BoxShape.circle,
                    //color: theme.themeColorB.withOpacity(0.1)
                ),
                child:  Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    //color: theme.themeColorB.withOpacity(0.95)
                  ),
                  height: size,
                  child: Image.asset('assets/logo/mindnsoul_white.png'),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
                right: 0,
                left: 0,
                child: AnimatedOpacity(
                  duration: Duration(seconds: 1),
                    opacity: madewithlovetext=='' ? 0 : 1,
                    child: Text(madewithlovetext,textAlign: TextAlign.center,style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white60,
                      fontSize: 16
                    ),))
            )
          ],
        ),
      ),
    );
  }
}
