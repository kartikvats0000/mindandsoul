import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindandsoul/helper/bullet_list.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/screen/ui/home/breathe/breating.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../constants/iconconstants.dart';
import '../../../../helper/components.dart';


class BreatheList extends StatefulWidget {
  const BreatheList({super.key});

  @override
  State<BreatheList> createState() => _BreatheListState();
}

class _BreatheListState extends State<BreatheList> {


  List<dynamic> data = [];

  List timers = [
    1,2,3,5
  ];

  int timer = 1;

  Color myColor(String color){
    return Color(int.parse('0xff$color'));
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
                decoration:  BoxDecoration(
                  color: Colors.grey.shade300,
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
                      Text(data[index]['description'],style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.7),
                        fontWeight: FontWeight.w500
                      ),),
                      const SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        buildbreathIndicator(MyIcons.inhale, 'Inhale', data[index]['durations']['breatheIn'],  context),
                        buildbreathIndicator(MyIcons.pause_circle, 'Hold', data[index]['durations']['hold1'], context),
                        buildbreathIndicator((data[index]['exhaleThrough'] == 'nose')?MyIcons.exhale:MyIcons.exhale_mouth, 'Exhale', data[index]['durations']['breatheOut'],  context),
                        buildbreathIndicator(MyIcons.pause_circle, 'Hold', data[index]['durations']['hold2'], context),
                        ],
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
                              var sumOfOne = data[index]['durations']['breatheIn'] + data[index]['durations']['breatheOut'] + data[index]['durations']['hold1'] + data[index]['durations']['hold2'];
                              print((timer * 60/sumOfOne));
                              print('No of times user has to do == ${(timer * 60/sumOfOne).ceil()}');
                              Navigator.push(context, PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => Breathing(
                                  title: data[index]['title'],
                                  breatheIn: data[index]['durations']['breatheIn'],
                                  hold1: data[index]['durations']['hold1'],
                                  breatheOut: data[index]['durations']['breatheOut'],
                                  hold2: data[index]['durations']['hold2'],
                                  colorA: data[index]['colorA'],
                                  colorB: data[index]['colorB'],
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
           ),
        );
        }
    ).then((value) => timer = 1);
  }

  getData()async{
    String jsn = await DefaultAssetBundle.of(context).loadString("assets/data/breathingList.json");
    setState(() {
      var all = json.decode(jsn);
      data  = all['data'];
      //print(data);
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
        body: (data.isEmpty)
            ? Components(context).Loader(textColor: theme.textColor)
            :Container(
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
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 22),
                              margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 35),
                              width: double.infinity,
                             // height: MediaQuery.of(context).size.height * 0.12,
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
                                  (index%2==0)?Spacer():SizedBox(),
                                  Expanded(
                                    flex:2,
                                    child: Column(
                                      crossAxisAlignment: (index%2==0)?CrossAxisAlignment.start:CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(data[index]['title'],style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: theme.textColor,fontWeight: FontWeight.w700),),
                                        Text('For ${data[index]['purpose']}',style: Theme.of(context).textTheme.bodySmall?.copyWith(color: theme.textColor.withOpacity(0.7),fontWeight: FontWeight.w600),),
                                        const SizedBox(height: 15,),
                                        buildbreathsIndicatorList(data[index]['durations'],myColor(data[index]['colorB']),context)

                                      ],
                                    ),
                                  ),
                                  (index%2!=0)?const Spacer():const SizedBox(),
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
