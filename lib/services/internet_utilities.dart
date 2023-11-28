import 'package:internet_connection_checker/internet_connection_checker.dart';

class Internet {

  bool connected = false;

  checkInternet() async{

    connected = await InternetConnectionChecker().hasConnection;
    final msg = connected ? "CONNECTED TO INTERNET" :  "NOT CONNECTED TO INTERNET";

    return connected;
    //showSimpleNotification(Text(msg));
  }

}
