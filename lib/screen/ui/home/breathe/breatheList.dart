import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindandsoul/helper/bullet_list.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/screen/ui/home/breathe/breating.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../helper/components.dart';


class BreatheList extends StatefulWidget {
  const BreatheList({super.key});

  @override
  State<BreatheList> createState() => _BreatheListState();
}

class _BreatheListState extends State<BreatheList> {

  List<dynamic> data = [
    {
      "title": "Calming Breath",
      "purpose": "Stress Reduction",
      "description": "Focuses on slow, deep diaphragmatic breathing to reduce stress and anxiety.",
      "colorA": "FFD1DC",
      "colorB": "FFA07A",
      "average_time": "10 minutes",
      "instructions": [
        "Find a quiet and comfortable place to sit or lie down.",
        "Close your eyes and take a few natural breaths.",
        "Inhale deeply through your nose for a count of four, allowing your abdomen to rise.",
        "Exhale slowly and completely through your mouth for a count of six, feeling tension release.",
        "Focus on your breath and let go of stress and worries."
      ],
      "image": "assets/meditation/yoga1.png",
      "durations" : {
        "breatheIn" : 4,
        "hold1" : 1,
        "breatheOut" : 6,
        "hold2" : 1
      }
    },
    {
      "title": "Box Breathing",
      "purpose": "Anxiety Relief",
      "description": "Inhale, hold, exhale, and hold the breath for equal counts to alleviate anxiety.",
      "colorA": "E6E6FA",
      "colorB": "C5C1E0",
      "average_time": "5 minutes",
      "instructions": [
        "Sit in a relaxed position with your back straight.",
        "Close your eyes and take a slow, deep breath in through your nose for a count of four.",
        "Hold your breath for a count of four.",
        "Exhale slowly and completely through your nose for a count of four.",
        "Pause and hold your breath for a count of four.",
        "This technique helps calm anxiety and centers your mind."
      ],
      "image": "assets/meditation/yoga2.png",
      "durations" : {
        "breatheIn" : 4,
        "hold1" : 4,
        "breatheOut" : 4,
        "hold2" : 4
      }
    },
    {
      "title": "4-7-8 Relaxation Breath",
      "purpose": "Sleep and Insomnia",
      "description": "Aids sleep by using a 4-7-8 pattern to promote relaxation and improve sleep quality.",
      "colorA": "98FB98",
      "colorB": "86E986",
      "average_time": "15 minutes",
      "instructions": [
        "Lie down in a comfortable position, or sit with your back straight.",
        "Close your eyes and take a breath in quietly through your nose for a count of four.",
        "Hold your breath for a count of seven.",
        "Use this technique before bedtime to improve sleep quality."
      ],
      "image": "assets/meditation/yoga3.png",
      "durations" : {
        "breatheIn" : 4,
        "hold1" : 7,
        "breatheOut" : 8,
        "hold2" : 2
      }
    },
    {
      "title": "Energizing Breath",
      "purpose": "Energy and Focus",
      "description": "Utilizes rhythmic breath of fire to increase energy levels and enhance focus.",
      "colorA": "AEEEEE",
      "colorB": "87CEFA",
      "average_time": "7 minutes",
      "instructions": [
        "Sit with your back straight and shoulders relaxed.",
        "Inhale and exhale rapidly through your nose, keeping a steady rhythm.",
        "Focus on the movement of your diaphragm.",
        "This technique increases alertness and mental clarity."
      ],
      "image": "assets/meditation/yoga4.png",
      "durations" : {
        "breatheIn" : 2,
        "hold1" : 0,
        "breatheOut" : 2,
        "hold2" : 0
      }
    },
    {
      "title": "Mindful Breath Awareness",
      "purpose": "Mindfulness and Present Moment Awareness",
      "description": "Encourages observation of the natural breath to promote mindfulness and presence.",
      "colorA": "FFDAB9",
      "colorB": "FFA07A",
      "average_time": "12 minutes",
      "instructions": [
        "Find a quiet space to sit comfortably.",
        "Close your eyes and take a few natural breaths.",
        "Shift your attention to your breath.",
        "Observe each inhale and exhale without trying to change it.",
        "Practice being fully present in the moment."
      ],
      "image": "assets/meditation/yoga5.png",
      "durations" : {
        "breatheIn" : 3,
        "hold1" : 3,
        "breatheOut" : 3,
        "hold2" : 3
      }
    },
    {
      "title": "Pain Relief Breath",
      "purpose": "Pain Management and Relaxation",
      "description": "Combines deep rhythmic breathing with visualization to relieve physical discomfort.",
      "colorA": "C8A2C8",
      "colorB": "DDA0DD",
      "average_time": "8 minutes",
      "instructions": [
        "Sit or lie down in a relaxed position.",
        "Close your eyes and take a few deep breaths to relax.",
        "Visualize your breath as a soothing, healing energy.",
        "As you inhale, imagine this energy flowing to the areas of discomfort or pain.",
        "Exhale slowly, releasing tension and discomfort.",
        "Use this technique to find relief from physical discomfort or pain."
      ],
      "image": "assets/meditation/yoga1.png",
      "durations" : {
        "breatheIn" : 5,
        "hold1" : 1,
        "breatheOut" : 8,
        "hold2" : 2
      }
    }
  ];

