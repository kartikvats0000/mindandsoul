import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:provider/provider.dart';

import '../constants/iconconstants.dart';

export 'playersheet.dart';
export 'contentviewroute.dart';



class Components{
  BuildContext context;

  Components(this.context);

  bool showVolumeSlider = false;

  Widget customAppBar({
    required List<Widget> actions ,
    Color topColor = Colors.transparent,
    Color scrolledColor = Colors.white54,
    required Widget title,
    required bool isScrolling,
    Duration duration = const Duration(milliseconds: 450)
  }){
    return ClipRRect(
      child: BackdropFilter(
        filter: (isScrolling)?ImageFilter.blur(sigmaY: 10,sigmaX: 10):ImageFilter.dilate(),
        child: AnimatedContainer(
          duration: duration,
          color: (isScrolling)?scrolledColor:topColor,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+10,bottom: 13,left: 7,right: 7),
          child: Row(
          children: [
            Components(context).BlurBackgroundCircularButton(icon: Icons.chevron_left,onTap: (){
              HapticFeedback.selectionClick();
              Navigator.pop(context);
            }),
            const SizedBox(width: 10,),
            Expanded(
                child: AnimatedOpacity(
                  duration: duration,
                    opacity: (isScrolling)?1:0,
                    child: title)
            ),
            const SizedBox(width: 7,),
            Row(
              children: actions,
            )
          ],
        ),
        //  height: kToolbarHeight+25,
        ),
      ),
    );
  }

  PreferredSizeWidget myAppBar({required String title, List<Widget> actions = const [],TextStyle? titleStyle}){

    ThemeProvider theme = Provider.of<ThemeProvider>(context,listen: false);
    titleStyle ??= Theme.of(context).textTheme.displayLarge?.copyWith(color: theme.textColor,fontSize: 25);
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight+20),
      child: AppBar(
        toolbarHeight: kToolbarHeight+20,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        automaticallyImplyLeading: false,
        actions: actions,
        leading: Padding(
          padding: const EdgeInsets.all(9),
          child: Components(context).BlurBackgroundCircularButton(icon: Icons.chevron_left,onTap: (){
            HapticFeedback.selectionClick();
            Navigator.pop(context);
          }),
        ),
        title: Text(title,style: titleStyle,),
      ),
    );
  }



  Widget myIconWidget({required String icon, Color color = Colors.white70, double size = 23}){
    return SvgPicture.asset(icon,color: color,height: size,width: size,);
  }

  Widget tags({required String title, required BuildContext context, Color textcolor = Colors.white})
  {
    ThemeProvider theme = Provider.of<ThemeProvider>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 5,sigmaX: 5),
        child: Container(
          //height: 25,
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black12,
            border: Border.all(
                width: 0.4,
                color: theme.textColor
            ),
            borderRadius: BorderRadius.circular(15),

          ),
          child: Text(title, style: Theme
              .of(context)
              .textTheme
              .bodySmall
              ?.copyWith(
              color: textcolor.withOpacity(0.9),
              fontWeight: FontWeight.w900,
              fontSize: 11,
          ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget Loader({String title = 'Patience Breeds\nPeace',required Color textColor}){
    return Center(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitSpinningLines(color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 15,),
            Text(title,style: TextStyle(
                color: textColor
            ),textAlign: TextAlign.center,)
          ],
        ));
  }

  Widget WeatherDetailCard(String title, String value){
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context,listen: false);
    return Container(
      //  height: 20,
      padding: const EdgeInsets.all(7),
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.825),
          borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: const TextStyle(color: Colors.white70,fontSize: 12),),
          const SizedBox(height: 5,),
          Text(value,style: TextStyle(color: themeProvider.textColor,fontSize: 14,fontWeight: FontWeight.w600),),
        ],
      ),
    );
  }

  Widget WeatherDetailCard2(String title, String value){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(title,style: TextStyle(color: Colors.grey.shade700,fontSize: 12,fontWeight: FontWeight.w600),)),
        Text(value,style: const TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w700),),
      ],
    );
  }

  Widget BlurBackgroundCircularButton({
    Color iconColor =  Colors.white,
    IconData? icon,
    String? svg,
    VoidCallback? onTap,
    double buttonRadius = 20,
    double iconSize = 22,
    Color backgroundColor = Colors.black38
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor:backgroundColor,
        //Colors.black54.withOpacity(0.75),
        radius: buttonRadius,
        child: (svg == null)
            ?Icon(icon,color: iconColor,size: iconSize,)
            :myIconWidget(icon: svg,color: iconColor,size: iconSize)
      ),
    );
  }

  showSuccessSnackBar(String content, {EdgeInsetsGeometry margin = const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 10.0)}){
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      showCloseIcon: true,
        content: Container(
          padding: const EdgeInsets.all(20.0),
         // margin: const EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
            color: Colors.white54,
           // color: Theme.of(context).colorScheme.primary,
           //  gradient:  LinearGradient(
           //    colors: [Theme.of(context).colorScheme.secondary.withOpacity(0.9),Theme.of(context).colorScheme.primary,], // Define your gradient colors
           //    begin: Alignment.centerLeft, // Adjust the gradient's starting position
           //    end: Alignment.centerRight, // Adjust the gradient's ending position
           //  ),
            borderRadius: BorderRadius.circular(3.0),
          ),
          child: Text(content,style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.w800),),
        ),
      margin: margin,
      padding: const EdgeInsets.all(0),
      elevation: 0.0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 4),
      shape: RoundedRectangleBorder(
       // side: BorderSide(color: Theme.of(context).colorScheme.inversePrimary, width: 0.75),
        borderRadius: BorderRadius.circular(5),
      ),
    )
    );
  }

  showErrorSnackBar(String content){
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      padding: const EdgeInsets.all(0),
      showCloseIcon: true,
      content: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white54,
         /* gradient: const LinearGradient(
            colors: [ Color(0xff800000),Color(0xffD32121)], // Define your gradient colors
            begin: Alignment.centerLeft, // Adjust the gradient's starting position
            end: Alignment.centerRight, // Adjust the gradient's ending position
          ),*/
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: Text(content,style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.error),),
      ),
      elevation: 0.0,
      backgroundColor: Theme.of(context).colorScheme.error,
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 4),
      onVisible: (){},
      shape:RoundedRectangleBorder(
       //side: const BorderSide(color: Colors.redAccent, width: 0.75),
        borderRadius: BorderRadius.circular(5),
      ),
    )
    );
  }

  confirmationDialog(BuildContext context,{
    required String title,
    required String message,
    required List<Widget> actions,
  }) => ClipRRect(
    borderRadius: BorderRadius.circular(15),
    child: AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      title: Text(title),
      content: Text(message),
      titleTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 19,fontWeight: FontWeight.w700,color: Colors.black87),
      contentTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87),
      actions: actions
    ),
  );

}

