import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mindandsoul/constants/iconconstants.dart';
import 'package:mindandsoul/screen/ui/content/content_screens/audioContentPage.dart';
import 'package:mindandsoul/screen/ui/content/content_screens/textContentPage.dart';
import 'package:provider/provider.dart';

import '../../../../helper/components.dart';
import '../../../../provider/themeProvider.dart';

class GridviewB extends StatefulWidget {
  final List data;
  final String title;
  const GridviewB({super.key,required this.title,required this.data});

  @override
  State<GridviewB> createState() => _GridviewBState();
}

class _GridviewBState extends State<GridviewB> {



  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context,theme,child) => Scaffold(
            backgroundColor: theme.themeColorA,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight + 20),

              child: AppBar(
                toolbarHeight: kToolbarHeight + 20,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                scrolledUnderElevation: 0.0,
                automaticallyImplyLeading: false,
                leading: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Components(context).BlurBackgroundCircularButton(icon: Icons.chevron_left,onTap: ()=>Navigator.pop(context)),
                ),
                title: Text(widget.title,style: Theme.of(context).textTheme.displayLarge?.copyWith(color: theme.textColor,fontSize: 30),),
              ),
            ),
            body: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.themeColorA,
                          theme.themeColorB,
                          theme.themeColorA,
                        ]
                    )
                ),

                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  itemCount: widget.data.length,
                  itemBuilder: (context,index) =>
                      StaggeredGridTile.fit(
                        crossAxisCellCount: index * 2 + 1,
                        child: GestureDetector(
                          onTap: (){
                            contentViewRoute(type: widget.data[index]['type'], data:  widget.data[index], context: context, title:  widget.title);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black26
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Hero(
                                          tag: widget.data[index]['_id'],
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: CachedNetworkImage(
                                              placeholder: (context,string)=> Container(
                                                  padding: const EdgeInsets.all(30),
                                                  alignment: Alignment.center,
                                                  child: const CircularProgressIndicator(
                                                    strokeWidth: 1,
                                                  )),
                                              imageUrl: widget.data[index]['image'],fit: BoxFit.cover,),
                                          ),
                                        ),
                                        Positioned(
                                            top: 7,
                                            right: 7,
                                            child: Components(context).BlurBackgroundCircularButton(svg: MyIcons.favorite)
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(widget.data[index]['title'],style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: theme.textColor,fontWeight: FontWeight.w800,fontSize: 14),),
                                    ),
                                    const SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 15.0,left: 8),
                                      child: Components(context).tags(
                                        title:(widget.data[index]['type'] == 'Text')?'Article': widget.data[index]['type'],
                                        context: context,

                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                ),
            )
        )
    );
  }
}