import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/screen/ui/home/navscreens/profile/favourites.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';

import '../../../../provider/userProvider.dart';

class SearchContent extends StatefulWidget {
  const SearchContent({super.key});

  @override
  State<SearchContent> createState() => _SearchContentState();
}

class _SearchContentState extends State<SearchContent> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;


  List searchResults = [];

  List categories = [];

  List content = [];
  
  bool loading = true;

  getContent({String search = ''})async{
    User user = Provider.of<User>(context,listen: false);
    content = await Services(user.token).getContent(search: search);
    setState(() {
      loading = false;
    });
  }
  
  getCategories()async{
    User user = Provider.of<User>(context,listen: false);
    var data = await Services(user.token).getCategories();

    setState(() {
      categories = data['data'];
    });
  } 
  
  @override
  void initState() {
    getContent();
    //getCategories();
    // TODO: implement initState
    super.initState();
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,theme,child){
        return Scaffold(
          backgroundColor: theme.themeColorA,
          appBar: AppBar(
            scrolledUnderElevation: 0.0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            title: Text('Search',style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 22
            ),),
          ),

          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: theme.themeColorA,
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.themeColorA,
                      theme.themeColorB,
                    ]
                )
            ),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: (str){
                    getContent(search: str);
                  },
                  textInputAction: TextInputAction.search,
                  decoration:  InputDecoration(
                /*    suffixIcon: Offstage(
                      offstage: searchController.text.isEmpty,
                      child: GestureDetector(
                        onTap: () => searchController.clear(),
                        child:  Icon(Icons.clear,color: theme.textColor,),
                      ),
                    ),*/
                    prefixIcon: Icon(Icons.search_rounded,color: theme.textColor.withOpacity(0.7),),
                      hintText: "I'm looking for..."
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                    child: (loading)
                        ? Center(
                      child: Components(context).Loader(textColor: theme.textColor),
                    )
                        : (content.isEmpty)
                        ? const NoFavourite()
                        : ListView.builder(
                        itemCount: content.length,
                        padding: const EdgeInsets.only(bottom: 65),
                        itemBuilder:  (context,index){
                          return GestureDetector(
                            onTap: (){
                              HapticFeedback.selectionClick();
                              contentViewRoute(type: content[index]['type'], id: content[index]['_id'], context: context);
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
                                              imageUrl: content[index]['image'],fit: BoxFit.fitWidth,)),
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
                                                child: Text(content[index]['title'],style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: theme.textColor,
                                                  fontSize: 13.5,
                                                ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              // const SizedBox(width: 15,),
                                              // Components(context).myIconWidget(icon: (content[index]['liked'])?MyIcons.favorite_filled:MyIcons.favorite)
                                            ],
                                          ),
                                          const SizedBox(height: 8,),
                                          Components(context).tags(
                                            textcolor: theme.textColor,
                                            title:(content[index]['type'] == 'Text')?'Article': content[index]['type'],
                                            context: context,
                                          ),
                                          const SizedBox(height: 15,),
                                          Text('${content[index]['desc']}\n',style: Theme.of(context).textTheme.bodySmall?.copyWith(color: theme.textColor.withOpacity(0.7),fontSize: 11.5),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                        ],
                                      ) ),

                                ],
                              ),
                            ),
                          );
                        })
                )
              ],
            ),
          ),
        );
      }
        );
  }
  
  Widget categoryBoxes(ThemeProvider theme){
    return RefreshIndicator(
      onRefresh: () async {
        await getCategories();
      },
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
          gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5/2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
          itemCount: categories.length,
          itemBuilder: (context,index){
            return GestureDetector(
              onTap: (){
                HapticFeedback.selectionClick();
              },
              child: Stack(
                children: [
                  Positioned.fill(child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(imageUrl:categories[index]['content'][0]['image'],fit: BoxFit.cover,))),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black12,
                              Colors.black45
                            ]
                        )
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(categories[index]['title'],style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 16
                        ),),
                        const SizedBox(height: 5,),
                        Text('${categories[index]['content'].length} ${categories[index]['content'].length > 1 ? 'Posts' : 'Post'}',style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 13
                        ),),

                      ],
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
  
}
