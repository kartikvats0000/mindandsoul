  import 'package:flutter/material.dart';


  import 'package:cached_network_image/cached_network_image.dart';
  import 'package:flutter_spinkit/flutter_spinkit.dart';
  import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
  import 'package:mindandsoul/constants/iconconstants.dart';
  import 'package:provider/provider.dart';

  import '../../../../helper/components.dart';
  import '../../../../provider/themeProvider.dart';
  import '../../../../provider/userProvider.dart';
  import '../../../../services/services.dart';

  class GridviewB extends StatefulWidget {
    final String categoryId;
    final String title;
    const GridviewB({super.key,required this.title,required this.categoryId});

    @override
    State<GridviewB> createState() => _GridviewBState();
  }

  class _GridviewBState extends State<GridviewB> {

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
      debugPrint('hello getData');
      User user = Provider.of<User>(context,listen: false);
      var data = await Services(user.token).getContent(widget.categoryId);
      setState(() {
        items = data;
        loading = false;
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
      print('gridB_rebuilt');
      return Consumer<ThemeProvider>(
          builder: (context,theme,child) => Scaffold(
              backgroundColor: theme.themeColorA,
              appBar: Components(context).myAppBar(widget.title),
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
                      :(items.isEmpty)?const Center(child: Text('No data'),):
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Flexible(
                        child: MasonryGridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          itemCount: filteredItems().length,
                          itemBuilder: (context,index) =>
                              GestureDetector(
                                onTap: ()async{
                                 await contentViewRoute(type: filteredItems()[index]['type'], id:  filteredItems()[index]['_id'], context: context,then: getData);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
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
                                              tag: filteredItems()[index]['_id'],
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: CachedNetworkImage(
                                                  placeholder: (context,string)=> Container(
                                                      padding: const EdgeInsets.all(30),
                                                      alignment: Alignment.center,
                                                      child:SpinKitSpinningLines(color: Theme.of(context).colorScheme.primary)),
                                                  imageUrl: filteredItems()[index]['image'],fit: BoxFit.cover,),
                                              ),
                                            ),
                                            Positioned(
                                                top: 7,
                                                right: 7,
                                                child: Components(context).BlurBackgroundCircularButton(svg: (filteredItems()[index]['liked'])?MyIcons.favorite_filled : MyIcons.favorite)
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15,),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(filteredItems()[index]['title'],style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: theme.textColor,fontWeight: FontWeight.w800,fontSize: 14),),
                                        ),
                                        const SizedBox(height: 10,),
                                        Padding(
                                            padding: const EdgeInsets.only(bottom: 15.0,left: 8),
                                            child: Components(context).tags(
                                              title:(filteredItems()[index]['type'] == 'Text')?'Article': filteredItems()[index]['type'],
                                              context: context,

                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                        ),
                      ),
                    ],
                  ),
              )
          )
      );
    }
  }