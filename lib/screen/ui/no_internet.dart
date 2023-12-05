import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/home/noInternet.png',height: 125,width: 125,),
            const SizedBox(height: 10,),
            Text('No Internet Connection',style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black,fontSize: 25),),
            const SizedBox(height: 10,),
            Text("Oops! It seems like you're not connected to the internet. Please check your connection and try again.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20,),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
                child: FilledButton(onPressed: (){}, child: Text('Try Again')))
          ],
        ),
      ),
    );
  }
}
