import 'package:flutter/material.dart';
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
               Icon(Icons.notifications_none_outlined,size: 70,
               color: Theme.of(context).colorScheme.inversePrimary,),
               SizedBox(height: 10,),
               Text('No Notifications'),
               ElevatedButton(onPressed: ()async{
                 // Future.delayed(Duration(seconds: 2),(){
                 //   NotificationService().show(id: 1, channelKey: 'channelKey', title: 'Hi', body: 'hello');
                 // });
               }, child: Text('Now')),
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
