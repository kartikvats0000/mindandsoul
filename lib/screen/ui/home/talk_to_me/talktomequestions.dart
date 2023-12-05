import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindandsoul/screen/ui/home/talk_to_me/talktomeResults.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';

import '../../../../helper/components.dart';
import '../../../../provider/userProvider.dart';

class TalktomeQuestions extends StatefulWidget {
  final List questions;
  const TalktomeQuestions({super.key,required this.questions});

  @override
  State<TalktomeQuestions> createState() => _TalktomeQuestionsState();
}

class _TalktomeQuestionsState extends State<TalktomeQuestions> {

  List data = [];
  bool loading = false;


  List<Map> finalAnswers = [];

  int currentPage = 0;

  getData()async{

    List lst = widget.questions;
    for(int i = 0; i<lst.length ; i++){
      finalAnswers.add({
        'catId' : lst[i]['_id'],
        'answers' : []
      });

    }
    setState(() {
      data = lst;
    });
  }

  PageController pageController = PageController();



  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context,user,_) =>
       Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: (loading)
            ? Components(context).Loader(textColor: Colors.black)
            :Column(
          children: [
            Expanded(
              child: PageView.builder(
                  onPageChanged: (page){
                    setState(() {
                      currentPage = page;
                    });
                    print(finalAnswers[currentPage]);
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  itemCount: data.length,
                  itemBuilder: (context,index){

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(15,15,15,0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            //color: Colors.redAccent,
                            padding: const EdgeInsets.only(top: 30,bottom: 10),
                            child: Text(data[index]['title'],style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary.withOpacity(0.9)),),
                          ),
                          const SizedBox(height: 10,),
                          Expanded(
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: data[index]['questions'].length,
                                  itemBuilder: (context,pos){
                                    List ques = data[index]['questions'];
                                    List options = ques[pos]['options'];
                                    List answers = finalAnswers[index]['answers'];

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${user.languages[user.selectedLanguage]['custom_round_button_class']['questions'] ?? user.languages['en']['custom_round_button_class']['questions']}  ${pos+1}/${ques.length}',style:Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black.withOpacity(0.45),fontSize: 16,fontWeight: FontWeight.w600),),
                                        const SizedBox(height: 25,),
                                        Text(ques[pos]['title'],style:Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black.withOpacity(0.9),fontSize: 18),),
                                        const SizedBox(height: 25,),
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              for(int i = 0; i < options.length ; i++)
                                                GestureDetector(
                                                    onTap: (){
                                                      print(finalAnswers[index]['catId']);
                                                      var check = answers.any((element) => element['ques'] == ques[pos]['title']);
                                                      print(check);
                                                      if(!check){
                                                        setState(() {
                                                          print(ques[pos]['options'][i]);
                                                          answers.add({
                                                            'ques' : ques[pos]['title'],
                                                            'option' : ques[pos]['options'][i]['title'],
                                                            'marks' : ques[pos]['options'][i]['marks'],
                                                            '_id' : ques[pos]['options'][i]['_id']
                                                          });
                                                          print('list now $answers');
                                                        });
                                                      }
                                                      else{
                                                        var _index = answers.indexWhere((element) => element['ques'] == ques[pos]['title']);
                                                        print('option at $_index before ${answers[_index]}');
                                                        setState(() {
                                                          answers[_index] = {
                                                            'ques' : ques[pos]['title'],
                                                            'option' : ques[pos]['options'][i]['title'],
                                                            'marks' : ques[pos]['options'][i]['marks'],
                                                            '_id' : ques[pos]['options'][i]['_id']
                                                          };

                                                          print('option at $_index after ${answers[_index]}');
                                                        });

                                                      }
                                                    },
                                                    child: mcqWidget(
                                                        option: ques[pos]['options'][i]['title'],
                                                        selected: finalAnswers[currentPage]['answers'].any((element) => element['_id'] == options[i]['_id'])
                                                    )
                                                )
                                            ]
                                        ),
                                        // GestureDetector(
                                        //     onTap: (){
                                        //       setState(() {
                                        //       });
                                        //     },
                                        //     child: mcqWidget(
                                        //         option: 'Prefer not to say',
                                        //       selected: true
                                        //     )
                                        // ),
                                        const SizedBox(height: 35,),
                                      ],
                                    );
                                  }
                              )
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Visibility(
                    visible: currentPage != 0,
                    child: Expanded(
                        flex: 4,
                        child: OutlinedButton(onPressed: (){
                          pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                        }, child:  Text(
                          user.languages[user.selectedLanguage]['custom_round_button_class']['back'] ?? user.languages['en']['custom_round_button_class']['back'],
                        ))),
                  ),
                  Visibility(
                      visible: currentPage != 0,
                      child: const Spacer()
                  ),
                  Expanded(
                      flex: 6,
                      child: FilledButton(onPressed: finalAnswers[currentPage]['answers'].length == data[currentPage]['questions'].length?(){
                        if(currentPage == data.length - 1){

                          showDialog(context: context, builder: (context) =>  Components(context).confirmationDialog(context,
                              title: user.languages[user.selectedLanguage]['custom_round_button_class']['dialog_title_know'] ?? user.languages['en']['custom_round_button_class']['dialog_title_know'],
                              message: '🤔 ${user.languages[user.selectedLanguage]['custom_round_button_class']['dialog_message_know'] ?? user.languages['en']['custom_round_button_class']['dialog_message_know']} 🌟',
                              actions: [
                                TextButton(onPressed: (){
                                  Navigator.pop(context);
                                }, child:  Text( user.languages[user.selectedLanguage]['breathe_screen']['confim_cancel'] ?? user.languages['en']['breathe_screen']['confim_cancel'],)),
                                TextButton(onPressed: ()async{
                                  //finalAnswers[currentPage]['answers'] = finalAnswers[currentPage]['answers'].where((element) => element['option'] != 'Prefer not to say').toList();
                                  finalAnswers.forEach((element) {
                                    element['answers'].forEach((element) {element.remove('_id');});
                                  });


                                  print('now final  => $finalAnswers');
                                  User user = Provider.of<User>(context,listen: false);
                                  await Services(user.token).answerTalktomeQuestions(answers: finalAnswers);
                                  Components(context).showSuccessSnackBar( user.languages[user.selectedLanguage]['custom_round_button_class']['request_registered'] ?? user.languages['en']['custom_round_button_class']['request_registered'],);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }, child:  Text(
                                  user.languages[user.selectedLanguage]['custom_round_button_class']['confirm'] ?? user.languages['en']['custom_round_button_class']['confirm'],
                                )),
                              ]
                          ));
                        }
                        else{
                          pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                        }
                      }:null, child: Text((currentPage == data.length -1 )
                          ? user.languages[user.selectedLanguage]['custom_round_button_class']['submit'] ?? user.languages['en']['custom_round_button_class']['submit']
                          : user.languages[user.selectedLanguage]['custom_round_button_class']['next'] ?? user.languages['en']['custom_round_button_class']['next'],
                      ))
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget mcqWidget({required String option,required bool selected}){
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
      ),
      child: Container(
        width: double.infinity,
        //margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: (selected)?Theme.of(context).colorScheme.primary:Colors.transparent
            )
        ),
        child: Row(
          children: [
            Expanded(child: Text(option,style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),)),
            SizedBox(
                height: 25,
                width: 25,
                child: CupertinoCheckbox(
                  activeColor: Theme.of(context).colorScheme.primary,

                  value: selected, onChanged: (_){},shape: const CircleBorder(),))
          ],
        ),
      ),
    );
  }
}
