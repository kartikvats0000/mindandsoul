import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:mindandsoul/constants/iconconstants.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:video_player/video_player.dart';

class VideoYoga extends StatefulWidget {
  final Map data;
  const VideoYoga({super.key, required this.data});

  @override
  State<VideoYoga> createState() => _VideoYogaState();
}

class _VideoYogaState extends State<VideoYoga> {
  late VideoPlayerController yogaVideoPlayer;
  bool loader = true;

  bool show = true;

  Timer? showTimer;

  int repCount = 0;

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
                      '✨ Keep up the fantastic work, and remember that the journey of a thousand miles begins with a single step. Your dedication will lead you to a more relaxed, energized, and centered self. ✨',
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

  showOrHideButtons() {
    setState(() {
      show = !show;
      if (showTimer != null) {
        if (showTimer!.isActive) {
          showTimer?.cancel();
        }
      }

      showTimer = Timer(const Duration(seconds: 4), () {
        setState(() {
          show = false;
        });
      });
    });
  }

  Timer? timer;

  _initVideo() {
    yogaVideoPlayer =
        VideoPlayerController.networkUrl(Uri.parse(widget.data['video']))
          ..initialize().then((_) {
            setState(() {
              loader = false;
              showOrHideButtons();

            });
          });
    yogaVideoPlayer.setLooping(false);
    yogaVideoPlayer.addListener(checkVideo);
    /* timer = Timer.periodic(yogaVideoPlayer.value.duration, (_timer) {
                setState(() {
                  repCount++;
                });
                if (repCount < widget.data['limit']) {
                  setState(() {
                    print('rep $repCount');
                    yogaVideoPlayer.play();
                    yogaVideoPlayer.seekTo(Duration.zero);
                  });
                } else {
                  yogaVideoPlayer.pause();
                  Components(context)
                      .showSuccessSnackBar('completed $repCount reps');
                  showCompletionSheet();
                  _timer.cancel();
                  timer?.cancel();
                }
              });*/
    yogaVideoPlayer.play();
  }

  void checkVideo() {
    if(repCount < widget.data['limit']){
      if((yogaVideoPlayer.value.position == yogaVideoPlayer.value.duration) && yogaVideoPlayer.value.isCompleted){
        setState(() {
          repCount++;
          print('$repCount done');
        });
       /* if(!yogaVideoPlayer.value.isPlaying) {
          yogaVideoPlayer.play();
        }*/
        if(repCount == widget.data['limit']){
          yogaVideoPlayer.pause();
        }
        else{
          yogaVideoPlayer.play();
          yogaVideoPlayer.seekTo(Duration.zero);
        }

      }
    }
    else if(repCount == widget.data['limit']){
      // if(yogaVideoPlayer.value.isPlaying){
      //   yogaVideoPlayer.pause();
      // }
      showCompletionSheet();
     // Components(context).showSuccessSnackBar('Completed $repCount');
      //yogaVideoPlayer.dispose();
      yogaVideoPlayer.pause();
      yogaVideoPlayer.removeListener(checkVideo);
    }
  }


  @override
  void initState() {
    _initVideo();
/*    yogaVideoPlayer.addListener(() {
      if(repCount == widget.data['limit']){
        setState(() {
          yogaVideoPlayer.pause();
        });
        yogaVideoPlayer.removeListener(() {});
      }
      if(yogaVideoPlayer.value.duration.inMilliseconds == yogaVideoPlayer.value.position.inMilliseconds){
        setState(() {
          repCount++;
        });
      }
      print(repCount);
    });*/
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {

      yogaVideoPlayer.dispose();
      yogaVideoPlayer.removeListener(checkVideo);

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var onwillpop = true;
        if (yogaVideoPlayer.value.isPlaying) {
          showDialog(
              context: context,
              builder: (context) {
                return Components(context).confirmationDialog(context,
                    title: 'Confirm Exit',
                    message:
                        'You are currently in between a yoga session. Do you really want to leave this page?',
                    actions: [
                      FilledButton.tonal(
                          onPressed: () {
                            onwillpop = true;
                            yogaVideoPlayer.dispose();
                            yogaVideoPlayer.removeListener(checkVideo);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text('Yes')),
                      FilledButton.tonal(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('No')),
                    ]);
              });
          return onwillpop;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: (loader)
            ? Components(context).Loader(textColor: Colors.black)
            : Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.black,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    showOrHideButtons();
                  },
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: yogaVideoPlayer.value.aspectRatio,
                        child: VideoPlayer(yogaVideoPlayer),
                      ),
                      Positioned.fill(
                          child: AnimatedOpacity(
                        opacity: (show) ? 1 : 0,
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.ease,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Colors.black87,
                                Colors.black26,
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black26,
                                Colors.black87
                              ])),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                widget.data['title'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              /*Slider(value:yogaVideoPlayer.value.position.inSeconds.toDouble(), onChanged: (vol){
                                  yogaVideoPlayer.seekTo(position)
                                }),*/
                              VideoProgressIndicator(
                                yogaVideoPlayer,
                                allowScrubbing: true,
                                colors: VideoProgressColors(
                                    playedColor:
                                        Theme.of(context).colorScheme.primary,
                                    bufferedColor:
                                        Theme.of(context).colorScheme.surface,
                                    backgroundColor: Colors.white70),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Components(context).myIconWidget(
                                      icon: MyIcons.backward_skip,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      size: 35,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  (yogaVideoPlayer.value.isBuffering)
                                      ? const SizedBox(
                                    height: 45,
                                    width: 45,
                                    child: SpinKitSpinningLines(
                                      color: Colors.white,
                                    ),
                                  )
                                      : Components(context)
                                      .BlurBackgroundCircularButton(
                                          buttonRadius: 65,
                                          iconSize: 55,
                                          onTap: () {
                                            if (show) {
                                              setState(() {
                                                yogaVideoPlayer.value.isPlaying
                                                    ? yogaVideoPlayer.pause()
                                                    : yogaVideoPlayer.play();
                                              });
                                            }
                                          },
                                          icon: (yogaVideoPlayer.value.isPlaying)
                                                  ? Icons.pause_rounded
                                                  : Icons.play_arrow_rounded),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Components(context).myIconWidget(
                                      icon: MyIcons.forward_skip,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      size: 35,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
