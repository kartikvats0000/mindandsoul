import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/screen/ui/home/breathe/breathingList.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';
import '../../../../helper/components.dart';
import '../../../../provider/userProvider.dart';


class BreatheCat extends StatefulWidget {
  const BreatheCat({super.key});

  @override
  State<BreatheCat> createState() => _BreatheCatState();
}

class _BreatheCatState extends State<BreatheCat> {


  List data = [];

  List timers = [
    1,2,3,5
  ];

  int timer = 1;

  Color myColor(String color){
    return Color(int.parse('0xff$color'));
  }


  void _showDisclaimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Components(context).confirmationDialog(context, title: 'Disclaimer', message: 'These breathing exercises are compiled from publicly available sources and are intended for relaxation and stress relief. \n\n'
            'If you have underlying medical conditions, please consult a healthcare professional before practicing. \n\nResults may vary between individuals, and we do not guarantee specific outcomes. Listen to your body and practice mindfully for your well-being.',
            actions: [FilledButton.tonal(onPressed: (){Navigator.pop(context);}, child: const Text('Close'))]);
      },
    );
  }

  List data2 = [];

  getData()async{
    User user = Provider.of<User>(context,listen: false);
    var jsn = await Services(user.token).getBreathingData();
    //String jsn = await DefaultAssetBundle.of(context).loadString("assets/data/breathingList.json");

    setState(() {
      data  = jsn[user.selectedLanguage];
      data2 = List.generate(4, (index) => data[ (data.length - 1) - index  ]).reversed.toList();
      //print(data);
    });
  }

  bool isScrolling = false;

  @override
  void initState() {
    // TODO: implement initState
    getData();
    scrollController.addListener(() {
      if(scrollController.position.pixels < MediaQuery.of(context).size.height * 0.12
      ){
        if(isScrolling == true){setState(() {
          isScrolling = false;
        });}
      }
      else{
        if(isScrolling == false){setState(() {
          isScrolling = true;
        });}
      }
    });
    super.initState();
  }

  ScrollController scrollController = ScrollController();





  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,theme,_)
      => Scaffold(
        backgroundColor: theme.themeColorA,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(preferredSize: const Size.fromHeight(kToolbarHeight), child: Components(context).customAppBar(actions: [], title: const Text('Breathe'), isScrolling: isScrolling)),
        body: (data.isEmpty)
            ? Components(context).Loader(textColor: theme.textColor)
            :Container(
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
            Text('Breathe', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
            const SizedBox(height: 20,),
            Text('Discover a collection of guided breathing exercises tailored to calm your mind and reduce stress...', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: theme.textColor.withOpacity(0.75),
                fontSize: 14.5
            ),),
            const SizedBox(height: 20,),
            _buildGrid(data),
            const SizedBox(height: 30,),
            _buildGrid(data2), // Add some space before the Disclaimer link.
            Center(
              child: TextButton(
                onPressed: () {
                  _showDisclaimerDialog(context); // Show the disclaimer dialog.
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
}

buildBreatheCatItem(List data, int index, BuildContext context,String page){
  double radius = 25;
  return Stack(
    children: [
      Hero(
        tag: data[index]['image'],
        child: ClipRRect(
            borderRadius:(page == 'Home')
                ? BorderRadius.circular(radius)
                : (index > 3)
                  ? BorderRadius.only(
              topLeft: (index == 4 || index == 5 || index == 6)? Radius.circular(radius):Radius.zero,
              topRight: (index == 4 ||index == 5 || index == 7)? Radius.circular(radius):Radius.zero,
              bottomLeft: (index == 4|| index == 6 || index == 7)?Radius.circular(radius):Radius.zero,
              bottomRight: (index == 5 || index == 6 || index == 7)?Radius.circular(radius):Radius.zero,
            )
                  : BorderRadius.only(
              topLeft: (index == 0 || index == 1 || index == 2)? Radius.circular(radius):Radius.zero,
              topRight: (index == 0 ||index == 1 || index == 3)?Radius.circular(radius):Radius.zero,
              bottomLeft: (index == 0|| index == 2 || index == 3)? Radius.circular(radius):Radius.zero,
              bottomRight: (index == 1 || index == 2 || index == 3)?Radius.circular(radius):Radius.zero,
            ),
            child: CachedNetworkImage(imageUrl:data[index]['image'],fit: BoxFit.fitHeight,height: double.maxFinite,)),
      ),
      Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
        gradient: const LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topCenter,
            colors: [
              Colors.black,Colors.black54,Colors.black38,Colors.transparent,Colors.transparent
            ]),
        borderRadius: (page == 'Home')
            ? BorderRadius.circular(radius)
            :(index > 3)
            ?BorderRadius.only(
          topLeft: (index == 4)? Radius.circular(radius):Radius.zero,
          topRight: (index == 5)? Radius.circular(radius):Radius.zero,
          bottomLeft: (index == 4 || index == 6 || index == 7)? Radius.circular(radius):Radius.zero,
          bottomRight: (index == 5 || index == 6|| index == 7)? Radius.circular(radius):Radius.zero,
        )
            :BorderRadius.only(
          topLeft: (index == 0)? Radius.circular(radius):Radius.zero,
          topRight: (index == 1)? Radius.circular(radius):Radius.zero,
          bottomLeft: (index == 0 || index == 2 || index == 3)? Radius.circular(radius):Radius.zero,
          bottomRight: (index == 1 || index == 2|| index == 3)? Radius.circular(radius):Radius.zero,
        ),
      ))),
      Positioned(
          bottom: 15,
          left: 10,
          right: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data[index]['category'],style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize:  (page == 'Home') ? 30 : 15,color: Colors.white),),
              Text('${data[index]['data'].length} Powerful Exercises',style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize:  (page == 'Home') ? 14 : 12,color: Colors.white70),),
              Text('${data[index]['tagline']}',style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize:  (page == 'Home') ? 14 : 12,color: Colors.white70),),
            ],
          ))
    ],
  );
}


_buildGrid(List data){
  return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4/3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10
      ),
      itemCount: 4,
      itemBuilder: (context,index){
        return GestureDetector(
          onTap: ()async {
            HapticFeedback.selectionClick();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BreathingList(title: data[index]['category'],desc: data[index]['tagline'], image: data[index]['image'], data: data[index]['data'],)));
          },
          child: buildBreatheCatItem(data,index,context,'CatPage')
        );
      }
  );
}
