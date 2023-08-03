import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mindandsoul/provider/userProvider.dart';
import 'package:mindandsoul/screen/ui/home/themes/themePicker.dart';
import 'package:mindandsoul/screen/ui/home/wellness.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

import '../../../../helper/components.dart';
import '../../../../provider/themeProvider.dart';
import '../../../../services/services.dart';
import '../../../../services/weatherservices.dart';


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

  void initVideo(){
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context,listen: false);
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(themeProvider.baseurl+themeProvider.videoUrl),videoPlayerOptions: VideoPlayerOptions(
      allowBackgroundPlayback: true
    ))..initialize()
        .then((value) {
      setState(() {
        loader = false;
      });
    });
    print('initial--${themeProvider.baseurl+themeProvider.videoUrl}');
    videoPlayerController.setVolume(0.60);
    videoPlayerController.play();
    videoPlayerController.setLooping(true);
  }

  List<dynamic> listingData = [];

  Map weatherData = {};

  fetchWeather() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {

    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

      }
    }
    if (permission == LocationPermission.deniedForever) {

    }
    if(permission == LocationPermission.whileInUse || permission == LocationPermission.always){
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
            //'air_quality' : 3,
          };
        });
        print('weather data--> $weatherData');
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

  @override
  void initState() {
    fetchCategories();
    fetchWeather();
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
    super.dispose();
  }

  List categoryList = [];

  bool showAccountIcon = true;

  bool showVolumeSlider = false;

  bool showWeatherDetailsDialog = false;

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
      child: Consumer2<ThemeProvider,User>(
        builder: (context,themeData,user,child) => Scaffold(
          backgroundColor: themeData.themeColorA,
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: Size.zero,
            child: AppBar(
              backgroundColor: Colors.transparent,
            ),
          ),

          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: h*0.6,
                    alignment: Alignment.topCenter,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        (loader)?  Center(
                         child: SpinKitSpinningLines(
                           size: 100,
                           color: Theme.of(context).colorScheme.primary,
                         ),
                       )
                        :VideoPlayer(
                            videoPlayerController
                        ),
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
                                    icon: Icons.cloud,
                                    onTap: (){
                                      var numberDialog = Padding(
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
                                                    //  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                          child:(weatherData['weather'] == null)
                                                              ?Center(child: SpinKitSpinningLines(color: Theme.of(context).colorScheme.primary,size: 40,),)
                                                              : Column(
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
                                                                      child: WeatherDetailCard('Weather', "${weatherData['weather']}")
                                                                  ),
                                                                  const SizedBox(width: 10,),
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        WeatherDetailCard2('Humidity : ', "${weatherData['humidity']}%"),
                                                                        const SizedBox(width: 5,),
                                                                        WeatherDetailCard2('Wind Speed : ', "${weatherData['wind_speed']} kph"),
                                                                        const SizedBox(width: 5,),
                                                                        WeatherDetailCard2('Cloud : ', "${weatherData['cloud']}%"),
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
                                      showDialog(
                                        context: context,
                                        barrierColor: Colors.black.withOpacity(0.08),
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                              builder: (context, setState) => numberDialog);
                                        },
                                      );

                                    },
                                  ),
                                  Row(
                                    children: [
                                      Components(context).BlurBackgroundCircularButton(
                                          icon: Icons.image,
                                        onTap: ()async{
                                          await videoPlayerController.pause();
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ThemePicker())).then((value) => initVideo());
                                        },
                                      ),
                                      const SizedBox(width: 10,),
                                      Components(context).BlurBackgroundCircularButton(
                                        icon: (videoPlayerController.value.volume  == 0)?Icons.volume_off:Icons.volume_up,
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
                                  child: Image.asset('assets/logo/mindnsoul_white.png',height: 100,width: 100,))
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
                  initialChildSize: 0.43,
                  minChildSize: 0.43,
                  builder: (context,sc) => Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: themeData.themeColorA,
                              blurRadius: 70,
                              spreadRadius: 85,
                              blurStyle: BlurStyle.normal
                          )
                        ],
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              themeData.themeColorA.withOpacity(0.2),
                              themeData.themeColorB,

                            ]
                        )
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      controller: sc,
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*const CircleAvatar(
                               radius: 20,
                               backgroundImage: NetworkImage('https://dfstudio-d420.kxcdn.com/wordpress/wp-content/uploads/2019/06/digital_camera_photo-980x653.jpg')
                           ),*/
                          const SizedBox(height: 30,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${greeting}',style: TextStyle(fontSize: 16,color: themeData.textColor,shadows: [
                                  const Shadow(color: Colors.black54,blurRadius: 2)
                                ]),
                                  textAlign: TextAlign.start,

                                ),
                                Text('${user.name} ...',style: TextStyle(fontSize: 24,color: themeData.textColor,fontWeight: FontWeight.bold,shadows: const [
                                   Shadow(color: Colors.black54,blurRadius: 2)
                                ]),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            height: 160,
                            //color: themeData.themeColorA,
                            child: GridView.builder(
                               // shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: categoryList.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1.5/2.5,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 7
                                ),
                                itemBuilder: (context,index){
                                  return Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.35),
                                        /*border: Border.all(
                                           color: Colors.grey.shade200,
                                           width: 0.4
                                         ),*/
                                        borderRadius: BorderRadius.circular(45)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 7,),
                                        Expanded(child: SvgPicture.network(categoryList[index]['image'],color: themeData.textColor,height: 25,width: 25,)),
                                        //SizedBox(height: ,),
                                        Text(categoryList[index]['title'],style: TextStyle(color: themeData.textColor,fontSize: 12),),
                                        const SizedBox(height: 7,),
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ),
                          const SizedBox(height: 20,),
                          (listingData.isEmpty)
                              ?Center(child: SpinKitSpinningLines(color: Theme.of(context).colorScheme.primary,),)
                              :ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:categoryList.length,
                              itemBuilder: (context,index){
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(categoryList[index]['title'],style: TextStyle(color: themeData.textColor,fontSize: 16,fontWeight: FontWeight.w800),),
                                          InkWell(
                                            onTap: (){},
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 2, 0, 2),
                                              child: Text("Explore →",style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                  color: themeData.textColor
                                              ),),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 15,),
                                    SizedBox(
                                      height: h * 0.4,
                                      child: ListView.builder(
                                         // shrinkWrap: true,
                                          itemCount: listingData.length,
                                          scrollDirection: Axis.horizontal,
                                          padding: const EdgeInsets.only(right: 15),
                                          itemBuilder: (context,i){
                                            return Container(
                                              width: w * 0.45,
                                              padding: const EdgeInsets.only(left: 15),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        color: Colors.black54,
                                                        margin: const EdgeInsets.only(bottom: 10),
                                                        height: 200,
                                                        width: 180,
                                                        child: CachedNetworkImage(
                                                          imageUrl: listingData[i]['image'],fit: BoxFit.cover,
                                                          placeholder: (context,str) => const Center(child: CircularProgressIndicator(),),
                                                        )
                                                    ),
                                                    Flexible(
                                                      child: Text(listingData[i]['title'],style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                          fontWeight: FontWeight.w700
                                                      ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10,),
                                                    Flexible(child: Text(listingData[i]['desc'],style: Theme.of(context).textTheme.bodyMedium,maxLines: 2,overflow: TextOverflow.ellipsis,))
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                      ),
                                    ),
                                    const SizedBox(height: 25,),
                                  ],
                                );
                              }
                          ),
                          const SizedBox(height: 20,),
                          Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Wellness',style: TextStyle(color: themeData.textColor,fontSize: 16,fontWeight: FontWeight.w800),),
                                  InkWell(
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Wellness(data: listingData,)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(10, 2, 0, 2),
                                      child: Text("Explore →",style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: themeData.textColor
                                      ),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //const SizedBox(height: 15,),
                            SizedBox(
                              height: h * 0.45,
                              child: ListView.builder(
                                  itemCount: listingData.length,
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.only(right: 15),
                                  itemBuilder: (context,i){
                                    return Container(
                                      //color: Colors.redAccent,
                                      width: w * 0.33,
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child: CachedNetworkImage(
                                              imageUrl: listingData[i]['image'],fit: BoxFit.cover,
                                              height: h * 0.28,
                                              width: w * 0.31,
                                              placeholder: (context,str) => const Center(child: CircularProgressIndicator(),),
                                            ),
                                          ),
                                         // const SizedBox(height: 7,),
                                          Flexible(
                                            child: Text(listingData[i]['title'],style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                fontWeight: FontWeight.w700
                                            ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                       //   const SizedBox(height: 4,),
                                          Flexible(child: Text(listingData[i]['desc'],style: Theme.of(context).textTheme.bodyMedium,maxLines: 2,overflow: TextOverflow.ellipsis,))
                                        ],
                                      ),
                                    );
                                  }
                              ),
                            ),
                            //const SizedBox(height: 25,),
                          ],
                        ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 120,horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Embrace',style: TextStyle(color: themeData.textColor.withOpacity(0.6),fontSize: 50,fontWeight: FontWeight.w800,height: 0.4),),
                                Text('inner peace!',style: TextStyle(color: themeData.textColor.withOpacity(0.6),fontSize: 50,fontWeight: FontWeight.w800),),
                                Text('Crafted with ❤️️ in Gurugram, India',style: TextStyle(color: themeData.textColor.withOpacity(0.54),fontSize: 14,fontWeight: FontWeight.w800),),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
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
}
