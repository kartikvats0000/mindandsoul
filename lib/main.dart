import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:mindandsoul/provider/playerProvider.dart';
import 'package:mindandsoul/provider/userProvider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/screen/ui/splash.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  tz.initializeTimeZones();
  //LocalNotifyManager.init();
  //NotificationServices().initializeNotification();
  // NotificationService().initialize();

 /* await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );*/

  Paint.enableDithering = true;
 await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) =>ThemeProvider(),),
        ChangeNotifierProvider(create: (context) =>User(),),
        ChangeNotifierProvider(create: (context)=>MusicPlayerProvider()),
      ],

      child: Consumer<ThemeProvider>(
        builder: (context,themeProvider,child) {
          return  MaterialApp(
              theme: ThemeData(
                  useMaterial3: true,
                  colorScheme: ColorScheme.fromSeed(seedColor: themeProvider.themeColorA),

                  sliderTheme:  const SliderThemeData(
                    // overlayShape: SliderComponentShape.noOverlay,
                    // activeTrackColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
                    //inactiveTrackColor: Theme.of(context).colorScheme.inversePrimary,
                    trackHeight: 1.0,
                   // thumbColor: Theme.of(context).colorScheme.inversePrimary,
                    thumbShape:  RoundSliderThumbShape(enabledThumbRadius: 8.5),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    hintStyle:  TextStyle(color: themeProvider.textColor.withOpacity(0.4),fontWeight: FontWeight.normal,fontSize: 14),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 14),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:  BorderSide(
                            width: 1,
                            color: themeProvider.textColor.withOpacity(0.8)
                        )
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            width: 0.85,
                           color: themeProvider.textColor.withOpacity(0.8)
                           // color: CustomColors.primaryColor
                        )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            width: 1.75,
                            color: themeProvider.textColor.withOpacity(0.85)
                        )
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: 1,
                        color: themeProvider.textColor.withOpacity(0.2)
                      )
                    )
                  ),
                  textTheme: TextTheme(
                      displayLarge: GoogleFonts.aboreto(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 57,
                            color: themeProvider.textColor
                        ),
                      ),
                      displayMedium: GoogleFonts.raleway(
                        textStyle:TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 45,
                            color: themeProvider.textColor
                        ),),
                      displaySmall: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 36,
                            color: themeProvider.textColor
                        ),
                      ),
                      headlineLarge: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 32,
                            color: themeProvider.textColor
                        ),
                      ),
                      headlineMedium: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 28,
                            color: themeProvider.textColor
                        ),
                      ),
                      headlineSmall: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 24,
                            color: themeProvider.textColor
                        ),
                      ),
                      titleLarge: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: themeProvider.textColor
                        ),
                      ),
                      titleMedium: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: themeProvider.textColor
                        ),
                      ),
                      titleSmall: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: themeProvider.textColor

                        ),
                      ),
                      labelLarge: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: themeProvider.textColor
                        ),
                      ),
                      labelMedium: GoogleFonts.aboreto(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: themeProvider.textColor

                        ),
                      ),
                      labelSmall: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            color: themeProvider.textColor

                        ),
                      ),
                      bodyLarge: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: themeProvider.textColor

                        ),
                      ),
                      bodyMedium: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: themeProvider.textColor

                        ),
                      ),
                      bodySmall: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: themeProvider.textColor

                        ),
                      )
                  )
              ),
              debugShowCheckedModeBanner: false,
              title: 'Brain N Soul',
              home: const Splash()
          );
        }

      ),
    );
  }
}


