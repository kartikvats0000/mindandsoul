import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/screen/ui/home/knowYourself/knowYourselfQuestions.dart';
import 'package:mindandsoul/screen/ui/home/knowYourself/knowYourselfResults.dart';
import 'package:mindandsoul/screen/ui/home/talk_to_me/talktomequestions.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';

import '../../../../provider/userProvider.dart';

class TalktomeIntro extends StatefulWidget {
  const TalktomeIntro({super.key});

  @override
  State<TalktomeIntro> createState() => _TalktomeIntroState();
}

class _TalktomeIntroState extends State<TalktomeIntro> {


  bool loading = true;

  Map data = {};

  getData()async{
    User user = Provider.of<User>(context,listen: false);
    var lst = await Services(user.token).getTalktomeCategory();

    setState(() {
      data = lst;
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
    return Consumer<User>(
      builder: (context,user,_)=>
          Scaffold(
          body: (loading)
              ?Components(context).Loader(textColor: Colors.black)
              :Stack(
            children: [
              Positioned.fill(
                child: Image.network(data['intro']['image'],fit: BoxFit.cover,),
              ),
              Positioned.fill(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: const BoxDecoration(
                      //borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                            end: Alignment.topRight,
                            begin: Alignment.bottomLeft,
                            colors: [
                              Colors.black87,
                              Colors.black54,
                              Colors.transparent,
                              Colors.transparent,
                            ]
                        )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(user.languages[user.selectedLanguage]['home_screen']['talk_to_me'] ?? user.languages['en']['home_screen']['talk_to_me'],
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.w900
                        ),),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(data['intro']['desc'],style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70
                        ),),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton.icon(
                          onPressed: (){

                              Navigator.push(context, fadeRoute(TalktomeQuestions(questions: data['data'],))).then((value) => getData());

                          }, label:  Text(user.languages[user.selectedLanguage]['custom_round_button_class']['take_quiz_know'] ?? user.languages['en']['custom_round_button_class']['take_quiz_know']),icon: const Icon(Icons.chevron_right),),

                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  )
              ),
            ],
          )
      ),
    );
  }
}
