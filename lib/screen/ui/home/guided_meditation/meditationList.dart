import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:provider/provider.dart';

import '../../../../helper/components.dart';


class MeditationList extends StatefulWidget {
  const MeditationList({super.key});

  @override
  State<MeditationList> createState() => _MeditationListState();
}

class _MeditationListState extends State<MeditationList> {

  List<dynamic> data = [
    {
      "title": "Calming Breath",
      "purpose": "Stress Reduction",
      "description": "Focuses on slow, deep diaphragmatic breathing to reduce stress and anxiety.",
      "colorA": "FFD1DC",
      "colorB": "FFA07A",
      "average_time": "10 minutes"
    },
    {
      "title": "Box Breathing",
      "purpose": "Anxiety Relief",
      "description": "Inhale, hold, exhale, and hold the breath for equal counts to alleviate anxiety.",
      "colorA": "E6E6FA",
      "colorB": "C5C1E0",
      "average_time": "5 minutes"
    },
    {
      "title": "4-7-8 Relaxation Breath",
      "purpose": "Sleep and Insomnia",
      "description": "Aids sleep by using a 4-7-8 pattern to promote relaxation and improve sleep quality.",
      "colorA": "98FB98",
      "colorB": "86E986",
      "average_time": "15 minutes"
    },
    {
      "title": "Ujjayi Breath",
      "purpose": "Energy and Focus",
      "description": "Utilizes rhythmic breath of fire to increase energy levels and enhance focus.",
      "colorA": "AEEEEE",
      "colorB": "87CEFA",
      "average_time": "7 minutes"
    },
    {
      "title": "Mindful Breath Awareness",
      "purpose": "Mindfulness and Present Moment Awareness",
      "description": "Encourages observation of the natural breath to promote mindfulness and presence.",
      "colorA": "FFDAB9",
      "colorB": "FFA07A",
      "average_time": "12 minutes"
    },
    {
      "title": "Pain Relief Breath",
      "purpose": "Pain Management and Relaxation",
      "description": "Combines deep rhythmic breathing with visualization to relieve physical discomfort.",
      "colorA": "C8A2C8",
      "colorB": "DDA0DD",
      "average_time": "8 minutes"
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,theme,_)
      => Scaffold(
        backgroundColor: theme.themeColorA,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight+25),
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
                Text('Meditation',style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                const SizedBox(height: 20,),
                Text('Discover inner peace with our Guided Meditation Section. Expertly crafted sessions for relaxation and mindfulness await...',style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.15,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(data[index]['title'],style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black87,fontWeight: FontWeight.w700),),
                          Text('For ${data[index]['purpose']}',style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black45,fontWeight: FontWeight.w600),),
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
