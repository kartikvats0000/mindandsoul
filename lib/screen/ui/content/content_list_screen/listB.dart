import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindandsoul/constants/iconconstants.dart';

import 'package:mindandsoul/helper/components.dart';

import 'package:mindandsoul/provider/themeProvider.dart';

import 'package:provider/provider.dart';

import '../../../../services/services.dart';


class ListviewB extends StatefulWidget {
  final String title;
  final String categoryId;
  ListviewB({required this.title,required this.categoryId});

  @override
  State<ListviewB> createState() => _ListviewBState();
}

class _ListviewBState extends State<ListviewB> {

  List taglist = [
    'Mindfulness',
    'Spiritual',
    'Sleep',
    'Food',
    'Meditation',
    'Study',
  ];

  List types = [
    'All',
    'Text',
    'Video',
    'Audio',
    'Info'
  ];

  List items = [];

  String selectedChip = 'All';

  List filteredItems() {
    if (selectedChip == 'All') {
      return items;
    } else {
      return items.where((item) => item['type'] == selectedChip).toList();
    }
  }

  getData()async{
    var data = await Services().getContent(widget.categoryId);
    setState(() {
      items = data;
    });
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

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

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom:3.0,top: 0.0,left: 10),
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical:8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: types.map((e) => GestureDetector(
                        onTap: (){
                          setState(() {
                            selectedChip = e;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color:  (selectedChip == e)?theme.textColor.withOpacity(0.25):Colors.transparent
                          ),
                          child: Text((e == 'Text')?'Article':e,style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 14,
                              color: (selectedChip == e)?theme.textColor:theme.textColor.withOpacity(0.8),
                              fontWeight:(selectedChip == e)?FontWeight.w900:FontWeight.w500),textAlign: TextAlign.center,),
                        ),
                      )
                      ).toList(),
                    ),
                  ),
                ),(items.isEmpty)
                    ?Components(context).Loader(textColor: theme.textColor)
                    :Expanded(
                  child: ListView.builder(
                      itemCount: filteredItems().length,
                    //  separatorBuilder: (context,index) =>  Divider(indent: 20,endIndent: 20,thickness: 0.65,color: theme.textColor.withOpacity(0.2),),
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){
                            contentViewRoute(type: filteredItems()[index]['type'], id: filteredItems()[index]['_id'], context: context,);
                          },
                          child: AspectRatio(
                            aspectRatio: 6/4,
                            child: Hero(
                              tag: filteredItems()[index]['_id'],
                              child: Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white70,
                                  image: DecorationImage(image: CachedNetworkImageProvider(filteredItems()[index]['image'],),fit: BoxFit.cover)
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black54
                                            ]
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(filteredItems()[index]['title'],style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white.withOpacity(0.92),fontWeight: FontWeight.w800,fontSize: 17),),
                                          SizedBox(height: 10,),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Wrap(
                                                    children:
                                                    taglist.map((e) => Text(
                                                        '$e • ' ,
                                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 11,
                                                          //letterSpacing: 1.3,
                                                          color: Colors.grey.shade50.withOpacity(0.8)
                                                      ),)).toList()

                                                ),
                                              ),
                                              const SizedBox(width: 10,),
                                              Text('August 18, 2023',
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11,
                                                  //letterSpacing: 1.3,
                                                  color: Colors.white.withOpacity(0.8)
                                              ),)

                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                        top: 7,
                                        left: 7,
                                        child: Components(context).tags(
                                          title:(filteredItems()[index]['type'] == 'Text')?'Article': filteredItems()[index]['type'],
                                          context: context,

                                        )
                                    ),
                                    Positioned(
                                        top: 7,
                                        right: 7,
                                        child: Components(context).BlurBackgroundCircularButton(svg: MyIcons.favorite)
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}


