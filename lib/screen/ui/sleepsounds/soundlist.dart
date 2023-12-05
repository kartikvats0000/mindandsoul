import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/screen/ui/sleepsounds/sound_player.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';

import '../../../constants/iconconstants.dart';
import '../../../helper/components.dart';
import '../../../provider/userProvider.dart';
import 'soundmaker.dart';

class SoundsList extends StatefulWidget {
  const SoundsList({super.key});

  @override
  State<SoundsList> createState() => _SoundsListState();
}

class _SoundsListState extends State<SoundsList> {
  
  List moodList = [];

  List favourites = [];

  getFavourites()async{
    User user = Provider.of<User>(context,listen: false);
    final data = await Services(user.token).getFavouriteHarmony();
    log(data.toString());
    setState(() {
      favourites = data['data'];
    });

  }
  
  getMoods()async{
    User user = Provider.of<User>(context,listen: false);
    var data = await Services(user.token).getHarmonyMoods();
    setState(() {
      moodList = data;
    });
    getFavourites();

  }


  List<AudioPlayerModel> audioplayers = [];

 /* bool connected = true;
  checkForInternet()async {
    connected = await Internet().checkInternet();
    setState(() {
      print(connected);
    });
  }*/
  
  @override
  void initState() {
  // checkForInternet();
    // TODO: implement initState
    getMoods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('moods rebuilt');
    return Consumer2<ThemeProvider,User>(
      builder: (context,theme,user,child) =>
      Scaffold(
        backgroundColor: theme.themeColorA,
        appBar: Components(context).myAppBar(title: user.languages[user.selectedLanguage]['home_screen']['harmonies_top'] ?? 'Harmony'),
        body: Container(
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
                      //theme.themeColorA,
                    ]
                )
            ),
          child: RefreshIndicator(
            onRefresh: ()async{
              await getMoods();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  ///favourites
                  Visibility(
                    visible: favourites.isNotEmpty,
                      child: Text(
                        user.languages[user.selectedLanguage]['custom_round_button_class']['your_mixes_harmony'] ?? 'Your Mixes',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: theme.textColor,fontWeight: FontWeight.bold,fontSize: 21),textAlign: TextAlign.start,)),
                  SizedBox(height: (favourites.isNotEmpty)?10:0,),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: favourites.length,
                      gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:3,
                    mainAxisExtent: 150,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                      itemBuilder: (context,index) {
                      return GestureDetector(
                        onTap: (){
                          HapticFeedback.selectionClick();
                          Navigator.of(context).push(
                              CupertinoPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => SoundPlayer(data: favourites[index],)));
                        },
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: CachedNetworkImage(
                                  placeholder: (context,string)=> Container(
                                      padding: const EdgeInsets.all(30),
                                      alignment: Alignment.center,
                                      child:  SpinKitSpinningLines(color: hexStringToColor(favourites[index]['moodId']['colorA']))),
                                  imageUrl: favourites[index]['moodId']['image'] ,fit: BoxFit.cover,),
                              ),
                            ),
                            const SizedBox(height: 8,),
                            Expanded(child: Text(favourites[index]['title'],style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),))
                          ],
                        ),
                      );
                    }
                  ),

                  ///new audio
                  Text(
                    user.languages[user.selectedLanguage]['custom_round_button_class']['select_mood_harmony'] ?? "Select Mood" ,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: theme.textColor,fontWeight: FontWeight.bold,fontSize: 21),textAlign: TextAlign.start,),
                  const SizedBox(height: 10,),
                  (moodList.isEmpty)
                      ? Components(context).Loader(textColor: theme.textColor)
                      :GridView.builder(
                    padding: const EdgeInsets.only(bottom: 15),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1/1.25,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: moodList.length,
                    itemBuilder: (context,index) {
                      return GestureDetector(
                        onTap: (){
                          HapticFeedback.selectionClick();
                          var data = moodList[index];
                          data['colorA'] = data['colorA'].toString().replaceAll('#', '');
                          data['colorB'] =  data['colorB'].toString().replaceAll('#', '');
                          data['textColor'] = data['textColor'] .toString().replaceAll('#', '');

                          Navigator.push(context, CupertinoPageRoute(builder: (context) => SoundMixer(themeImage: data,))).then((value) => getFavourites());
                        },
                        child: Container(
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
                                    imageUrl: moodList[index]['image'],fit: BoxFit.cover,),
                                ),

                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  left: 0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),

                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration:  const BoxDecoration(
                                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
                                          color: Colors.black54

                                      ),
                                      child: Text(moodList[index]['title'],style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700,color: Colors.white.withOpacity(0.85)),textAlign: TextAlign.center,),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


Color hexStringToColor(String hexColor) {
  final buffer = StringBuffer();
  if (hexColor.length == 7) {
    // If the input includes the alpha channel, remove it.
    hexColor = hexColor.replaceFirst('#', 'FF');
  }
  buffer.write('0x$hexColor');
  return Color(int.parse(buffer.toString()));
}