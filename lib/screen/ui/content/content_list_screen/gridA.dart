import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../../constants/iconconstants.dart';
import '../../../../helper/components.dart';
import '../../../../provider/themeProvider.dart';
import '../../../../provider/userProvider.dart';
import '../../../../services/services.dart';

class GridviewA extends StatefulWidget {
  final String categoryId;
  final String title;
  const GridviewA({super.key,required this.title,required this.categoryId});

  @override
  State<GridviewA> createState() => _GridviewAState();
}

class _GridviewAState extends State<GridviewA> {

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
  Widget build(BuildContext context) {
    print('gridArebuilt');
    return Consumer<ThemeProvider>(
        builder: (context,theme,child) => Scaffold(
            backgroundColor: theme.themeColorA,
            appBar: Components(context).myAppBar( title: widget.title),
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
                         // theme.themeColorA,
                        ]
                    )
                ),

                child: (loading)
                    ?Components(context).Loader(textColor: theme.textColor)
                    :(items.isEmpty)?const Center(child: Text('No data'),):Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      child: GridView.custom(
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 15,top: 10),
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
                                  onTap: ()async{
                                    HapticFeedback.selectionClick();
                                    await contentViewRoute(type: filteredItems()[index]['type'], id:  filteredItems()[index]['_id'], context: context,then: getData);


                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: const [
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
                                            tag: filteredItems()[index]['_id'],
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(15),
                                                child: CachedNetworkImage(fit: BoxFit.cover, imageUrl: filteredItems()[index]['image'],placeholder: (context,url) =>Center(child: SpinKitSpinningCircle(
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

                                                  child: Text(filteredItems()[index]['title'],style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                                            child: Components(context).BlurBackgroundCircularButton(svg: (filteredItems()[index]['liked'])?MyIcons.favorite_filled : MyIcons.favorite)
                                        ),
                                        Positioned(
                                            top: 7,
                                            left: 7,
                                            child: Components(context).tags(

                                              title:typesToShow.elementAt(types.indexWhere((element) => element == filteredItems()[index]['type'])),
                                              context: context,
                                            ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            childCount: filteredItems().length
                        ),
                      ),
                    ),
                  ],
                )
            )
        )
    );
  }
}

