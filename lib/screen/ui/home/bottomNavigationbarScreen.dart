import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindandsoul/screen/ui/auth/login.dart';
import 'package:mindandsoul/screen/ui/home/navscreens/Home.dart';
import 'package:mindandsoul/screen/ui/home/navscreens/notifications.dart';
import 'package:mindandsoul/screen/ui/home/navscreens/profile/profile.dart';
import 'package:mindandsoul/screen/ui/home/themes/themePicker.dart';
import 'package:provider/provider.dart';

import '../../../helper/circle_transition_clipper.dart';
import '../../../provider/userProvider.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

late TabController homeScreenTabController;

class _BottomNavScreenState extends State<BottomNavScreen> with TickerProviderStateMixin {

 // late AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    /*_controller = AnimationController(
        vsync: this,
      duration: Duration(milliseconds: 4000),
      upperBound: 1.3
    );
    _controller.forward();*/
    homeScreenTabController = TabController(length: 4, vsync: this)..addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    homeScreenTabController.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;
  
  List<Widget> screens = const [
    Home(),
    Notifications(),
    Notifications(),
    Profile()
  ];

  
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context,user,child) =>
      Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            TabBarView(
                controller: homeScreenTabController,
                physics: const NeverScrollableScrollPhysics(),
                children: screens
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 3),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: BackdropFilter(
                    filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      decoration:  BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          // border: Border.all(color: Colors.grey.shade50.withOpacity(0.45),width: 0.5,),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(45),bottom: Radius.circular(45))
                      ),

                      child: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.circular(45),
                        color: Colors.transparent,
                        // color:  Theme.of(context).colorScheme.primary.withOpacity(0.35),
                        child: TabBar(
                          labelColor: Colors.white,
                          padding: const EdgeInsets.all(10),
                          indicatorColor: Colors.white,
                          unselectedLabelColor: Colors.white38,
                          dividerColor: Colors.transparent,
                          indicatorPadding: const EdgeInsets.symmetric(horizontal: 35),
                          controller: homeScreenTabController,
                          isScrollable: false,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: const <Widget>[
                            Tab(
                                child: Column(
                                  children: [
                                    Icon(Icons.home_outlined,),
                                    Text('Home',style: TextStyle(fontSize: 11),)
                                  ],
                                )
                              //text: 'Home',
                            ),
                            Tab(
                                child: Column(
                                  children: [
                                    Icon(Icons.list,),
                                    Text('Menu',style: TextStyle(fontSize: 11),)
                                  ],
                                )
                              //text: 'Home',
                            ),
                            Tab(
                                child: Column(
                                  children: [
                                    Icon(Icons.notifications_none,),
                                    Text('Notification',style: TextStyle(fontSize: 11),)
                                  ],
                                )
                              //text: 'Home',
                            ),
                            Tab(
                                child: Column(
                                  children: [
                                    Icon(Icons.person_outline,),
                                    Text('Profile',style: TextStyle(fontSize: 11),)
                                  ],
                                )
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }


}


/*
import 'dart:developer';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindandsoul/screen/ui/auth/login.dart';
import 'package:mindandsoul/screen/ui/home/Home.dart';
import 'package:mindandsoul/screen/ui/home/themePicker.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

late TabController homeScreenTabController;

class _BottomNavScreenState extends State<BottomNavScreen> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  late CircularBottomNavigationController circularBottomNavigationController;
  @override
  void initState() {
    // TODO: implement initState
    circularBottomNavigationController = CircularBottomNavigationController(_selectedIndex);
    homeScreenTabController = TabController(length: 4, vsync: this)..addListener(() {setState(() {});});
    super.initState();
  }



  @override
  void dispose() {
    // TODO: implement dispose
    homeScreenTabController.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;

  List<Widget> screens = const [
    Home(),
    ThemePicker(),
    Login(),
    Home()
  ];

  int maxCount = 4;


  List<TabItem> tabItems = List.of([
    TabItem(Icons.home, "Home", Colors.red, labelStyle: TextStyle(fontWeight: FontWeight.normal)),
    TabItem(Icons.search, "Search", Colors.orange, labelStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
    TabItem(Icons.layers, "Reports", Colors.red, circleStrokeColor: Colors.black),
    TabItem(Icons.notifications, "Notifications", Colors.cyan),
  ]);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CircularBottomNavigation(
        tabItems,
        controller: circularBottomNavigationController,
        selectedCallback: (selectedPos) {
          setState(() {
            circularBottomNavigationController.value!;
            _selectedIndex = selectedPos!;
          });
          print("clicked on $selectedPos");
        },
        barBackgroundColor: Theme.of(context).colorScheme.primary,
      ),
     // extendBodyBehindAppBar: true,

      extendBody: true,
      body: screens[_selectedIndex]
    );
  }


}
*/
