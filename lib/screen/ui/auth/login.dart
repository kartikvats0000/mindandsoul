import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/notification/notification_service.dart';
import 'package:mindandsoul/screen/ui/home/bottomNavigationbarScreen.dart';
import 'dart:io' show Platform;

import 'package:mindandsoul/services/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../provider/userProvider.dart';
import '../../../services/services.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  static const androidIdPlugin = AndroidId();
  var androidId = '';
  var iosId = '';

  String deviceId = "", deviceType = "",fcmToken = "";
  NotificationService notificationService  = NotificationService();

  requestToken()async{
    await notificationService.requestNotificationPermission();
    await notificationService.firebaseInit(context);
    await notificationService.isTokenFresh();
    await notificationService.getDeviceToken().then((value) {
      print('hello token-----$value');
      fcmToken = value!;
    });
    User user = Provider.of<User>(context,listen: false);
    await user.updateSplashData(deviceId, fcmToken);

    getdevicedata();
  }

  getdevicedata() async {

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    //device type and device id
    if (Platform.isAndroid) {
      deviceType = 'android';
      try {
        androidId = await androidIdPlugin.getId() ?? 'Unknown ID';
        print('android id -< $androidId');
      } on PlatformException {
        androidId = 'Failed to get Android ID.';
      }
      if (!mounted) return;

      deviceId = androidId;
      deviceType = "android";
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor!;
      deviceType = "ios";
    }

    // if (settings.authorizationStatus == AuthorizationStatus.authorized){
    //   await firebaseMessaging.getToken().then((value) {
    //     fcmToken = value!;
    //
    //   }
    //   );
    // }
    // if (settings.authorizationStatus == AuthorizationStatus.provisional){
    //   await firebaseMessaging.getToken().then((value) {
    //     fcmToken = value!;
    //
    //   }
    //   );
    // }
    // else{
    //   debugPrint('user Denied');
    // }

    //hitting api

    /*await FirebaseMessaging.instance.getToken().then((newToken) {
      setState(() {
        fcmToken = newToken.toString();
        print('fcm---$fcmToken');
      });
    });*/

    var data = await Services('').splashApi(
        {'deviceId': deviceId, 'deviceType': deviceType, 'fcmToken': fcmToken});
    User user = Provider.of<User>(context, listen: false);

    await user.updateSplashData(deviceId, fcmToken);
    print('fcm');
    print(user.fcmToken);
    print(user.fcmToken);
  }



  Future googleSignin()async{
    final googleUser = await GoogleSignInAPI.login();
    User user = Provider.of<User>(context,listen:false);

    if(googleUser == null){
      Components(context).showErrorSnackBar('Could not connect you');
    }

    else{
      var data = await Services('').login({
        'name' : googleUser.displayName,
        'email' : googleUser.email,
        'deviceId' : user.deviceId,
        'deviceType' : (Platform.isAndroid)?'android':'ios',
        'fcmToken' : user.fcmToken
      });

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      if(data['statusCode'] == 200){
        await user.updateLoginStatus(true);
        await user.fromJson(data['data']);
        var stringdata = user.toEncodedJson();
        await sharedPreferences.setString('loginData', stringdata);
        await sharedPreferences.setBool('isLogged', user.isLogged);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavScreen()));
      }
      else{
        Components(context).showErrorSnackBar('Error! ${data['error']}');
      }


    }
  }

  @override
  void initState() {
    // TODO: implement initState
    requestToken();
    //getdevicedata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff576c21),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff576c21))
        ),
        child: Builder(
          builder: (context) {
            return Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,width: double.infinity,
                        child: Image.asset('assets/login/login.jpg',fit: BoxFit.cover,)),
                    Expanded(child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xff576c21),
                              Color(0xff304B16)
                            ]),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff576c21),
                              blurRadius: 70,
                              spreadRadius: 85,
                              blurStyle: BlurStyle.normal
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text('Enter the Sanctuary',style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 40,
                                  color: Colors.white.withOpacity(0.85)
                                ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text('Unlock Inner Journey, Access Grace',textAlign: TextAlign.center,style: TextStyle(
                                    fontSize: 16.5,
                                      color: Colors.white.withOpacity(0.75),
                                      height:2),)
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: Platform.isIOS,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 7),
                                    height: kToolbarHeight + 5,
                                    width: double.infinity,
                                    child: FilledButton(
                                      style: ButtonStyle(
                                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15)
                                        )),
                                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                            var colorr =Color(0xff161F17).withOpacity(0.4);
                                            if (states.contains(MaterialState.pressed))
                                              colorr = Color(0xff222e23).withOpacity(0.4);
                                            else if (states.contains(MaterialState.disabled))
                                              colorr = Theme.of(context).colorScheme.primary.withOpacity(0.65);
                                            return colorr;// Use the component's default.
                                          },
                                        ),
                                      ),
                                      onPressed: (){
                                        Components(context).showErrorSnackBar('Could not connect you');
                                      },
                                      child:
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset('assets/login/apple.svg',height: 28,width: 28,color: Colors.white,),
                                          SizedBox(width: 10,),
                                          Text('Connect with Apple',
                                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600,color: Colors.white,)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin:EdgeInsets.fromLTRB(7,25,7,0),
                                  height: kToolbarHeight + 5,
                                  width: double.infinity,
                                  child: FilledButton(
                                    style: ButtonStyle(
                                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      )),
                                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                          var colorr =Color(0xff161F17).withOpacity(0.4);
                                          if (states.contains(MaterialState.pressed))
                                            colorr = Color(0xff222e23).withOpacity(0.4);
                                          else if (states.contains(MaterialState.disabled))
                                            colorr = Theme.of(context).colorScheme.primary.withOpacity(0.65);
                                          return colorr;// Use the component's default.
                                        },
                                      ),
                                    ),
                                    onPressed: googleSignin,
                                    child:
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/login/google.svg',height: 28,width: 28,color: Colors.white,),
                                        SizedBox(width: 10,),
                                        Text('Connect with Google',
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600,color: Colors.white,)),
                                      ],
                                    ),
                                  ),
                                ),
                                //SizedBox(height: 25,),

                              ],
                            )
                          ),
                        ],
                      )
                    )
                    )
                  ],
                ),
                // Positioned(
                //   top: MediaQuery.of(context).size.height/2 - 150,
                //     right: 0,
                //     left: 0,
                //     child: Image.asset('assets/logo/mindnsoul_white.png',height: 100,width: 100,)
                // )
              ],
            );
          }
        ),
      ),
    );
  }
}
