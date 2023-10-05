import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/services/notificationServices.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:io';

import '../../../../constants/iconconstants.dart';


class DailyQuotes extends StatefulWidget {
  final List data;
  const DailyQuotes({super.key, required this.data});

  @override
  State<DailyQuotes> createState() => _DailyQuotesState();
}

class _DailyQuotesState extends State<DailyQuotes> {

  DateTime date = DateTime.now();

  bool showDate = false;
  bool showQuote = false;

  int selectedIndex = 0;

  Future<void> downloadAndSaveImage(String imageUrl, String fileName) async {
    Dio dio = Dio();
    setState(() {
      shareLoading = true;
    });
    try {
      // Download the image using dio
      Response response = await dio.get(imageUrl, options: Options(responseType: ResponseType.bytes));

      // Get the device's gallery directory
      final appDocDir = await getExternalStorageDirectory();
      final galleryDirectory = appDocDir!.path;

      // Create a File and write the downloaded bytes to it
      final file = File('$galleryDirectory/$fileName');
      await file.writeAsBytes(response.data);

      // Notify the gallery app to scan the new file (so it appears in the gallery)
      await ImageGallerySaver.saveFile(file.path);
      print('Image saved to gallery: $fileName');
     // Components(context).showSuccessSnackBar('Image saved to gallery: $fileName');
      Components(context).showSuccessSnackBar('Image Saved in Gallery');
      setState(() {
        shareLoading = false;
      });
    } catch (e) {
      print('Error saving image: $e');
      setState(() {
        shareLoading = false;
      });
    }
  }

  Future<void> saveMemoryImageToGallery(Uint8List imageBytes, String fileName) async {
    setState(() {
      shareLoading = true;
    });
    try {
      // Get the device's gallery directory
      final appDocDir = await getExternalStorageDirectory();
      final galleryDirectory = appDocDir!.path;

      // Create a File and write the image bytes to it
      final file = File('$galleryDirectory/$fileName');
      await file.writeAsBytes(imageBytes);

      // Notify the gallery app to scan the new file (so it appears in the gallery)
      await ImageGallerySaver.saveFile(file.path);

      print('Memory image saved to gallery: $fileName');
      //Components(context).showSuccessSnackBar('image saved to gallery: $fileName');
      Components(context).showSuccessSnackBar('Image Saved in Gallery');
      setState(() {
        shareLoading = false;
      });
    } catch (e) {
      print('Error saving memory image: $e');
      setState(() {
        shareLoading = false;
      });
    }
  }

