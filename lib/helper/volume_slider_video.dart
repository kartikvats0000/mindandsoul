import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VolumeSlider extends StatefulWidget {
  bool showVolumeSlider;
  VideoPlayerController videoPlayerController;
  VolumeSlider({super.key, required this.showVolumeSlider,required this.videoPlayerController});

  @override
  State<VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
  @override
  Widget build(BuildContext context) {
    print(widget.videoPlayerController.value.volume);
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      right: (widget.showVolumeSlider)?5:-50,
      //right: (showVolumeSlider)?7.5:-70,
      top: 85,
      //top: (showVolumeSlider)?85:-200,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(25)
        ),
        child: RotatedBox(
          quarterTurns: -1,
          child: Slider(
              min: 0,
              max: 1,
              value: widget.videoPlayerController.value.volume,
              onChangeEnd: (val){
                setState(() {
                  widget.showVolumeSlider = false;
                });
              },
              onChanged: (val){
                setState(() {
                  widget.videoPlayerController.setVolume(val);
                });

              }
          ),
        ),
      ),
    );
  }
}
