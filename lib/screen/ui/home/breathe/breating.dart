import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/screen/ui/home/breathe/breatheCategory.dart';

import '../../../../constants/iconconstants.dart';

class Breathing extends StatefulWidget {
  final String title;
  final int breatheIn;
  final int hold1;
  final int breatheOut;
  final int hold2;
  final String colorA;
  final String colorB;
  final int noOfCounts;
  final String exhaleThrough;
  final List messageList;


  const Breathing({super.key, required this.title,required this.breatheIn,required this.hold1,required this.breatheOut,required this.hold2,required this.colorA,required this.colorB,required this.noOfCounts,required this.exhaleThrough, required this.messageList});

  @override
  State<Breathing> createState() => _BreathingState();
}

bool startAnimation = false;

class _BreathingState extends State<Breathing> {

  Color myColor(String color){
    return Color(int.parse('0xff$color'));
  }

  bool startAnimation = false;
  bool showBox = false;


  @override
  Widget build(BuildContext context) {

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: myColor(widget.colorA))
      ),
      child: Builder(
        builder: (context) {
          return WillPopScope(
            onWillPop: ()async{
              var onwillpop = !startAnimation;
              if(startAnimation == true){
                showDialog(context: context, builder: (context)=> Components(context).confirmationDialog(context, title: 'Confirm Exit', message: 'Are you sure you want to exit the breathing exercise? Your progress will not be saved.',
                    actions: [
                      FilledButton.tonal(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                      FilledButton.tonal(onPressed: (){
                        audioPlayer.dispose();
                        setState(() {
                          onwillpop = true;
                        });
                        Navigator.pop(context);
                        Navigator.pop(context);
                      /*  Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context,animation,secondaryAnimation) => const BreatheList(),
                          transitionDuration: const Duration(
                              milliseconds: 400
                          ),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ));*/
                      }, child: const Text('Exit')),
                    ]));
                return onwillpop;
              }
              else{
                return true;
              }
            },
            child: Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: myColor(widget.colorB),
              appBar: AppBar(
                elevation: 0.0,
                scrolledUnderElevation: 0.0,
                centerTitle: true,
                backgroundColor: Colors.transparent,
                title: Text(widget.title,style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 17,
                ),),
                automaticallyImplyLeading: false,
                leading: GestureDetector(
                 onTap: () {
                   if(startAnimation == true){
                     showDialog(context: context, builder: (context)=> Components(context).confirmationDialog(context, title: 'Confirm Exit', message: 'Are you sure you want to exit the breathing exercise? Your progress will not be saved.',
                         actions: [
                           FilledButton.tonal(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                           FilledButton.tonal(onPressed: (){
                             audioPlayer.dispose();
                             // Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context,animation,secondaryAnimation) =>BreatheList(),
                             //   transitionDuration: const Duration(
                             //       milliseconds: 400
                             //   ),
                             //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
                             //     return FadeTransition(
                             //       opacity: animation,
                             //       child: child,
                             //     );
                             //   },
                             // ));
                             Navigator.pop(context);
                             Navigator.pop(context);
                           }, child: const Text('Exit')),
                         ]));
                   }else{Navigator.pop(context);}
                 },
                 child: const Icon(Icons.chevron_left),
                ),
              ),
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: const Alignment(-1,-1),
                    end: const Alignment(1,1),
                      colors: [
                        myColor(widget.colorA),
                        myColor(widget.colorB),
                      ]
                  )
                ),
                child: Stack(
                  children: [
                    Center(
                      child:
                        AnimatedSwitcher(
                            duration: Duration(milliseconds: 400),
                          child: (!startAnimation)
                              ?Center(
                            key: const ValueKey<int>(1),
                                child: AnimatedTextKit(
                            //repeatForever: false,
                                isRepeatingAnimation: false,
                                totalRepeatCount: 0,
                                onFinished: (){
                                  setState(() {
                                    startAnimation  = true;
                                   // Timer(Duration(milliseconds: 750), () {showBox = true;});
                                  });
                                },
                                animatedTexts: [
                                  FadeAnimatedText('',duration: Duration(seconds: 1),
                                    textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      fontSize: 15,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    fadeInEnd: 0.1,
                                    fadeOutBegin: 0.11,

                                  ),
                                  FadeAnimatedText('Make Yourself Calm and Relaxed\n',duration: Duration(seconds: 2),
                                    textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      fontSize: 15,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    fadeInEnd: 0.1,
                                    fadeOutBegin: 0.11,

                                  ),
                                  FadeAnimatedText('3',duration: const Duration(milliseconds: 700),
                                    textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      fontSize: 20,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    fadeInEnd: 0.1,
                                    fadeOutBegin: 0.11,

                                  ),
                                  FadeAnimatedText('2',duration: const Duration(milliseconds: 700),
                                    textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        fontSize: 20,
                                        color: Theme.of(context).colorScheme.primary
                                    ),
                                    fadeInEnd: 0.1,
                                    fadeOutBegin: 0.11,
                                  ),
                                  FadeAnimatedText('1',duration: const Duration(milliseconds: 700),
                                    textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        fontSize: 20,
                                        color: Theme.of(context).colorScheme.primary
                                    ),
                                    fadeInEnd: 0.1,
                                    fadeOutBegin: 0.11,
                                  ),
                                ]
                          ),
                              )
                              :Center(
                            child: SizedBox(
                              child: PulsatingAnimation(
                                key: const ValueKey<int>(2),
                                //key: Key('anim'),
                                breatheIn: widget.breatheIn,hold1: widget.hold1,breatheOut: widget.breatheOut,hold2: widget.hold2,noOfCounts: widget.noOfCounts,colorA: widget.colorA,colorB: widget.colorB, exhaleThrough: widget.exhaleThrough,messageList: widget.messageList,),
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              )
            ),
          );
        }
      ),
    );
  }
}

