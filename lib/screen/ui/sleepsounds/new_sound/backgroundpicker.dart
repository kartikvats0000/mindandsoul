
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/screen/ui/sleepsounds/newsounds.dart';
import 'package:provider/provider.dart';

import '../../../../provider/themeProvider.dart';
import '../../../../services/services.dart';
import '../../home/themes/Themepreview.dart';

class BackGroundPicker extends StatefulWidget {
  const BackGroundPicker({Key? key}) : super(key: key);

  @override
  State<BackGroundPicker> createState() => _BackGroundPickerState();
}

class _BackGroundPickerState extends State<BackGroundPicker> {

  bool loading = false;
  updateThemes()async {
    setState(() {
      loading = true;
    });
    var data =  await Services().getThemes();
    ThemeProvider theme = Provider.of<ThemeProvider>(context,listen: false);
    await theme.clearThemes();
    await theme.addThemes(data);
  }

  List themesList = [
    {
      'name' : 'Forest',
      'image' : 'https://cdn.pixabay.com/photo/2015/06/19/21/24/avenue-815297_1280.jpg',
      'themeColorA' : '4D5784',
      'themeColorB' : '75706D',
      'textColor' : 'FDFEFE'
    },
    {
      'name' : 'Rain',
      'image' : 'https://cdn.pixabay.com/photo/2014/09/21/14/39/surface-455124_640.jpg',
      'themeColorA' : 'E1F2F1',
      'themeColorB' : '9EC0C7',
      'textColor' : '1A2C32'
    },

    {
      'name' : 'Beach',
      'image' : 'https://cdn.pixabay.com/photo/2012/02/23/08/38/rocks-15712_640.jpg',
      'themeColorA' : '937551',
      'themeColorB' : '9F9282',
      'textColor' : '2D2827'
    },
    // {
    //   'name' : 'City',
    //   'image' : 'https://cdn.pixabay.com/photo/2017/01/28/02/24/japan-2014619_640.jpg'
    // },
    //
    // {
    //   'name' : 'Night',
    //   'image' : 'https://cdn.pixabay.com/photo/2018/08/14/13/23/ocean-3605547_1280.jpg'
    // },
    // {
    //   'name' : 'Desert',
    //   'image' : 'https://cdn.pixabay.com/photo/2015/05/30/19/55/desert-790640_640.jpg'
    // },
    // {
    //   'name' : 'Zen',
    //   'image' : 'https://cdn.pixabay.com/photo/2017/01/13/08/08/tori-1976609_640.jpg'
    // }
  ];



  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,themeData,child) =>
          Scaffold(
            backgroundColor: themeData.themeColorA,
            //extendBody: true,
            //extendBodyBehindAppBar: true,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight + 20),
              child: AppBar(
                toolbarHeight: kToolbarHeight + 20,
                elevation: 0.0,
                scrolledUnderElevation: 0.0,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                title: Text('Pick Essence',style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 30),),
                leading: Padding(
                    padding: EdgeInsets.all(7),
                    child: Components(context).BlurBackgroundCircularButton(
                      icon: Icons.chevron_left,
                      onTap: (){Navigator.pop(context);},
                    )
                ),

              ),
            ),
            body: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 7),
                decoration: BoxDecoration(
                    color: themeData.themeColorA,
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          themeData.themeColorA.withOpacity(0.2),
                          themeData.themeColorB,
                          themeData.themeColorA,
                        ]
                    )
                ),
                child: (loading)
                    ?Components(context).Loader(textColor: themeData.textColor)
                    :Stack(
                      children: [
                        GridView.builder(
                  physics: const BouncingScrollPhysics(
                        // parent: AlwaysScrollableScrollPhysics()
                  ),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1/1.25,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        // mainAxisExtent: 220
                  ),
                  itemCount: themesList.length,
                  itemBuilder: (context,index) =>
                          GestureDetector(
                            onTap: (){
                              HapticFeedback.selectionClick();
                              setState(() {
                                themeImage = themesList[index];
                              });
                              pageController.nextPage(duration: Duration(milliseconds: 100), curve: Curves.linear);
                            //  Navigator.push(context, MaterialPageRoute(builder: (context)=>ThemePreview(themeDetails: themeData.themesList[index])));
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
                                            child: const CircularProgressIndicator(
                                              strokeWidth: 1,
                                            )),
                                        imageUrl: themesList[index]['image'],fit: BoxFit.cover,),
                                    ),

                                  ),
                                  Positioned(
                                    bottom: 0,
                                      right: 0,
                                      left: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration:  const BoxDecoration(
                                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
                                        color: Colors.black54

                                        ),
                                        child: Text(themesList[index]['name'],style: TextStyle(color: themeData.textColor.withOpacity(0.9),fontWeight: FontWeight.w700,),textAlign: TextAlign.center,),
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                ),
                      ],
                    )
            ),
          ),
    );
  }
}
