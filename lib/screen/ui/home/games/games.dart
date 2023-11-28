import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindandsoul/constants/iconconstants.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/provider/userProvider.dart';
import 'package:mindandsoul/screen/ui/home/games/game_detail.dart';
import 'package:provider/provider.dart';

import '../../../../services/services.dart';
import 'game_screen.dart';

class GamesList extends StatefulWidget {
  const GamesList({super.key});

  @override
  State<GamesList> createState() => _GamesListState();
}

class _GamesListState extends State<GamesList> {
  
  bool loading = true;

  List data = [
    {
      'id' : generateRandomHexId(),
      'title' : 'Om Nom Run',
      'image' : 'https://img.cdn.famobi.com/portal/html5games/images/tmp/OmNomRunTeaser.jpg?v=0.2-790e55b8',
      'desc' : "Run alongside Om Nom in his famous adventure, now finally in immersive and full-responsive HTML5. Try to run as far as possible by avoiding the dangerous obstacles and enemies, collect all coins and transform Om Nom into the fastest runner possible. Use the power-ups as smart as possible to explore the beautiful world with all it's beautiful areas, but be aware of the dangers that lurk inside of them. Are you ready to explore the world of Om Nom Run and reach the highest of highscores?",
      'url' : 'https://play.famobi.com/wrapper/om-nom-run/A1000-10'
    },
    {
      'id' : generateRandomHexId(),
      'title' : 'Archery World Tour ',
      'image' : 'https://img.cdn.famobi.com/portal/html5games/images/tmp/ArcheryWorldTourTeaser.jpg?v=0.2-790e55b8',
      'desc' : "Grab a bow and put your archery skills to the ultimate test! Play in two different modes: select World Tour and travel to a variety of exotic locations. Try to earn three stars in 50 increasingly challenging levels to become a true champion. Or choose the Balloon Challenge mode for quick fire game-play, hit the balloons to progress and earn as many points as possible. Aim carefully, keep a steady hand and watch out for the wind direction and power before you shoot. Multiple distance targets that can move, rotate or obscure your shot are waiting for you. Can you master them all?",
      'url' : 'https://play.famobi.com/archery-world-tour'
    },
    {
      'id' : generateRandomHexId(),
      'title' : 'Archery World Tour',
      'image' : 'https://img.cdn.famobi.com/portal/html5games/images/tmp/ArcheryWorldTourTeaser.jpg?v=0.2-790e55b8',
      'desc' : "Grab a bow and put your archery skills to the ultimate test! Play in two different modes: select World Tour and travel to a variety of exotic locations. Try to earn three stars in 50 increasingly challenging levels to become a true champion. Or choose the Balloon Challenge mode for quick fire game-play, hit the balloons to progress and earn as many points as possible. Aim carefully, keep a steady hand and watch out for the wind direction and power before you shoot. Multiple distance targets that can move, rotate or obscure your shot are waiting for you. Can you master them all?",
      'url' : 'https://play.famobi.com/archery-world-tour'
    }
  ];
  
  getData()async{
    User user = Provider.of<User>(context,listen: false);
    
    var lst = await Services(user.token).getGames();
    
    setState(() {
      data = lst;
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,theme,_) =>
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          appBar: Components(context).myAppBar(title: 'Games',titleStyle:  Theme.of(context).textTheme.labelMedium?.copyWith(
              fontSize: 23,
              color: Colors.black
          ),),
          body: (loading)
              ? Center(
            child: Components(context).Loader(textColor: Colors.black),
          )
              :RefreshIndicator(
            onRefresh: ()async{
              await getData();
            },
                child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                crossAxisSpacing: 25,
                mainAxisSpacing: 5,
                childAspectRatio: 1/1.4,
            ),
                itemBuilder: (context,index){
                  return GestureDetector(
                    onTap: (){
                      HapticFeedback.selectionClick();
                      Navigator.of(context).push(bottomToTopRoute(GameDetail(data : data[index]))).then((value) => getData());
                    },
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                              child: AspectRatio(
                                  aspectRatio: 1,
                                child: Image.network(data[index]['image'],fit: BoxFit.cover,)

                              ),
                            ),
                            Positioned.fill(
                                child: Container(
                                  decoration:  BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          Colors.black87,
                                          Colors.transparent,
                                          Colors.transparent,
                                        ]
                                    )
                                  ),
                                )
                            ),
                            Positioned(
                              top: 10,
                                right: 10,
                                child: Components(context).myIconWidget(icon: (data[index]['liked']?MyIcons.favorite_filled:MyIcons.favorite))
                            )
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(data[index]['title'],style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black),)),
                            GestureDetector(
                               onTap: (){
                                 Navigator.of(context).push(fadeRoute(GameScreen(url : data[index]['url'])));
                                 },
                               child:  const CircleAvatar(
                                 backgroundColor: Colors.white60,
                                 child: Icon(Icons.play_arrow_rounded),
                            ),
                             )
                          ],
                        )
                      ],
                    ),
                  );
                }
          ),
              ),
        )
    );
  }
}
