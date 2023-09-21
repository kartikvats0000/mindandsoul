import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/provider/userProvider.dart';
import 'package:mindandsoul/services/notificationServices.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider,User>(
      builder: (context,theme,user,child) =>
       Scaffold(
         appBar: AppBar(
           automaticallyImplyLeading: false,
           backgroundColor: Colors.transparent,
           elevation: 0.0,
           centerTitle: true,
           title: Text('Notification',style: TextStyle(color: theme.textColor),),
         ),
         extendBodyBehindAppBar: true,
         body: Container(
           padding: EdgeInsets.symmetric(horizontal: 10),
           decoration: BoxDecoration(
               color: theme.themeColorA,
               gradient: LinearGradient(
                   begin: Alignment.topCenter,
                   end: Alignment.bottomCenter,
                   colors: [
                     theme.themeColorA,
                     theme.themeColorB,
                     theme.themeColorB.withOpacity(0.7),
                   ]
               )
           ),
           alignment: Alignment.center,
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               LottieBuilder.asset('assets/animations/noNotification.json'),
               SizedBox(height: 10,),
               Text('Your notifications are serene and clear.\nNo updates at the moment',style: Theme.of(context).textTheme.titleMedium?.copyWith(
               color: theme.textColor.withOpacity(0.8)
                ),
               textAlign: TextAlign.center,)
               /*ElevatedButton(onPressed: ()async{
                 NotificationServices().scheduleNotification(time: , title: title, body: body)
               }, child: Text('Now')),*/
             ],
           ),
         ),
       ),
    );
  }
}
