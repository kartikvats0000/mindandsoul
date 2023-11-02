import 'package:flutter/material.dart';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mindandsoul/helper/bullet_list.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/screen/ui/home/breathe/breating.dart';
import 'package:provider/provider.dart';

import '../../../../constants/iconconstants.dart';
import '../../../../helper/components.dart';


class BreathingList extends StatefulWidget {
  final String title;
  final String image;
  final String desc;
  final List data;
  const BreathingList({super.key,required this.title,required this.image,required this.desc, required this.data,});

  @override
  State<BreathingList> createState() => _BreathingListState();
}


class _BreathingListState extends State<BreathingList> {



  List timers = [
    1,2,3,5
  ];

  int timer = 1;

  Color myColor(String color){
    return Color(int.parse('0xff$color'));
  }

  showActionSheet(List data,int index){
    showModalBottomSheet(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        isScrollControlled: true,
        context: context,
        useSafeArea: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context,setState) =>
                Theme(
                  data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.fromSeed(
                          seedColor: myColor(data[index]['colorA'])
                      )
                  ),
                  child: Builder(
                    builder: (context) =>
                        Container(
                          // height: MediaQuery.of(context).size.height * 0.9,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
                          decoration:  BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius:  const BorderRadius.vertical(top: Radius.circular(25)),

                          ),
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(data[index]['title'].toString(),style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: 25),
                                    ),
                                  ),
                                  Components(context).BlurBackgroundCircularButton(icon: Icons.clear,iconSize: 15,buttonRadius: 15,onTap: ()=>Navigator.pop(context))
                                ],
                              ),
                              const SizedBox(height: 15,),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(data[index]['description'],style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.7),
                                          fontWeight: FontWeight.w500
                                      ),),
                                      const SizedBox(height: 15,),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(child: buildbreathIndicator(MyIcons.inhale, 'Inhale', data[index]['durations']['breatheIn']['duration'].toString(),  context)),
                                            Visibility(
                                              visible: data[index]['durations']['hold1']['duration'].floor() != 0,
                                                child: Expanded(child: buildbreathIndicator(MyIcons.pause_circle, 'Hold', data[index]['durations']['hold1']['duration'].floor().toString(), context))),
                                            Expanded(child: buildbreathIndicator((data[index]['exhaleThrough'] == 'nose')?MyIcons.exhale:MyIcons.exhale_mouth, 'Exhale', data[index]['durations']['breatheOut']['duration'].toString(),  context)),
                                            Visibility(
                                              visible:  data[index]['durations']['hold2']['duration'].floor() != 0,
                                              child: Expanded(
                                                child: buildbreathIndicator(MyIcons.pause_circle, 'Hold', data[index]['durations']['hold2']['duration'].floor().toString(), context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20,),
                                      Text('Directions',style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontSize: 19),
                                      ),
                                      BulletList(data[index]['instructions'],
                                          Components(context).myIconWidget(icon: MyIcons.breathe,color: Theme.of(context).colorScheme.primary,size: 12)
                                      ),
                                      Divider(
                                        indent: 10,
                                        endIndent: 10,
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                        thickness: 0.5,
                                      ),
                                      Text('\nDetails\n',style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontSize: 19),
                                      ),
                                      Text(data[index]['detail'],style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Colors.black87
                                      ),),
                                      Divider(
                                        indent: 10,
                                        endIndent: 10,
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                        thickness: 0.5,
                                      ),
                                      Text('\nBenefits\n',style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontSize: 19),
                                      ),
                                      Text(data[index]['benefits'],style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Colors.black87
                                      ),)
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Text('Period',style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 19),
                              ),
                              const SizedBox(height: 15,),
                              Row(
                                  children: timers.map((e) {
                                    return Expanded(child: GestureDetector(
                                      onTap: (){
                                        setState((){
                                          timer = e;
                                        });
                                      },
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: AnimatedContainer(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.symmetric(horizontal: 4),

                                          duration: const Duration(milliseconds: 150),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: (timer != e)?Theme.of(context).colorScheme.primary:Colors.transparent,
                                                  width: 1
                                              ),
                                              color: (timer != e)?Colors.white:Theme.of(context).colorScheme.primary,
                                              shape: BoxShape.circle
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(e.toString(),style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: (timer == e)?Colors.white:Theme.of(context).colorScheme.primary
                                              ),),
                                              Text('min',style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                //fontSize: 16,
                                                //fontWeight: FontWeight.bold,
                                                  color: (timer == e)?Colors.white:Theme.of(context).colorScheme.primary
                                              ),),
                                              /*Text('$e',style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                            fontSize: 18,
                                            //color: (index == e)?Colors.red:Colors.white,
                                            fontWeight: FontWeight.bold
                                        ),),
                                        Text('min')*/
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                                  }).toList()
                              ),
                              const SizedBox(height: 15,),
                              /*Center(
                            child: FilledButton.tonal(onPressed: (){}, child: Text('Begin'),style: FilledButton.styleFrom(
                              fixedSize: Size(MediaQuery.of(context).size.width * 0.85, kToolbarHeight)
                            ),),
                          ),*/
                              Center(
                                  child: InkWell(
                                    onTap: (){
                                      HapticFeedback.mediumImpact();
                                      var sumOfOne = data[index]['durations']['breatheIn']['duration'] + data[index]['durations']['breatheOut']['duration'] + data[index]['durations']['hold1']['duration'] + data[index]['durations']['hold2']['duration'];
                                      print((timer * 60/sumOfOne));
                                      print('No of times user has to do == ${(timer * 60/sumOfOne).ceil()}');
                                      Navigator.push(context, PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => Breathing(
                                          title: data[index]['title'],
                                          breatheIn: (data[index]['durations']['breatheIn']['duration'] * 1000).toInt(),
                                          hold1: (data[index]['durations']['hold1']['duration']* 1000).toInt(),
                                          breatheOut:( data[index]['durations']['breatheOut']['duration'] * 1000).toInt(),
                                          hold2: (data[index]['durations']['hold2']['duration']* 1000).toInt(),
                                          colorA: data[index]['colorA'],
                                          colorB: data[index]['colorB'],
                                          exhaleThrough: data[index]['exhaleThrough'],
                                          messageList: [
                                            data[index]['durations']['breatheIn']['message'],
                                            data[index]['durations']['hold1']['message'],
                                            data[index]['durations']['breatheOut']['message'],
                                            data[index]['durations']['hold2']['message'],
                                          ],
                                          noOfCounts: (timer * 60/sumOfOne).ceil(),
                                        ),
                                        transitionDuration: const Duration(
                                            milliseconds: 500
                                        ),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                      )).then((value) => Navigator.pop(context));
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
                                              color: myColor(data[index]['colorA']).withOpacity(0.6),
                                              blurRadius: 5,
                                              spreadRadius: 5
                                          ),
                                        ],
                                        borderRadius:  BorderRadius.circular(15),
                                        color: myColor(data[index]['colorA']),
                                        gradient: LinearGradient(
                                            colors: [
                                              Theme.of(context).colorScheme.inversePrimary.withOpacity(0.8),
                                              myColor(data[index]['colorA']).withOpacity(0.6),
                                              myColor(data[index]['colorA']).withOpacity(0.6),
                                              Theme.of(context).colorScheme.inversePrimary.withOpacity(0.8),
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
                        ),
                  ),
                ),
          );
        }
    ).then((value) => timer = 1);
  }

  void _showDisclaimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Components(context).confirmationDialog(
            context, title: 'Disclaimer',
            message: 'These breathing exercises are compiled from publicly available sources and are intended for relaxation and stress relief. \n\n'
            'If you have underlying medical conditions, please consult a healthcare professional before practicing. \n\nResults may vary between individuals, and we do not guarantee specific outcomes. Listen to your body and practice mindfully for your well-being.',

            actions: [FilledButton.tonal(onPressed: (){Navigator.pop(context);}, child: Text('Close'))]);
      },
    );
  }


  bool isScrolling = false;

  @override
  void initState() {
    // TODO: implement initState
    scrollController.addListener(() {
      if(scrollController.position.pixels < MediaQuery.of(context).size.height * 0.12
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

  ScrollController scrollController = ScrollController();



  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,theme,_){
        debugPrint('hiBreathingList');
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(preferredSize: const Size.fromHeight(kToolbarHeight), child: Components(context).customAppBar(actions: [], title: const Text('Breathe'), isScrolling: isScrolling)),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                    tag: widget.image,
                    child: CachedNetworkImage(imageUrl: widget.image,height: MediaQuery.of(context).size.height * 0.25,width: MediaQuery.of(context).size.width,fit: BoxFit.cover,)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff202327),
                        Color(0xff1F2024),

                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff202327),
                        blurRadius: 20,
                        spreadRadius: 30,
                      ),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          ListView.builder(
                            padding: const EdgeInsets.only(bottom: 10,top:0),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.data.length,
                            itemBuilder: (context, j) {
                              return GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  showActionSheet(widget.data,j);
                                },
                                child: buildBreathingListItem(widget.data, j, context),
                              );
                            },
                          ),
                          const SizedBox(height: 20), // Add some space before the Disclaimer link.
                          Center(
                            child: TextButton(
                              onPressed: () {
                                _showDisclaimerDialog(context); // Show the disclaimer dialog.
                              },
                              child: Text('Disclaimer', style: Theme.of(context).textTheme.bodyMedium), // Style this link accordingly.
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: -55,
                        child:Text(widget.title, style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 27, fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
                      ),
                      Positioned(
                        top: 0,
                        child:Text('${widget.desc}...', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.75),
                            fontSize: 14.5
                        ),),

                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}

