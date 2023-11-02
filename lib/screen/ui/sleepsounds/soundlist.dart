import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:mindandsoul/helper/random_shape.dart';
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

List playlist =  [
  {
    "_id" : "cs1",
    "title" : "Custom Sound 1",
    "image" :"https://cdn.pixabay.com/photo/2012/02/23/08/38/rocks-15712_640.jpg",
    "themeColorA" : "937551",
    "themeColorB" : "9F9282",
    "textColor" : "FDFEFE",
    "sounds" : [
      {
        "_id" : "cs1s1",
        "name" : "Beach",
        "icon" : "https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690956701385.svg",
        "audio" : "https://cms-artifacts.motionarray.com/content/motion-array/1677490/Water_Swooshes_mp3.mp3?Expires=2003734610110&Key-Pair-Id=K2ZDLYDZI2R1DF&Signature=mC1Dsqne9BOuY9HhehZ7~ER5z3IUbrL6g9Y-tojm4gQAE2S7a3MJCjuBiGys4t25LJLakyZoxh8XRthef4Q7H2zfisVp4NkQp-PJLoCvh6HwUh5s82xtsNq5GqJSK0Mu2fPj7w9O9ebE6QPmJWkz3f5~1cG3pPO9Alem~b0fciubRQwvzSEBso3pC852wkLrrJ7uYuClhIo1gWYDElHpEbSPp-DzueNi1xJrgvrqtwfW2yKZxaGPFpFp60fQ9MqFixpqS7c966rHaka6QkJbGLKTcbq7Iv4cIxZLUhFEvZmbxZVrRhn-4A4~FJEHwdEy8NMHNl9pHLaFZWVZnFG1pw__",
        "volume" : 0.7
      },
      {
        "_id" : "cs1s2",
        "name" : "Calm",
        "icon" : "https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690789544820.svg",
        "audio" : "https://cms-artifacts.motionarray.com/content/motion-array/1728625/Crickets_mp3.mp3?Expires=2004367748890&Key-Pair-Id=K2ZDLYDZI2R1DF&Signature=R-6TqmYNGwW2aDYDT0XeTUqa144PwEaydaobvkyYVCcLVeLeQuF89pYJ-hPphbxmcZdOaCzW2HjVXpFWaU-~1KSkJeFjVRoeoEp3ika4-iTEa3E97nSYNHoJBn8z7y6aKnz297tvf~NEi~aSXSP1Tk4gv~nwDO6jUHxwS3jeU6LwgqeB7VPQFtDOk-9QUEPDRkSaDNraX63KN3p5H47d-SU_idqxX11DPnALSUsiHNbzSLU7SbJtqA0FTXjBbIKP1QaeT_idLQM0JgVegR5qxNTsJ9RaJBEkOmUxC5NsYiEV0An1lNu-sW9Hf2m4yhzUCHh8FgR23S3-iVqzf8hnyuGQ__",
        "volume" : 0.7
      },
      {
        "_id" : "cs1s3",
        "name" : "Calm Forest",
        "icon" : "https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690789544820.svg",
        "audio" : "https://cms-artifacts.motionarray.com/content/motion-array/1647324/Cuckoo_mp3.mp3?Expires=2003744828282&Key-Pair-Id=K2ZDLYDZI2R1DF&Signature=SaXzSK4mkJwdEZIU7AqWZPUoSCIYJGKvkvhQWJEdERLX69GIpEOktkDVG~0bsqyt6XLBFKd8uu~A43SuGLoWaM4LqXbKYd-5P84VdIf6Np-svVyHma~fG0ql6fyRYI0SXaYYtcIG93OkwG633EDM9HDYeN1PnDr0xUFtI2iKPpafAxi3u4inPonQPKEyLlIIfJukLqN7VGCcSSogns7KafBqvjbOKJ5Fso1mKkThBKqkV4Xlq01mnWEEqbVY4jFt3FBg2f6PyhbAyi3Bpzs-Y-T12lWLT10T5YdiLxz1Nwb3sl08rKS7TRPoNRiK8LHQNQi34fHMfY0JnrDCTKvRhw__",
        "volume" : 0.5
      }
    ]
  },
  {
    "_id" : "cs2",
    "title" : "Custom Sound 2",
    "image" :"https://cdn.pixabay.com/photo/2014/09/21/14/39/surface-455124_640.jpg",
    "themeColorA" : "E1F2F1",
    "themeColorB" : "9EC0C7",
    "textColor" : "1A2C32",
    "sounds" : [
      {
        "_id" : "cs2s1",
        "name" : "Rain Inside",
        "icon" : "https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690789544820.svg",
        "audio" : "https://cms-artifacts.motionarray.com/content/motion-array/1666029/Heavy_Rain_Wind_Sound_Effects_Interior_mp3.mp3?Expires=2004243122840&Key-Pair-Id=K2ZDLYDZI2R1DF&Signature=PKM9KOxL4BUjWRbRimHaBczQmJ0rdf3gA~iA6zt14Zz3Z919e3YNZZqN1dkW7XQaj3QUEZA0EkbuKhW6HyXdzjxGW-nXmH41NEn1AbwlI85cEB40A-P4riLTIaFL62uza0ixBE3LhC54dyXtAamUZ~fwSvbVHiUhBipDwS1kTlyBXI0ZNfzwJgfiG9-nCYXtCoOsH4DkpYswWNVmRuTAKUxGKTLMnTYJkvOyQzxErj7Fck51AvZXH6~EsCM1G2kzYeEim7NVA7adaFwmgeYflS6E5ZU4WXinhbcyeF1KWOKJvW-POxwQFR7VTm-Tn~yx9XK6zitKSV-NQ~fCpMcDQQ__",
        "volume" : 0.45
      },
      {
        "_id" : "cs2s2",
        "name" : "Water Drop",
        "icon" : "https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690789544820.svg",
        "audio" : "https://cms-artifacts.motionarray.com/content/motion-array/142579/Water_Drops_mp3.mp3?Expires=2003744634732&Key-Pair-Id=K2ZDLYDZI2R1DF&Signature=P2R02O78YVdp98zxqRID6MngExipMXgEpJkneLU-pZoSp5iitWj-KibK9X0uZGsFyBoXhfSEMRLT2TXPX3TtTmj1-mxVf39GwApXglj73Ese4fDQNJhjDMR0LmqOQOwpbRPcqqAnuuF3OARNUCelavqZNN0JIdHtjBwRVpJRRUGP6gJp-JDeXZHNVBR7j0cYZok2-1py7fVXxXG1WMUwHg4YVyOiSui4ipHFz90kpV-CrAgTswl-YggZuxqoigy0uF6q1vsrI4RoZpI97HRvf5hHEi3B1afi26XDST1GF5o0j1XCttcVaoUD~UGXkI9e2U~oGZcj4zGFyV-KYf8VCw__",
        "volume" : 0.1
      },
      {
        "_id" : "cs2s3",
        "name" : "Rain Wind",
        "icon" : "https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690789544820.svg",
        "audio" : "https://cms-artifacts.motionarray.com/content/motion-array/139605/Rain-_Wind_And_Birds_mp3.mp3?Expires=2003748346155&Key-Pair-Id=K2ZDLYDZI2R1DF&Signature=1DPMh0Ua5iUxjIOWGE50vqxrXZPV3W11Hxw-DVapCaZK9nbaQgv2-gzcmoFEOVutOnq~HVn36mdC0gJs1zsoC3l98o0Bin6AgFtuJfwuLmqjGEdH1KDYtANeHU2~Y4WatKCz1CZaWmN~C7ZX5p8X86JfrmruWvomri0~zDV1nrmVk72IBvI~GC7BPv4CoAFprQk7hTqg~fuFKl4ION3X~bIZYwZwOMqe4Z0EMnPoUc6I~YRf4d5ogPaTCb4euB7hmtCqGdag-63rOEP1OBCYmBxNQifW4Z33nNqy7qUOMdtMV3DmiEm9hq5bsNd6iMtp3zE0bMLN5fGIfhPQrHrmTQ__",
        "volume" : 1.0
      }
    ]
  },


];


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
    return Consumer<ThemeProvider>(
      builder: (context,theme,child) =>
      Scaffold(
        backgroundColor: theme.themeColorA,
        appBar: Components(context).myAppBar('Harmony'),
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
                      child: Text('Your Mixes',style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: theme.textColor,fontWeight: FontWeight.bold,fontSize: 21),textAlign: TextAlign.start,)),
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
                  SizedBox(height: (playlist.isNotEmpty)?15:0,),

                  ///new audio
                  Text('Select Mood',style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: theme.textColor,fontWeight: FontWeight.bold,fontSize: 21),textAlign: TextAlign.start,),
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