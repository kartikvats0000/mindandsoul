import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:provider/provider.dart';


class ListviewA extends StatefulWidget {
  final String title;
  final List data;
  const ListviewA({super.key, required this.title,required this.data});

  @override
  State<ListviewA> createState() => _ListviewAState();
}

class _ListviewAState extends State<ListviewA> {


  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context,theme,child) => Scaffold(
          backgroundColor: theme.themeColorA,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight + 20),
            child: AppBar(
              toolbarHeight: kToolbarHeight + 20,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              scrolledUnderElevation: 0.0,
              automaticallyImplyLeading: false,
              leading: Padding(
                padding: EdgeInsets.all(7),
                child: Components(context).BlurBackgroundCircularButton(icon: Icons.chevron_left,onTap: ()=>Navigator.pop(context)),
              ),
              title: Text(widget.title,style: Theme.of(context).textTheme.displayLarge?.copyWith(color: theme.textColor,fontSize: 30),),
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.themeColorA.withOpacity(0.2),
                      theme.themeColorB,
                    ]
                )
            ),

            child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.data.length,
                separatorBuilder: (context,index) =>  Divider(indent: 20,endIndent: 20,thickness: 0.65,color: theme.textColor.withOpacity(0.2),),
                itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 3.5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                        child: GestureDetector(
                          onTap: (){
                            contentViewRoute(type: widget.data[index]['type'], data:  widget.data[index], context: context, title:  widget.title);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              // color: Colors.black12,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            padding: const EdgeInsets.only(bottom: 5),
                            // height: MediaQuery.of(context).size.height * 0.15,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Hero(
                                            tag: widget.data[index]['_id'],
                                              child: CachedNetworkImage(imageUrl: widget.data[index]['image'],fit: BoxFit.cover,))),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 7,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(widget.data[index]['title'],style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16,fontWeight: FontWeight.bold),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                          SizedBox(height: 10,),
                                          Components(context).tags(
                                            title:(widget.data[index]['type'] == 'Text')?'Article': widget.data[index]['type'],
                                            context: context,
                                            textcolor: theme.textColor.withOpacity(0.7)
                                          )
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    child: Icon(CupertinoIcons.ellipsis,color: theme.textColor.withOpacity(0.6),)
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
            ),
          ),
        )
    );
  }
}


