import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

export 'weatherservices.dart';



class Services {

  final String baseurl = 'http://13.200.60.212:8085/';
  //final String baseurl = 'http://192.168.1.146:8085/';

  Future<dynamic> splashApi(Map<String, dynamic> params)async{
    final uri = Uri.parse('${baseurl}splash');
    print(uri);
    
    http.Response response = await http.post(uri,body: params);
    var data = jsonDecode(response.body);
    print(response.statusCode);


    return data;
  }

  ///AUTH

  Future<dynamic> login(Map<String,dynamic> params)async{
    final uri = Uri.parse('${baseurl}login');
    http.Response response = await http.post(uri,body: params);
    var data = jsonDecode(response.body);
    print('user -> $data');
    return data;
  }

  ///GET

  Future<dynamic> getCategories()async{
    final uri = Uri.parse('${baseurl}category');

    http.Response response = await http.get(uri);
    if (response.statusCode == 200){
      var data = json.decode(response.body);
      return data;
    }
  }

  Future<dynamic> getThemes()async{
    final uri = Uri.parse('${baseurl}theme');
    http.Response response = await http.get(uri);
    var data = json.decode(response.body);
    if(response.statusCode == 200){
      var lst = data['data'];
      return lst;
    }
  }

  Future<dynamic> getContent()async{
    final uri = Uri.parse('${baseurl}content');

    http.Response response = await http.get(uri);

    var data = json.decode(response.body);

    if(response.statusCode == 200){
      var lst = data['data'];
      return lst;
    }
  }

  Future<dynamic> getWellnessContent()async{
    final uri = Uri.parse('${baseurl}wellness');

    http.Response response = await http.get(uri);

    var data = json.decode(response.body);

    if(response.statusCode == 200){
      var lst = data['data'];
      return lst;
    }
  }

  Future<dynamic> getHarmonyMoods()async{
    final uri = Uri.parse('${baseurl}harmony/mood');

    try{
      http.Response response = await http.get(uri);

      var data = json.decode(response.body);

      if(response.statusCode == 200){
        var lst = data['data'];
        return lst;
      }
    }catch(e){
      print(e);
    }
  }

  Future<dynamic> getHarmonyData()async{
    final uri = Uri.parse('${baseurl}harmony/cat');

    try{
      http.Response response = await http.get(uri);

      var data = json.decode(response.body);

      if(response.statusCode == 200){
        var lst = data['data'];
        return lst;
      }
    }catch(e){
      print(e);
    }
  }


  ///PUT
  Future<dynamic> editProfile(Map<String,dynamic> params,String token) async {
    final uri = Uri.parse('${baseurl}user/update');

    http.Response response = await http.put(uri,body:params,headers: {
      'authorization' : 'Bearer ${token}'
    });
    var data = json.decode(response.body);
    if(response.statusCode == 200){
      return data;
    }
  }

  ///POST
  Future<dynamic> getQuotes(String country)async{

    final uri = Uri.parse('${baseurl}quote');

    http.Response response = await http.post(uri,body: {'country' : country});



    var data = json.decode(response.body);
    print(data);

    if(response.statusCode == 200){
      var lst = data['data'];
      return lst;
    }
  }

  ///Multipart

  Future<String> uploadImage(File file, String token) async {
    var url = Uri.parse('${baseurl}user/image_upload');
    print('new path ${file.path}');
    //var url = Uri.http('192.168.0.172:8086','/post/image_upload');
    var request = http.MultipartRequest(
        "POST", url);
    var pic = await http.MultipartFile.fromPath("image", file.path);

    request.files.add(pic);
    request.headers['authorization'] = 'Bearer $token';

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var value = jsonDecode(responseString);

    print(value);
    // print(value['image']['url']);
    var imageurl = value['data'];

    return imageurl;
  }




}



