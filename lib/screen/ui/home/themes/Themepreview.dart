import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../constants/iconconstants.dart';
import '../../../../helper/components.dart';
import '../../../../provider/themeProvider.dart';
import '../../../../provider/userProvider.dart';

class ThemePreview extends StatefulWidget {
  final dynamic themeDetails;
  const ThemePreview({Key? key,required this.themeDetails}) : super(key: key);

  @override
  State<ThemePreview> createState() => _ThemePreviewState();
}

class _ThemePreviewState extends State<ThemePreview> {

  bool isLoading = true;

  late VideoPlayerController previewVideoPlayer;

  void initVideo(){
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context,listen: false);
    previewVideoPlayer = VideoPlayerController.networkUrl(Uri.parse(themeProvider.baseurl+widget.themeDetails['video']))..initialize().then((value) {
      setState(() {
        isLoading = false;
      });
    });
    print('initial--${themeProvider.baseurl+themeProvider.videoUrl}');
    previewVideoPlayer.setVolume(0.60);
    previewVideoPlayer.play();
    previewVideoPlayer.setLooping(true);
  }

  setDefaultTheme(String theme)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('defaultTheme', theme);
  }

  @override
  void initState() {
    initVideo();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    previewVideoPlayer.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  bool setDefault = false;
  bool buttonLoad = false;

  @override
  Widget build(BuildContext context) {
    //print('video ${previewVideoPlayer.value}');
    return Consumer<ThemeProvider>(
      builder: (context,themeData,child) =>
       Theme(
         data: Theme.of(context).copyWith(
           useMaterial3: true,
               colorScheme: ColorScheme.fromSeed(seedColor:Color(int.parse('0xff' + widget.themeDetails['baseColor1'])),),
        ),
         child: Builder(
           builder: (context) =>
            Scaffold(
             backgroundColor: Color(int.parse('0xff' + widget.themeDetails['baseColor1'])),
            extendBodyBehindAppBar: true,
            extendBody: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: Padding(
                padding: EdgeInsets.all(7),
                child: Components(context).BlurBackgroundCircularButton(
                  icon: Icons.close,
                  onTap: (){Navigator.pop(context);},
                )
              ),
              actions: [
                Components(context).BlurBackgroundCircularButton(
                    svg: (previewVideoPlayer.value.volume >0)?MyIcons.volume_high:MyIcons.mute,
                   onTap: (){
                    setState(() {
                    if(previewVideoPlayer.value.volume > 0){
                      previewVideoPlayer.setVolume(0);
                    }
                    else{
                      previewVideoPlayer.setVolume(1);
                    }
                  });},
                ),
                SizedBox(width: 5,),
              ],
            ),
            body: (isLoading)?
            Components(context).Loader(textColor: Color(int.parse('0xff' + widget.themeDetails['textColor'])))
                :Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: VideoPlayer(
                        previewVideoPlayer
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(int.parse('0xff' + widget.themeDetails['baseColor1'])),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(int.parse('0xff' + widget.themeDetails['baseColor1'])),
                                  Color(int.parse('0xff' + widget.themeDetails['baseColor2'])),
                                ]
                            ),
                          //backgroundBlendMode: BlendMode.color,
                          boxShadow: [
                            BoxShadow(
                                color: Color(int.parse('0xff' + widget.themeDetails['baseColor1'])),
                                blurRadius: 50,
                                spreadRadius: 80,
                                blurStyle: BlurStyle.normal
                            )
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 38.0),
                                        child: Text(widget.themeDetails['title'],style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                          fontSize: 39,
                                          color: Color(int.parse('0xff' + widget.themeDetails['textColor'])).withOpacity(0.8),
                                        ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Row(
                                            children: [
                                              Text('“',style: GoogleFonts.imFellGreatPrimerSc(
                                                  textStyle: TextStyle(
                                                      color: Color(int.parse('0xff' + widget.themeDetails['textColor'])).withOpacity(0.50),
                                                      fontSize: 75
                                                  )
                                              )),
                                              Expanded(child: Text(' ${widget.themeDetails['tagline']} ',textAlign: TextAlign.center,style: TextStyle(
                                                  color: Color(int.parse('0xff' + widget.themeDetails['textColor'])).withOpacity(0.70),
                                                  height:2),)),
                                              Text('”',style: GoogleFonts.imFellGreatPrimerSc(
                                                  textStyle: TextStyle(
                                                      color: Color(int.parse('0xff' + widget.themeDetails['textColor'])).withOpacity(0.50),
                                                      fontSize: 75
                                                  )
                                              )),
                                              //Text('"',style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 100,color: Colors.white70),),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: (buttonLoad)?SpinKitSpinningLines(color: Theme.of(context).colorScheme.primary)
                                      :Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 7),
                                    height: kToolbarHeight,
                                            width: double.infinity,
                                            child: FilledButton(
                                    style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                  (Set<MaterialState> states) {
                                                    var colorr =Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                        .withOpacity(0.5);
                                                if (states.contains(MaterialState.pressed)) {
                                                  colorr = Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withOpacity(0.5);
                                                } else if (states.contains(MaterialState.disabled))
                                                  colorr = Color(int.parse('0xff' + widget.themeDetails['baseColor1'])).withOpacity(0.5);
                                                return colorr;// Use the component's default.
                                              },
                                            ),
                                    ),
                                    onPressed: (themeData.id == widget.themeDetails['_id'])
                                              ?null
                                              :()async{
                                      User user = Provider.of<User>(context,listen: false);
                                          /*  setState(() {
                                              buttonLoad = true;
                                            });*/
                                            await themeData.updateTheme(widget.themeDetails);
                                            if(setDefault == true){
                                              await setDefaultTheme(json.encode(widget.themeDetails));
                                            }
                                            /*  Navigator.of(context).pushAndRemoveUntil(
                                              PageRouteBuilder(
                                                maintainState: true,
                                                opaque: false,
                                                  pageBuilder: (context,animation,secondaryAnimation) => BottomNavScreen()
                                              ),
                                                 //_createRoute(),
                                                    (Route<dynamic> route) => true
                                            );*/

                                            /* Navigator.of(context).pushAndRemoveUntil(
                                                MaterialPageRoute(builder: (context) => const BottomNavScreen()),
                                                    (Route<dynamic> route) => false
                                            );*/
                                            await Services(user.token).themeCounter(widget.themeDetails['_id']);
                                            Timer(const Duration(milliseconds: 1000), () {
                                              //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>  const BottomNavScreen()), (route) => true);
                                              Navigator.pop(context);
                                              Navigator.pop(context);

                                            });

                                            Components(context).showSuccessSnackBar('Essence Aligned Harmoniously',margin: const EdgeInsets.only(bottom: kToolbarHeight+15,right: 15,left: 15));
                                    },
                                    child:
                                    Text(
                                              (themeData.id == widget.themeDetails['_id'])
                                                  ?'Essence Already Embraced'
                                                  :'Select Essence',
                                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600,color: Color(int.parse('0xff' + widget.themeDetails['textColor'])),)),),
                                          ),
                                          SizedBox(height: 20,),
                                          Visibility(
                                            visible: (themeData.id != widget.themeDetails['_id']),
                                            child: GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  setDefault = !setDefault;
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Checkbox(
                                                    side: BorderSide(
                                                      color: Color(int.parse('0xff' + widget.themeDetails['textColor'])),
                                                      width: 2
                                                    ),
                                                    focusColor: Colors.white,
                                                      value: setDefault,
                                                      onChanged: (val){
                                                    setState(() {
                                                      setDefault = val!;
                                                    });
                                                  }),
                                                  Text('Infuse as Core Essence',style: TextStyle(fontWeight: FontWeight.w800,color: Color(int.parse('0xff' + widget.themeDetails['textColor'])),),)
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                ),
                              ],
                            ),
                        )

                      ),
                    )
                  ],
                ),
      ),
         ),
       ),
    );
  }

}