  downloadWallpaper()async{
    setState(() {
      shareLoading = true;
    });
    screenshotController.captureFromWidget(
      Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: widget.data[selectedIndex]['image'],
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              bottom: 0,
              right: 10,
              child: Image.asset(
                'assets/logo/brainnsoul_white.png',
                height: 100,
                width: 100,
                opacity: const AlwaysStoppedAnimation(.6),
              )
          ),
        ],
      ),

    ).then((value) async{
      saveMemoryImageToGallery(value, widget.data[selectedIndex]['image'].toString().split('/').last);
    });
  }

  quoteScreen(){
    return Stack(
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: widget.data[selectedIndex]['image'],
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
            bottom: 0,
            right: 10,
            child: Image.asset(
              'assets/logo/brainnsoul_white.png',
              height: 100,
              width: 100,
              opacity: const AlwaysStoppedAnimation(.6),
            )
        ),
        Positioned.fill(
            child: AnimatedContainer(
              color: showDate?Colors.red.withOpacity(0.15):Colors.transparent,
              duration: const Duration(milliseconds: 1500),
            )
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: AnimatedOpacity(
                    curve: Curves.easeIn,
                    opacity: showDate?1:0,
                    duration: const Duration(milliseconds: 1500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('  ${DateFormat('MMM').format(date)}',style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 15,color: Colors.white,),),
                        Text(date.day.toString().padLeft(2,'0'),style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          height: 1,
                          color: Colors.white,
                        ),),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25,),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: AnimatedOpacity(
                    opacity: showQuote?1:0,
                    duration: const Duration(milliseconds: 2800),
                    child: Text.rich(
                      TextSpan(
                        text: '“${widget.data[selectedIndex]['quote']}”',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontSize: 22,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.3
                        ),
                        children:  <TextSpan>[
                          TextSpan(text: '\n\n  - ${widget.data[selectedIndex]['author']}', style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50,)
              ],
            ),
          ),
        ),
      ],
    );
  }

  wallpaperScreen(){
    return  Stack(
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: widget.data[selectedIndex]['image'],
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
            bottom: 0,
            right: 10,
            child: Image.asset(
              'assets/logo/brainnsoul_white.png',
              height: 100,
              width: 100,
              opacity: const AlwaysStoppedAnimation(.6),
            )
        ),
      ],
    );
  }

  downloadQuote()async{
    setState(() {
      shareLoading = true;
    });

    screenshotController.captureFromWidget(
        quoteScreen()
    )
        .then((value) async{
      saveMemoryImageToGallery(value, widget.data[selectedIndex]['image'].toString().split('/').last);
    });
  }


  PageController pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    Timer(const Duration(milliseconds: 450), () { setState(() {
      showDate = true;
    });});
    Timer(const Duration(milliseconds: 700), () { setState(() {
      showQuote = true;
    });});
    super.initState();
  }

  bool shareLoading = false;


  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            GestureDetector(
              onTapDown: _onTapDown,
                child: PageView.builder(
                    controller: pageController,
                    onPageChanged: (position){
                      setState(() {
                        selectedIndex = position;
                      });
                    },
                    itemCount: widget.data.length,
                    itemBuilder: (context,index){
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: CachedNetworkImage(
                              placeholder: (context,url) => Center(
                                child: Container(
                                    margin: EdgeInsets.all(40),
                                    height: 60,
                                    width: 60,
                                    child: SpinKitSpinningLines(color: Theme.of(context).colorScheme.primary,)),
                              ),
                              imageUrl: widget.data[index]['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 10,
                              child: Image.asset(
                                'assets/logo/brainnsoul_white.png',
                                height: 100,
                                width: 100,
                                opacity: const AlwaysStoppedAnimation(.6),
                              )
                          ),
                          Positioned.fill(
                              child: AnimatedContainer(
                                color: showDate?(shareLoading)?Colors.black.withOpacity(0.65):Colors.black.withOpacity(0.15):Colors.transparent,
                                duration: const Duration(milliseconds: 1200),
                              )
                          ),
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  AnimatedOpacity(
                                    curve: Curves.easeIn,
                                    opacity: showDate?1:0,
                                    duration: const Duration(milliseconds: 1300),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.45),
                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('  ${DateFormat('MMM').format(date)}',style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 15,color: Colors.white),),
                                          Text(date.day.toString().padLeft(2,'0'),style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                              color: Colors.white,
                                              height: 1
                                          ),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                  AnimatedOpacity(
                                    opacity: showQuote?1:0,
                                    duration: const Duration(milliseconds: 1600),
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.45),
                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Text.rich(
                                        TextSpan(
                                          text: '“${widget.data[index]['quote']}”',
                                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                              fontSize: 22,
                                              color: Colors.white.withOpacity(0.9),
                                              height: 1.3
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(text: '\n\n  - ${(widget.data[index]['author'].toString().isNotEmpty)?widget.data[index]['author']:'Unknown'}', style: TextStyle(fontSize: 15)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 50,)
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                )
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Components(context).BlurBackgroundCircularButton(icon: Icons.clear,onTap: (){Navigator.pop(context);}),
                      Visibility(
                        visible: widget.data.length > 1,
                        child: SmoothPageIndicator(
                          controller: pageController,
                          count: widget.data.length,
                          effect:  ExpandingDotsEffect(
                            expansionFactor: 2,
                            dotHeight: 10,
                            dotWidth: (MediaQuery.of(context).size.width/(widget.data.length * 3)),
                            radius: 13,
                            activeDotColor : Colors.white.withOpacity(0.85),
                            dotColor : Colors.white30,

                          )
                        ),
                      )
                    ],
                  ),
                )),
            Positioned(
              bottom: 10,
                left: 15,
                child: Row(
                  children: [
                    (Platform.isAndroid)
                        ? SpeedDial(
                      switchLabelPosition: true,
                      //childMargin: const EdgeInsets.only(left: 0),
                      overlayColor: Colors.grey.withOpacity(0.05),
                      elevation: 0.0,
                      backgroundColor: Colors.black45,
                      buttonSize: const Size(40,40),
                      childrenButtonSize: const Size(40,40),
                      animatedIcon: AnimatedIcons.menu_close,
                      animatedIconTheme: IconThemeData(color: Colors.white),
                      spacing: 10,
                      //child: Components(context).myIconWidget(icon: MyIcons.download,size: 30,color: Colors.white),
                      children: [
                        SpeedDialChild(
                          onTap: (){
                            // downloadAndSaveImage(images[selectedIndex],images[selectedIndex].toString().split('/').last);
                            downloadWallpaper();

                          },
                          elevation: 0.0,
                          backgroundColor: Colors.black87,
                          child: Components(context).myIconWidget(icon: MyIcons.download,size: 15),
                          shape: const CircleBorder(),
                          label: 'Download Wallpaper',
                          labelBackgroundColor: Colors.black54,
                          labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)?.copyWith(color: Colors.white)
                        ),
                        SpeedDialChild(
                          elevation: 0.0,
                          onTap: (){
                            downloadQuote();
                          },
                          backgroundColor: Colors.black87,
                          child: Components(context).myIconWidget(icon: MyIcons.quotes,size: 15),
                          shape: const CircleBorder(),
                          label: 'Download Quote',
                          labelBackgroundColor: Colors.black54,
                          labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)
                        ),
                        SpeedDialChild(
                          visible: !Platform.isIOS,
                          onTap: () async {
                            setState(() {
                              shareLoading = true;
                            });
                            screenshotController.captureFromWidget(
                              wallpaperScreen()
                            ).then((value) async{
                              int location = WallpaperManager.HOME_SCREEN;
                              final tempDir = await getTemporaryDirectory();
                              File file = await File('${tempDir.path}/image.png').create();
                              file.writeAsBytesSync(value);
                              final bool result = await WallpaperManager.setWallpaperFromFile(file.path, location);
                              Components(context).showSuccessSnackBar('Wallpaper Set Successfully');
                              setState(() {
                                shareLoading = false;
                              });
                            });


                          },
                          elevation: 0.0,
                          backgroundColor: Colors.black87,
                          child: Components(context).myIconWidget(icon: MyIcons.home,size: 15),
                          shape: const CircleBorder(),
                          label: 'Set as Home Screen',
                          labelBackgroundColor: Colors.black54,
                          labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)
                        ),
                        SpeedDialChild(
                            visible: !Platform.isIOS,
                            onTap: () async {
                              setState(() {
                                shareLoading = true;
                              });
                              screenshotController.captureFromWidget(
                                  wallpaperScreen()
                              ).then((value) async{
                                int location = WallpaperManager.LOCK_SCREEN;
                                final tempDir = await getTemporaryDirectory();
                                File file = await File('${tempDir.path}/image.png').create();
                                file.writeAsBytesSync(value);
                                final bool result = await WallpaperManager.setWallpaperFromFile(file.path, location);
                                Components(context).showSuccessSnackBar('Wallpaper Set Successfully');
                                setState(() {
                                  shareLoading = false;
                                });
                              });
                            },
                          elevation: 0.0,
                          backgroundColor: Colors.black87,
                          child: Components(context).myIconWidget(icon: MyIcons.lock,size: 15),
                          shape: const CircleBorder(),
                          label: 'Set as Lock Screen',
                          labelBackgroundColor: Colors.black54,
                          labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)
                        ),
                        SpeedDialChild(
                            visible: !Platform.isIOS,
                            onTap: () async {
                              setState(() {
                                shareLoading = true;
                              });
                              screenshotController.captureFromWidget(
                                  wallpaperScreen()
                              ).then((value) async{
                                int location = WallpaperManager.BOTH_SCREEN;
                                final tempDir = await getTemporaryDirectory();
                                File file = await File('${tempDir.path}/image.png').create();
                                file.writeAsBytesSync(value);
                                final bool result = await WallpaperManager.setWallpaperFromFile(file.path, location);
                                Components(context).showSuccessSnackBar('Wallpaper Set Successfully');
                                setState(() {
                                  shareLoading = false;
                                });
                              });


                            },
                          elevation: 0.0,
                          backgroundColor: Colors.black87,
                          child: Components(context).myIconWidget(icon: MyIcons.both,size: 15),
                          shape: const CircleBorder(),
                          label: 'Set Both',
                          labelBackgroundColor: Colors.black54,
                          labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)
                        ),
                      ],
                    )
                        : Components(context).BlurBackgroundCircularButton(
                        svg: MyIcons.download,
                        onTap: (){
                          downloadWallpaper();
                          // downloadAndSaveImage(images[selectedIndex],images[selectedIndex].toString().split('/').last);


                        }
                    ),
                    const SizedBox(width: 10,),
                    Components(context).BlurBackgroundCircularButton(
                        svg: MyIcons.share,
                        onTap: (){
                          setState(() {
                            shareLoading = true;
                          });
                          screenshotController.captureFromWidget(
                              quoteScreen()).then((value) async{
                            final tempDir = await getTemporaryDirectory();
                            File file = await File('${tempDir.path}/image.png').create();
                            file.writeAsBytesSync(value);
                            await Share.shareXFiles([XFile(file.path)]);
                            setState(() {
                              shareLoading = false;
                            });
                          });
                        }
                    ),
                  ],
                )
            ),
            Visibility(
              visible: shareLoading,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 75,
                  width: 75,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: const SpinKitSpinningLines(color: Colors.white70,size: 40,)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  void _onTapDown(TapDownDetails tapDownDetails){
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = tapDownDetails.globalPosition.dx;
    print(tapDownDetails.globalPosition);
    if(widget.data.length > 1){
      if(dx<screenWidth / 2){
        print('pressed in left');
        if(selectedIndex < widget.data.length){
          pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
        }
      }
      else{
        print('pressed in right');
        if(selectedIndex < widget.data.length){
          pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
        }
      }
    }
    // if(dx < screenWidth/3){
    //
    // } else if (dx>2*screenWidth/3) {} else {}
  }
}

