import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindandsoul/screen/ui/home/dailyyoga/yogaDetails.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';

import '../../../../helper/components.dart';
import '../../../../provider/themeProvider.dart';
import '../../../../provider/userProvider.dart';

class DailyYoga extends StatefulWidget {
  const DailyYoga({super.key});

  @override
  State<DailyYoga> createState() => _DailyYogaState();
}

class _DailyYogaState extends State<DailyYoga> {


  @override
  void initState(){
    getData();
    // TODO: implement initState
    super.initState();

  }

  bool loading  = false;

  List data = [];

  getData()async{
    User user = Provider.of<User>(context,listen: false);
    var _data = await Services(user.token).getYogaList();
    setState(() {
      data = _data['data'];
      loading = false;
    });
  }

  List<String> items = [
    'Beginner',
    'Moderate',
    'Expert',
  ];

  List likesList = [
    'https://images.unsplash.com/photo-1423479185712-25d4a4fe1006?auto=format&fit=crop&q=80&w=2076&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1423479185712-25d4a4fe1006?auto=format&fit=crop&q=80&w=2076&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1423479185712-25d4a4fe1006?auto=format&fit=crop&q=80&w=2076&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1423479185712-25d4a4fe1006?auto=format&fit=crop&q=80&w=2076&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1423479185712-25d4a4fe1006?auto=format&fit=crop&q=80&w=2076&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1423479185712-25d4a4fe1006?auto=format&fit=crop&q=80&w=2076&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ];

  String dropdownval = 'Beginner';


  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,theme,_)
      => Scaffold(
        backgroundColor: theme.themeColorA,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(preferredSize: const Size.fromHeight(kToolbarHeight), child: Components(context).myAppBar(title: '')),
        body:(loading)
            ?Center(
          child: Components(context).Loader(textColor: theme.textColor),
        )
            : Container(
          height: MediaQuery.of(context).size.height,
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
          child:  SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top + kToolbarHeight + 10,
                ),
                Text('Daily Yoga', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
                const SizedBox(height: 20,),
                Text('Elevate your day with daily yoga. Discover a variety of routines designed to strengthen your body and calm your mind...', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: theme.textColor.withOpacity(0.75),
                    fontSize: 14.5
                ),),
                const SizedBox(height: 20,),
               ListView.builder(
                 physics: const NeverScrollableScrollPhysics(),
                 padding: EdgeInsets.zero,
                 shrinkWrap: true,
                 itemCount: data.length,
                   itemBuilder: (context,index){
                     return GestureDetector(
                       onTap: () {
                         HapticFeedback.lightImpact();
                        Navigator.of(context).push( bottomToTopRoute(YogaDetails(yogaId: data[index]['_id'])));
                        // showDetails(index);
                       },
                       child: Card(
                         margin: const EdgeInsets.only(bottom: 15),
                         color: Colors.white30,
                         elevation: 1.5,
                         child: Padding(
                           padding: EdgeInsets.all(10),
                           child: Column(
                             children: [
                               Row(
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
                                         Row(

                                         )
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
                               const SizedBox(height: 10,),
                               Row(
                                 children: [
                                   customTag(data[index]['avgTime'].toString(),  Icon(Icons.watch_later,color: Theme.of(context).colorScheme.onSurface,size: 18,), theme),
                                   const SizedBox(width: 20,),
                                   customTag(data[index]['steps'].length.toString(),  Icon(Icons.featured_play_list_rounded,color: Theme.of(context).colorScheme.onSurface,size: 18,), theme),
                                 ],
                               )
                             ],
                           ),
                         ),
                       ),
                     );
                   }
               ),
               // Add some space before the Disclaimer link.
                Center(
                  child: TextButton(
                    onPressed: () {
               //       _showDisclaimerDialog(context); // Show the disclaimer dialog.
                    },
                    child: Text('Disclaimer', style: Theme.of(context).textTheme.bodyMedium), // Style this link accordingly.
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }

  Widget customTag(String text,Widget icon, ThemeProvider theme){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
     decoration: BoxDecoration(
       color: Theme.of(context).colorScheme.surface.withOpacity(0.25),
       border: Border.all(
           width: 0.4,
           color: theme.themeColorA
       ),
       borderRadius: BorderRadius.circular(7),

     ),
      child: Row(
        children: [
          icon,
          const SizedBox(width:6,),
          Text(text, style: Theme
            .of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w900,
          fontSize: 12,
    ),
            textAlign: TextAlign.center,
    ),
        ],
      ));
  }

  buildLikesViewer(List likesList){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        likesList.isNotEmpty
            ? Row(
          children: [
            for (int i = 0; i < likesList.length; i++)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 0),
                child: Align(
                    widthFactor: 0.5,
                    child: CircleAvatar(
                      radius: 11.5,
                      backgroundColor: Colors.grey.shade100,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white,
                        backgroundImage: CachedNetworkImageProvider(
                          likesList[i]['profile_picture'],
                        ),
                      ),
                    )),
              ),
            const SizedBox(width: 5,),
            Text(15.toString(),style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),),
          ],
        )
            : Container(),
      ],
    );
  }
}






