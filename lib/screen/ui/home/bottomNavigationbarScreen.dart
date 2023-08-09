import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindandsoul/provider/playerProvider.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/screen/ui/auth/login.dart';
import 'package:mindandsoul/screen/ui/home/navscreens/Home.dart';
import 'package:mindandsoul/screen/ui/home/navscreens/notifications.dart';
import 'package:mindandsoul/screen/ui/home/navscreens/profile/profile.dart';
import 'package:mindandsoul/screen/ui/home/themes/themePicker.dart';
import 'package:provider/provider.dart';

import '../../../helper/circle_transition_clipper.dart';
import '../../../helper/components.dart';
import '../../../helper/miniplayer.dart';
import '../../../provider/userProvider.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

late TabController homeScreenTabController;

class _BottomNavScreenState extends State<BottomNavScreen> with TickerProviderStateMixin {
  ScrollController scrollBottomBarController = ScrollController();
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    // TODO: implement initState

    // _controller = AnimationController(
    //   duration: const Duration(milliseconds: 300),
    //   vsync: this,
    // );
    // _offsetAnimation = Tween<Offset>(
    //   begin: Offset(0, widget.end),
    //   end: Offset.zero,
    // ).animate(CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.easeIn,
    // ))
    //   ..addListener(() {
    //     if (mounted) {
    //       setState(() {});
    //     }
    //   });
    // _controller.forward();

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
    return Consumer<ThemeProvider>(
      builder: (context,theme,child) =>
      Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            TabBarView(
                controller: homeScreenTabController,
                physics: const NeverScrollableScrollPhysics(),
                children: screens
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 1200),
              curve: Curves.easeInToLinear,
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              alignment: Alignment.bottomRight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(45),
                child: BackdropFilter(
                  filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: AnimatedContainer(
                    curve: Curves.easeIn,
                    duration: Duration(milliseconds: 1200),
                    decoration:  BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        // border: Border.all(color: Colors.grey.shade50.withOpacity(0.45),width: 0.5,),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(45),bottom: Radius.circular(45))
                    ),

                    child: (theme.isScrolling == false)
                        ?TabBar(
                      labelColor: Colors.white,
                      padding: const EdgeInsets.all(10),
                      indicatorColor: Colors.white,
                      unselectedLabelColor: Colors.white38,
                      dividerColor: Colors.transparent,
                     // indicatorPadding: const EdgeInsets.symmetric(horizontal: 15),
                      controller: homeScreenTabController,
                      isScrollable: false,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: const <Widget>[
                        Tab(
                            icon: Icon(Icons.home_outlined),
                          //text: 'Home',
                        ),
                        Tab(
                          icon: Icon(Icons.list),
                          //text: 'Home',
                        ),
                        Tab(
                          icon: Icon(Icons.notifications_none_outlined),
                          //text: 'Home',
                        ),
                        Tab(
                          icon: Icon(Icons.person_outline),
                        ),

                      ],
                    )
                        :ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                            child: GestureDetector(
                              onTap: () => theme.changeScrollStatus(false),
                              child: const CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.black54,
                                child: Icon(Icons.open_in_full_rounded,color: Colors.white70,size: 25,),
                              ),
                            ),
                          ),
                        )
                  ),
                ),
              ),
            ),
           const Positioned(
                bottom: kToolbarHeight+20,
                left: 0,
                right: 0,
                child: MiniPlayer()
            ),

          ],
        ),
      ),
    );
  }


}