String getDurationString(Duration duration) {
  String minutes = duration.inMinutes.toString().padLeft(2,'0');
  String seconds = (duration.inSeconds % 60).toString().padLeft(2,'0');

  if (minutes == 0) {
    return '00:$seconds';
  } else {
    return '$minutes:$seconds';
  }
}

Widget buildbreathsIndicatorList(Map durations,Color color, String exhaleTrough, BuildContext context){
  return Theme(
    data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: color)
    ),
    child: Builder(
        builder: (context) {
          return Row(
            children: [
              Row(
                children: [
                  Components(context).myIconWidget(icon: MyIcons.inhale,size: 16,color: Colors.white70),
                  Text(' : ${durations['breatheIn']}s',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),),
                ],
              ),
              const SizedBox(width: 9,),
              Visibility(
                visible:durations['hold1'] != 0 ,
                child: Row(
                  children: [
                    Components(context).myIconWidget(icon: MyIcons.pause_circle,size: 16,color: Colors.white70),
                    Text(' : ${durations['hold1']}s',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),),
                  ],
                ),
              ),
              const SizedBox(width: 9,),
              Row(
                children: [
                  Components(context).myIconWidget(icon:(exhaleTrough == 'nose')? MyIcons.exhale:MyIcons.exhale_mouth,size: 16,color: Colors.white70),
                  Text(' : ${durations['breatheOut']}s',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),),
                ],
              ),

            ],
          );
        }
    ),
  );
}

Widget buildbreathIndicator(String icon, String title, String breath,BuildContext context){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Components(context).myIconWidget(icon: icon,size: 32,color: Theme.of(context).colorScheme.primary),
      Text(title,style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.surfaceTint,
          fontWeight: FontWeight.w500
      ),),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(breath,style: Theme.of(context).textTheme.titleLarge?.copyWith(color:Theme.of(context).colorScheme.primary,fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
          Text(' sec',style: Theme.of(context).textTheme.titleSmall?.copyWith(color:Theme.of(context).colorScheme.primary,fontWeight: FontWeight.w700),textAlign: TextAlign.center),
        ],
      ),

    ],
  );
}

Color myColor(String color){
  return Color(int.parse('0xff$color'));
}




String generateRandomHexId() {
  // Create a Random object for generating random values
  Random random = Random();

  // Generate a random 5-digit hexadecimal number
  int randomHexValue = random.nextInt(0xFFFFF); // 0xFFFFF is the maximum value for a 5-digit hexadecimal number

  // Convert the random value to a hexadecimal string
  String hexId = randomHexValue.toRadixString(16);

  // Ensure that the string has exactly 5 characters by padding with zeros if needed
  hexId = hexId.padLeft(5, '0');

  return hexId.toUpperCase(); // Convert to uppercase for consistency
}
