import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:mindandsoul/constants/iconconstants.dart';
import 'package:mindandsoul/helper/showcasewidget.dart';
import 'package:mindandsoul/helper/theme_icon_animation.dart';
import 'package:mindandsoul/helper/volume_slider_video.dart';
import 'package:mindandsoul/provider/playerProvider.dart';
import 'package:mindandsoul/provider/userProvider.dart';
import 'package:mindandsoul/screen/ui/content/content_list_screen/gridB.dart';
import 'package:mindandsoul/screen/ui/content/content_list_screen/listA.dart';
import 'package:mindandsoul/screen/ui/content/content_list_screen/listB.dart';
import 'package:mindandsoul/screen/ui/home/breathe/breatheList.dart';
import 'package:mindandsoul/screen/ui/home/quotes/dailyquotes.dart';
import 'package:mindandsoul/screen/ui/home/themes/themePicker.dart';
import 'package:mindandsoul/screen/ui/home/wellness/wellness.dart';
import 'package:mindandsoul/screen/ui/sleepsounds/soundlist.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import '../../../../helper/components.dart';
import '../../../../provider/themeProvider.dart';
import '../../../../services/services.dart';
import '../../content/content_list_screen/gridA.dart';
import '../../sleepsounds/soundmaker.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin{

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  late VideoPlayerController videoPlayerController;

  bool loader = true;
  bool onThisPage = true;

  void initVideo(){
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context,listen: false);
    MusicPlayerProvider player = Provider.of<MusicPlayerProvider>(context,listen: false);
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(themeProvider.baseurl+themeProvider.videoUrl))..initialize()
        .then((_) {
      setState(() {
        loader = false;
        player.addListener(_onAudioPlayerStateChanged);
        _onAudioPlayerStateChanged();

      });
    });

  
    videoPlayerController.setVolume(0.60);
    videoPlayerController.play();
    videoPlayerController.setLooping(true);


  }

  void _onAudioPlayerStateChanged() {
    MusicPlayerProvider player = Provider.of<MusicPlayerProvider>(context,listen: false);
   if(mounted){
     if(onThisPage){
       if (player.audioPlayer.playerState.playing == true) {
         videoPlayerController.pause();
       } else {
         videoPlayerController.play();
       }
     }

   }
  }


  Map weatherData = {};

  List quotesList  = [];

  getQuotes()async{
    print(DateFormat('d-M').format(DateTime.now()).toString());
    User user = Provider.of<User>(context,listen: false);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var map = sharedPreferences.getString('quoteData');
    if(map == null){
      var data = await Services(user.token).getQuotes(user.country);
      setState(() {
        quotesList = data;
        log('quotes =  ${quotesList.toString()}');
      });
      await sharedPreferences.setString('quoteData', json.encode({
        'date' : DateFormat('d-M').format(DateTime.now()).toString(),
        'data' : quotesList
      }));
    }
   else{
     var quoteData = json.decode(map);
     if(quoteData['date'] != DateFormat('d-M').format(DateTime.now()).toString()){
       var data = await Services(user.token).getQuotes(user.country);
       setState(() {
         quotesList = data;
         log('quotes =  ${quotesList.toString()}');
       });
       await sharedPreferences.setString('quoteData', json.encode({
         'date' : DateFormat('d-M').format(DateTime.now()).toString(),
         'data' : quotesList
       }));
     }
     else{
       setState(() {
         quotesList = quoteData['data'];
       });
     }
    }
    getData();
  }

  bool weatherPermission = true;

  Future fetchWeather() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      setState(() {
        weatherPermission = false;
      });
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          weatherPermission = false;
        });
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        weatherPermission = false;
      });
    }
    if(permission == LocationPermission.whileInUse || permission == LocationPermission.always){
      setState(() {
        weatherPermission = true;
      });
      var curr = await Geolocator.getCurrentPosition();
      print(curr.longitude);
      print(curr.latitude);

      http.Response data = await WeatherServices().getCurrentWeather(curr.latitude, curr.longitude);

      var map = json.decode(data.body);

      if(data.statusCode == 200){
        setState(() {
          weatherData = {
            'weather' : map['current']['condition']['text'],
            'wind_speed' : map['current']['wind_kph'],
            'humidity' : map['current']['humidity'],
            'cloud' : map['current']['cloud'],
            'air_quality' : map['current']['air_quality']['us-epa-index'],
          };
        });

      }

    }
  }

  List categoryList = [];
  List breatheData = [];
  List harmonyData = [];
  List wellnessData = [];

  /// Gets Breathing List Too
  getData()async{
    User user = Provider.of<User>(context,listen: false);

    var data = await Services(user.token).getHomeData(user.id);
    String jsn = await DefaultAssetBundle.of(context).loadString("assets/data/breathingList.json");
    print(jsn);
    var all = json.decode(jsn);
    setState(() {
      categoryList = data['data']['category'];
      wellnessData = data['data']['wellness'];
      harmonyData = data['data']['harmony'];
      breatheData = all['data'];
    });
  }

  String get greeting {
    if(DateTime.now().hour < 12){
      return 'Good Morning';
    }
    if(DateTime.now().hour <= 16){
      return 'Good Afternoon';
    }
    else{
      return 'Good Evening';
    }

  }

  contentPageRoute(String view, String id,String title){
    var destination;
    if(view == 'a'){
      destination = ListviewA(categoryId: id, title: title,);
    }
    if(view == 'b'){
      destination =  GridviewA(title: title, categoryId: id);
    }
    if(view == 'c'){
      destination =  ListviewB(categoryId: id, title: title,);
    }
    if(view == 'd'){
      destination =  GridviewB(title: title, categoryId: id,);
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => destination)).then((value) => videoPlayerController.play());
  }

  bool connected = true;

  /*checkForInternet()async {
    setState(() {
      connected =  Internet().checkInternet();
      print('$connected internet');
    });
  }*/

  final GlobalKey themeKey = GlobalKey();
  final GlobalKey weatherKey = GlobalKey();
  final GlobalKey volumeKey = GlobalKey();
  final GlobalKey quoteKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) { ShowCaseWidget.of(context).startShowCase(
        [themeKey,quoteKey]);
    });
    //checkForInternet();
    fetchWeather();
    getQuotes();
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
      statusBarColor: Colors.grey.shade50,
      statusBarIconBrightness: Brightness.light, // status bar color
    ));
    initVideo();
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    Provider.of<MusicPlayerProvider>(context,listen: false).removeListener(() {_onAudioPlayerStateChanged();});
    super.dispose();
  }

  bool showVolumeSlider = false;

  List aqiLabels = [
    'Good',
    'Moderate',
    'Unhealthy for sensitive group',
    'Unhealthy',
    'Very Unhealthy',
    'Hazardous'
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint('homepageRebuilt');
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ThemeProvider>(
      builder: (context,themeData,child) => Scaffold(
        backgroundColor: themeData.themeColorA,
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.zero,
          child: AppBar(
            elevation: 0.0,
            scrolledUnderElevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: h*0.5,
                  alignment: Alignment.topCenter,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      (loader)
                          ?Center(
                        child: SpinKitSpinningLines(
                          size: 100,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                          :VideoPlayer(videoPlayerController),
                      Positioned(
                        top: 40,
                        right: 10,
                        left: 10,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Components(context).BlurBackgroundCircularButton(
                                  svg: MyIcons.weather,
                                  onTap: (){ HapticFeedback.selectionClick();
                                    var dialog = StatefulBuilder(
                                        builder:(context,_setState){
                                          Timer(const Duration(seconds: 2),(){
                                            _setState((){});
                                          });
                                          return Padding(
                                            padding: const EdgeInsets.only(left: 15,top: 65,right: 15),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(25),
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                                    child: Container(
                                                      padding: const EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                        color: Colors.black38,
                                                        borderRadius: BorderRadius.circular(25),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          const SizedBox(height: 5,),
                                                          Container(
                                                            //  height: 150,
                                                              width: double.infinity,
                                                              padding: const EdgeInsets.all(12),
                                                              margin: const EdgeInsets.all(3),
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(20),
                                                              ),
                                                              child:(!weatherPermission)?
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  const  Text("Sorry, we need your location to show you the weather",style: TextStyle(
                                                                      color: Colors.black,
                                                                      //color: themeData.textColor,
                                                                      // color: Theme.of(context).colorScheme.primary,
                                                                      fontWeight: FontWeight.w700
                                                                  ),),
                                                                  ElevatedButton(onPressed: ()async{

                                                                    Geolocator.openLocationSettings().then((value)async{
                                                                      LocationPermission permission = await Geolocator.checkPermission();
                                                                      print('hi $permission');
                                                                      Navigator.pop(context);
                                                                      fetchWeather();
                                                                    });
                                                                  }, child: Text('Enable Location'))
                                                                ],
                                                              )
                                                                  :(weatherData['weather'] == null)
                                                                  ?Center(child: SpinKitSpinningLines(color: Theme.of(context).colorScheme.primary,size: 40,),)
                                                                  :Column(
                                                                children: [
                                                                  const Text("Nature's Aura Nearby",style: TextStyle(
                                                                      color: Colors.black,
                                                                      //color: themeData.textColor,
                                                                      // color: Theme.of(context).colorScheme.primary,
                                                                      fontWeight: FontWeight.w700
                                                                  ),),
                                                                  const SizedBox(height: 10,),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(
                                                                          width : MediaQuery.of(context).size.width * 0.40,
                                                                          //child: WeatherDetailCard('Weather', "${weatherData['weather']}")
                                                                          child: Components(context).WeatherDetailCard('Weather', "${weatherData['weather']}")
                                                                      ),
                                                                      const SizedBox(width: 10,),
                                                                      Expanded(
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Components(context).WeatherDetailCard2('Humidity : ', "${weatherData['humidity']}%"),
                                                                            const SizedBox(width: 5,),
                                                                            Components(context).WeatherDetailCard2('Wind Speed : ', "${weatherData['wind_speed']} kph"),
                                                                            const SizedBox(width: 5,),
                                                                            Components(context).WeatherDetailCard2('Cloud : ', "${weatherData['cloud']}%"),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 10,),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      Text('Air Quality : ',style: TextStyle(color: Colors.grey.shade700,fontSize: 12,fontWeight: FontWeight.w600),),
                                                                      Text(aqiLabels[weatherData['air_quality'] - 1] ,style: const TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w600),)
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 10,),
                                                                  Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                                                    child: Image.asset('assets/home/aqi_indicator/${weatherData['air_quality']}.png'),
                                                                    //child: Image.asset('assets/home/aqi_indicator/${weatherData['air_quality']}.png'),
                                                                  )
                                                                ],
                                                              )
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                    );
                                    showModal(
                                      configuration: const FadeScaleTransitionConfiguration(
                                        transitionDuration: Duration(milliseconds: 400),
                                        reverseTransitionDuration: Duration(milliseconds: 350)
                                      ),
                                        context: context,
                                        builder: (context) => dialog
                                    );
                                  },
                                ),
                                Row(
                                  children: [
                                    ShowCaseView(
                                     // shapeBorder: CircleBorder(),
                                      globalKey: themeKey,
                                      title: 'Essence',
                                      description: 'Change App Theme',
                                      child: GestureDetector(
                                        onTap: ()async{ HapticFeedback.selectionClick();
                                        await videoPlayerController.pause();
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ThemePicker())).then((value) => initVideo());
                                        },
                                        child: ThemeButtonAnimation(),
                                      )
                                    ),
                                    const SizedBox(width: 10,),
                                    Components(context).BlurBackgroundCircularButton(
                                      svg: (videoPlayerController.value.volume  == 0)?MyIcons.mute:MyIcons.volume_high,
                                      onTap: (){ HapticFeedback.selectionClick();
                                        setState(() {
                                          showVolumeSlider = !showVolumeSlider;
                                        });
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Positioned(
                                top: 50,
                                right: 0,
                                left: 0,
                                child: Image.asset('assets/logo/brainnsoul_white.png',height: 100,width: 100,))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            VolumeSlider(showVolumeSlider: showVolumeSlider, videoPlayerController: videoPlayerController),
            DraggableScrollableSheet(
              //controller: draggableScrollableController,
                initialChildSize: 0.51,
                minChildSize: 0.51,
                builder: (context,sc) {
                  sc.addListener(() {
                    if(sc.position.pixels == 0){
                      if(themeData.isScrolling == true){ themeData.changeScrollStatus(false);}
                    }
                    else{
                      if(themeData.isScrolling == false){themeData.changeScrollStatus(true);}
                    }
                  });

                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          themeData.themeColorA.withOpacity(0.2),
                          themeData.themeColorA.withOpacity(0.7),
                         // themeData.themeColorB,
                          themeData.themeColorB.withOpacity(0.5),
                          themeData.themeColorB,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: themeData.themeColorA,
                          blurRadius: 60,
                          spreadRadius: 70,
                        ),
                      ],
                    ),
                    child: RefreshIndicator(
                      backgroundColor: Colors.transparent,
                      onRefresh: ()async=> await getData(),
                      child: SingleChildScrollView(
                        controller: sc,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20,),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(greeting, style: TextStyle(
                                      fontSize: 16,
                                      color: themeData.textColor,),
                                    textAlign: TextAlign.start,
                                  ),
                                  Consumer<User>(
                                    builder: (context,user,child) =>
                                     Text('${user.name}...', style: TextStyle(
                                        fontSize: 24,
                                        color: themeData.textColor,
                                        fontWeight: FontWeight.bold,
                                     ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                           // const SizedBox(height: 10,),
                            Visibility(
                              visible: categoryList.isNotEmpty,
                              child: Container(
                                width: double.infinity,
                                child: GridView.builder(
                                  padding: const  EdgeInsets.symmetric(vertical: 10,horizontal: 7),
                                  shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    //scrollDirection: Axis.horizontal,
                                    itemCount: categoryList.length,
                                    gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 2.5/1.5,//1.5 / 2.5,
                                        crossAxisSpacing: 7,
                                        mainAxisSpacing: 10,
                                     // mainAxisExtent: w * 0.3, //maxCrossAxisExtent: 170/2
                                    ),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: (){ HapticFeedback.selectionClick();
                                          videoPlayerController.pause();
                                          contentPageRoute((index % 2 == 0)?'d':'d',categoryList[index]['_id'],categoryList[index]['title']);
                                        },
                                        child: Container(
                                          height: 60,
                                          // margin: EdgeInsets.all(6),
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(45)
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              const SizedBox(height: 7,),
                                              Expanded(child: SvgPicture.network(
                                                categoryList[index]['image'],
                                                color: themeData.textColor,
                                                height: 25,
                                                width: 25,)),
                                              //SizedBox(height: ,),
                                              Text(categoryList[index]['title'],
                                                style: TextStyle(
                                                    color: themeData.textColor,
                                                    fontSize: 12),),
                                              const SizedBox(height: 7,),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Visibility(
                              visible: categoryList.isNotEmpty,
                              child: Divider(
                                thickness: 0.2,
                                color: themeData.textColor.withOpacity(0.5),
                                indent: 15,
                                endIndent: 15,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: (){ HapticFeedback.selectionClick();
                                          MusicPlayerProvider player = Provider.of<MusicPlayerProvider>(context,listen: false);
                                          videoPlayerController.pause();
                                          setState(() {
                                            onThisPage = false;
                                          });
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Wellness())).then((value) {
                                            setState(() {
                                              onThisPage = true;
                                            });
                                            if(!player.audioPlayer.playing){
                                              videoPlayerController.play();
                                            }
                                          });
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Theme
                                              .of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.35),
                                          radius: 33,
                                          child: Components(context).myIconWidget(icon: MyIcons.wellness,color: themeData.textColor.withOpacity(0.9),size: 30),
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      Text('Wellness',style: TextStyle(fontSize: 11,color: themeData.textColor.withOpacity(0.85)),)
                                    ],
                                  )),
                                  Expanded(child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: (){ HapticFeedback.selectionClick();
                                          videoPlayerController.pause();
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SoundsList())).then((value) => videoPlayerController.play());
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Theme
                                              .of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.35),
                                          radius: 33,
                                          child: Components(context).myIconWidget(icon: MyIcons.harmony,color: themeData.textColor.withOpacity(0.9),size: 30),
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                       Text('Harmonies',style: TextStyle(fontSize: 11,color: themeData.textColor.withOpacity(0.85)),)
                                    ],
                                  )),
                                  Expanded(
                                      child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: (){ HapticFeedback.selectionClick();},
                                        child: CircleAvatar(
                                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.35),
                                          radius: 33,
                                          child: Components(context).myIconWidget(icon: MyIcons.knowYourself,color: themeData.textColor.withOpacity(0.9),size: 30),
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      Text('Know Yourself',style: TextStyle(fontSize: 11,color: themeData.textColor.withOpacity(0.85)),maxLines: 1,)
                                    ],
                                  )),
                                  Expanded(child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: (){ HapticFeedback.selectionClick();
                                         // videoPlayerController.pause();
                                          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MeditationList()));
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Theme
                                              .of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.35),
                                          radius: 33,
                                          child: Components(context).myIconWidget(icon: MyIcons.meditation,color: themeData.textColor.withOpacity(0.9),size: 30),
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      Text('Meditation',style: TextStyle(fontSize: 11,color: themeData.textColor.withOpacity(0.85)),)
                                    ],
                                  )),
                                  Expanded(child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: (){ HapticFeedback.selectionClick();
                                          videoPlayerController.pause();
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BreatheList())).then((value) =>videoPlayerController.play());
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Theme
                                              .of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.35),
                                          radius: 33,
                                          child: Components(context).myIconWidget(icon: MyIcons.breathe,color: themeData.textColor.withOpacity(0.9),size: 30),
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      Text('Breathe',style: TextStyle(fontSize: 11,color: themeData.textColor.withOpacity(0.85)),)
                                    ],
                                  )),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
                            GestureDetector(
                              onTap: (quotesList.isEmpty)?null:(){
                                HapticFeedback.selectionClick();
                                videoPlayerController.pause();
                                Navigator.push(context, CupertinoPageRoute(builder: (context) => DailyQuotes(data: quotesList,),fullscreenDialog: true)).then((value) => videoPlayerController.play());
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Theme
                                      .of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.35),
                                  borderRadius: BorderRadius.circular(25),
                                ),

                                child: ShowCaseView(
                                  shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                  globalKey: quoteKey,
                                  title: "Today's Quote",
                                  description: 'New Motivational Quote Daily',
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                            child: AspectRatio(
                                              aspectRatio: 1,
                                                child: (quotesList.isEmpty)
                                                    ?SpinKitSpinningLines(color: Theme.of(context).colorScheme.primary,size: 40,):ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                    child: Stack(
                                                      children: [
                                                        Positioned.fill(child: CachedNetworkImage(imageUrl: quotesList.first['image'],fit: BoxFit.cover,placeholder: (context,url) =>Container(color: Theme.of(context).colorScheme.primary,),)),
                                                        Center(
                                                          child: Text(DateTime.now().day.toString().padLeft(2,'0'),
                                                            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white,fontSize: 18),
                                                          ),
                                                        )
                                                      ],
                                                    ))
                                            )
                                        ),
                                        const SizedBox(width: 10,),
                                         Expanded(
                                          flex: 10,
                                            child:Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Today's Quote",style: Theme.of(context).textTheme.labelLarge,),
                                                const SizedBox(height: 5,),
                                                (quotesList.isEmpty)?const Text('Loading...'): Text(quotesList.first['quote'],
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: themeData.textColor.withOpacity(0.8)),
                                                  maxLines: 1,overflow: TextOverflow.ellipsis,)
                                              ],
                                            )
                                        ),
                                        const SizedBox(width: 5,),
                                      Icon(Icons.chevron_right,color: themeData.textColor,)
                                      //   TextButton(onPressed: null, style: TextButton.styleFrom(backgroundColor: Colors.white
                                      //       .withOpacity(0.15),),child: Text('Show',style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.black87),)),
                                      // ],
                                    ]
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            ///wellness listview
                            Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Wellness', style: Theme.of(context).textTheme.titleMedium,),
                                    GestureDetector(
                                      onTap: () { HapticFeedback.selectionClick();
                                        MusicPlayerProvider player = Provider.of<MusicPlayerProvider>(context,listen: false);
                                        videoPlayerController.pause();
                                        setState(() {
                                          onThisPage = false;
                                        });
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Wellness())).then((value) {
                                          setState(() {
                                            onThisPage = true;
                                          });
                                          if(!player.audioPlayer.playing){
                                            videoPlayerController.play();
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets
                                            .fromLTRB(10, 2, 0, 2),
                                        child: Text(
                                          "Explore →", style: Theme.of(context).textTheme.labelSmall?.copyWith(color: themeData.textColor),),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15,),
                              SizedBox(
                                //color: Colors.yellow,
                                height: h * 0.32,
                                child: ListView.builder(
                                  // shrinkWrap: true,
                                    itemCount: wellnessData.length ,
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.only(
                                        right: 15),
                                    itemBuilder: (context, i) {
                                      return Consumer<MusicPlayerProvider>(
                                        builder: (context,player,child) =>
                                            GestureDetector(
                                              onTap: ()async{ HapticFeedback.selectionClick();
                                              User user = Provider.of<User>(context,listen: false);
                                              //Navigator.push(context, MaterialPageRoute(builder: (context) => Wellness()));
                                              if(wellnessData[i]['image'] != player.currentTrack?.thumbnail){
                                                  debugPrint('wellness details api hit');
                                                  var data = await Services(user.token).getWellnessDetails(wellnessData[i]['_id']);
                                                  var wellData = data['data'];
                                                  player.play(Track(title: wellData['title'], thumbnail: wellData['image'], audioUrl:wellData['audio'], gif: wellData['anim']));
                                                }
                                              Components(context).showPlayerSheet();
                                               // Navigator.push(context, CupertinoPageRoute(builder: (context) => WellnessPlayer(),fullscreenDialog: true));
                                              },
                                              child: Container(
                                                width: w * 0.33,
                                                padding: const EdgeInsets.only(
                                                    left: 10
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(55),
                                                      child: CachedNetworkImage(
                                                        imageUrl: wellnessData[i]['image'],
                                                        fit: BoxFit.cover,
                                                        height: h * 0.25,
                                                        placeholder: (context, str) =>
                                                         Center(
                                                          child: SpinKitSpinningLines(color: Theme.of(context).colorScheme.primary),),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10,),
                                                    Text(
                                                      wellnessData[i]['title'],
                                                      style: Theme
                                                          .of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.copyWith(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .w700
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                    ),
                                                    //   const SizedBox(height: 4,),
                                                  ],
                                                ),
                                              ),
                                            ),
                                      );
                                    }
                                ),
                              ),
                            ],
                          ),
                            Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Harmony', style: Theme.of(context).textTheme.titleMedium,),
                                    GestureDetector(
                                      onTap: () { HapticFeedback.selectionClick();
                                        MusicPlayerProvider player = Provider.of<MusicPlayerProvider>(context,listen: false);
                                        videoPlayerController.pause();
                                        setState(() {
                                          onThisPage = false;
                                        });
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SoundsList())).then((value) {
                                          setState(() {
                                            onThisPage = true;
                                          });
                                          if(!player.audioPlayer.playing){
                                            videoPlayerController.play();
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets
                                            .fromLTRB(10, 2, 0, 2),
                                        child: Text(
                                          "Explore →", style: Theme.of(context).textTheme.labelSmall?.copyWith(color: themeData.textColor),),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15,),
                              SizedBox(
                                height: h * 0.32,
                                child: ListView.builder(
                                    itemCount: wellnessData.length ,
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.only(
                                        right: 10),
                                    itemBuilder: (context, i) {
                                      return  GestureDetector(
                                        onTap: (){
                                          HapticFeedback.selectionClick();
                                          harmonyData[i]['colorA'] = harmonyData[i]['colorA'].toString().replaceAll('#', '');
                                          harmonyData[i]['colorB'] =  harmonyData[i]['colorB'].toString().replaceAll('#', '');
                                          harmonyData[i]['textColor'] = harmonyData[i]['textColor'] .toString().replaceAll('#', '');

                                          Navigator.push(context, CupertinoPageRoute(builder: (context) => SoundMixer(themeImage: harmonyData[i],)));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.only(left: 10),
                                          width:  w * 0.4,
                                          decoration:  BoxDecoration(
                                              borderRadius: BorderRadius.circular(25)
                                          ),
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Positioned.fill(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(25),
                                                  child: CachedNetworkImage(
                                                    placeholder: (context,string)=> Container(
                                                        padding: const EdgeInsets.all(30),
                                                        alignment: Alignment.center,
                                                        child:SpinKitSpinningLines(color: Theme.of(context).colorScheme.primary)),
                                                    imageUrl: harmonyData[i]['image'],fit: BoxFit.cover,),
                                                ),

                                              ),
                                              Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  left: 0,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),

                                                    child: Container(
                                                      padding: const EdgeInsets.all(10),
                                                      decoration:   BoxDecoration(
                                                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
                                                          color: Colors.black.withOpacity(0.7)

                                                      ),
                                                      child: Text(harmonyData[i]['title'],style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700,color: Colors.white.withOpacity(0.85)),textAlign: TextAlign.center,),
                                                    ),
                                                  )
                                              ),
                                              Positioned(
                                                  top: 5,
                                                  right: 5,
                                                  child: Components(context).BlurBackgroundCircularButton(
                                                      svg: MyIcons.premium,
                                                      iconSize: 18,
                                                      buttonRadius: 17,
                                                      iconColor: Colors.white
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                ),
                              ),
                              const SizedBox(height: 15,)
                            ],
                          ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('Breathe',
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      GestureDetector(
                                        onTap: () { HapticFeedback.selectionClick();
                                        MusicPlayerProvider player = Provider.of<MusicPlayerProvider>(context,listen: false);
                                        videoPlayerController.pause();
                                        setState(() {
                                          onThisPage = false;
                                        });
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BreatheList())).then((value) {
                                          setState(() {
                                            onThisPage = true;
                                          });
                                          if(!player.audioPlayer.playing){
                                            videoPlayerController.play();
                                          }
                                        });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets
                                              .fromLTRB(10, 2, 0, 2),
                                          child: Text(
                                            "Explore →", style: Theme.of(context).textTheme.labelSmall?.copyWith(color: themeData.textColor),),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                             //   const SizedBox(height: 15,),
                                SizedBox(
                                  height: h * 0.25,
                                  child: Visibility(
                                    visible: breatheData.isNotEmpty,
                                    child: PageView.builder(

                                      pageSnapping: true,
                                        itemCount: 5 ,
                                        scrollDirection: Axis.horizontal,

                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: (){
                                              videoPlayerController.pause();
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BreatheList())).then((value) =>videoPlayerController.play());
                                            },
                                            child: Container(width: w,margin: const EdgeInsets.all(5),child: buildBreahtheListItem(breatheData, index, context),)
                                          );
                                        }
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Center(
                              child:ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: categoryList.length,
                                  itemBuilder: (context, index) {
                                    var listingData = categoryList[index]['content'];
                                    return Visibility(
                                      visible: listingData.length > 0,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(categoryList[index]['title'],
                                                  style: TextStyle(color: themeData.textColor, fontSize: 14, fontWeight: FontWeight.w800),),
                                                GestureDetector(
                                                  onTap: () { HapticFeedback.selectionClick();
                                                  videoPlayerController.pause();
                                                  contentPageRoute((index % 2 == 0)?'c':'d',categoryList[index]['_id'],categoryList[index]['title']);
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 2, 0, 2),
                                                    child: Text(
                                                      "Explore →", style: Theme.of(context).textTheme.labelSmall?.copyWith(color: themeData.textColor),),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 15,),
                                          SizedBox(
                                            //color: Colors.yellow,
                                            height: h * 0.4,
                                            child: ListView.builder(
                                                itemCount: listingData.length ,
                                                scrollDirection: Axis.horizontal,
                                                padding: const EdgeInsets.only(right: 15),
                                                itemBuilder: (context, i) {
                                                  return GestureDetector(
                                                    onTap: ()async{ HapticFeedback.selectionClick();
                                                    videoPlayerController.pause();
                                                    await contentViewRoute(type: listingData[i]['type'],  id: listingData[i]['_id'], context: context);
                                                    },
                                                    child: Container(
                                                      width: w * 0.35,
                                                      padding: const EdgeInsets.only(left: 15),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(20),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Expanded(
                                                              flex: 6,
                                                              child: Container(
                                                                  color: Colors.black54,
                                                                  margin: const EdgeInsets.only(bottom: 10),
                                                                  child: Hero(
                                                                    tag: listingData[i]['_id'],
                                                                    child: CachedNetworkImage(
                                                                      imageUrl: listingData[i]['image'],
                                                                      fit: BoxFit.cover,
                                                                      placeholder: (context, str) =>
                                                                          Center(
                                                                            child: SpinKitSpinningLines(color: Theme.of(context).colorScheme.primary),),
                                                                    ),
                                                                  )
                                                              ),
                                                            ),
                                                            Flexible(
                                                              flex: 1,
                                                              child: Text(
                                                                listingData[i]['title'],
                                                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700, fontSize: 14),
                                                                maxLines: 1,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,),
                                                            Flexible(
                                                                flex: 2,
                                                                fit: FlexFit.loose,
                                                                child: Text(
                                                                  listingData[i]['desc'],
                                                                  style: Theme.of(context).textTheme.bodySmall,
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                            ),
                                          ),

                                          const SizedBox(height: 5,),
                                        ],
                                      ),
                                    );
                                  }
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 120, horizontal: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Embrace\nInner Peace!',style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      color: themeData.textColor.withOpacity(0.6),
                                      fontSize: 50,
                                      fontWeight: FontWeight.w500,
                                      height: 1
                                  ) ,),

                                  Text('\nCrafted with ❤️️ in Gurugram, India',
                                    style: TextStyle(
                                        color: themeData.textColor.withOpacity(
                                            0.54),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800),),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}