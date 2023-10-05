import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/screen/ui/home/quotes/dailyquotes.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../../../provider/userProvider.dart';

class FavouriteQuote extends StatefulWidget {
  const FavouriteQuote({super.key});

  @override
  State<FavouriteQuote> createState() => _FavouriteQuoteState();
}

class _FavouriteQuoteState extends State<FavouriteQuote> {

  List data = [];
  bool loader = false;


  getData()async{
    User user = Provider.of<User>(context,listen: false);
    print('getting your favorites');
    var lst = await Services(user.token).getFavouriteQuotes();
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
                    child: (loader)
                        ? RefreshIndicator(
                      onRefresh: ()async{
                        getData();
                      },
                      child: GridView.builder(
                        padding: const EdgeInsets.only(bottom: 15,top: 10),
                          gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 9/16
                          ),
                          itemCount: data.length,
                          itemBuilder: (context,index){
                            return GestureDetector(
                              onTap: (){
                                HapticFeedback.selectionClick();
                                Navigator.of(context).push(CupertinoPageRoute(builder: (context) => DailyQuotes(data: [data[index]]),fullscreenDialog: true));
                              },
                              child: Stack(
                                children: [
                                  AspectRatio(aspectRatio: 9/16,child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(imageUrl: data[index]['image'],fit: BoxFit.cover,)),),
                                  Positioned.fill(child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(15)
                                    ),
                                  )),
                                  Positioned(
                                    bottom: 10,
                                      right: 5,
                                      left: 5,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(data[index]['quote'],
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.dancingScript(
                                            textStyle: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white
                                            )
                                          ),),
                                          const SizedBox(height: 11.5,),
                                          Text(data[index]['author'],style: GoogleFonts.laila(
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10,
                                              color: Colors.white
                                            )
                                          ),),
                                        ],
                                      ))
                                ],
                              ),
                            );
                          }),
                    )
                        : Components(context).Loader(textColor: theme.textColor)
                )
            ),
          );
        }
    );
  }
}



