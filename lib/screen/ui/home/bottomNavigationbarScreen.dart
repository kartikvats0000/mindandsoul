import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mindandsoul/constants/iconconstants.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/screen/ui/home/navscreens/Home.dart';
import 'package:mindandsoul/screen/ui/home/navscreens/notifications.dart';
import 'package:mindandsoul/screen/ui/home/navscreens/profile/profile.dart';
import 'package:provider/provider.dart';


import '../../../helper/miniplayer.dart';


class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

late TabController homeScreenTabController;

class _BottomNavScreenState extends State<BottomNavScreen> with TickerProviderStateMixin {
  ScrollController scrollBottomBarController = ScrollController();


  @override
  void initState() {
    // TODO: implement initState
    homeScreenTabController = TabController(length: 4, vsync: this);
    super.initState();
  }



  @override
  void dispose() {
    // TODO: implement dispose
    homeScreenTabController.dispose();
    super.dispose();
  }

  int _index = 0;


  List<Widget> screens = const [
    Home(),
    Notifications(),
    Notifications(),
    Profile()
  ];
  DateTime? currentBackPressTime;
  
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,theme,child) =>
      WillPopScope(
        onWillPop: ()async{
          if(_index == 0){
            DateTime now = DateTime.now();
            if (currentBackPressTime == null ||
                now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
              currentBackPressTime = now;
              Components(context).showSuccessSnackBar('Double Tap the Back Button to Exit the App');
              return false;
            }
            return true;
          }
          else{
            setState(() {
              _index = 0;
            });
            homeScreenTabController.animateTo(_index);
            return false;
          }
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              TabBarView(
                  controller: homeScreenTabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: screens
              ),
              AnimatedPositioned(
                right: 2,
                  left: 2,
                  bottom: (theme.isScrolling)?-kToolbarHeight-25:7,
                  duration: const Duration(milliseconds: 450),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(45),
                    child: BackdropFilter(
                        filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(45),bottom: Radius.circular(45))
                          ),
                          child: TabBar(
                            labelColor: Colors.white,
                            padding: const EdgeInsets.all(5),
                            indicatorColor: Colors.white,
                            unselectedLabelColor: Colors.white38,
                            dividerColor: Colors.transparent,
                            // indicatorPadding: const EdgeInsets.symmetric(horizontal: 15),
                            controller: homeScreenTabController,
                            isScrollable: false,
                            onTap: (index){
                              setState(() {
                                _index = index;
                              });
                            },
                            indicatorSize: TabBarIndicatorSize.label,
                            tabs:  <Widget>[
                              Tab(
                                child: Components(context).myIconWidget(icon: MyIcons.home,color: Colors.white.withOpacity(0.8)),
                                //text: 'Home',
                              ),
                              Tab(
                                child: Components(context).myIconWidget(icon: MyIcons.menu,color: Colors.white.withOpacity(0.8)),
                                //text: 'Home',
                              ),
                              Tab(
                                child: Components(context).myIconWidget(icon: MyIcons.notification,color: Colors.white.withOpacity(0.8)),
                                //text: 'Home',
                              ),
                              Tab(
                                child: Components(context).myIconWidget(icon: MyIcons.profile,color: Colors.white.withOpacity(0.8)),
                                //text: 'Home',
                              ),

                            ],
                          )
                        )
                    ),
                  )
              ),
              AnimatedPositioned(
                right: 3,
                  bottom: (!theme.isScrolling)?-kToolbarHeight-25:7,
                  duration: const Duration(milliseconds: 450),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(45),
                    child: BackdropFilter(
                        filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(45),bottom: Radius.circular(45))
                          ),
                          child: GestureDetector(
                            onTap: () => theme.changeScrollStatus(false),
                            child: const CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.transparent,
                              child: Icon(Icons.open_in_full_rounded,color: Colors.white70,size: 20,),
                            ),
                          ),
                        )
                    ),
                  )
              ),
              /*Container(
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                alignment: Alignment.bottomRight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: BackdropFilter(
                    filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(45),bottom: Radius.circular(45))
                      ),
                        child: (theme.isScrolling == false)
                            ?TabBar(
                          labelColor: Colors.white,
                          padding: const EdgeInsets.all(5),
                          indicatorColor: Colors.white,
                          unselectedLabelColor: Colors.white38,
                          dividerColor: Colors.transparent,
                          // indicatorPadding: const EdgeInsets.symmetric(horizontal: 15),
                          controller: homeScreenTabController,
                          isScrollable: false,

                          indicatorSize: TabBarIndicatorSize.label,
                          tabs:  <Widget>[
                            Tab(
                              child: Components(context).myIconWidget(icon: MyIcons.home,color: Colors.white.withOpacity(0.8)),
                              //text: 'Home',
                            ),
                            Tab(
                              child: Components(context).myIconWidget(icon: MyIcons.menu,color: Colors.white.withOpacity(0.8)),
                              //text: 'Home',
                            ),
                            Tab(
                              child: Components(context).myIconWidget(icon: MyIcons.notification,color: Colors.white.withOpacity(0.8)),
                              //text: 'Home',
                            ),
                            Tab(
                              child: Components(context).myIconWidget(icon: MyIcons.profile,color: Colors.white.withOpacity(0.8)),
                              //text: 'Home',
                            ),

                          ],
                        )
                            :GestureDetector(
                          onTap: () => theme.changeScrollStatus(false),
                          child: const CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.open_in_full_rounded,color: Colors.white70,size: 20,),
                          ),
                        ),
                    )
                  ),
                ),
              ),*/
             const Positioned(
                  bottom: kToolbarHeight+20,
                  left: 0,
                  right: 0,
                  child: MiniPlayer()
              ),

            ],
          ),
        ),
      ),
    );
  }


}
