import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindandsoul/constants/iconconstants.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:provider/provider.dart';

import '../../../../helper/components.dart';

class InfoGraphic extends StatefulWidget {
  final Map data;
  final String title;
  const InfoGraphic({super.key,required this.title, required this.data});

  @override
  State<InfoGraphic> createState() => _InfoGraphicState();
}

class _InfoGraphicState extends State<InfoGraphic> {

  List infographics =[];

  ScrollController scrollController = ScrollController();
  bool isScrolling = false;


  @override
  void initState() {
    // TODO: implement initState
    infographics = widget.data['infoData'];
    infographics = infographics.reversed.toList();
    scrollController.addListener(() {
      if(scrollController.position.pixels < MediaQuery.of(context).size.height * 0.45){
        if(isScrolling == true){setState(() {
          isScrolling = false;
        });}
      }
      else{
        if(isScrolling == false){setState(() {
          isScrolling = true;
        });}
      }
    });
    super.initState();
  }


  List taglist = [
    'Mindfulness',
    'Spiritual',
    'Sleep',
    'Food',
  ];

  bool like = false;


  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,theme,child)=>
       Scaffold(
         extendBodyBehindAppBar: true,
         appBar: PreferredSize(
           preferredSize: const Size.fromHeight(kToolbarHeight+10),
           child: Components(context).customAppBar(
             duration: const Duration(milliseconds: 200),
             scrolledColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
               actions: [
                 Components(context).BlurBackgroundCircularButton(svg: MyIcons.favorite),
                 const SizedBox(width: 5,),
                 Components(context).BlurBackgroundCircularButton(svg: MyIcons.share),
               ],
               title: Text(widget.data['title'],style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white.withOpacity(0.9),fontWeight: FontWeight.w800,fontSize: 15.5,),maxLines: 2,overflow: TextOverflow.ellipsis,),
               isScrolling: isScrolling
           )
         ),
         backgroundColor: theme.themeColorB,
        body: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.themeColorB,
                    theme.themeColorA,
                  ]
              )
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      //width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Hero(
                              tag: widget.data['_id'],
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.network(widget.data['image'],fit: BoxFit.cover,),
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration:  BoxDecoration(
                                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
                                    gradient:  LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black26,
                                          //Colors.transparent,
                                          Colors.black.withOpacity(0.92)
                                        ]
                                    )
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Components(context).tags(
                                          title:widget.title,
                                          context: context,
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.watch_later_outlined,color: theme.textColor.withOpacity(0.7),size: 13,),
                                            SizedBox(width: 5,),
                                            Text('August 18, 2023',
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11,
                                                  //letterSpacing: 1.3,
                                                  color: Colors.white.withOpacity(0.7)
                                              ),),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Text(widget.data['title'],style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white.withOpacity(0.9),fontWeight: FontWeight.w800,fontSize: 19),),
                                    const SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.remove_red_eye_outlined,color: Colors.grey.withOpacity(0.7),size: 13,),
                                            SizedBox(width: 5,),
                                            Text('34.8k reads • ❤️ 12.2k likes',
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11,
                                                  //letterSpacing: 1.3,
                                                  color: Colors.white.withOpacity(0.7)
                                              ),),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Components(context).BlurBackgroundCircularButton(svg: (like)?MyIcons.like:MyIcons.like_filled,onTap: (){
                                              HapticFeedback.lightImpact();
                                              setState(() {
                                                like = !like;
                                              });
                                            }),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                          ),
                          /*Positioned(
                              top: 30,
                              left: 5,
                              child: Components(context).BlurBackgroundCircularButton(icon: Icons.chevron_left,onTap: (){Navigator.pop(context);})
                          ),
                          Positioned(
                              top: 30,
                              right: 5,
                              child: Components(context).BlurBackgroundCircularButton(svg: MyIcons.favorite,onTap: (){})
                          ),*/
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           // Text('Tags:\n',style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: theme.textColor,fontWeight: FontWeight.w800,fontSize: 15.5),),
                            Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children:
                                taglist.map((e) => Components(context).tags(
                                    title:e,
                                    context: context,
                                    textcolor: theme.textColor.withOpacity(0.7)
                                )).toList()
                            ),
                            const SizedBox(height: 15,),
                           // Text('Description:\n',style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: theme.textColor,fontWeight: FontWeight.w800,fontSize: 15.5),),
                            Text('${widget.data['desc']}\n',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: theme.textColor.withOpacity(0.7),fontSize: 13.5),),
                          //  Text('Instructions:\n',style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: theme.textColor,fontWeight: FontWeight.w800,fontSize: 15.5),),

                          ],
                        ),

                    ),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: infographics.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context,index){
                        var itemList = [
                          Expanded(
                            flex: 5,
                              child: AspectRatio(aspectRatio: 16/12,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(infographics[index]['image'],fit: BoxFit.cover,)),)
                          ),
                          const SizedBox(width:10),
                          Expanded(
                            flex: 4,
                              child: Column(
                                crossAxisAlignment : CrossAxisAlignment.start,
                                children: [
                                  Text('Step ${index+1}:',style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: theme.textColor,fontWeight: FontWeight.w800,fontSize: 13.5),),
                                  const SizedBox(height: 5,),
                                  Text('${infographics[index]['desc']}',style: Theme.of(context).textTheme.bodySmall?.copyWith(color: theme.textColor.withOpacity(0.8),fontSize: 13),
                                  ),
                                ],
                              )
                          ),
                        ];

                        return Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 10),
                          child:  Row(
                            children:(index%2 == 0)?itemList:itemList.reversed.toList()
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            /*  AnimatedPositioned(
                duration: Duration(milliseconds: 350),
                top: (isScrolling)?0:-kToolbarHeight-35,
                right: 0,
                left: 0,
                curve: Curves.easeOut,
                child: Components(context).customAppBar(
                  actions: [
                    Components(context).BlurBackgroundCircularButton(svg: MyIcons.favorite),
                    const SizedBox(width: 5,),
                    Components(context).BlurBackgroundCircularButton(svg: MyIcons.share),
                  ],
                  title: Text(widget.data['title'],style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white.withOpacity(0.9),fontWeight: FontWeight.w800,fontSize: 15.5,),maxLines: 2,overflow: TextOverflow.ellipsis,),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
              )*/
            ],
          ),
        ),
      ),
    );
  }
}
