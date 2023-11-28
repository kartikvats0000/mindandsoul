import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:mindandsoul/constants/iconconstants.dart';
import 'package:mindandsoul/helper/components.dart';

class StepYoga extends StatefulWidget {
  final String title;
  final List steps;
  final String difficulty;
  const StepYoga({super.key, required this.steps, required this.difficulty,required this.title});

  @override
  State<StepYoga> createState() => _StepYogaState();
}

class _StepYogaState extends State<StepYoga> {

  int currentIndex = 0;


  @override
  void initState() {
    startTimer();
    // TODO: implement initState
    super.initState();
  }

  String get difficulty {
    if(widget.difficulty == 'Moderate') {
      return 'moderator';
    } else {
      return widget.difficulty.toLowerCase();
    }
  }

  showCompletionSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: false,
        elevation: 0.0,
        context: context,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height* 0.95,
          minHeight: MediaQuery.of(context).size.height * 0.94,
        ),
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.95,
              padding:
              const EdgeInsets.only(left: 15, right: 15, top: 15),
              decoration: const BoxDecoration(
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height:
                      MediaQuery.of(context).size.height * 0.25,
                      child: LottieBuilder.asset(
                          'assets/animations/relaxed.json')),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Congratulations on Completing Your Yoga Session!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .primary,
                        fontSize: 17),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "🧘‍♀️ Well done on completing your yoga session! You've taken a positive step towards a healthier, more balanced life. 🧘‍♂️",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceTint
                              .withOpacity(0.9),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                  const SizedBox(
                    height: 25,
                  ),
                  Text("Through consistent practice, you'll discover a wide range of benefits, including reduced stress, increased flexibility, and improved mental clarity. Each session brings you closer to becoming your best self. 🌟",style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                      fontSize: 14
                  ),
                      textAlign: TextAlign.center
                  ),
                  const SizedBox(height: 10,),
                  Spacer(),
                  Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);


                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: kToolbarHeight,
                          width:
                          MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color:
                            Theme.of(context).colorScheme.primary,
                            gradient: LinearGradient(colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withOpacity(0.8),
                              Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withOpacity(0.8),
                              Theme.of(context).colorScheme.primary,
                            ]),
                          ),
                          child: Text(
                            'Done',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer),
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          );
        });
  }


  Timer? timer;
  
  startTimer(){
    setState(() {
      timer = Timer(Duration(seconds: widget.steps[currentIndex][difficulty]), () {
      if(currentIndex < widget.steps.length-1){
        currentIndex++;
        print('current index $currentIndex');
        startTimer();
      }
      else {
        timer?.cancel();
        print('complete');
        showCompletionSheet();
      }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedSwitcher(
            switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              duration: const Duration(milliseconds: 2500),
            child: Center(
                key: ValueKey(currentIndex),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Image.network(
                          widget.steps[currentIndex]['image'],fit: BoxFit.fill,width: double.infinity,key: Key(widget.steps[currentIndex]['image']),)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.steps[currentIndex]['title'],style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.w800,fontSize: 19),textAlign: TextAlign.start,),
                          const SizedBox(height: 10,),
                          LinearProgressIndicator(
                            value: (currentIndex+1)/widget.steps.length,
                          ),
                          Text('${currentIndex+1} / ${widget.steps.length}',style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),textAlign: TextAlign.end,
                            textDirection: TextDirection.ltr,),
                          const SizedBox(height: 10,),
                          Text(widget.steps[currentIndex]['desc'],style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600,fontSize: 13),)
                        ],
                      ),
                    )
                  ],
                )
            ),
          ),
          Positioned(
            top: 50,
              left: 10,
              child: Row(
                children: [
                  Components(context).BlurBackgroundCircularButton(icon: Icons.chevron_left,onTap: (){

                    HapticFeedback.mediumImpact();
                    timer?.cancel();
                    Navigator.pop(context);

                  }),
                  const SizedBox(width: 10,),
                  Text(widget.title,style: Theme.of(context).textTheme.headlineSmall,)
                ],
              )
          )
        ],
      )
    );
  }
}
