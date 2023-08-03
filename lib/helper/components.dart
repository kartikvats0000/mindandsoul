
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Components{
  BuildContext context;

  Components(this.context);

  BlurBackgroundCircularButton({required IconData icon, VoidCallback? onTap}){
    return ClipRRect(
      borderRadius: BorderRadius.circular(45),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: CircleAvatar(
          backgroundColor:Colors.black38,
          //Colors.black54.withOpacity(0.75),
          radius: 20,
          child: InkWell(
            onTap: onTap,
            child: Icon(
              icon,color: Colors.white.withOpacity(0.9),
            ),
            //child: SvgPicture.asset('assets/home/menu.svg',color: Colors.white,height: 20,width: 20,),
          ),
        ),
      ),
    );
  }

  showSuccessSnackBar(String content){
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(content),
      elevation: 0.0,
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.9),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 6),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.inversePrimary, width: 0.75),
        borderRadius: BorderRadius.circular(24),
      ),
    )
    );
  }

  showErrorSnackBar(String content){
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(content),
      elevation: 0.0,
      backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.65),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 6),
      onVisible: (){},
      shape:RoundedRectangleBorder(
        side: BorderSide(color: Colors.redAccent, width: 0.75),
        borderRadius: BorderRadius.circular(24),
      ),
    )
    );
  }

}