buildBreathingListItem(List data, int index, BuildContext context){
  ThemeProvider theme = Provider.of<ThemeProvider>(context,listen: false);
  return Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        alignment: (index%2==0)?Alignment.centerRight:Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 22),
        margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 27),
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.white60
          ),
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(int.parse('0xff${data[index]['colorB']}')).withOpacity(0.35),
                Color(int.parse('0xff${data[index]['colorA']}')).withOpacity(0.35),
              ]
          ),
        ),
        child: Row(
          children: [
            (index%2==0)?const Spacer():const SizedBox(),
            Expanded(
              flex:2,
              child: Column(
                crossAxisAlignment: (index%2==0)?CrossAxisAlignment.start:CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(data[index]['title'],style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: theme.textColor,fontWeight: FontWeight.w700),),
               //   Text('For ${data[index]['purpose']}',style: Theme.of(context).textTheme.bodySmall?.copyWith(color: theme.textColor.withOpacity(0.7),fontWeight: FontWeight.w600),),
                  const SizedBox(height: 15,),
                  buildbreathsIndicatorList(
                      {
                        'breatheIn' : data[index]['durations']['breatheIn']['duration'].floor(),
                        'hold1' : data[index]['durations']['hold1']['duration'].floor(),
                        'breatheOut' : data[index]['durations']['breatheOut']['duration'].floor(),
                        'hold2' : data[index]['durations']['hold2']['duration'].floor(),
                      },
                      myColor(data[index]['colorB']),
                      data[index]['exhaleThrough'],
                      context)

                ],
              ),
            ),
            (index%2!=0)?const Spacer():const SizedBox(),
          ],
        ),
      ),
      /*(index%2==0)
          ?Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          //alignment: Alignment.topLeft,
          child: Image.asset(data[index]['image'],height: 150,width: 150,))
          :Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          //alignment: Alignment.topLeft,
          child: Image.asset(data[index]['image'],height: 150,width: 150,)),*/
    ],
  );
}
