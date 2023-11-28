import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/provider/userProvider.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';

import '../../../../../../constants/iconconstants.dart';
import '../../../dailyyoga/yogaDetails.dart';
import '../favourites.dart';

class FavouriteYoga extends StatefulWidget {
  const FavouriteYoga({super.key});

  @override
  State<FavouriteYoga> createState() => _FavouriteYogaState();
}

class _FavouriteYogaState extends State<FavouriteYoga> {

  bool loading = true;
  List data = [];

  getData()async{
    User user = Provider.of<User>(context,listen: false);
    var jsn = await Services(user.token).getFavouriteYoga();
    setState(() {
      data = jsn['data'];
      loading = false;
    });
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
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
                            String message = await Services(user.token).likeYoga(data[index]['_id']);
                            Navigator.pop(context);
                            getData();
                            // Components(context).showSuccessSnackBar(message);
                          },
                          leading: Components(context).BlurBackgroundCircularButton(
                              backgroundColor: Colors.white12,
                              svg: MyIcons.favorite_filled ,
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder:(_,theme,__)  => Scaffold(
        backgroundColor: theme.themeColorA,
          body: (loading)
              ?Center(
            child: Components(context).Loader(textColor: theme.textColor),
          )
              :(data.isEmpty)
              ?const Center(child: NoFavourite())
              :RefreshIndicator(
            onRefresh: ()async{
              await getData();
            },
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context,index){
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).push( bottomToTopRoute(YogaDetails(yogaId: data[index]['_id']))).then((value) => getData());
                      // showDetails(index);
                    },
                    onLongPress: () {
                      HapticFeedback.heavyImpact();
                      showOptionSheet(theme,index);
                    },
                    child: Card(
                      color: Colors.white30,
                      elevation: 1.5,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data[index]['title'],style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.textColor,
                                    fontSize: 15,
                                  )),
                                  const SizedBox(height: 7,),
                                  Text(data[index]['desc'],style:Theme.of(context).textTheme.bodySmall?.copyWith(color: theme.textColor.withOpacity(0.7),fontSize: 12.5),maxLines:2,overflow: TextOverflow.ellipsis,),
                                  const SizedBox(height: 7,),
                                ],
                              ),
                            ),
                            const SizedBox(width: 15,),
                            Expanded(
                                flex: 3,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child:CachedNetworkImage(imageUrl: data[index]['image'],
                                      fit: BoxFit.cover,),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  );
                }
            ),
          ),
      ),
    );
  }
}
