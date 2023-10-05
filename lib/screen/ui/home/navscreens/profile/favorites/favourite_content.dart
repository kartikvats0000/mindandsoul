import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../../../provider/userProvider.dart';

class FavouriteContent extends StatefulWidget {
  const FavouriteContent({super.key});

  @override
  State<FavouriteContent> createState() => _FavouriteContentState();
}

class _FavouriteContentState extends State<FavouriteContent> {

  List data = [];
  bool loader = false;


  List types = [
    'All',
    'Text',
    'Video',
    'Audio',
    'Info'
  ];


  String selectedChip = 'All';


  List filteredItems() {
    if (selectedChip == 'All') {
      return data;
    } else {
      return data.where((item) => item['type'] == selectedChip).toList();
    }
  }

  getData()async{
    User user = Provider.of<User>(context,listen: false);
    print('getting your favorites');
    var lst = await Services(user.token).getFavouriteContent();
    setState(() {
      data = lst;
      loader = true;
    });
  }

  @override
  void initState() {
    print('getting your favorites');
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,theme,child){
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: theme.themeColorA,
            ),
            child: Center(
              child: (loader)? Column(
                children: [
                  SingleChildScrollView(
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
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: ()async{
                        getData();
                      },
                      child: ListView.builder(
                        itemCount: filteredItems().length,
                          itemBuilder: (context,index){
                          return GestureDetector(
                            onTap: (){
                              HapticFeedback.selectionClick();
                              contentViewRoute(type: filteredItems()[index]['type'], id: filteredItems()[index]['_id'], context: context);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 15,horizontal: 5),
                              padding: const EdgeInsets.symmetric(vertical: 13,horizontal: 13),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.35),
                                borderRadius: BorderRadius.circular(12)
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 6,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(filteredItems()[index]['title'],style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: theme.textColor,
                                              fontSize: 13.5,
                                          ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8,),
                                          Components(context).tags(
                                            textcolor: theme.textColor,
                                            title:(filteredItems()[index]['type'] == 'Text')?'Article': filteredItems()[index]['type'],
                                            context: context,
                                          ),
                                          const SizedBox(height: 15,),
                                          Text('${filteredItems()[index]['desc']}\n',style: Theme.of(context).textTheme.bodySmall?.copyWith(color: theme.textColor.withOpacity(0.7),fontSize: 13.5),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                        ],
                                      ) ),
                                  const SizedBox(width: 8,),
                                  Expanded(
                                    flex: 3,
                                      child:ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                          child: CachedNetworkImage(imageUrl: filteredItems()[index]['image']))),
                                ],
                              ),
                            ),
                          );
                          }),
                    ),
                  ),
                ],
              ) :Components(context).Loader(textColor: theme.textColor)
            )
          ),
        );
      }
    );
  }
}



