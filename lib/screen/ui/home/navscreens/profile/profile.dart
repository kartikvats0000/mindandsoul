import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mindandsoul/constants/iconconstants.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/provider/userProvider.dart';
import 'package:mindandsoul/screen/ui/auth/login.dart';
import 'package:mindandsoul/screen/ui/home/navscreens/profile/downloads.dart';
import 'package:mindandsoul/screen/ui/home/navscreens/profile/editprofile.dart';
import 'package:mindandsoul/services/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider,User>(
        builder: (context,theme,user,child) =>
            Scaffold(
              body: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: theme.themeColorA,
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.themeColorA,
                          theme.themeColorB,
                          theme.themeColorA,
                        ]
                    )
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: CachedNetworkImageProvider(user.profilePicture),
                          ),
                          const SizedBox(height: 12.5,),
                          Text(user.name,style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 19,color: theme.textColor.withOpacity(0.9)),),
                          const SizedBox(height: 10,),
                          Text(user.email,style: TextStyle(color: theme.textColor.withOpacity(0.8)),),
                          const SizedBox(height: 15,),
                          FilledButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
                              },
                              style: ButtonStyle(
                                  fixedSize: MaterialStatePropertyAll(Size(MediaQuery.of(context).size.width * 0.85,kToolbarHeight - 12)),
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      )
                                  )
                              ),
                              child: const Text('Edit Profile')
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.black.withOpacity(0.3)
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: ListTile(
                                        iconColor: Theme.of(context).colorScheme.inversePrimary,
                                        textColor: theme.textColor.withOpacity(0.75),
                                        leading: Components(context).myIconWidget(icon:MyIcons.settings,color: Theme.of(context).colorScheme.inversePrimary),
                                        title: const Text('Account Settings'),
                                        onTap: (){},
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: ListTile(
                                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Downloads())),
                                        iconColor: Theme.of(context).colorScheme.inversePrimary,
                                        textColor: theme.textColor.withOpacity(0.75),
                                        leading: const Icon(Icons.download_outlined),
                                        title: const Text('Downloads'),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: ListTile(
                                        iconColor: Theme.of(context).colorScheme.inversePrimary,
                                        textColor: theme.textColor.withOpacity(0.75),
                                        leading: Components(context).myIconWidget(icon:MyIcons.terms,color: Theme.of(context).colorScheme.inversePrimary),
                                        title: Text('Terms and Conditions'),
                                        onTap: (){},
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: ListTile(
                                        iconColor: Theme.of(context).colorScheme.inversePrimary,
                                        textColor: theme.textColor.withOpacity(0.75),
                                        leading: Components(context).myIconWidget(icon:MyIcons.favorite,color: Theme.of(context).colorScheme.inversePrimary),
                                        title: Text('Favorites'),
                                        onTap: (){},
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: ListTile(
                                        iconColor: Theme.of(context).colorScheme.inversePrimary,
                                        textColor: theme.textColor.withOpacity(0.75),
                                        leading: Components(context).myIconWidget(icon:MyIcons.share,color: Theme.of(context).colorScheme.inversePrimary),
                                        title: Text('Share App'),
                                        onTap: (){},
                                      ),
                                    ),

                                    Expanded(
                                      flex: 2,
                                      child: ListTile(
                                        onTap: (){
                                          showDialog(context: context, builder: (context) => Components(context).confirmationDialog(context,
                                              title: 'Are you sure you want to log out?',
                                              message: "Take a moment to cherish your journey and return whenever you seek tranquility.",
                                              actions: [
                                                FilledButton.tonal(
                                                    onPressed: ()async{
                                                      await GoogleSignInAPI.logout();
                                                      await user.clear();
                                                      await user.updateLoginStatus(false);
                                                      SharedPreferences sharedPreference = await SharedPreferences.getInstance();
                                                      await sharedPreference.remove('loginData');
                                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
                                                    },
                                                    child: const Text('Log Out')
                                                ),
                                                FilledButton.tonal(
                                                    onPressed: (){
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Stay')
                                                ),
                                              ]
                                          )
                                          );
                                        },
                                        /*onTap: ()async{
                                    /// showLogoutDialog();
                                     await GoogleSignInAPI.logout();
                                     await user.clear();
                                     await user.updateLoginStatus(false);
                                     SharedPreferences sharedPreference = await SharedPreferences.getInstance();
                                     await sharedPreference.remove('loginData');
                                     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
                                   },*/
                                        textColor: theme.textColor.withOpacity(0.75),
                                        //tileColor: Theme.of(context).colorScheme.primary,
                                        leading: Icon(Icons.logout,color: Colors.red,),
                                        title: Text('Logout'),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                    ),
                    Spacer(flex: 1,)
                  ],
                ),
              ),
            )
    );
  }
}
