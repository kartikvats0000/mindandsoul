import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../../constants/iconconstants.dart';
import '../../../../helper/components.dart';
import '../../../../provider/themeProvider.dart';

class GridviewA extends StatefulWidget {
  final List data;
  final String title;
  const GridviewA({super.key,required this.title,required this.data});

  @override
  State<GridviewA> createState() => _GridviewAState();
}

class _GridviewAState extends State<GridviewA> {

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

                child: GridView.custom(
                  gridDelegate: SliverWovenGridDelegate.count(
                    pattern: const [
                      WovenGridTile(0.85),
                      //WovenGridTile(0.4),
                      WovenGridTile(
                        5 / 8,
                        crossAxisRatio: 0.95,
                        alignment: AlignmentDirectional.centerEnd,
                      ),
                    ],
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(
                          (context, index) =>
                          GestureDetector(
                            onTap: (){
                              contentViewRoute(type: widget.data[index]['type'], data:  widget.data[index], context: context, title:  widget.title);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow:  const [
                                    BoxShadow(
                                        blurRadius: 8,
                                        color: Colors.black38,
                                        offset: Offset(0, 3)
                                    )
                                  ]
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Hero(
                                      tag: widget.data[index]['_id'],
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: CachedNetworkImage(fit: BoxFit.cover, imageUrl: widget.data[index]['image'],placeholder: (context,url) =>Center(child: SpinKitSpinningCircle(
                                            color: Theme.of(context).colorScheme.primary,
                                          ),),)),
                                    ),
                                  ),
                                  Positioned.fill(
                                      child:Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            gradient: const LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.black38,
                                                  Colors.transparent,
                                                  Colors.black12,
                                                  //Colors.transparent,
                                                  Colors.black87
                                                ]
                                            )
                                        ),
                                      )
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15),top: Radius.circular(0)),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaY: 10,sigmaX: 10),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                              color: Colors.white12,
                                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15),top: Radius.circular(0)),
                                            ),
                                            padding: const EdgeInsets.only(bottom: 15.0,right: 5,left: 7,top: 15),

                                            child: Text(widget.data[index]['title'],style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white.withOpacity(0.92),
                                                fontSize: 13.5
                                            ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      top: 7,
                                      right: 7,
                                      child: Components(context).BlurBackgroundCircularButton(svg: MyIcons.favorite)
                                  ),
                                  Positioned(
                                      top: 7,
                                      left: 7,
                                      child: Components(context).tags(
                                        title:(widget.data[index]['type'] == 'Text')?'Article': widget.data[index]['type'],
                                        context: context,

                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                      childCount: widget.data.length
                  ),
                )
            )
        )
    );
  }
}

