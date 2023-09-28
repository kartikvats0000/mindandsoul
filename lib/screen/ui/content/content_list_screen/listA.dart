import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';


class ListviewA extends StatefulWidget {
  final String title;
  final String categoryId;
  const ListviewA({super.key, required this.title, required this.categoryId});

  @override
  State<ListviewA> createState() => _ListviewAState();
}

class _ListviewAState extends State<ListviewA> {

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
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:5.0,top: 0.0,left: 10),
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
                              color:  (selectedChip == e)?Colors.black.withOpacity(0.23):Colors.transparent
                          ),
                          child: Text((e == 'Text')?'Article':e,style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: filteredItems().length,
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
                                  contentViewRoute(type: filteredItems()[index]['type'], context: context, id: filteredItems()[index]['_id']);
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
                                                  tag: filteredItems()[index]['_id'],
                                                    child: CachedNetworkImage(imageUrl: filteredItems()[index]['image'],fit: BoxFit.cover,))),
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
                                                Text(filteredItems()[index]['title'],style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16,fontWeight: FontWeight.bold),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                                SizedBox(height: 10,),
                                                Components(context).tags(
                                                  title:(filteredItems()[index]['type'] == 'Text')?'Article': filteredItems()[index]['type'],
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
              ],
            ),
          ),
        )
    );
  }
}


