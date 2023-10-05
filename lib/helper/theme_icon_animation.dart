import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:provider/provider.dart';

import '../constants/iconconstants.dart';

class ThemeButtonAnimation extends StatefulWidget {
  const ThemeButtonAnimation({super.key});

  @override
  State<ThemeButtonAnimation> createState() => _ThemeButtonAnimationState();
}

class _ThemeButtonAnimationState extends State<ThemeButtonAnimation> {

  int index = 0;
  late Timer timer;

  @override
  void initState() {
    ThemeProvider theme = Provider.of<ThemeProvider>(context,listen: false);
    timer =Timer.periodic(const Duration(seconds: 1), (timer) {setState(() {
      if(index == theme.themesList.length - 1){
        timer.cancel();
      }
      else{
        index++;
      }
      print(index);
    });});
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,theme,child){
        return CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 20,
          child: AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: (index == theme.themesList.length - 1)
                ? Components(context).BlurBackgroundCircularButton(svg: MyIcons.theme)
                :AnimatedSwitcher(duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  key: ValueKey<int>(index),
                    imageUrl: theme.themesList[index]['image'],fit: BoxFit.cover,),
              ) ,),
          ),
        );
      }

    );
  }
}
