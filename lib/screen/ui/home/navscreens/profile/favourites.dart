import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:mindandsoul/helper/miniplayer.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/screen/ui/home/navscreens/profile/favorites/favourite_content.dart';
import 'package:mindandsoul/screen/ui/home/navscreens/profile/favorites/favourite_quotes.dart';
import 'package:mindandsoul/screen/ui/home/navscreens/profile/favorites/favourite_wellness.dart';
import 'package:mindandsoul/screen/ui/home/navscreens/profile/favorites/favourite_yoga.dart';
import 'package:provider/provider.dart';

import '../../../../../helper/components.dart';
import '../../../../../provider/userProvider.dart';


class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin{

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;



  List<Widget> tabbarlist = const [
    FavouriteContent(),
    FavouriteQuote(),
    FavouriteWellnes(),
    FavouriteYoga(),
  ];


   late TabController tabController;

   @override
  void initState() {
     print('init tab');
    // TODO: implement initState
     tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,theme,child) =>
          Scaffold(
            backgroundColor: theme.themeColorA,
            //extendBodyBehindAppBar: true,
            appBar: Components(context).myAppBar(title: 'Favourites'),
            body: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: theme.themeColorA,
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            theme.themeColorA.withOpacity(0.2),
                            theme.themeColorB,
                          //  theme.themeColorA,
                          ]
                      )
                  ),
                  child: Column(
                    children: [
                      TabBar(
                        onTap: (index){HapticFeedback.selectionClick();},
                        //tabAlignment: TabAlignment.start,
                       // isScrollable: true,
                          labelPadding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.12), // Space between tabs
                          labelStyle: Theme.of(context).textTheme.labelMedium,
                          labelColor: theme.textColor,
                          padding: const EdgeInsets.all(5),
                          indicatorColor: theme.textColor,
                          unselectedLabelColor: theme.textColor.withOpacity(0.25),
                          dividerColor: Colors.transparent,
                          isScrollable : true,
                        controller: tabController,
                          tabs: const [
                            Tab(
                              text: 'Content',
                            ),
                            Tab(
                              text: 'Quotes',
                            ),
                            Tab(
                              text: 'Wellness ',
                            ),
                            Tab(
                              text: 'Yoga',
                            )
                          ]
                      ),
                      Expanded(
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                              controller: tabController,
                              children: tabbarlist
                          )
                      )
                    ],
                  )
                ),
                const Positioned(
                  bottom: 8,
                    right: 1,
                    left: 1,
                    child: MiniPlayer()
                )
              ],
            ),
          ),
    );
  }



}

class NoFavourite extends StatelessWidget {
  const NoFavourite({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider theme = Provider.of<ThemeProvider>(context,listen: false);
    User user = Provider.of<User>(context,listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LottieBuilder.asset('assets/animations/noFavourite.json',height: 300,),
        const SizedBox(height: 10,),
        Text('${ user.languages[user.selectedLanguage]['components_class']['no_data']}....',style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: theme.textColor.withOpacity(0.8)
        ),)
      ],
    );
  }
}

