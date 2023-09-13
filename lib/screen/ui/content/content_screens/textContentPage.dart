import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mindandsoul/constants/iconconstants.dart';
import 'package:mindandsoul/helper/components.dart';


class TextContent extends StatefulWidget {
  final Map data;
  final String title;
  const TextContent({super.key,required this.data,required this.title});

  @override
  State<TextContent> createState() => _TextContentState();
}

class _TextContentState extends State<TextContent> {

  ScrollController scrollController = ScrollController();
  bool isScrolling = false;

  @override
  void initState() {
    // TODO: implement initState
    scrollController.addListener(() {
      if(scrollController.position.pixels < MediaQuery.of(context).size.height * 0.45
      ){
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
    'Spiritual',
    'Sleep',
  ];

  bool like = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor:Theme.of(context).colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight+10),
          child: Components(context).customAppBar(
            duration: const Duration(milliseconds: 150),
              scrolledColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
              actions: [
                Components(context).BlurBackgroundCircularButton(svg: MyIcons.favorite,),
                const SizedBox(width: 5,),
                Components(context).BlurBackgroundCircularButton(svg: MyIcons.share),
              ],
              title: Text(widget.data['title'],style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white.withOpacity(0.9),fontWeight: FontWeight.w800,fontSize: 15.5,),maxLines: 2,overflow: TextOverflow.ellipsis,),
              isScrolling: isScrolling
          )
      ),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
             // padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: Stack(
                      children: [
                        Positioned.fill(child: Hero(
                          tag: widget.data['_id'],
                          child: ClipRRect(
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
                              child: CachedNetworkImage(imageUrl: widget.data['image'],fit: BoxFit.cover,)),
                        )
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Components(context).tags(
                                        title:widget.title,
                                        context: context,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.watch_later_outlined,color: Colors.white.withOpacity(0.8),size: 13,),
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
                                          Icon(Icons.remove_red_eye_outlined,color: Colors.white.withOpacity(0.7),size: 13,),
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
                                          /*SizedBox(width: 15,),
                                          Components(context).BlurBackgroundCircularButton(svg: MyIcons.share),*/
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                        ),
                       /* Positioned(
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
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HtmlWidget(
                            widget.data['html']
                        ),

                        SizedBox(height: 15,),
                        Text('Tags:\n',style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 14),),
                        Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children:
                            taglist.map((e) => Components(context).tags(
                                title:e,
                                context: context,
                                textcolor: Colors.black87
                            )).toList()

                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            /*AnimatedPositioned(
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
    );
  }
}
