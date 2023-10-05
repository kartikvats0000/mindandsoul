import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../constants/iconconstants.dart';
import '../../../../../helper/components.dart';
import '../../../../../provider/userProvider.dart';
import '../../../../../services/services.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  var countries = [];
  var countrieslist = [];

  String countryVal = '';

  late String userCountry;

  TextEditingController searchController = TextEditingController();

  void filterSearchResults(String query) {
    setState(() {
      countrieslist = countries
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }




  //List<DropdownMenuEntry<String>> dropdownValues = [];


  getCountries()async{
    ThemeProvider theme = Provider.of<ThemeProvider>(context,listen: false);
    User user = Provider.of<User>(context,listen: false);
    String data = await DefaultAssetBundle.of(context).loadString("assets/countries.json");
    setState(() {
      countries = jsonDecode(data);
      countrieslist = countries;
      /*for(int i = 0;i<countries.length;i++){
      //  dropdownValues.add(DropdownMenuEntry(value: countries[i]['name'], label: countries[i]['name'],style: ButtonStyle(textStyle: MaterialStatePropertyAll(TextStyle(color: theme.textColor)))));
        //print('${countries[i]['name']} --> $i');
      }*/
      /*print('my ${user.country}');
      var value = countries.firstWhere((element) => element['name'] == user.country);
      print('first $value');
      countryVal = value['name'];*/
      /*print('not empty $countryVal');

      print("user=======${user.country}");
*/
      /*if(user.country.isEmpty){
        setState(() {
          userCountry = "Select Country";
        });
      }else{
        setState(() {
          userCountry = user.country;
        });
      }*/
    });
  }

  @override
  void initState() {
    User user = Provider.of<User>(context,listen: false);
    imageurl = user.profilePicture;
    nameController.text = user.name;
    emailController.text = user.email;

    print('user country ${user.country}');
    setState(() {
      countryVal = (user.country != '')
          ? user.country
          :'Select Country';
    });
    print(countryVal);
    getCountries();
    // TODO: implement initState
    super.initState();
  }

  File? image;
  final picker = ImagePicker();

  String imageurl = '';

  uploadimageforurl()async{
    User user = Provider.of<User>(context,listen: false);
    if(image==null){
      print('No Image');
    }
    else{
      imageurl = await Services(user.token).uploadImage(image!,user.token);
      print(imageurl);
      setState(() {});
    }
  }

  Future getImageGallery()async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if(pickedImage!=null){
      image = File(pickedImage.path);
      //print(pickedImage.path);
      //print("------> ${image!.path}");
      setState(() {});
      //print(File(image!.path).readAsBytes());
      //print(File(image!.path).readAsBytesSync());
    //  await uploadimageforurl();
      // print(base64Encode(File(image!.path).readAsBytesSync()));
    }else{
      print('No image selected');
    }
  }

  Future getImageCamera()async {
    final pickedImage = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);

    if(pickedImage!=null){
      image = File(pickedImage.path);
      print(pickedImage.path);
      setState(() {

      });
    }else{
      print('No image selected');
    }
  }

  cropImage(File file)async{
    if(file != null){
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image!.path,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Theme.of(context).colorScheme.primary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
            const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          image = File(croppedFile.path);
        });
      }
    }
  }

  showActionSheet(){
    ThemeProvider theme = Provider.of<ThemeProvider>(context,listen: false);
    showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
       // showDragHandle: true,
        builder: (BuildContext ctx) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 15),
            child: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select Image',style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 20,color: Theme.of(context).colorScheme.onPrimaryContainer),),
                        Components(context).BlurBackgroundCircularButton(buttonRadius: 15,icon: Icons.clear,onTap: () =>Navigator.pop(context))
                      ],
                    ),
                    const SizedBox(height: 15,),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              style: ListTileStyle.list,
                              leading: CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                                  child: Components(context).myIconWidget(icon: MyIcons.gallery,color: Theme.of(context).colorScheme.primary)
                              ),
                              title: Text('Pick Image From Gallery',style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14,color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8)),),
                              onTap: ()async{
                                await getImageGallery().whenComplete(() => cropImage(image!));
                                await uploadimageforurl();
                                Navigator.pop(context);
                              },
                            ),
                          ),

                          Divider(indent: 20,endIndent: 20,thickness: 0.3,color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                                  child: Components(context).myIconWidget(icon: MyIcons.camera,color: Theme.of(context).colorScheme.primary)
                              ),
                              title: Text('Take Image From Camera',style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14,color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8))),
                              onTap: ()async{
                                await getImageCamera().then((value) => cropImage(image!));
                                await uploadimageforurl();
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        }
    );
  }

  ScrollController listController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider,User>(
      builder: (context,theme,user,child) =>
      Scaffold(
        backgroundColor: theme.themeColorA,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight+25),
          child: AppBar(
            elevation: 0.0,
            scrolledUnderElevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: Padding(
                padding: const EdgeInsets.all(7),
                child: Components(context).BlurBackgroundCircularButton(
                  icon: Icons.chevron_left,
                  onTap: (){Navigator.pop(context);},
                )
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(left: 10,right: 10,top: kToolbarHeight+30),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              color: theme.themeColorA,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.themeColorA,
                    theme.themeColorB.withOpacity(0.75),
                  ]
              ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                  child: Text('Edit Profile',style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32,fontWeight: FontWeight.bold),textAlign: TextAlign.start,)),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  HapticFeedback.lightImpact();
                  showActionSheet();
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: CachedNetworkImageProvider(imageurl),
                    ),
                    Positioned(
                      bottom: 0,
                        right: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                              radius: 20,
                              child: Components(context).myIconWidget(icon: MyIcons.edit,color: Colors.white)
                            ),
                          ),
                        ) )
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                  //  physics: NeverScrollableScrollPhysics(),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Name'),
                      const SizedBox(height: 10,),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Name',
                        ),
                      ),
                      const SizedBox(height: 25,),
                      const Text('Email'),
                      const SizedBox(height: 10,),
                      TextFormField(
                        controller: emailController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 25,),
                      const Text('Country'),
                      const SizedBox(height: 10,),
                      GestureDetector(
                        onTap: (){
                          Future.delayed(const Duration(milliseconds: 200),(){
                            listController.animateTo((kToolbarHeight + 3) * (countries.indexWhere((element) => element['name'] == countryVal )),duration: const Duration(milliseconds: 500),curve: Curves.easeOut);
                          });
                          showModalBottomSheet(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            useSafeArea: true,
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, _setState) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Theme.of(context).colorScheme.primaryContainer,
                                              theme.themeColorB.withOpacity(0.8)
                                            ]
                                        )
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height * 0.85,
                                      child: Column(
                                        children: [

                                           Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 15),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('Select Country',style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 20,color: Theme.of(context).colorScheme.onPrimaryContainer),),
                                                Components(context).BlurBackgroundCircularButton(buttonRadius: 15,icon: Icons.clear,onTap: () =>Navigator.pop(context))
                                              ],
                                            ),
                                          ),
                                           Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 12),
                                            child: TextField(
                                              controller: searchController,
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: Theme.of(context).colorScheme.onPrimaryContainer
                                              ),
                                              textAlign: TextAlign.start,
                                              textAlignVertical: TextAlignVertical.center,
                                              textCapitalization: TextCapitalization.sentences,
                                              textInputAction: TextInputAction.search,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(20),
                                                      borderSide:  BorderSide(
                                                          width: 1,
                                                          color: Theme.of(context).colorScheme.onPrimaryContainer
                                                      )
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(20),
                                                      borderSide: BorderSide(
                                                          width: 0.85,
                                                          color: Theme.of(context).colorScheme.onPrimaryContainer
                                                      )
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(20),
                                                      borderSide: BorderSide(
                                                          width: 1.75,
                                                          color: Theme.of(context).colorScheme.onPrimaryContainer
                                                      )
                                                  ),
                                                labelText: 'Search Your Country',
                                               labelStyle: TextStyle(
                                                 fontSize: 14,
                                                 fontWeight: FontWeight.normal,
                                                 color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.5)
                                               ),
                                                  contentPadding : const EdgeInsets.all(12),
                                                //prefix: Icon(Icons.search_rounded),
                                                  prefixIcon: Icon(Icons.search),
                                               // prefixIconColor: theme.textColor.withOpacity(0.8),
                                                isCollapsed: true
                                              ),
                                              onChanged: (value) {
                                                print(value);
                                                _setState(() {
                                                  countrieslist = countries
                                                      .where((item) => item['name'].toLowerCase().contains(value.toLowerCase()))
                                                      .toList();
                                                });
                                              },
                                            ),
                                          ),
                                         // SizedBox(height: 10,),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: theme.themeColorB.withOpacity(0.4),
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(25))
                                              ),
                                              margin: EdgeInsets.fromLTRB(5,5,5,0),
                                              padding: const EdgeInsets.all(7),
                                              child: CupertinoScrollbar(
                                                controller: listController,
                                                child: ListView.builder(
                                                  controller: listController,
                                                 // physics: const NeverScrollableScrollPhysics(),
                                                  itemCount: countrieslist.length,
                                                    itemBuilder: (context,index){
                                                      return  GestureDetector(
                                                          onTap: countrieslist[index]['name'] == countryVal ? null : (){
                                                            setState(() {
                                                              countryVal = countrieslist[index]['name'];
                                                            });
                                                            Navigator.pop(context);
                                                            searchController.clear();
                                                            countrieslist = countries;
                                                          },
                                                        child: Container(
                                                          alignment: Alignment.centerLeft,
                                                          padding: const EdgeInsets.only(left: 10),
                                                          margin: const EdgeInsets.only(bottom: 3),
                                                          height: kToolbarHeight,
                                                           decoration: BoxDecoration(
                                                             color: countrieslist[index]['name'] == countryVal ? Colors.black12:Colors.transparent,
                                                             borderRadius: BorderRadius.circular(18)
                                                           ),
                                                            child: Text(countrieslist[index]['name'],style: TextStyle(color: theme.textColor),textAlign: TextAlign.start,)),
                                                      );
                                                    }),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                );
                              }
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                width: 0.85,
                                color: theme.textColor
                            )
                          ),
                          child: Text((countryVal == '')?'Select Country':countryVal),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    fixedSize: Size(MediaQuery.of(context).size.width * 0.85, kToolbarHeight)
                  ),
                    onPressed:()async{
                    var body = {
                      'userId' : user.id,
                      'name' : nameController.text,
                      'profile_picture' : imageurl,
                      'country' : countryVal
                    };
                    var data = await Services(user.token).editProfile(body, user.token);
                    SharedPreferences sharedpreference = await SharedPreferences.getInstance();
                    await sharedpreference.setString('loginData', json.encode(data['data']));
                    Components(context).showSuccessSnackBar('Profile Serenely Updated',margin: const EdgeInsets.only(bottom: kToolbarHeight+15,right: 15,left: 15));
                    await user.fromJson(data['data']);
                    Navigator.pop(context);
                    },
                    child: const Text('Affirm Changes')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
