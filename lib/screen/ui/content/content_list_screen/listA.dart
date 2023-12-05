import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';

import '../../../../constants/iconconstants.dart';
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

  List typesToShow = [];

  List items = [];

  String selectedChip = 'All';
  String selectedChipToShow = 'All';

  List filteredItems() {
    User user = Provider.of<User>(context,listen: false);
    if (selectedChip == 'All') {
      return items;
    } else {
      return items.where((item) => item['type'] == selectedChip).toList();
    }
  }

  bool loading = true;

  getData()async{
    User user = Provider.of<User>(context,listen: false);
    var data = await Services(user.token).getContent(categoryId:widget.categoryId);
    setState(() {
      items = data;
      loading  = false;
      typesToShow = user.languages[user.selectedLanguage]['component_class']['content_type'] ?? user.languages['en']['component_class']['content_type'];
      selectedChipToShow = typesToShow[0];
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
          appBar: Components(context).myAppBar(title : widget.title),
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
                      children: typesToShow.asMap().entries.map((e) => GestureDetector(
                        onTap: (){
                          HapticFeedback.selectionClick();
                          setState(() {
                            selectedChip = types[e.key];
                            selectedChipToShow = e.value;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color:  (selectedChipToShow == e.value)?Colors.black.withOpacity(0.23):Colors.transparent
                          ),
                          child: Text((e.value == 'Text')?'Article':typesToShow[e.key],style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: (selectedChipToShow == e.value)?theme.textColor:theme.textColor.withOpacity(0.8),
                              fontWeight:(selectedChipToShow == e.value)?FontWeight.w900:FontWeight.w500),textAlign: TextAlign.center,),
                        ),
                      )
                      ).toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shrinkWrap: true,
                      itemCount: filteredItems().length,
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){
                            HapticFeedback.selectionClick();
                            contentViewRoute(type: filteredItems()[index]['type'], id: filteredItems()[index]['_id'], context: context,then: getData);
                          },
                          onLongPress: (){
                            HapticFeedback.mediumImpact();
                            showOptionSheet(theme, index);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 5),
                            padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.01),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    flex: 3,
                                    child:Card(
                                      elevation:10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                              imageUrl: filteredItems()[index]['image'],fit: BoxFit.fitWidth,)),
                                    )
                                ),
                                const SizedBox(width: 12,),
                                Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(filteredItems()[index]['title'],style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: theme.textColor,
                                                fontSize: 13.5,
                                              ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 15,),
                                            Components(context).myIconWidget(icon: (filteredItems()[index]['liked'])?MyIcons.favorite_filled:MyIcons.favorite)
                                          ],
                                        ),
                                        const SizedBox(height: 8,),
                                        Components(context).tags(
                                          textcolor: theme.textColor,
                                          title:typesToShow.elementAt(types.indexWhere((element) => element == filteredItems()[index]['type'])),
                                          context: context,
                                        ),
                                        const SizedBox(height: 15,),
                                        Text('${filteredItems()[index]['desc']}\n',style: Theme.of(context).textTheme.bodySmall?.copyWith(color: theme.textColor.withOpacity(0.7),fontSize: 11.5),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                      ],
                                    ) ),

                              ],
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
  showOptionSheet(ThemeProvider theme, int index){
    User user  = Provider.of<User>(context,listen: false);
    showModalBottomSheet(
      //showDragHandle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        context: context, builder: (context)=>
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 15),
          child: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Options',style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 20,color: Theme.of(context).colorScheme.onPrimaryContainer),),
                      Components(context).BlurBackgroundCircularButton(buttonRadius: 15,icon: Icons.clear)
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: ()async{
                            String message = await Services(user.token).likeContent(items[index]['_id']);
                            Navigator.pop(context);
                            getData();
                            // Components(context).showSuccessSnackBar(message);
                          },
                          leading: Components(context).BlurBackgroundCircularButton(
                              backgroundColor: Colors.white12,
                              svg: MyIcons.favorite_filled,
                              iconColor: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.9)
                          ),
                          title: Text('Remove from Favourites',style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14,color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.9)),),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        )
    );
  }

}




