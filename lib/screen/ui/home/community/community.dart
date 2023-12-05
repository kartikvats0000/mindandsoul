import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:like_button/like_button.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/iconconstants.dart';
import '../../../../provider/userProvider.dart';
import '../../../../services/services.dart';
import 'package:just_audio/just_audio.dart';

class Communities extends StatefulWidget {
  const Communities({super.key});

  @override
  State<Communities> createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities> {
  List data = [
    {
      'id': generateRandomHexId(),
      'title': "Buddha's Teachings",
      'image':
          "https://scontent.fdel1-2.fna.fbcdn.net/v/t39.30808-6/355486327_217125357915983_7591271941326132658_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=5f2048&_nc_ohc=txYRWUGDHJoAX_ibY-L&_nc_ht=scontent.fdel1-2.fna&oh=00_AfAraoF0Sn1l-bS5R0ylcfMNiB4a2hwf5gPHoZgWnAJZ0g&oe=656233E4",
      'desc':
          "Compliation of Buddhist videos for easy and better understanding of everyone.",
      'url': 'https://www.facebook.com/groups/670404179639431/'
    },
    {
      'id': generateRandomHexId(),
      'title': "Yoga As Exercise",
      'image':
          "https://scontent.fdel1-4.fna.fbcdn.net/v/t39.30808-6/352748550_188836497477698_5110657846893325116_n.jpg?stp=dst-jpg_p960x960&_nc_cat=107&ccb=1-7&_nc_sid=5f2048&_nc_ohc=HvtZ6yZCJCQAX-IKurW&_nc_ht=scontent.fdel1-4.fna&oh=00_AfCpZZOPUYQh6rh5BYhmHi1EYEr8rR-ERN7sgqoQZ6v5Xw&oe=6561FEEC",
      'desc':
          "We are delighted to have you join our community of yoga enthusiasts who recognize the numerous physical and mental benefits of this ancient practice.",
      'url': 'https://www.facebook.com/groups/669036638330223/'
    },
  ];

  AudioPlayer audioPlayer = AudioPlayer();


  popSound(){
    audioPlayer.setAsset('assets/data/pop.mp3');
    audioPlayer.play();
  }

  bool loading = true;

  getData()async{
    User user = Provider.of<User>(context,listen: false);

    var lst = await Services(user.token).getCommunities();

    setState(() {
      data = lst;
      loading = false;
    });
  }

  Future<void> _launchUrl(String url) async {
    Uri _url = Uri.parse(url);
    if (!await launchUrl(_url,mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
   // print('hi${data[0]['likeUsers'][0]['profile_picture']}');
    print(MediaQuery.of(context).size.height - 30);
    return Consumer<User>(
      builder: (context,user,_) =>
       Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        appBar: Components(context).myAppBar(
          title: user.languages[user.selectedLanguage]['home_screen']['Community'] ?? user.languages['en']['home_screen']['Community'],
          titleStyle: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(fontSize: 23, color: Colors.black),
        ),
        body: (loading)
            ?Center(
          child: Components(context).Loader(textColor: Colors.black),
        )
            :RefreshIndicator(
          onRefresh: ()async{
            await getData();
          },
              child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                List likedList = data[index]['likeUsers'];
                return Card(
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15),bottom:Radius.circular(10) )
                  ),
                  child: Container(
                    //margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15),bottom: Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 448,
                          height: 252,
                          //preferredSize: Size(16,9),
                          //height: MediaQuery.of(context).size.height * 0.2,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius:
                                      const BorderRadius.vertical(top: Radius.circular(15)),
                                  child: Image.network(
                                    data[index]['image'],
                                    key: ValueKey(index),
                                    fit: BoxFit.cover,
                                    /*loadingBuilder: (context,_,__){
                                      return SpinKitSpinningLines(color: Theme.of(context).colorScheme.primary);
                                    },*/
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                  child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15)),
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black26,
                                          Colors.transparent,
                                          Colors.black26,
                                          Colors.black87,
                                        ])),
                              )),
                              Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Text(data[index]['title'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(color: Colors.white))),
                              Positioned(
                                  top: 10,
                                  right: 10,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black38,
                                    child: LikeButton(
                                      onTap: (isLiked) async {
                                        User user = Provider.of<User>(context,listen: false);
                                         await Services(user.token).likeCommunity(data[index]['_id']);
                                        // Components(context).showSuccessSnackBar(message);
                                        if(data[index]['liked'] == false){
                                          HapticFeedback.mediumImpact();
                                          popSound();
                                        }
                                        else{
                                          HapticFeedback.lightImpact();
                                        }
                                        getData();
                                        return !isLiked;
                                      },
                                      padding: EdgeInsets.zero,
                                      likeCountPadding: EdgeInsets.zero,
                                      size: 22,
                                      isLiked : data[index]['liked'],
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
                              ),
                            ],
                          ),
                        ),
                       //  Text(data[index]['desc'])
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data[index]['desc'],style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black87),),
                              const SizedBox(height: 15,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  FilledButton.tonalIcon(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.primaryContainer
                                    ),
                                      onPressed: () async{
                                      await _launchUrl(data[index]['url']);
                                      },
                                      icon: const Icon(Icons.chevron_right),
                                      label:  Text(user.languages[user.selectedLanguage]['custom_round_button_class']['join_community'] ?? user.languages['en']['custom_round_button_class']['join_community']
                                      )),
                                  Row(
                                    children: [
                                      Row(
                                        children: likedList.map((e) => Align(
                                            widthFactor: 0.5,
                                            child: CircleAvatar(
                                              radius: 14,
                                              backgroundColor: Colors.grey.shade100,
                                              child: CircleAvatar(
                                                radius: 13,
                                                backgroundColor: Colors.white,
                                                backgroundImage: CachedNetworkImageProvider(
                                                  e['profile_picture'],
                                                ),
                                              ),
                                            ))).toList(),
                                      ),
                                      const SizedBox(width: 20,),
                                      Visibility(
                                        visible: likedList.length == 4,
                                          child: Text('+ ${data[index]['likes'] - 4}'.toString(),style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black),)),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),
      ),
    );
  }
}
