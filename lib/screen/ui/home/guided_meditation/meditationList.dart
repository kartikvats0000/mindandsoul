import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../helper/components.dart';
import '../../../../provider/themeProvider.dart';

class DailyYoga extends StatefulWidget {
  const DailyYoga({super.key});

  @override
  State<DailyYoga> createState() => _DailyYogaState();
}

class _DailyYogaState extends State<DailyYoga> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,theme,_)
      => Scaffold(
        backgroundColor: theme.themeColorA,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(preferredSize: const Size.fromHeight(kToolbarHeight), child: Components(context).myAppBar('')),
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
               Card(
                 color: Colors.white30,
                 elevation: 1.5,
                 child: Padding(
                     padding: EdgeInsets.all(10),
                   child: Row(
                     children: [
                       Expanded(
                         flex: 11,
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text('Surya Namaskar',style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                               fontWeight: FontWeight.bold,
                               color: theme.textColor,
                               fontSize: 15,
                             )),
                             const SizedBox(height: 7,),
                             Text('Invigorate body and soul with Surya Namaskar. A flowing sequence to energize your day."',style:Theme.of(context).textTheme.bodySmall?.copyWith(color: theme.textColor.withOpacity(0.7),fontSize: 12.5),maxLines: 3,overflow: TextOverflow.ellipsis,),
                             const SizedBox(height: 7,),
                             Text('View ►',style:Theme.of(context).textTheme.labelSmall?.copyWith(color: theme.themeColorA,fontSize: 11.5),maxLines: 3,overflow: TextOverflow.ellipsis,),
                           ],
                         ),
                       ),
                       const SizedBox(width: 15,),
                       Expanded(
                         flex: 13,
                           child: ClipRRect(
                             borderRadius: BorderRadius.circular(7),
                             child: Image.network('https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&q=80&w=1840&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                           ))
                     ],
                   ),
                 ),
               ),
               const SizedBox(
                 height: 500,
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
}
