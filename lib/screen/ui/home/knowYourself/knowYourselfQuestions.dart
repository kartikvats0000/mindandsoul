import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';

import '../../../../helper/components.dart';
import '../../../../provider/userProvider.dart';

class KnowYourselfQuestions extends StatefulWidget {
   final List questions;
  const KnowYourselfQuestions({super.key,required this.questions});

  @override
  State<KnowYourselfQuestions> createState() => _KnowYourselfQuestionsState();
}

class _KnowYourselfQuestionsState extends State<KnowYourselfQuestions> {

  List data = [];
  bool loading = false;


  List<Map> finalAnswers = [];
  //List<Map> finalAnswersToSend = [];

  int currentPage = 0;

  getData()async{
    User user = Provider.of<User>(context,listen:false);

    List lst = widget.questions;
    for(int i = 0; i<lst.length ; i++){
      finalAnswers.add({
        'catId' : lst[i]['_id'],
        'answers' : []
      });
      // finalAnswersToSend.add({
      //   'catId' : lst[i]['_id'],
      //   'answers' : []
      // });

      List _ques = lst[i]['questions'];
      for(int j = 0; j<_ques.length ; j++){
        List _options = _ques[j]['options'];
        _options.add({
          "title": "Prefer not to say",
          "marks": -1 * j,
          "_id": j
        },);
      }

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
    return Scaffold(
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(data[index]['title'],style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary.withOpacity(0.9)),),
                            GestureDetector(
                              onTap: (){
                                (finalAnswers[currentPage]['answers'].isNotEmpty)?Components(context).showErrorSnackBar('You need to answer every question'):
                                pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                              },
                                child: Text('Skip →',style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey.shade500),)),
                          ],
                        ),
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
                                  Text('Question  ${pos+1}/${ques.length}',style:Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black.withOpacity(0.45),fontSize: 16,fontWeight: FontWeight.w600),),
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
                                                 // finalAnswersToSend[index]['answers'].add({
                                                 //   'ques' : ques[pos]['title'],
                                                 //   'option' : ques[pos]['options'][i]['title'],
                                                 //   'marks' : ques[pos]['options'][i]['marks'],
                                                 //   '_id' : ques[pos]['options'][i]['_id']
                                                 // });
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
                          }, child: const Text('Back'))),
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
                               title: 'Confirmation',
                               message: '🤔 Are you sure about your answer? Take a moment to review before confirming. Accurate responses lead to a stronger understanding and better results. 🌟',
                               actions: [
                                 TextButton(onPressed: (){
                                   Navigator.pop(context);
                                 }, child: const Text('Cancel')),
                                 TextButton(onPressed: ()async{
                                   //finalAnswers[currentPage]['answers'] = finalAnswers[currentPage]['answers'].where((element) => element['option'] != 'Prefer not to say').toList();
                                   finalAnswers.forEach((element) {
                                   element['answers'] = element['answers'].where((e) => e['option'] != 'Prefer not to say').toList();
                                   print('HAHA' + element.toString());
                                   element['answers'].forEach((element) {element.remove('_id');});
                                    /* if(element['answers'] == []){
                                       finalAnswers.remove(element);
                                     }
                                     else{
                                       element['answers'].forEach((element) {element.remove('_id');});
                                     }*/
                                   });

                                   finalAnswers = finalAnswers.where((element) => element['answers'].length != 0).toList();
                                   print('now final  => $finalAnswers');
                                   User user = Provider.of<User>(context,listen: false);
                                   var res = await Services(user.token).answerKnowYourselfQuestions(answers: finalAnswers);
                                   Components(context).showSuccessSnackBar(res['message']);
                                   Navigator.pop(context);
                                   Navigator.pop(context);
                                   Navigator.pop(context);
                                 }, child: const Text('Confirm')),
                               ]
                           ));
                          }
                          else{
                            pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                          }
                        }:null, child: Text((currentPage == data.length -1 )?'Submit':'Next'))
                    )
                  ],
                ),
              )
            ],
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
