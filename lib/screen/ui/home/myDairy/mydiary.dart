import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindandsoul/constants/iconconstants.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/screen/ui/home/myDairy/add_diary_item.dart';
import 'package:mindandsoul/screen/ui/home/myDairy/edit_diary_item.dart';
import 'package:mindandsoul/screen/ui/home/navscreens/profile/favourites.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';

import '../../../../provider/userProvider.dart';

class MyDiary extends StatefulWidget {
  const MyDiary({super.key});

  @override
  State<MyDiary> createState() => _MyDiaryState();
}

class _MyDiaryState extends State<MyDiary> {
  bool loading = true;

  List data = [];

  getData()async{
    User user = Provider.of<User>(context,listen: false);
    var _data = await Services(user.token).getUserProfile(user.id);
    setState(() {
      data = _data['myDairy'];
      loading = false;
    });
  }

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
        //extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GestureDetector(
          onTap: ()async{
            Navigator.of(context).push(bottomToTopRoute(AddDiaryEntry(currentItems: data,))).then((value) => getData());
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.45,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add),
                const SizedBox(width: 5,),
                Text( user.languages[user.selectedLanguage]['custom_round_button_class']['add_new_entry'] ?? user.languages['en']['custom_round_button_class']['add_new_entry'],
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black),)
              ],
            ),
          ),
        ),
        appBar:AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(9),
            child: Components(context).BlurBackgroundCircularButton(icon: Icons.chevron_left,onTap: (){
              HapticFeedback.selectionClick();
              Navigator.pop(context);
            }),
          ),
          title: Text( user.languages[user.selectedLanguage]['home_screen']['my_diary'] ?? user.languages['en']['home_screen']['my_diary'],
            style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.black87,fontSize: 25),),
        ),
        body: (loading)
            ? Components(context).Loader(textColor: Colors.black)
            : (data.isEmpty || data == null)
            ? const Center(child:  NoFavourite())
            : ListView.builder(
          itemCount: data.length,
            padding: const EdgeInsets.only(bottom: 100),
            itemBuilder: (context,index){
            return GestureDetector(
              onTap: (){
                HapticFeedback.selectionClick();
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(padding: const EdgeInsets.all(5),child: Text(
                          '${data[index]['time']}',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black),
                      ),),
                    ),
                    const SizedBox(width: 5,),
                    Expanded(
                      flex: 9,
                        child: GestureDetector(
                          onTap: (){
                            HapticFeedback.selectionClick();
                            Navigator.of(context).push(bottomToTopRoute(EditDiaryEntry(index: index, currentItems: data,)));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(data[index]['title'],style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black,fontWeight: FontWeight.w800,),),
                                      const SizedBox(height: 10,),
                                      Text(data[index]['desc'],style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54),maxLines: 3,),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                GestureDetector(
                                    onTap: ()async{
                                      User user = Provider.of<User>(context,listen: false);
                                      data.removeAt(index);
                                      await Services(user.token).editProfile({
                                        'myDairy' : data
                                      },
                                      ).then((value) => getData());
                                      // diary.deleteDiaryItem(diary.diaryItems[index].id);
                                    },
                                    child: Components(context).myIconWidget(icon: MyIcons.delete,color: Colors.redAccent)),
                              ],
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              ),
            );
            })
      ),
    );
  }
}

