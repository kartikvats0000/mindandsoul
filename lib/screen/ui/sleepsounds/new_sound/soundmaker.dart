import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindandsoul/constants/iconconstants.dart';
import 'package:provider/provider.dart';
import '../../../../helper/components.dart';
import '../../../../provider/themeProvider.dart';
import '../newsounds.dart';

class SoundMixer extends StatefulWidget {
  const SoundMixer({Key? key}) : super(key: key);

  @override
  State<SoundMixer> createState() => _SoundMixerState();
}
class AudioPlayerModel{
  String id;
  String name;
  String image;
  String url;
  AudioPlayer player;

  AudioPlayerModel({required this.id,required this.name, required this.url, required this.image, required this.player});
}

class _SoundMixerState extends State<SoundMixer> {

  AudioPlayer audioPlayer = AudioPlayer();

  List<AudioPlayerModel> audioplayers = [];

  List<Map> content = [

    {
      'category' : 'Water',
      'items' : [
        {
          'id' : '1',
          'name' : 'Beach',
          'icon' : 'https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690956701385.svg',
          'audio' : 'https://cms-artifacts.motionarray.com/content/motion-array/1677490/Water_Swooshes_mp3.mp3?Expires=2003734610110&Key-Pair-Id=K2ZDLYDZI2R1DF&Signature=mC1Dsqne9BOuY9HhehZ7~ER5z3IUbrL6g9Y-tojm4gQAE2S7a3MJCjuBiGys4t25LJLakyZoxh8XRthef4Q7H2zfisVp4NkQp-PJLoCvh6HwUh5s82xtsNq5GqJSK0Mu2fPj7w9O9ebE6QPmJWkz3f5~1cG3pPO9Alem~b0fciubRQwvzSEBso3pC852wkLrrJ7uYuClhIo1gWYDElHpEbSPp-DzueNi1xJrgvrqtwfW2yKZxaGPFpFp60fQ9MqFixpqS7c966rHaka6QkJbGLKTcbq7Iv4cIxZLUhFEvZmbxZVrRhn-4A4~FJEHwdEy8NMHNl9pHLaFZWVZnFG1pw__',
          'isPlaying' : 'false'
        },
        {
          'id' : '2',
          'name' : 'Bird',
          'icon' : 'https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690789544820.svg',
          'audio' : 'https://assets.mixkit.co/active_storage/sfx/2458/2458-preview.mp3',
          'isPlaying' : 'false'
        },
        {
          'id' : '3',
          'name' : 'Calm',
          'icon' : 'https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690789544820.svg',
          'audio' : 'https://cms-artifacts.motionarray.com/content/motion-array/1728625/Crickets_mp3.mp3?Expires=2004367748890&Key-Pair-Id=K2ZDLYDZI2R1DF&Signature=R-6TqmYNGwW2aDYDT0XeTUqa144PwEaydaobvkyYVCcLVeLeQuF89pYJ-hPphbxmcZdOaCzW2HjVXpFWaU-~1KSkJeFjVRoeoEp3ika4-iTEa3E97nSYNHoJBn8z7y6aKnz297tvf~NEi~aSXSP1Tk4gv~nwDO6jUHxwS3jeU6LwgqeB7VPQFtDOk-9QUEPDRkSaDNraX63KN3p5H47d-SUidqxX11DPnALSUsiHNbzSLU7SbJtqA0FTXjBbIKP1QaeTIdLQM0JgVegR5qxNTsJ9RaJBEkOmUxC5NsYiEV0An1lNu-sW9Hf2m4yhzUCHh8FgR23S3-iVqzf8hnyuGQ__',
          'isPlaying' : 'false'
        },

      ]
    },
    {

      'category' : 'Rain',
      'items' : [
        {
          'id' : '4',
          'name' : 'Rain Inside',
          'icon' : 'https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690789544820.svg',
          'audio' : 'https://cms-artifacts.motionarray.com/content/motion-array/1666029/Heavy_Rain_Wind_Sound_Effects_Interior_mp3.mp3?Expires=2004243122840&Key-Pair-Id=K2ZDLYDZI2R1DF&Signature=PKM9KOxL4BUjWRbRimHaBczQmJ0rdf3gA~iA6zt14Zz3Z919e3YNZZqN1dkW7XQaj3QUEZA0EkbuKhW6HyXdzjxGW-nXmH41NEn1AbwlI85cEB40A-P4riLTIaFL62uza0ixBE3LhC54dyXtAamUZ~fwSvbVHiUhBipDwS1kTlyBXI0ZNfzwJgfiG9-nCYXtCoOsH4DkpYswWNVmRuTAKUxGKTLMnTYJkvOyQzxErj7Fck51AvZXH6~EsCM1G2kzYeEim7NVA7adaFwmgeYflS6E5ZU4WXinhbcyeF1KWOKJvW-POxwQFR7VTm-Tn~yx9XK6zitKSV-NQ~fCpMcDQQ__',
          'isPlaying' : 'false'
        },
        {
          'id' : '5',
          'name' : 'Water Drop',
          'icon' : 'https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690789544820.svg',
          'audio' : 'https://cms-artifacts.motionarray.com/content/motion-array/142579/Water_Drops_mp3.mp3?Expires=2003744634732&Key-Pair-Id=K2ZDLYDZI2R1DF&Signature=P2R02O78YVdp98zxqRID6MngExipMXgEpJkneLU-pZoSp5iitWj-KibK9X0uZGsFyBoXhfSEMRLT2TXPX3TtTmj1-mxVf39GwApXglj73Ese4fDQNJhjDMR0LmqOQOwpbRPcqqAnuuF3OARNUCelavqZNN0JIdHtjBwRVpJRRUGP6gJp-JDeXZHNVBR7j0cYZok2-1py7fVXxXG1WMUwHg4YVyOiSui4ipHFz90kpV-CrAgTswl-YggZuxqoigy0uF6q1vsrI4RoZpI97HRvf5hHEi3B1afi26XDST1GF5o0j1XCttcVaoUD~UGXkI9e2U~oGZcj4zGFyV-KYf8VCw__',
          'isPlaying' : 'false'
        },
        {
          'id' : '6',
          'name' : 'Rain Wind',
          'icon' : 'https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690789544820.svg',
          'audio' : 'https://cms-artifacts.motionarray.com/content/motion-array/139605/Rain-_Wind_And_Birds_mp3.mp3?Expires=2003748346155&Key-Pair-Id=K2ZDLYDZI2R1DF&Signature=1DPMh0Ua5iUxjIOWGE50vqxrXZPV3W11Hxw-DVapCaZK9nbaQgv2-gzcmoFEOVutOnq~HVn36mdC0gJs1zsoC3l98o0Bin6AgFtuJfwuLmqjGEdH1KDYtANeHU2~Y4WatKCz1CZaWmN~C7ZX5p8X86JfrmruWvomri0~zDV1nrmVk72IBvI~GC7BPv4CoAFprQk7hTqg~fuFKl4ION3X~bIZYwZwOMqe4Z0EMnPoUc6I~YRf4d5ogPaTCb4euB7hmtCqGdag-63rOEP1OBCYmBxNQifW4Z33nNqy7qUOMdtMV3DmiEm9hq5bsNd6iMtp3zE0bMLN5fGIfhPQrHrmTQ__',
          'isPlaying' : 'false'
        },
      ]
    },
    {
      'category' : 'Nature',
      'items' : [
        {
          'id' : '7',
          'name' : 'Bird Forest',
          'icon' : 'https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690956713137.svg',
          'audio' : 'https://cms-artifacts.motionarray.com/content/motion-array/1728625/Crickets_mp3.mp3?Expires=2004367748890&Key-Pair-Id=K2ZDLYDZI2R1DF&Signature=R-6TqmYNGwW2aDYDT0XeTUqa144PwEaydaobvkyYVCcLVeLeQuF89pYJ-hPphbxmcZdOaCzW2HjVXpFWaU-~1KSkJeFjVRoeoEp3ika4-iTEa3E97nSYNHoJBn8z7y6aKnz297tvf~NEi~aSXSP1Tk4gv~nwDO6jUHxwS3jeU6LwgqeB7VPQFtDOk-9QUEPDRkSaDNraX63KN3p5H47d-SUidqxX11DPnALSUsiHNbzSLU7SbJtqA0FTXjBbIKP1QaeTIdLQM0JgVegR5qxNTsJ9RaJBEkOmUxC5NsYiEV0An1lNu-sW9Hf2m4yhzUCHh8FgR23S3-iVqzf8hnyuGQ__',
          'isPlaying' : 'false'
        },
        {
          'id' : '8',
          'name' : 'Calm Forest',
          'icon' : 'https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690789544820.svg',
          'audio' : 'https://cms-artifacts.motionarray.com/content/motion-array/1647324/Cuckoo_mp3.mp3?Expires=2003744828282&Key-Pair-Id=K2ZDLYDZI2R1DF&Signature=SaXzSK4mkJwdEZIU7AqWZPUoSCIYJGKvkvhQWJEdERLX69GIpEOktkDVG~0bsqyt6XLBFKd8uu~A43SuGLoWaM4LqXbKYd-5P84VdIf6Np-svVyHma~fG0ql6fyRYI0SXaYYtcIG93OkwG633EDM9HDYeN1PnDr0xUFtI2iKPpafAxi3u4inPonQPKEyLlIIfJukLqN7VGCcSSogns7KafBqvjbOKJ5Fso1mKkThBKqkV4Xlq01mnWEEqbVY4jFt3FBg2f6PyhbAyi3Bpzs-Y-T12lWLT10T5YdiLxz1Nwb3sl08rKS7TRPoNRiK8LHQNQi34fHMfY0JnrDCTKvRhw__',
          'isPlaying' : 'false'
        },
        {
          'id' : '9',
          'name' : 'Calm',
          'icon' : 'https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690789544820.svg',
          'audio' : 'https://cms-artifacts.motionarray.com/content/motion-array/1122596/Night_Crickets_And_Insects_mp3.mp3?Expires=2003733322832&Key-Pair-Id=K2ZDLYDZI2R1DF&Signature=ykQj0nBomOxih~m2GkNvH9WlYbu2fzbrqcywebRF-CalmMEuAoM7aZKmV8riUg~KALx5E6FP5ykuaf2BoJ6ppeX4m0vSbN-YPsiqkoZidwj3F4wQ3d0K7lhMMUJEGoR0Bnfm~y6mZPlRcqTPjTVZVur1sqYUWJxR9C~Z6hbt7PLayAWc3MBOklUxEgLSNaq2vhX488MJbemXssAlNzR7yrLB1U0UOERx3yQtvMHK74YATXTMj-v2-deJJHVom6Yz6Z1~2IJjTzYYm0tXp7u0-IYvkGf8nXyzKSoNIG0sKFTJeQ~8VFBlR~zzQG1Ir6Fq5InCiDKngQAT2r00b3gAHA__',
          'isPlaying' : 'false'
        },

      ]
    },

   /* {
      'category' : 'Rain',
      'items' : [
        {
          'id' : '7',
          'name' : 'Rain Inside',
          'icon' : 'https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690789544820.svg',
          'audio' : 'https://cms-artifacts.motionarray.com/content/motion-array/1666029/Heavy_Rain_Wind_Sound_Effects_Interior_mp3.mp3?Expires=2004243122840&Key-Pair-Id=K2ZDLYDZI2R1DF&Signature=PKM9KOxL4BUjWRbRimHaBczQmJ0rdf3gA~iA6zt14Zz3Z919e3YNZZqN1dkW7XQaj3QUEZA0EkbuKhW6HyXdzjxGW-nXmH41NEn1AbwlI85cEB40A-P4riLTIaFL62uza0ixBE3LhC54dyXtAamUZ~fwSvbVHiUhBipDwS1kTlyBXI0ZNfzwJgfiG9-nCYXtCoOsH4DkpYswWNVmRuTAKUxGKTLMnTYJkvOyQzxErj7Fck51AvZXH6~EsCM1G2kzYeEim7NVA7adaFwmgeYflS6E5ZU4WXinhbcyeF1KWOKJvW-POxwQFR7VTm-Tn~yx9XK6zitKSV-NQ~fCpMcDQQ__',
          'isPlaying' : 'false'
        },
        {
          'id' : '8',
          'name' : 'Water Drop',
          'icon' : 'https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690789544820.svg',
          'audio' : 'https://cms-artifacts.motionarray.com/content/motion-array/142579/Water_Drops_mp3.mp3?Expires=2003744634732&Key-Pair-Id=K2ZDLYDZI2R1DF&Signature=P2R02O78YVdp98zxqRID6MngExipMXgEpJkneLU-pZoSp5iitWj-KibK9X0uZGsFyBoXhfSEMRLT2TXPX3TtTmj1-mxVf39GwApXglj73Ese4fDQNJhjDMR0LmqOQOwpbRPcqqAnuuF3OARNUCelavqZNN0JIdHtjBwRVpJRRUGP6gJp-JDeXZHNVBR7j0cYZok2-1py7fVXxXG1WMUwHg4YVyOiSui4ipHFz90kpV-CrAgTswl-YggZuxqoigy0uF6q1vsrI4RoZpI97HRvf5hHEi3B1afi26XDST1GF5o0j1XCttcVaoUD~UGXkI9e2U~oGZcj4zGFyV-KYf8VCw__',
          'isPlaying' : 'false'
        },
        {
          'id' : '9',
          'name' : 'Rain Wind',
          'icon' : 'https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690789544820.svg',
          'audio' : 'https://cms-artifacts.motionarray.com/content/motion-array/139605/Rain-_Wind_And_Birds_mp3.mp3?Expires=2003748346155&Key-Pair-Id=K2ZDLYDZI2R1DF&Signature=1DPMh0Ua5iUxjIOWGE50vqxrXZPV3W11Hxw-DVapCaZK9nbaQgv2-gzcmoFEOVutOnq~HVn36mdC0gJs1zsoC3l98o0Bin6AgFtuJfwuLmqjGEdH1KDYtANeHU2~Y4WatKCz1CZaWmN~C7ZX5p8X86JfrmruWvomri0~zDV1nrmVk72IBvI~GC7BPv4CoAFprQk7hTqg~fuFKl4ION3X~bIZYwZwOMqe4Z0EMnPoUc6I~YRf4d5ogPaTCb4euB7hmtCqGdag-63rOEP1OBCYmBxNQifW4Z33nNqy7qUOMdtMV3DmiEm9hq5bsNd6iMtp3zE0bMLN5fGIfhPQrHrmTQ__',
          'isPlaying' : 'false'
        },
        {
          'category' : 'Nature',
          'items' : [
            {
              'id' : '10',
              'name' : 'Bird Forest',
              'icon' : 'https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690956713137.svg',
              'audio' : 'https://cms-artifacts.motionarray.com/content/motion-array/1728625/Crickets_mp3.mp3?Expires=2004367748890&Key-Pair-Id=K2ZDLYDZI2R1DF&Signature=R-6TqmYNGwW2aDYDT0XeTUqa144PwEaydaobvkyYVCcLVeLeQuF89pYJ-hPphbxmcZdOaCzW2HjVXpFWaU-~1KSkJeFjVRoeoEp3ika4-iTEa3E97nSYNHoJBn8z7y6aKnz297tvf~NEi~aSXSP1Tk4gv~nwDO6jUHxwS3jeU6LwgqeB7VPQFtDOk-9QUEPDRkSaDNraX63KN3p5H47d-SUidqxX11DPnALSUsiHNbzSLU7SbJtqA0FTXjBbIKP1QaeTIdLQM0JgVegR5qxNTsJ9RaJBEkOmUxC5NsYiEV0An1lNu-sW9Hf2m4yhzUCHh8FgR23S3-iVqzf8hnyuGQ__',
              'isPlaying' : 'false'
            },
            {
              'id' : '11',
              'name' : 'Calm Forest',
              'icon' : 'https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690789544820.svg',
              'audio' : 'https://cms-artifacts.motionarray.com/content/motion-array/1647324/Cuckoo_mp3.mp3?Expires=2003744828282&Key-Pair-Id=K2ZDLYDZI2R1DF&Signature=SaXzSK4mkJwdEZIU7AqWZPUoSCIYJGKvkvhQWJEdERLX69GIpEOktkDVG~0bsqyt6XLBFKd8uu~A43SuGLoWaM4LqXbKYd-5P84VdIf6Np-svVyHma~fG0ql6fyRYI0SXaYYtcIG93OkwG633EDM9HDYeN1PnDr0xUFtI2iKPpafAxi3u4inPonQPKEyLlIIfJukLqN7VGCcSSogns7KafBqvjbOKJ5Fso1mKkThBKqkV4Xlq01mnWEEqbVY4jFt3FBg2f6PyhbAyi3Bpzs-Y-T12lWLT10T5YdiLxz1Nwb3sl08rKS7TRPoNRiK8LHQNQi34fHMfY0JnrDCTKvRhw__',
              'isPlaying' : 'false'
            },
            {
              'id' : '12',
              'name' : 'Calm',
              'icon' : 'https://eeasy.s3.ap-south-1.amazonaws.com/brain/category/1690789544820.svg',
              'audio' : 'https://cms-artifacts.motionarray.com/content/motion-array/1122596/Night_Crickets_And_Insects_mp3.mp3?Expires=2003733322832&Key-Pair-Id=K2ZDLYDZI2R1DF&Signature=ykQj0nBomOxih~m2GkNvH9WlYbu2fzbrqcywebRF-CalmMEuAoM7aZKmV8riUg~KALx5E6FP5ykuaf2BoJ6ppeX4m0vSbN-YPsiqkoZidwj3F4wQ3d0K7lhMMUJEGoR0Bnfm~y6mZPlRcqTPjTVZVur1sqYUWJxR9C~Z6hbt7PLayAWc3MBOklUxEgLSNaq2vhX488MJbemXssAlNzR7yrLB1U0UOERx3yQtvMHK74YATXTMj-v2-deJJHVom6Yz6Z1~2IJjTzYYm0tXp7u0-IYvkGf8nXyzKSoNIG0sKFTJeQ~8VFBlR~zzQG1Ir6Fq5InCiDKngQAT2r00b3gAHA__',
              'isPlaying' : 'false'
            },
          ]
        },
      ]
    },*/
  ];

