import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/screen/ui/home/knowYourself/knowYourselfQuestions.dart';
import 'package:mindandsoul/screen/ui/home/knowYourself/knowYourselfResults.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';

import '../../../../provider/userProvider.dart';

class KnowYourselfIntro extends StatefulWidget {
  const KnowYourselfIntro({super.key});

  @override
  State<KnowYourselfIntro> createState() => _KnowYourselfIntroState();
}

class _KnowYourselfIntroState extends State<KnowYourselfIntro> {


  bool loading = true;

  Map data = {};

  getData()async{
    User user = Provider.of<User>(context,listen: false);
    var lst = await Services(user.token).getKnowYourselfCategory();

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
    return Scaffold(
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
                      Text('Welcome to Know Yourself',style: Theme.of(context).textTheme.displayLarge?.copyWith(
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
                          if(data['canTest'] == false){
                            Components(context).showSuccessSnackBar('You can only take one quiz in 15 days');
                          }
                          else{
                            Navigator.push(context, fadeRoute(KnowYourselfQuestions(questions: data['data'],))).then((value) => getData());
                          }
                      }, label: const Text('Take Quiz'),icon: const Icon(Icons.chevron_right),),

                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                )
            ),
          ],
        )
    );
  }
}
