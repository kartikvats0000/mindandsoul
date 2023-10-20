import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';

import '../../../../provider/userProvider.dart';


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

  bool loading = true;

  getData()async{
    User user = Provider.of<User>(context,listen: false);
    var data = await Services(user.token).getContent(widget.categoryId);
    setState(() {
      items = data;
      loading  = false;
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
          appBar: Components(context).myAppBar(widget.title),
          body: Container(

            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.themeColorA,
                      theme.themeColorB,
                    ]
                )
            ),

            child: (loading)
                ?Components(context).Loader(textColor: theme.textColor)
                :(items.isEmpty)?const Center(child: Text('No data'),):Column(
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
                ),Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: filteredItems().length,
                      separatorBuilder: (context,index) =>  Divider(indent: 20,endIndent: 20,thickness: 0.65,color: theme.textColor.withOpacity(0.2),),
                      itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 3.5),
                          child: GestureDetector(
                            onTap: (){
                               contentViewRoute(type: filteredItems()[index]['type'], id:  filteredItems()[index]['_id'], context: context,then: getData);
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