  bool allplaying = false;

  pauseAll(){
    DateTime start = DateTime.now();

    for(int i = 0;i<audioplayers.length;i++){
      if(audioplayers[i].player.state == PlayerState.playing){
        audioplayers[i].player.pause();
      }
    }
    setState(() {
      allplaying = false;
    });
  }

  playAll(){
    for(int i = 0;i<audioplayers.length;i++){
      if(audioplayers[i].player.state == PlayerState.paused){
        audioplayers[i].player.resume();
      }

    }
    setState(() {
      allplaying = false;
    });
  }

  @override
  void dispose(){
    for(int i = 0;i<audioplayers.length;i++){
      print('disposing ${audioplayers[i].name}');
      audioplayers[i].player.stop();
      audioplayers[i].player.dispose();
    }

    super.dispose();
  }

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,themeData,child) =>
          Theme(
            data: Theme.of(context).copyWith(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor:Color(int.parse('0xff${themeImage['themeColorA']}')),),
            ),
            child: Builder(
              builder: (context) =>
                  Scaffold(
                    backgroundColor: Color(int.parse("0xff${themeImage['themeColorA']}")),
                    extendBodyBehindAppBar: true,
                    extendBody: true,
                    appBar: AppBar(
                      elevation: 0.0,
                      scrolledUnderElevation: 0.0,
                      backgroundColor: Colors.transparent,
                      leading: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Components(context).BlurBackgroundCircularButton(
                            icon: Icons.chevron_left,
                            onTap: (){pageController.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);},
                          )
                      ),

                    ),
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex:4,
                          child: SizedBox(
                            width: double.infinity,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: CachedNetworkImage(imageUrl: themeImage['image'],fit: BoxFit.cover,),
                            ),
                          )
                        ),
                        Expanded(
                          flex:6,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                 // alignment: Alignment.center,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(int.parse('0xff' + themeImage['themeColorA'])),
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(int.parse('0xff' + themeImage['themeColorA'])),
                                          Color(int.parse('0xff' + themeImage['themeColorB'])),
                                        ]
                                    ),
                                    //backgroundBlendMode: BlendMode.color,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(int.parse('0xff' + themeImage['themeColorA'])),
                                          blurRadius: 50,
                                          spreadRadius: 80,
                                          blurStyle: BlurStyle.normal,
                                      )
                                    ],
                                  ),
                                child: ListView.builder(
                                  padding: (audioplayers.isEmpty)?EdgeInsets.zero: EdgeInsets.only(bottom: 50),
                                    shrinkWrap: true,
                                    itemCount: content.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                            child: Text(content[index]['category'],
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Color(int.parse('0xff' + themeImage['textColor'])).withOpacity(0.8)),textAlign: TextAlign.start,),
                                          ),
                                          const SizedBox(height: 15,),
                                          GridView.builder(
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 7,
                                                mainAxisSpacing: 7,
                                            ),
                                             physics:const NeverScrollableScrollPhysics(),
                                             shrinkWrap: true,
                                              itemCount: content[index]['items'].length ,
                                              itemBuilder: (context, pos) {
                                              var isinplayer = audioplayers.where((element) => element.id == content[index]['items'][pos]['id']);
                                              print('player with ${content[index]['items'][pos]['id']} $isinplayer');
                                              print((isinplayer.isEmpty)?'no playa':isinplayer.first.name);
                                                return GestureDetector(
                                                  onTap: (){
                                                    AudioPlayer audioplayer1 = AudioPlayer();
                                                    var check = false;
                                                    int indexToRemove = -1;
                                                    setState(() {
                                                      for (int i = audioplayers.length - 1; i >= 0; i--) {
                                                        var element = audioplayers[i];
                                                        print('element id ${element.id}');
                                                        print('current item id ${content[index]['items'][pos]['id']}');

                                                        if (element.id == content[index]['items'][pos]['id']) {
                                                          element.player.stop();
                                                          element.player.dispose();
                                                          indexToRemove = i;
                                                          check = true;
                                                          break; // Exit the loop once you find the element to remove
                                                        } else {
                                                          check = false;
                                                        }
                                                      }

                                                      print('check $check');

                                                      if (check) {
                                                        print('removing');
                                                        audioplayers.removeAt(indexToRemove);
                                                      } else {
                                                        if(audioplayers.length >= 7){
                                                          Components(context).showSuccessSnackBar('Only 7 Harmonies can be added together');
                                                        }
                                                        else{
                                                          print('adding');
                                                          audioplayer1.play(UrlSource(content[index]['items'][pos]['audio']));
                                                          audioplayer1.setReleaseMode(ReleaseMode.loop);
                                                          audioplayer1.setVolume(0.7);
                                                          audioplayers.add(AudioPlayerModel(
                                                            id: content[index]['items'][pos]['id'],
                                                            name: content[index]['items'][pos]['name'],
                                                            image: content[index]['items'][pos]['icon'],
                                                            url: content[index]['items'][pos]['audio'],
                                                            player: audioplayer1,
                                                          ));
                                                        }
                                                      }
                                                    });
                                                    playAll();
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Text( '${content[index]['items'][pos]['name']}',
                                                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Color(int.parse('0xff' + themeImage['textColor'])),
                                                            fontSize: 12),),
                                                      const SizedBox(height: 10,),
                                                      Expanded(
                                                        flex: 4,
                                                        child: AnimatedContainer(
                                                          duration: const Duration(milliseconds: 300 ),
                                                          padding: const EdgeInsets.all(20),
                                                         // radius: 40,
                                                           decoration: BoxDecoration(
                                                             color: (isinplayer.isEmpty)? Colors.white.withOpacity(0.5):Theme.of(context).colorScheme.primary.withOpacity(0.65),
                                                             shape: BoxShape.circle,
                                                             boxShadow: [
                                                               BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.7),blurRadius: 10,spreadRadius: 1)
                                                             ]
                                                           ),
                                                          child: SvgPicture.network(
                                                            content[index]['items'][pos]['icon'],
                                                            color: (isinplayer.isEmpty)?Colors.black.withOpacity(0.8):Colors.white,//Color(int.parse('0xff' +themeImage['textColor'] )),
                                                            height: 25,
                                                            width: 25,
                                                            ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5,),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Opacity(
                                                          //duration: const Duration(milliseconds: 300),
                                                          opacity: (isinplayer.isEmpty)?0:1,
                                                          child: Slider(
                                                            thumbColor: Theme.of(context).colorScheme.inversePrimary,
                                                              activeColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
                                                             // inactiveColor: Color(int.parse('0xff${themeImage['textColor']}')).withOpacity(0.35),
                                                              value: (isinplayer.isEmpty)?0:isinplayer.first.player.volume, onChanged:(isinplayer.isEmpty)?null:(vol){
                                                            setState(() {
                                                              isinplayer.first.player.setVolume(vol);
                                                            });
                                                          }),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8,),
                                                    ],
                                                  ),
                                                );
                                              },
                                            padding: const EdgeInsets.only(bottom: 10),
                                          ),
                                          const SizedBox(height: 15,),
                                        ],
                                      );
                                    }
                                ),

                              ),
                              Positioned(
                                left: 10,
                                top: -40,
                                child: Text('Pick Sounds',style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Color(int.parse('0xff${themeImage['textColor']}'))),textAlign: TextAlign.start,),),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                    child: Visibility(
                                      visible: audioplayers.isNotEmpty,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(25),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                                          child: Container(
                                           // margin: EdgeInsets.only(bottom: 10),
                                           // width: MediaQuery.of(context).size.width * 0.4,
                                            decoration: BoxDecoration(

                                              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                                              borderRadius: BorderRadius.circular(30),
                                              border: Border.all(color: Colors.white.withOpacity(0.5))
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                    onPressed: (){
                                                      for(int i = 0;i<audioplayers.length;i++){
                                                        setState(() {
                                                          allplaying = audioplayers[i].player.state == PlayerState.playing;
                                                        });
                                                        if(allplaying == true){
                                                          audioplayers[i].player.pause();
                                                        }
                                                        else{
                                                          audioplayers[i].player.resume();
                                                        }
                                                      }
                                                    },
                                                    icon: Icon((allplaying)?Icons.play_arrow_rounded:Icons.pause,color: Colors.white70,)
                                                ),
                                                IconButton(
                                                    onPressed: (){
                                                      showModalBottomSheet(
                                                        backgroundColor: Colors.transparent,
                                                        isScrollControlled: true,
                                                        enableDrag: true,
                                                          context: context,
                                                          builder: (context)=>
                                                              StatefulBuilder(
                                                                builder: (context,setState) =>
                                                                 ClipRRect(
                                                                   borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                                                                   child: BackdropFilter(
                                                                     filter: ImageFilter.blur(sigmaY: 10,sigmaX: 10),
                                                                     child: Container(
                                                                       color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
                                                                       height: MediaQuery.of(context).size.height * 0.85,
                                                                      child: Scaffold(
                                                                        backgroundColor: Colors.transparent,
                                                                        body: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text('Save Harmony Mix',style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white.withOpacity(0.8)),textAlign: TextAlign.start,),
                                                                                  Components(context).BlurBackgroundCircularButton(icon: Icons.clear,iconSize: 17,buttonRadius: 17,iconColor: Colors.white70,onTap: ()=>Navigator.pop(context))
                                                                                ],
                                                                              ),
                                                                            ),
                                                                             Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: TextField(
                                                                                controller: nameController,
                                                                                decoration: const InputDecoration(
                                                                                    hintText: 'Give your mix a name'
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: ListView.builder(
                                                                                shrinkWrap: true,
                                                                                scrollDirection: Axis.vertical,
                                                                                itemCount: audioplayers.length,
                                                                                  itemBuilder: (context,position){
                                                                                  return ListTile(
                                                                                   // minLeadingWidth: MediaQuery.of(context).size.width * 0.25,
                                                                                    horizontalTitleGap: 0,
                                                                                    contentPadding: EdgeInsets.all(10),
                                                                                    leading: Container(
                                                                                      width: MediaQuery.of(context).size.width * 0.17,
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          Expanded(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(2),
                                                                                              child: AspectRatio(
                                                                                                aspectRatio: 1,
                                                                                                  child: SvgPicture.network(audioplayers[position].image,color: themeData.textColor,)),
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(height: 5,),
                                                                                          Text(audioplayers[position].name,style: Theme.of(context).textTheme.bodySmall?.copyWith(color: themeData.textColor,fontSize: 11.5),),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    title: Slider(
                                                                                      thumbColor: Theme.of(context).colorScheme.inversePrimary,
                                                                                      activeColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
                                                                                      //inactiveColor: Colors.grey.shade200.withOpacity(0.35),
                                                                                      value: audioplayers[position].player.volume, onChanged: (double value) {setState((){
                                                                                      audioplayers[position].player.setVolume(value);
                                                                                    }) ;},),
                                                                                    trailing: Components(context).BlurBackgroundCircularButton(svg: MyIcons.delete,onTap: (){
                                                                                      setState(()  {
                                                                                        audioplayers[position].player.stop();
                                                                                        audioplayers[position].player.release();
                                                                                        audioplayers[position].player.dispose();
                                                                                        audioplayers.removeAt(position);
                                                                                      });
                                                                                      if(audioplayers.isEmpty) {
                                                                                        Navigator.pop(context);
                                                                                      }
                                                                                    })
                                                                                  );
                                                                                  }),
                                                                            ),
                                                                            const SizedBox(height: 10,),
                                                                            FilledButton.tonal(
                                                                                onPressed: (){
                                                                                  if(nameController.text.isEmpty){
                                                                                    Components(context).showErrorSnackBar('The mix must be named');
                                                                                  }
                                                                                },
                                                                                child: Text('Save Custom Harmony Mix'),
                                                                              style: ElevatedButton.styleFrom(
                                                                                shadowColor: Theme.of(context).colorScheme.primary,
                                                                                fixedSize: Size(MediaQuery.of(context).size.width,kToolbarHeight-5),
                                                                                shape: const RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.vertical(top: Radius.circular(15))
                                                                                )
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                ),
                                                                   ),
                                                                 ),
                                                              )
                                                      ).then((value) => setState((){}));
                                                    },
                                                    icon: const Icon(Icons.save_alt_outlined,color: Colors.white70,)
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
            ),
          ),
    );
  }
}