import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindandsoul/constants/iconconstants.dart';
import 'package:mindandsoul/helper/bullet_list.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';

import '../../../../../provider/userProvider.dart';

class Subscriptions extends StatefulWidget {
  const Subscriptions({super.key});

  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {

  List data = [];

  getData()async{
    User user = Provider.of<User>(context,listen: false);
    var lst = await Services(user.token).getSubscriptions();

    setState(() {
      data= lst;
      print(data);
    });
  }

  int selectedIndex = -1;

  bool selected(int index) => selectedIndex == index;

  List benefits = [
  "🌟 Ad-Free Experience: Immerse yourself in meditation and wellness without interruptions.\n",
  "🎧 Premium Content Access: Access a vast library of premium guided sessions and masterclasses.\n",
  "🔒 Offline Access: Download your favorite sessions and practice anytime, anywhere, even without an internet connection\n",

  "🌈 Exclusive Themes and Customization: Personalize your app with exclusive themes and advanced customization options.",

  "💖 Priority Support: Experience faster response times and dedicated support."
  ];


  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Positioned(
                      top: 0,
                        left: 0,
                        child: Components(context).BlurBackgroundCircularButton(icon: Icons.chevron_left,onTap: () => Navigator.pop(context))),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Components(context).myIconWidget(icon: MyIcons.premium,size: 100,color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
                Text('Unlock a world of exclusive features and content with\n\nBeyondLifestyle PLUS. ',style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),textAlign: TextAlign.center,),
                const SizedBox(height: 30,),
                Text('What will you get? ',style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black),textAlign: TextAlign.start,),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      for(int i =0 ; i< benefits.length ; i++)
                        Text(
                            benefits[i],
                            textAlign: TextAlign.left,
                            softWrap: true,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.black87
                            )
                        )
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for(int index = 0; index< data.length ;index++)
                        GestureDetector(
                          onTap: (){
                            HapticFeedback.selectionClick();
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.35,
                                padding: const EdgeInsets.all(15),
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  //  color: Colors.red,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      width: (selected(index))?2.5:1,
                                      color: (selected(index))
                                          ? Theme.of(context).colorScheme.primary
                                          : Colors.black26
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data[index]['title'],style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black),),
                                    Text('${data[index]['duration']} days',style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),),
                                    const SizedBox(height: 20,),
                                    Center(child: Text('\$ ${data[index]['price']}',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700,decoration: TextDecoration.lineThrough),)),
                                    const SizedBox(height: 10,),
                                    Center(child: Text('\$ ${data[index]['offPrice']}',style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.primary,),)),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: data[index]['recomm'],
                                child: Positioned(
                                  top: 5,
                                    right: 20,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary,
                                        borderRadius: BorderRadius.circular(2)
                                      ),
                                        child: Text('Recommended',style: Theme.of(context).textTheme.labelSmall,))
                                ),
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Visibility.maintain(
                  visible: selectedIndex != -1,
                    child: FilledButton(
                  onPressed: (){},
                  child: Text(
                      (selectedIndex == -1)?'':
                      'Continue with \$${data[selectedIndex]['offPrice']}'
                  ),

                )),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
