import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:like_button/like_button.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/screen/ui/home/games/game_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/iconconstants.dart';
import '../../../../provider/userProvider.dart';
import '../../../../services/services.dart';

class GameDetail extends StatelessWidget {
  final Map data;
  const GameDetail({super.key,required this.data});


  Future<void> _launchUrl(String url) async {
    Uri _url = Uri.parse(url);
    if (!await launchUrl(
        _url,
        mode: LaunchMode.inAppWebView,
        webOnlyWindowName: "Game"

    )) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<User>(
      builder: (context,user,_) =>
      Scaffold(
        backgroundColor: Colors.grey.shade200,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: Components(context).myAppBar(title: '',actions: [
          CircleAvatar(
            backgroundColor: Colors.black38,
            child: LikeButton(
              onTap: (isLiked) async {
                User user = Provider.of<User>(context,listen: false);
                String message = await Services(user.token).likeContent(data['_id']);
                // Components(context).showSuccessSnackBar(message);
                if(data['liked'] == false){
                  HapticFeedback.mediumImpact();
                  //popSound();
                }
                else{
                  HapticFeedback.lightImpact();
                }

                return !isLiked;
              },
              padding: EdgeInsets.zero,
              likeCountPadding: EdgeInsets.zero,
              size: 22,
              isLiked : data['liked'],
              likeBuilder: (bool isLiked) {
                print('is liked $isLiked');
                return Components(context).myIconWidget(
                  icon: (isLiked)?MyIcons.favorite_filled:MyIcons.favorite,
                  //color: (isLiked) ? Colors.redAccent.shade200 : Colors.white,
                  color: Colors.white,
                );
              },
            ),
          ),
        ]),
        body: Column(
          children: [
            Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Image.network(data['image'],fit: BoxFit.cover,),
                              ),
                            ),
                          ),
                          Positioned.fill(
                              child: Container(
                                decoration:const BoxDecoration(
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black26,
                                        Colors.transparent,
                                    Colors.black26,
                                    Colors.black87,
                                  ])
                                ),
                              )
                          ),
                          Positioned(bottom: 10,
                              left: 10,
                              child: Text(data['title'],style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white.withOpacity(0.9),fontWeight: FontWeight.w800,fontSize: 19),))
                        ],
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15.0),
                      child: Text( user.languages[user.selectedLanguage]['component_class']['description'] ?? user.languages['en']['component_class']['description'],
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 22
                      ),),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(data['desc'],style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),),
                    ),
                  ],
                )
            ),
            GestureDetector(
              onTap: (){
                _launchUrl(data['url']);
                //Navigator.of(context).push(fadeRoute(GameScreen(url : data['url'])));
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                alignment: Alignment.center,
                height: kToolbarHeight,
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  borderRadius:  BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.8)
                ),
                child: Text(
                    user.languages[user.selectedLanguage]['custom_round_button_class']['play_game'] ?? user.languages['en']['custom_round_button_class']['play_game'],
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer
                ),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
