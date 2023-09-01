import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'new_sound/backgroundpicker.dart';
import 'new_sound/soundmaker.dart';

class SleepSoundPageView extends StatefulWidget {
  const SleepSoundPageView({super.key});

  @override
  State<SleepSoundPageView> createState() => _SleepSoundPageViewState();
}
Map themeImage = {};
PageController pageController = PageController();

int currentIndex = 0;
class _SleepSoundPageViewState extends State<SleepSoundPageView> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(currentIndex == 0){
          Navigator.pop(context);
          return true;
        }
        else{
          pageController.previousPage(duration: Duration(milliseconds: 250), curve: Curves.easeOut);
          return false;
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: pageController,
              onPageChanged: (index){
                setState(() {
                  currentIndex = index;
                });
              },
              physics: NeverScrollableScrollPhysics(),
              pageSnapping: true,
              children: const [
                 BackGroundPicker(),
                 SoundMixer()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
