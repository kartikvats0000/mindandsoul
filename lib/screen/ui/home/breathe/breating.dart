import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:mindandsoul/helper/components.dart';

class Breathing extends StatefulWidget {
  final String title;
  final int breatheIn;
  final int hold1;
  final int breatheOut;
  final int hold2;
  final String colorA;
  final String colorB;


  const Breathing({super.key, required this.title,required this.breatheIn,required this.hold1,required this.breatheOut,required this.hold2,required this.colorA,required this.colorB});

  @override
  State<Breathing> createState() => _BreathingState();
}

class _BreathingState extends State<Breathing> {

  Color myColor(String color){
    return Color(int.parse('0xff$color'));
  }

  bool startAnimation = false;
  bool showBox = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: myColor(widget.colorA))
      ),
      child: Builder(
        builder: (context) {
          return Scaffold(
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
               onTap: () => Navigator.pop(context),
               child: const Icon(Icons.chevron_left),
              ),
            ),
            body: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          //padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
       /*   decoration:  BoxDecoration(
           gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    myColor(widget.colorA),

                                    myColor(widget.colorB),
                                  ]
                              )
                ),*/
          ),
                Center(
                  child:
                    AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                      child: (!startAnimation)
                          ?Container(
                        height: MediaQuery.of(context).size.width * 0.3,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
          ),
                            child: Center(
                              child: AnimatedTextKit(
                        //repeatForever: false,
                              isRepeatingAnimation: false,
                              totalRepeatCount: 0,
                              onFinished: (){
                                setState(() {
                                  startAnimation  = true;
                                  Timer(Duration(milliseconds: 750), () {showBox = true;});
                                });
                              },
                              animatedTexts: [
                                FadeAnimatedText('',duration: Duration(seconds: 1),
                                  textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  fadeInEnd: 0.1,
                                  fadeOutBegin: 0.11,

                                ),
                                FadeAnimatedText('Make Yourself Calm and Relaxed',duration: Duration(seconds: 2),
                                  textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  fadeInEnd: 0.1,
                                  fadeOutBegin: 0.11,

                                ),
                                FadeAnimatedText('3',duration: Duration(seconds: 1),
                                  textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  fadeInEnd: 0.1,
                                  fadeOutBegin: 0.11,

                                ),
                                FadeAnimatedText('2',duration: Duration(seconds: 1),
                                  textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      fontSize: 16,
                                      color: Theme.of(context).colorScheme.primary
                                  ),
                                  fadeInEnd: 0.1,
                                  fadeOutBegin: 0.11,
                                ),
                                FadeAnimatedText('1',duration: Duration(seconds: 1),
                                  textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      fontSize: 16,
                                      color: Theme.of(context).colorScheme.primary
                                  ),
                                  fadeInEnd: 0.1,
                                  fadeOutBegin: 0.11,
                                ),
                              ]
                      ),
                            ),
                          )
                          :PulsatingAnimation(
                        //key: Key('anim'),
                        breatheIn: widget.breatheIn,hold1: widget.hold1,breatheOut: widget.breatheOut,hold2: widget.hold2,colorA: widget.colorA,colorB: widget.colorB,),
                    )
                     /* AnimatedCrossFade(
                        firstCurve: Curves.easeIn,
                        secondCurve: Curves.easeIn,
                        sizeCurve: Curves.easeIn,
                        alignment: Alignment.center,
                        duration: Duration(milliseconds: 500),
                        crossFadeState: (startAnimation)?CrossFadeState.showSecond:CrossFadeState.showFirst,
                        firstChild: AnimatedTextKit(
                          //repeatForever: false,
                            isRepeatingAnimation: false,
                            totalRepeatCount: 0,
                            onFinished: (){
                              setState(() {
                                startAnimation  = true;
                              });
                            },
                            animatedTexts: [
                              FadeAnimatedText('',duration: Duration(seconds: 1),
                                textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                fadeInEnd: 0.1,
                                fadeOutBegin: 0.11,

                              ),
                              FadeAnimatedText('Make Yourself Calm and Relaxed',duration: Duration(seconds: 2),
                                textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                fadeInEnd: 0.1,
                                fadeOutBegin: 0.11,

                              ),
                              FadeAnimatedText('3',duration: Duration(seconds: 1),
                                textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                fadeInEnd: 0.1,
                                fadeOutBegin: 0.11,

                              ),
                              FadeAnimatedText('2',duration: Duration(seconds: 1),
                                textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.primary
                                ),
                                fadeInEnd: 0.1,
                                fadeOutBegin: 0.11,
                              ),
                              FadeAnimatedText('1',duration: Duration(seconds: 1),
                                textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.primary
                                ),
                                fadeInEnd: 0.1,
                                fadeOutBegin: 0.11,
                              ),
                            ]
                        ),
                        secondChild: (!startAnimation)
                            ? SizedBox.shrink()
                            :PulsatingAnimation(
                              //key: Key('anim'),
                              breatheIn: widget.breatheIn,hold1: widget.hold1,breatheOut: widget.breatheOut,hold2: widget.hold2,colorA: widget.colorA,colorB: widget.colorB,),
                      )*/

                ),
              ],
            )
          );
        }
      ),
    );
  }
}


