import 'package:flutter/material.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/provider/userProvider.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';

class AddDiaryEntry extends StatefulWidget {
  List currentItems;
   AddDiaryEntry({super.key, required this.currentItems});

  @override
  State<AddDiaryEntry> createState() => _AddDiaryEntryState();
}

class _AddDiaryEntryState extends State<AddDiaryEntry> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descController = TextEditingController();


   TimeOfDay selectedTime = TimeOfDay.now();

   @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context,user,_) =>
      Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(user.languages[user.selectedLanguage]['custom_round_button_class']['add_task_diary'] ?? user.languages['en']['custom_round_button_class']['add_task_diary'],
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.primary,fontSize: 22),),
                    Components(context).BlurBackgroundCircularButton(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        icon: Icons.clear
                    )
                  ],
                ),
                const SizedBox(height: 25,),
                SizedBox(
                  child: TextField(
                    controller: titleController,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black87,decoration: TextDecoration.none),
                    decoration: InputDecoration(
                      filled: true,
                      isDense : true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 12),
                      fillColor: Colors.white70,
                      hintText: user.languages[user.selectedLanguage]['custom_round_button_class']['title'] ?? user.languages['en']['custom_round_button_class']['title'],
                      hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey.shade500),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,

                    ),

                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: descController,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black87,decoration: TextDecoration.none),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white70,
                    hintText: user.languages[user.selectedLanguage]['custom_round_button_class']['note'] ?? user.languages['en']['custom_round_button_class']['note'],
                    hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey.shade500),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,

                  ), maxLines: 7,
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: ()async{
                        TimeOfDay? _timeofday = TimeOfDay.now();
                        _timeofday  =  await showTimePicker(context: context, initialTime: selectedTime);
                        if(_timeofday != null){
                          setState(() {
                            selectedTime = _timeofday!;
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.watch_later,color: Colors.black87,),
                            const SizedBox(width: 10,),
                            Text('${selectedTime.hour.toString().padLeft(2,'0')}:${selectedTime.minute.toString().padLeft(2,'0')}',style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w700
                            ),)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        List currentItems = widget.currentItems;
                        User user = Provider.of<User>(context,listen: false);
                        if(titleController.text.isEmpty){
                          Components(context).showErrorSnackBar('Title cannot be empty');
                        }
                        else{
                          currentItems.add({
                            'time': '${selectedTime.hour.toString().padLeft(2,'0')}:${selectedTime.minute.toString().padLeft(2,'0')}',
                            'title': titleController.text,
                            'desc': descController.text
                          });
                          print('curr ${currentItems}');
                          var body = {
                            'myDairy' : widget.currentItems
                          };
                          await Services(user.token).editProfile(body).then((value) => Navigator.pop(context));

                        }
                      },
                      child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 25),
                          //width: MediaQuery.of(context).size.width * 0.25,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Theme.of(context).colorScheme.primaryContainer
                          ),
                          child:  Text(user.languages[user.selectedLanguage]['custom_round_button_class']['add'] ?? user.languages['en']['custom_round_button_class']['add'],
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w700
                          ),
                          )
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
