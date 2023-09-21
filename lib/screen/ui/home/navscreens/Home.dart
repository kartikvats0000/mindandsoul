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
import 'package:mindandsoul/constants/iconconstants.dart';
import 'package:mindandsoul/provider/playerProvider.dart';
import 'package:mindandsoul/provider/userProvider.dart';
import 'package:mindandsoul/screen/ui/content/content_list_screen/gridB.dart';
import 'package:mindandsoul/screen/ui/content/content_list_screen/listA.dart';
import 'package:mindandsoul/screen/ui/content/content_list_screen/listB.dart';
import 'package:mindandsoul/screen/ui/home/breathe/breatheList.dart';
import 'package:mindandsoul/screen/ui/home/guided_meditation/meditationList.dart';
import 'package:mindandsoul/screen/ui/home/quotes/dailyquotes.dart';
import 'package:mindandsoul/screen/ui/home/themes/themePicker.dart';
import 'package:mindandsoul/screen/ui/content/wellness.dart';
import 'package:mindandsoul/screen/ui/sleepsounds/soundlist.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

import '../../../../helper/components.dart';
import '../../../../provider/themeProvider.dart';
import '../../../../services/services.dart';
import '../../../../services/weatherservices.dart';
import '../../content/content_list_screen/gridA.dart';


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

  List<dynamic> listingData = [];

  Map weatherData = {};

  List quotesList  = [];

  getQuotes()async{
    User user = Provider.of<User>(context,listen: false);
    var data = await Services().getQuotes(user.country);

    setState(() {
      quotesList = data;
      log('quotes =  ${quotesList.toString()}');
    });

    getdata();
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

  fetchCategories()async{
    var data = await Services().getCategories();

    setState(() {
      categoryList = data['data'];
      log('category =  ${categoryList.toString()}');
    });

    getdata();
  }

  getdata()async{
    final data = await Services().getContent();
    setState(() {
      listingData = data;
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

  contentPageRoute(String view, List data,String title){
    var destination;
    if(view == 'a'){
      destination = ListviewA(data: data, title: title,);
    }
    if(view == 'b'){
      destination =  GridviewA(title: title, data: data);
    }
    if(view == 'c'){
      destination =  ListviewB(data: data, title: title,);
    }
    if(view == 'd'){
      destination =  GridviewB(title: title, data: data);
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => destination)).then((value) => videoPlayerController.play());
  }


  bool connected = true;

  checkForInternet()async {
    setState(() async{
      connected = await Internet().checkInternet();
      print('$connected internet');
    });


  }
  @override
  void initState() {
    checkForInternet();
    fetchCategories();
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

  List categoryList = [];

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
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: ()async{
        return true;
      },
      child: Consumer<ThemeProvider>(
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
                                    onTap: (){
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
                                      Components(context).BlurBackgroundCircularButton(
                                        svg: MyIcons.theme,
                                        onTap: ()async{
                                          await videoPlayerController.pause();
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ThemePicker())).then((value) => initVideo());
                                        },
                                      ),
                                      const SizedBox(width: 10,),
                                      Components(context).BlurBackgroundCircularButton(
                                        svg: (videoPlayerController.value.volume  == 0)?MyIcons.mute:MyIcons.volume_high,
                                        onTap: (){
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
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                right: (showVolumeSlider)?5:-50,
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
                        value: videoPlayerController.value.volume,
                        onChangeEnd: (val){
                          setState(() {
                            showVolumeSlider = false;
                          });
                        },
                        onChanged: (val){
                          setState(() {
                            videoPlayerController.setVolume(val);
                          });

                        }
                    ),
                  ),
                ),
              ),
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
                            themeData.themeColorB,
                           // themeData.themeColorB,
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
                        onRefresh: ()async{
                          await fetchCategories();
                          await fetchWeather();
                          getQuotes();
                        },
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
                              const SizedBox(height: 10,),
                              Container(
                              //  color: Colors.yellow,
                                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                               // margin: const EdgeInsets.all(10),
//                              height: h * 0.22,
                                height: 170,
                                width: double.infinity,
                                //color: themeData.themeColorA,
                                child: GridView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: categoryList.length,
                                    gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 1.5 / 2.5,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 7,
                                      mainAxisExtent: w * 0.3
                                    ),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: (){
                                          if(categoryList[index]['title'] == 'Wellness'){
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

                                          }
                                          else{
                                            contentPageRoute((index % 2 == 0)?'b':'a',categoryList[index]['content'],categoryList[index]['title']);
                                          }
                                        },
                                        child: Container(
                                          height: 60,
                                          // margin: EdgeInsets.all(6),
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              color: Theme
                                                  .of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.35),
                                              /*border: Border.all(
                                               color: Colors.grey.shade200,
                                               width: 0.4
                                             ),*/
                                              borderRadius: BorderRadius.circular(
                                                  45)
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
                              SizedBox(height: 10,),
                              Divider(
                                thickness: 0.2,
                                color: themeData.textColor.withOpacity(0.5),
                                indent: 15,
                                endIndent: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
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
                                          onTap: (){
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
                                          onTap: (){},
                                          child: CircleAvatar(
                                            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.35),
                                            radius: 33,
                                            child: Components(context).myIconWidget(icon: MyIcons.knowYourself,color: themeData.textColor.withOpacity(0.9),size: 30),
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        Text('Know Yourself',style: TextStyle(fontSize: 11,color: themeData.textColor.withOpacity(0.85)),)
                                      ],
                                    )),
                                    Expanded(child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
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
                                          onTap: (){
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
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => DailyQuotes(data: quotesList,),fullscreenDialog: true));
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
                                  padding: const EdgeInsets.all(15),
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

                              const SizedBox(height: 20,),
                              (listingData.isEmpty)
                                  ? Center(
                                child: SpinKitSpinningLines(color: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary,),)

                               ///Category List View

                                  : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: categoryList.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: [
                                              Text(categoryList[index]['title'],
                                                style: TextStyle(
                                                    color: themeData.textColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight
                                                        .w800),),
                                              GestureDetector(
                                                onTap: () {
                                                  if(categoryList[index]['title'] == 'Wellness'){
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

                                                  }
                                                  else{
                                                    contentPageRoute((index % 2 == 0)?'c':'d',categoryList[index]['content'],categoryList[index]['title']);
                                                  }
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(10, 2, 0, 2),
                                                  child: Text(
                                                    "Explore →", style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .labelSmall
                                                      ?.copyWith(
                                                      color: themeData.textColor
                                                  ),),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 15,),
                                        Container(
                                          //color: Colors.yellow,
                                          height: h * 0.4,
                                          child: ListView.builder(
                                            // shrinkWrap: true,
                                              itemCount: listingData.length ,
                                              scrollDirection: Axis.horizontal,
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              itemBuilder: (context, i) {
                                                if(categoryList[index]['title'] == 'Wellness'){
                                                  return Consumer<MusicPlayerProvider>(
                                                    builder: (context,player,child) =>
                                                     GestureDetector(
                                                      onTap: (){},
                                                      child: Container(
                                                        width: w * 0.33,
                                                        padding: const EdgeInsets.only(
                                                            left: 10
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .start,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius: BorderRadius
                                                                  .circular(55),
                                                              child: CachedNetworkImage(
                                                                imageUrl: listingData[i]['image'],
                                                                fit: BoxFit.cover,
                                                                height: h * 0.25,
                                                                //width: w * 0.3,
                                                                placeholder: (context, str) =>
                                                                const Center(
                                                                  child: CircularProgressIndicator(),),
                                                              ),
                                                            ),
                                                             const SizedBox(height: 10,),
                                                            Text(
                                                              listingData[i]['title'],
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
                                                else{
                                                  return GestureDetector(
                                                    onTap: ()async{
                                                      await contentViewRoute(type: listingData[i]['type'], data: listingData[i], context: context, title:  categoryList[index]['title']);
                                                      videoPlayerController.play();
                                                    },
                                                    child: Container(
                                                      width: w * 0.35,
                                                      padding: const EdgeInsets.only(
                                                          left: 15),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius
                                                            .circular(20),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Expanded(
                                                              flex: 6,
                                                              child: Container(
                                                                  color: Colors.black54,
                                                                  margin: const EdgeInsets
                                                                      .only(bottom: 10),
                                                                  child: CachedNetworkImage(
                                                                    imageUrl: listingData[i]['image'],
                                                                    fit: BoxFit.cover,
                                                                    placeholder: (
                                                                        context, str) =>
                                                                    const Center(
                                                                      child: CircularProgressIndicator(),),
                                                                  )
                                                              ),
                                                            ),
                                                            Flexible(
                                                              flex: 1,
                                                              child: Text(
                                                                listingData[i]['title'],
                                                                style: Theme
                                                                    .of(context)
                                                                    .textTheme
                                                                    .bodyLarge
                                                                    ?.copyWith(
                                                                    fontWeight: FontWeight
                                                                        .w700,
                                                                    fontSize: 14
                                                                ),
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
                                                                  style: Theme
                                                                      .of(context)
                                                                      .textTheme
                                                                      .bodySmall,
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow
                                                                      .ellipsis,))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                          ),
                                        ),
                                        const SizedBox(height: 5,),
                                      ],
                                    );
                                  }
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
      ),
    );
  }
}