class PulsatingAnimation extends StatefulWidget {
  final int breatheIn;
  final int hold1;
  final int breatheOut;
  final int hold2;
  final String colorA;
  final String colorB;

  const PulsatingAnimation({super.key,required this.breatheIn,required this.hold1,required this.breatheOut,required this.hold2,required this.colorA,required this.colorB});

  @override
  State<PulsatingAnimation> createState() => _PulsatingAnimationState();
}

class _PulsatingAnimationState extends State<PulsatingAnimation> with SingleTickerProviderStateMixin{

  late AnimationController _animationController;
  late Animation _animation;


  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: widget.breatheIn),
        reverseDuration: Duration(seconds: widget.breatheOut)
    );
    _animation = Tween(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut,reverseCurve: Curves.easeInOut),
    );
    _animationController.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        Future.delayed(Duration(seconds: widget.hold1),(){_animationController.reverse();});
      }
      else if (status == AnimationStatus.dismissed){
        Future.delayed(Duration(seconds: widget.hold2),(){_animationController.forward();});
      }
    });
    _animationController.forward();
    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: Duration(
    //     seconds: widget.breatheIn + widget.hold1 + widget.breatheOut + widget.hold2,
    //   ),
    // );
    //
    // _animation = Tween<double>(begin: 0, end: 12).animate(
    //   CurvedAnimation(
    //     parent: _animationController,
    //     curve: Interval(
    //       0.0,  // Start at 0%
    //       (widget.breatheIn / _animationController.duration!.inSeconds).toDouble(),  // Breathe in duration as a fraction
    //       curve: Curves.easeInOut,
    //     ),
    //   ),
    // )..addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     Future.delayed(Duration(seconds: widget.hold1), () {
    //       _animationController.reverse();
    //     });
    //   } else if (status == AnimationStatus.dismissed) {
    //     Future.delayed(Duration(seconds: widget.hold2), () {
    //       _animationController.forward();
    //     });
    //   }
    // });
    //
    // _animationController.forward();
    /*_animationController.repeat(reverse: true);*/
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    _animationController.removeStatusListener((status) {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child:  AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return Ink(
              height: MediaQuery.of(context).size.width * 0.3,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  for (int i = 1; i <= 3; i++)
                    BoxShadow(
                      color: Colors.white.withOpacity(_animationController.value / 2),
                      spreadRadius: _animation.value * 2.7 * i,
                      // spreadRadius:  _animation.value + 2 * 5,
                    )
                ],
              ),
              child:  Center(
                child:/*Text('Breathe',style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),)*/
                AnimatedTextKit(
                    animatedTexts: [
                      RotateAnimatedText('Breathe In',
                        duration: Duration(seconds: widget.breatheIn),
                        textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),

                      ),
                      RotateAnimatedText('Hold',duration: Duration(seconds: widget.hold1),
                        textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),

                      ),
                      RotateAnimatedText('Breathe Out',duration: Duration(seconds: widget.breatheOut),
                        textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary
                        ),

                      ),
                      RotateAnimatedText('Relax',duration: Duration(seconds: widget.hold2),
                        textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary
                        ),
                      ),
                    ]
                ),
              )
          );
        },
      ),

    );
  }
}

