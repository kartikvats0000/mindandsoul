import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/provider/userProvider.dart';
import 'package:mindandsoul/screen/ui/auth/login.dart';
import 'package:mindandsoul/screen/ui/home/bottomNavigationbarScreen.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectLanguage extends StatefulWidget {
  final String source;
   const SelectLanguage({super.key,required this.source});

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  
  
  getData()async{
    List lst = await Services('').getSupportedLanguages();

    setState(() {
      languages = lst;
      selectedIndex = lst.indexWhere((element) => element['code'] == Provider.of<User>(context,listen: false).selectedLanguage) ?? -1;
      selectedLanguage = lst[selectedIndex]['code'];
    });
  }
  List languages = [
  /*  {
      'title' : 'Engish',
      'code' : 'EN',
      'flag' : '🇬🇧',
      'buttonLabel' : 'Continue'
    },
    {
      'title' : 'français',
      'code' : 'FR',
      'flag' : '🇫🇷',
      'buttonLabel' : 'Continuer'
    },
    {
      'title' : 'عربي',
      'code' : 'AR',
      'flag' : '🇸🇦',
      'buttonLabel' : 'متابعة'
    },*/
  ];

  int selectedIndex = -1;

  String selectedLanguage = '';



  @override
  void initState() {
    getData();// TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider,User>(
      builder: (context,theme,user,child) =>
       Scaffold(
         extendBody: false,
        extendBodyBehindAppBar: false,
        body: Container(
         // padding: const EdgeInsets.symmetric(horizontal: 10),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.shade100,
          child: SafeArea(
            top: true,
            child: Column(
              children: [
               Container(
                 padding: const EdgeInsets.all(15),
                 alignment: Alignment.bottomLeft,
                 height: MediaQuery.of(context).size.height * 0.25,
                 decoration: BoxDecoration(
                   image: DecorationImage(image: const AssetImage('assets/home/map.jpg',),fit: BoxFit.cover,colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary ,BlendMode.color))
                 ),
                 child: Text('Select Language',style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 30,color: Colors.black,fontWeight: FontWeight.w700),),
               ),
                //const SizedBox(height: 10,),
                Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                      itemCount: languages.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          childAspectRatio: 2.5,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15
                        ),
                        itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){
                            HapticFeedback.selectionClick();
                           setState(() {
                             selectedIndex = index;
                             print(selectedIndex);
                             selectedLanguage = languages[index]['code'];
                             print(selectedLanguage);
                             /*print(selectedIndex);
                             selectedLanguage = languages[index]['code'];*/
                           });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                           // margin: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              border: Border.all(
                                color: (selectedIndex == index)?(Theme.of(context).colorScheme.primary):Colors.transparent
                              )
                            ),
                            child: Row(
                              children: [
                                Expanded(child: Text(languages[index]['title'],style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),)),
                                const SizedBox(width: 15,),
                                SizedBox(
                                  height: 15,
                                    child: Checkbox(
                                      side: BorderSide(color: Colors.grey.shade700),
                                      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        value: selectedIndex == index,
                                        onChanged: (val){
                                        HapticFeedback.selectionClick();
                                      setState(() {
                                        selectedIndex = index;
                                        selectedLanguage = languages[index]['code'];
                                      });
                                    }))
                              ],
                            ),
                          ),
                        );
                        }
                    )
                ),
               // const SizedBox(height: 10,),
                Visibility(
                  visible: selectedIndex != -1,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10),
                    width: MediaQuery.of(context).size.width * 0.8,
                      child: FilledButton.tonal(
                          onPressed: (selectedLanguage == '')?null:()async{
                            SharedPreferences sharedPref = await SharedPreferences.getInstance();
                            await sharedPref.setString('lang', selectedLanguage.toLowerCase());
                            user.changeUserLanguage(selectedLanguage.toLowerCase());
                            if(widget.source == 'Splash'){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                            }
                            else{
                              Navigator.pop(context);
                            }
                      }, child: const Text('Continue',)
                      )
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
