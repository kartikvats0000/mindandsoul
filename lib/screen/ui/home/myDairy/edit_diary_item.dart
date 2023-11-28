import 'package:flutter/material.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';

import '../../../../provider/userProvider.dart';

class EditDiaryEntry extends StatefulWidget {
  List currentItems;
  final int index;
  EditDiaryEntry({super.key,required this.currentItems,required this.index});

  @override
  State<EditDiaryEntry> createState() => _EditDiaryEntryState();
}

class _EditDiaryEntryState extends State<EditDiaryEntry> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descController = TextEditingController();


  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      titleController.text = widget.currentItems[widget.index]['title'];
      descController.text = widget.currentItems[widget.index]['desc'];
      selectedTime = TimeOfDay(hour: int.parse(widget.currentItems[widget.index]['time'].toString().split(':').first), minute: int.parse(widget.currentItems[widget.index]['time'].toString().split(':').last));

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Edit Task',style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.primary,fontSize: 22),),
                  Components(context).BlurBackgroundCircularButton(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      icon: Icons.clear
                  )
                ],
              ),
              const SizedBox(height: 25,),
              TextFormField(
                controller: titleController,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black87,decoration: TextDecoration.none),
                decoration: InputDecoration(
                  isDense : true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 12),
                  filled: true,
                  fillColor: Colors.white70,
                  hintText: 'Title',
                  hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey.shade500),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,

                ),

              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: descController,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black87,decoration: TextDecoration.none),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white70,
                  hintText: 'Note',
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
                          const Icon(Icons.watch_later,color: Colors.black87,),
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
                      User user = Provider.of<User>(context,listen: false);
                      List currentItems = widget.currentItems;
                      if(titleController.text.isEmpty){
                        Components(context).showErrorSnackBar('Title cannot be empty');
                      }
                      else{
                        currentItems[widget.index] = {
                          'time' : '${selectedTime.hour}:${selectedTime.minute}',
                          'title' : titleController.text,
                          'desc' : descController.text
                        };

                        var body = {
                          'myDairy' : currentItems
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
                        child: const Text('Save',style: TextStyle(
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
    );
  }
}