  List timers = [
    1,2,5,10
  ];

  int timer = 1;

  Color myColor(String color){
    return Color(int.parse('0xff${color}'));
  }

  showActionSheet(int index){

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
                decoration: const BoxDecoration(
                  borderRadius:  BorderRadius.vertical(top: Radius.circular(25)),
                   // color: myColor(data[index]['colorA']),
                   /* gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          myColor(data[index]['colorA']).withOpacity(0.5),
                          myColor(data[index]['colorB']),
                        ]
                    )*/
                ),
                child:  SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15,),
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
                      Text(data[index]['description'],style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.7),
                        fontWeight: FontWeight.w500
                      ),),
                      const SizedBox(height: 27,),
                      Text('Directions',style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 19),
                      ),
                      BulletList(data[index]['instructions']),
                      Divider(
                        indent: 10,
                        endIndent: 10,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        thickness: 0.5,
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
                            Navigator.push(context, PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => Breathing(
                                  title: data[index]['title'],
                                  breatheIn: data[index]['durations']['breatheIn'],
                                  hold1: data[index]['durations']['hold1'],
                                  breatheOut: data[index]['durations']['breatheOut'],
                                  hold2: data[index]['durations']['hold2'],
                                colorA: data[index]['colorA'],
                                colorB: data[index]['colorB'],
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
                              borderRadius:  BorderRadius.circular(15),
                               color: myColor(data[index]['colorA']),
                               gradient: LinearGradient(
                        colors: [
                          myColor(data[index]['colorB']),
                          myColor(data[index]['colorA']).withOpacity(0.8),
                          myColor(data[index]['colorA']).withOpacity(0.8),
                          myColor(data[index]['colorB']),
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
           ),
        );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,theme,_)
      => Scaffold(
        backgroundColor: theme.themeColorA,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight+25),
          child: AppBar(
            elevation: 0.0,
            scrolledUnderElevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: Padding(
                padding: const EdgeInsets.all(7),
                child: Components(context).BlurBackgroundCircularButton(
                  icon: Icons.chevron_left,
                  onTap: (){Navigator.pop(context);},
                )
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: theme.themeColorA,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.themeColorA.withOpacity(0.2),
                    theme.themeColorB,
                    theme.themeColorA,
                  ]
              )
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top + kToolbarHeight + 10,
                ),
                Text('Breathe',style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                const SizedBox(height: 20,),
                Text('Discover a collection of guided breathing exercises tailored to calm your mind and reduce stress...',style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: theme.textColor.withOpacity(0.75),
                    fontSize: 14.5
                ),),
                const SizedBox(height: 20,),
                ListView.builder(
                    padding: const EdgeInsets.only(bottom: 10),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context,index){
                      return GestureDetector(
                        onTap: (){
                          showActionSheet(index);
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              alignment: (index%2==0)?Alignment.centerRight:Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                              margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 35),
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.12,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white60
                                ),
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(int.parse('0xff${data[index]['colorB']}')),
                                      Color(int.parse('0xff${data[index]['colorA']}')),
                                    ]
                                ),
                              ),
                              child: Row(
                                children: [
                                  (index%2==0)?Spacer():SizedBox(),
                                  Expanded(
                                    flex:2,
                                    child: Column(
                                      crossAxisAlignment: (index%2==0)?CrossAxisAlignment.start:CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(data[index]['title'],style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black87,fontWeight: FontWeight.w700),),
                                        Text('For ${data[index]['purpose']}',style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black45,fontWeight: FontWeight.w600),),
                                      ],
                                    ),
                                  ),
                                  (index%2!=0)?Spacer():SizedBox(),
                                ],
                              ),
                            ),
                            (index%2==0)
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
                                child: Image.asset(data[index]['image'],height: 150,width: 150,)),
                          ],
                        ),
                      );
                    }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
