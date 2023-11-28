import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/screen/ui/home/dailyyoga/VideoYoga.dart';
import 'package:mindandsoul/screen/ui/home/dailyyoga/stepsYoga.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';

import '../../../../constants/iconconstants.dart';
import '../../../../provider/userProvider.dart';

class YogaDetails extends StatefulWidget {
  final String yogaId;
  const YogaDetails({super.key, required this.yogaId});

  @override
  State<YogaDetails> createState() => _YogaDetailsState();
}

class _YogaDetailsState extends State<YogaDetails> {


  List<String> difficulty = [
    'Beginner',
    'Moderate',
    'Expert',
  ];

  List<int> repetitions = [
    1,2,5
  ];

  List likesList = [
    'https://images.unsplash.com/photo-1423479185712-25d4a4fe1006?auto=format&fit=crop&q=80&w=2076&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1423479185712-25d4a4fe1006?auto=format&fit=crop&q=80&w=2076&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1423479185712-25d4a4fe1006?auto=format&fit=crop&q=80&w=2076&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1423479185712-25d4a4fe1006?auto=format&fit=crop&q=80&w=2076&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1423479185712-25d4a4fe1006?auto=format&fit=crop&q=80&w=2076&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1423479185712-25d4a4fe1006?auto=format&fit=crop&q=80&w=2076&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ];

  String selectedDifficulty = 'Beginner';

  int selectedRepetition = 1;


  var data = {};

  getDetails()async{

    User user = Provider.of<User>(context,listen: false);
    var res = await Services(user.token).getYogaDetail(yogaId: widget.yogaId);

    //print('yoga details for ${widget.yogaId} : $res');

    setState(() {
      data = res['data'];
    });
  }

  @override
  void initState() {
    getDetails();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_,theme,__) => Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: Components(context).myAppBar(title: '',actions: [
          CircleAvatar(
            backgroundColor: Colors.black38,
            child: LikeButton(
              onTap: (isLiked) async {
                User user = Provider.of<User>(context,listen: false);
                String message = await Services(user.token).likeYoga(data['_id']);
                // Components(context).showSuccessSnackBar(message);

                // getData();
                return !isLiked;
              },
              isLiked: data['liked'],
              padding: EdgeInsets.zero,
              likeCountPadding: EdgeInsets.zero,

              size: 22,
              // isLiked : data['liked'],
              likeBuilder: (bool isLiked) {
                return Components(context).myIconWidget(
                  icon: (isLiked)?MyIcons.favorite_filled:MyIcons.favorite,
                  //color: (isLiked) ? Colors.redAccent.shade200 : Colors.white,
                  color: Colors.white,
                );
              },
            ),
          ),
          const SizedBox(width: 5,),
          Components(context).BlurBackgroundCircularButton(svg: MyIcons.share),
          const SizedBox(width: 10,)
        ]),
        body: (data.isEmpty)
            ? Components(context).Loader(textColor: Colors.black87)
            :Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 2 ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Stack(
                            children: [
                              Positioned.fill(child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
                                  child: CachedNetworkImage(imageUrl: data['image'],fit: BoxFit.cover,))),
                              Positioned.fill(
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration:  BoxDecoration(
                                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
                                        gradient:  LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black12,
                                              //Colors.transparent,
                                              Colors.black.withOpacity(0.92)
                                            ]
                                        )
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        buildLikesViewer(likesList, theme),
                                        const SizedBox(height: 20,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            customTag('${data['avgTime']} mins',Icon(Icons.watch_later,color: Theme.of(context).colorScheme.primary,size: 15,),  theme),
                                            //const Spacer(flex: 1,),
                                            const SizedBox(width: 10,),
                                            customTag('${data['steps'].length} Steps',Icon(Icons.featured_play_list_rounded,color: Theme.of(context).colorScheme.primary,size: 15,), theme)
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                              )

                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10,),
                              Text(data['shortDesc'],style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
                                  fontWeight: FontWeight.w500
                              ),),
                              const SizedBox(height: 15,),
                              Text('Description',style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 17),
                              ),
                              const SizedBox(height: 15,),
                              Text(
                                data['desc'],
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13
                                ),),
                              const SizedBox(height: 15,),

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  //color: Colors.green.withOpacity(0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                     exerciseStartSection(data['type']),
                      Center(
                          child: InkWell(
                            onTap: (){
                              if(data['type'] == 'Steps'){
                                Navigator.push(context, fadeRoute(StepYoga(
                                  steps: data['steps'],
                                  difficulty: selectedDifficulty,
                                  title: data['title']
                                )));
                              }
                              else{
                                Navigator.push(context, fadeRoute(VideoYoga(data: {
                                  'video' : data['video'],
                                  'title' : data['title'],
                                  'limit' : selectedRepetition
                                })));
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: kToolbarHeight,
                              width: MediaQuery.of(context).size.width * 0.95,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  const BoxShadow(
                                      offset: Offset(-0.5,-5),
                                      color: Colors.white,
                                      blurRadius: 8,
                                      spreadRadius:5
                                  ),
                                  BoxShadow(
                                    // /blurStyle: BlurStyle.solid,
                                      offset: const Offset(0.15,5),
                                      color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
                                      blurRadius: 5,
                                      spreadRadius: 5
                                  ),
                                ],
                                borderRadius:  BorderRadius.circular(15),
                                color:Theme.of(context).colorScheme.primary,
                                gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                                      Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
                                      Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
                                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                                    ]
                                ),
                              ),
                              child: Text('Begin',style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer
                              ),),
                            ),
                          )
                      ),
                      const SizedBox(height: 15,),
                    ],
                  ),
                )
              ],
            ),
          ],
        )
      )
    );
  }

  Widget customTag(String text,Widget icon, ThemeProvider theme){
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(
              width: 0.4,
              color: theme.themeColorA
          ),
          borderRadius: BorderRadius.circular(20),

        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 5,),
            Text(text, style: Theme
                .of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }

  _buildButton({VoidCallback? onTap, required String text, required bool selected}){
    return Padding(
      padding:const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: onTap,
        child: AnimatedContainer(
            padding: const EdgeInsets.symmetric(horizontal: 23,vertical: 13),
            curve: Curves.ease,
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
                color: selected ? Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4) : Colors.white.withOpacity(0.4),
                border: Border.all(
                    width: 1,
                    color: selected ? Colors.transparent : Theme.of(context).colorScheme.secondaryContainer
                ),
                borderRadius: BorderRadius.circular(25)
            ),
            child: Text(text,style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: selected ? Colors.black : Theme.of(context).colorScheme.primary,
                fontSize: 12
            ),textAlign: TextAlign.center,)
        ),
      ),
    );
  }

  buildLikesViewer(List likesList, ThemeProvider theme){
    return Row(
      children: [
        Expanded(
          child: Text(data['title'],style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white.withOpacity(0.9),fontWeight: FontWeight.w800,fontSize: 19),),
        ),
        Row(
          children: [
            for (int i = 0; i < 5; i++)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 0),
                child: Align(
                    widthFactor: 0.5,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.grey.shade100,
                      child: CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.white,
                        backgroundImage: CachedNetworkImageProvider(
                          likesList[i],
                        ),
                      ),
                    )),
              ),
            const SizedBox(width: 20,),
            Text('+ 15'.toString(),style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),),
          ],
        )
      ],
    ) ;
  }

  exerciseStartSection(String type){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text((type == 'Steps')?'Select Difficulty':'Select Repetition',style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 17),
        ),
        const SizedBox(height: 15,),
        (type == 'Steps')?Row(
          children: difficulty.map((e) => Expanded(child:
          _buildButton(
              onTap : (){
                setState((){
                  selectedDifficulty = e;
                });
              },
              text: e.toString(),
              selected: e == selectedDifficulty)
          )).toList()
        ):Row(
            children: repetitions.map((e) => Expanded(child:_buildButton(
                onTap : (){
                  setState((){
                    selectedRepetition = e;
                    print(selectedRepetition);
                  });
                },
                text:e.toString(),
                selected: e == selectedRepetition)
            )).toList()
        ),
        const SizedBox(height: 15,),
      ],
    );
  }

}
