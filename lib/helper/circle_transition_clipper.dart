import 'package:flutter/cupertino.dart';

class Myclipper extends CustomClipper<Path>{

  final double value;


  Myclipper({required this.value});

  @override
  Path getClip(Size size) {
    var path = Path();
    path.addOval(Rect.fromCircle(
        center: Offset(size.width/2, size.height * 0.8),
        radius: value * size.height
    ),
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
  
}


