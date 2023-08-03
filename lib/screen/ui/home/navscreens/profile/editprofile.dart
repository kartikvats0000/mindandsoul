import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    User user = Provider.of<User>(context,listen: false);
    imageurl = user.profilePicture;
    nameController.text = user.name;
    emailController.text = user.email;
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
      imageurl = await Services().uploadImage(image!,user.token);
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
        backgroundColor: theme.themeColorA,
       // showDragHandle: true,
        builder: (BuildContext ctx) {
          return Wrap(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  /*  gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.themeColorA,
                          theme.themeColorB,
                        ]
                    ),*/
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      height: 5,
                      width: 65,
                      decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                        child: Icon(Icons.image_outlined,color: Theme.of(context).colorScheme.primary,),
                      ),
                      title: Text('Pick Image From Gallery'),
                      onTap: ()async{
                        await getImageGallery().whenComplete(() => cropImage(image!));
                        await uploadimageforurl();
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                        child: Icon(Icons.camera_alt_outlined,color: Theme.of(context).colorScheme.primary,),
                      ),
                      title: Text('Take Image from Camera'),
                      onTap: ()async{
                        await getImageCamera().then((value) => cropImage(image!));
                        await uploadimageforurl();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider,User>(
      builder: (context,theme,user,child) =>
      Scaffold(
        backgroundColor: theme.themeColorA,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Padding(
              padding: EdgeInsets.all(7),
              child: Components(context).BlurBackgroundCircularButton(
                icon: Icons.chevron_left,
                onTap: (){Navigator.pop(context);},
              )
          ),
        ),
        body: Container(
       //   margin: EdgeInsets.only(top: kToolbarHeight + 10),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 10,right: 10,top: kToolbarHeight+30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              color: theme.themeColorA,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.themeColorA,
                    theme.themeColorB.withOpacity(0.55),
                  ]
              ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                  child: Text('Edit Profile',style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 30),textAlign: TextAlign.start,)),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
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
                        right: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                              radius: 20,
                              child: Icon(Icons.edit,color: Colors.white70,),
                            ),
                          ),
                        ) )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                  //  physics: NeverScrollableScrollPhysics(),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name'),
                      SizedBox(height: 10,),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Name',
                        ),
                      ),
                      SizedBox(height: 25,),
                      Text('Email'),
                      SizedBox(height: 10,),
                      TextFormField(
                        controller: emailController,
                        enabled: false,
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
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
                      'city' : ''
                    };
                    var data = await Services().editProfile(body, user.token);
                    SharedPreferences sharedpreference = await SharedPreferences.getInstance();
                    await sharedpreference.setString('loginData', json.encode(data['data']));
                    Components(context).showSuccessSnackBar('Profile Serenely Updated');
                    await user.fromJson(data['data']);
                    Navigator.pop(context);
                    },
                    child: Text('Affirm Changes')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
