import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/provider/userProvider.dart';
import 'package:provider/provider.dart';

import '../../../../../helper/components.dart';


class Downloads extends StatefulWidget {
  const Downloads({super.key});

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider,User>(
      builder: (context,theme,user,child) =>
       Scaffold(
         backgroundColor: theme.themeColorA,
         extendBodyBehindAppBar: true,
         appBar: AppBar(
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
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: theme.themeColorA,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.themeColorA,
                    theme.themeColorB,
                    theme.themeColorA,
                  ]
              )
          ),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               SizedBox(
                 height: 350,
                   width: 350,
                   child: LottieBuilder.asset('assets/animations/downloads.json')),
               Text('Your downloads are empty, but your collection awaits.\nStart saving your favorites now',style: Theme.of(context).textTheme.titleMedium?.copyWith(
                 color: theme.textColor.withOpacity(0.8)
               ),
               textAlign: TextAlign.center,)
             ],
           ),
        ),
      ),
    );
  }
}