AudioPlayer audioPlayer = AudioPlayer();

class PulsatingAnimation extends StatefulWidget {
  final int breatheIn;
  final int hold1;
  final int breatheOut;
  final int hold2;
  final int noOfCounts;
  final String colorA;
  final String colorB;
  final String exhaleThrough;
  final List messageList;


  const PulsatingAnimation({super.key,required this.breatheIn,required this.hold1,required this.breatheOut,required this.hold2,required this.noOfCounts,required this.colorA,required this.colorB,required this.exhaleThrough, required this.messageList});

  @override
  State<PulsatingAnimation> createState() => _PulsatingAnimationState();
}

class _PulsatingAnimationState extends State<PulsatingAnimation> with SingleTickerProviderStateMixin{

  late AnimationController _animationController;
  late Animation _animation;

  Color myColor(String color){
    return Color(int.parse('0xff$color'));
  }

  int selectedText = 0;

  showCompletionSheet(){
    showBottomSheet(
      enableDrag: false,
        elevation: 0.0,
        context: context,
        //useSafeArea: true,
        builder: (context) {
          return WillPopScope(
            onWillPop: ()async{
              return false;
            },
            child: StatefulBuilder(
              builder: (context,setState) =>
                  Container(
                    height: MediaQuery.of(context).size.height * 0.85 ,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
                    decoration: const BoxDecoration(
                      borderRadius:  BorderRadius.vertical(top: Radius.circular(25)),
                    ),
                    child:  SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                              child: LottieBuilder.asset('assets/animations/relaxed.json')),
                          const SizedBox(height: 15,),
                          Text("Congratulations! You've Taken a Step Towards Inner Harmony.",textAlign: TextAlign.center,style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 17),
                          ),
                          const SizedBox(height: 20,),
                          Text('Great job on completing your breathing exercise! 🌬️',style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.9),
                              fontWeight: FontWeight.bold
                          ),
                              textAlign: TextAlign.center
                          ),
                          const SizedBox(height: 20,),
                          Text("By dedicating time to your well-being, you're sowing the seeds of calm and clarity within. Each breath you've taken has moved you closer to a balanced, more centered you.",style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black,
                              fontSize: 14
                          ),
                              textAlign: TextAlign.center
                          ),
                          const SizedBox(height: 10,),
                          Divider(
                            indent: 10,
                            endIndent: 10,
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                            thickness: 0.5,
                          ),
                          const SizedBox(height: 10,),
                          Text("How Are You Feeling??",textAlign: TextAlign.center,style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 17),
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                   // borderRadius: BorderRadius.circular(15),
                                    border: Border.all()
                                  ),
                                  child: Text('😞',style: TextStyle(fontSize: 22),),
                                ),
                              )),
                              Expanded(child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    //borderRadius: BorderRadius.circular(15),
                                    border: Border.all()
                                  ),
                                  child: Text('😑',style: TextStyle(fontSize: 22),),
                                ),
                              )),
                              Expanded(child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                  //  borderRadius: BorderRadius.circular(15),
                                    border: Border.all()
                                  ),
                                  child: Text('🙂',style: TextStyle(fontSize: 22),),
                                ),
                              )),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Center(
                              child: InkWell(
                                onTap: () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context,animation,secondaryAnimation) =>const BreatheCat(),
                                  transitionDuration: const Duration(
                                      milliseconds: 1000
                                  ),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                )),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: kToolbarHeight,
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                    borderRadius:  BorderRadius.circular(25),
                                    color: myColor(widget.colorA),
                                    gradient: LinearGradient(
                                        colors: [
                                          myColor(widget.colorA),
                                          myColor(widget.colorB).withOpacity(0.8),
                                          myColor(widget.colorB).withOpacity(0.8),
                                          myColor(widget.colorA),
                                        ]
                                    ),
                                  ),
                                  child: Text('Done',style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimaryContainer
                                  ),),
                                ),
                              )
                          ),
                          const SizedBox(height: 15,),
                        ],
                      ),
                    ),
                  )
            ),
          );
        }
    );
  }

  List texts = [];

  List icons = [];

  int numberOfCounts = 0;
  Timer? vibrationTimer;
  bool startAnimation  = false;

  initSound()async{

    await audioPlayer.play(UrlSource('https://eeasy.s3.ap-south-1.amazonaws.com/brain/harmony/1694864290956.mp3'));
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    audioPlayer.setVolume(0.4);
    
  }

  bool activateListener = true;

  @override
  void initState() {
    print(widget.exhaleThrough);
    setState(() {
      texts = widget.messageList;
      if(widget.exhaleThrough == 'nose'){
        icons = [
          MyIcons.inhale,
          MyIcons.pause_circle,
          MyIcons.exhale,
          MyIcons.pause_circle,
        ];
      }
      else{
        icons = [
          MyIcons.inhale,
          MyIcons.pause_circle,
          MyIcons.exhale_mouth,
          MyIcons.pause_circle,
        ];
      }

    });
    initSound();
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.breatheIn),
        reverseDuration: Duration(milliseconds: widget.breatheOut)
    );
    _animation = Tween(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut,reverseCurve: Curves.easeOut),
    );
    _animationController.addStatusListener((status) {
      if(status == AnimationStatus.forward){
        if(startAnimation == false){
          setState(() {
            startAnimation = true;
          });
        }
        setState(() {
          startAnimation = true;
        });
        Timer(Duration(milliseconds:widget.breatheIn),(){
          setState(() {
            selectedText = 1;
          });
        });
      }
      else if (status == AnimationStatus.reverse){
        Timer(Duration(milliseconds:widget.breatheOut),(){
          setState(() {
            selectedText = 3;
          });
        });
      }
      else if(status == AnimationStatus.completed){
        Future.delayed(Duration(milliseconds: widget.hold1),(){
          _animationController.reverse();
          setState(() {
            selectedText = 2;

          });
        });
      }
      else if (status == AnimationStatus.dismissed){

        Future.delayed(Duration(milliseconds: widget.hold2),(){
          setState(() {
            numberOfCounts++;
            selectedText = 0;
          });
          if(numberOfCounts == widget.noOfCounts){
            audioPlayer.stop();
            _animationController.stop(canceled: true);
            setState(() {
              startAnimation  = false;
            });
            showCompletionSheet();
          }
          else{
            _animationController.forward();
          }

        });
      }
    });
    _animationController.forward();
    print(_animationController.status);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer.dispose();
    _animationController.stop(canceled: true);
    _animationController.dispose();
    _animationController.removeStatusListener((status) {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
      },
      child:  AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
             // clipBehavior: Clip.none,
              children: [

                Center(
                  child: Container(
                      height: MediaQuery.of(context).size.width * 0.35,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          for (int i = 1; i <= 3; i++)
                            BoxShadow(
                              color: Colors.white.withOpacity(_animationController.value / 2.25),
                              spreadRadius: _animation.value * 2.85 * i,
                              // spreadRadius:  _animation.value + 2 * 5,
                            )
                        ],
                      ),
                      child:  Center(
                        child:AnimatedSwitcher(
                          duration: const Duration(milliseconds: 1000),
                          child: SvgPicture.asset(
                            icons[selectedText],
                            height: 60,
                            width: 60,
                            color: Theme.of(context).colorScheme.primary,
                            key: ValueKey<int>(selectedText),
                          ),
                        )
                      )
                  ),
                ),
            Positioned(
             bottom:  10,//MediaQuery.of(context).padding.top,
               right: 10,
               child: Components(context).BlurBackgroundCircularButton(
                 iconColor: Theme.of(context).colorScheme.primary,
                 onTap: (){
                   setState(() {
                     (audioPlayer.volume == 0.0)?audioPlayer.setVolume(0.4):audioPlayer.setVolume(0.0);
                   });
                 },
                   backgroundColor: Colors.white,svg: (audioPlayer.volume  == 0)?MyIcons.mute:MyIcons.volume_high),),
            Positioned(
             bottom:  0,//MediaQuery.of(context).padding.top,
               right: 5,
               left: 5,
               top: MediaQuery.of(context).size.height * 0.5 + 23.5,
               child: AnimatedSwitcher(
                 duration: const Duration(milliseconds: 1000),
                 child: Text(
                   texts[selectedText],
                   key: ValueKey<int>(selectedText),
                   style: Theme.of(context).textTheme.labelMedium?.copyWith(
                     fontSize: 15,
                     color: Theme.of(context).colorScheme.primary,
                   ),
                   textAlign: TextAlign.center,
                 ),
               )
            )
                /*  Positioned(
                    bottom: 10,
                    //right: 25,
                    left: 10,
                    child: AnimatedOpacity(
                      opacity: startAnimation?1:0,
                      duration: Duration(seconds: 1),
                      child: FilledButton.icon(
                          onPressed: (){
                            _animationController.reset();
                            print(_animationController.status);
                            */
                /*setState(() {
                              activateListener = !activateListener;
                            });
                            print(activateListener);
                            if (_animationController.isAnimating) {
                              _animationController.stop();
                            } else {
                              _animationController.forward();
                            */
                /*},
                          icon: (activateListener)?Icon(Icons.pause_rounded):Icon(Icons.play_arrow_rounded),
                          label: Text((activateListener)?'Pause':'Play')
                      ),
                    )
                )*/
              ],
            ),
          );
        },
      ),

    );
  }
}

