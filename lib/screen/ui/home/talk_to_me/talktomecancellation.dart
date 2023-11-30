import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/provider/userProvider.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';

class TalkToMeCancellation extends StatelessWidget {
  final String talkId;
   TalkToMeCancellation({super.key, required this.talkId});



  TextEditingController reason = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print(talkId);
    return Consumer<User>(
      builder: (context,user,_) =>
       Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        appBar: Components(context).myAppBar(title: 'Cancel Request',titleStyle: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black,fontSize: 21)),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: [
                  Text('Do you want to cancel this meeting request? Kindly share your reason this cancellation.\n\nWe discourage frequent cancellations to make the experience good for everyone',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87),),
                  const SizedBox(height: 15,),
                  Text('Why are you cancelling this meeting? *',style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black87,),),
                  const SizedBox(height: 25,),
                  TextField(
                    controller: reason,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black87,decoration: TextDecoration.none),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white30,
                      hintText: 'Reason for cancellation',
                      hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black54),
                      border: InputBorder.none,


                    ), maxLines: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
                height: kToolbarHeight,
                child: ElevatedButton(onPressed: ()async{
                  if(reason.text.isEmpty){
                    Components(context).showErrorSnackBar('Please provide a reason');
                  }
                  else{
                    var body = {
                      'talkId' : talkId,
                      'status' : 'Cancelled',
                      'desc' : reason.text
                    };
                    await Services(user.token).cancelTalktome(body);
                    Navigator.pop(context);
                  }
                }, child: const Text('Confirm Cancellation'))),
            const SizedBox(height:15 ,)
          ],
        ),
      ),
    );
  }
}
