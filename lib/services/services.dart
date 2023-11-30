import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:io';

export 'weatherservices.dart';
export 'internet_utilities.dart';



class Services {
  final String token;


  Services(this.token);

  final String baseurl = 'http://13.200.60.212:8085/';
  //final String baseurl = 'http://192.168.1.146:8085/';

  Future<dynamic> splashApi(Map<String, dynamic> params)async{

    final uri = Uri.parse('${baseurl}splash');
    print(uri);

    print('params for apiSplash $params');
    
    http.Response response = await http.post(uri,body: params );
    var data = jsonDecode(response.body);
    print('${response.body}  ${response.statusCode}');


    return data;
  }

  ///AUTH

  Future<dynamic> login(Map<String,dynamic> params)async{
    final uri = Uri.parse('${baseurl}login');
    http.Response response = await http.post(uri,body: params,);
    var data = jsonDecode(response.body);
    print('user -> $data');
    return data;
  }


  ///GET

  Future<dynamic> getCategories()async{
    final uri = Uri.parse('${baseurl}category');

    http.Response response = await http.get(uri,headers: {
      'authorization' : 'Bearer ${token}'
    });
    if (response.statusCode == 200){
      var data = json.decode(response.body);
      return data;
    }
  }

  Future<dynamic> getSupportedLanguages()async{
    final uri = Uri.parse('${baseurl}lang');

    http.Response response = await http.get(uri,headers: {
      'authorization' : 'Bearer $token'
    });
    if (response.statusCode == 200){
      var data = json.decode(response.body);
      return data['data'];
    }
  }

  Future<dynamic> getLanguagesContent()async{
    final uri = Uri.parse('https://brainsoul.s3.ap-south-1.amazonaws.com/language/language.json');

    http.Response response = await http.get(uri);
    log('res ${response.body}');
    if (response.statusCode == 200){
      var data = json.decode(utf8.decode(response.bodyBytes));
      return data;
    }
  }

  Future<dynamic> getHomeData(String userId)async{
    final uri = Uri.parse('${baseurl}home?userId=$userId');

    http.Response response = await http.get(uri,headers: {
      'authorization' : 'Bearer ${token}'
    });
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

  Future<dynamic> getContent({String categoryId = '', String search = ''})async{
    final uri = Uri.http('13.200.60.212:8085','/content',{
      'catId' : categoryId,
      'search' : search
    });
    //final uri = Uri.parse('${baseurl}content?catId=$categoryId');

    http.Response response = await http.get(uri,headers: {
      'authorization' : 'Bearer ${token}'
    });

    var data = json.decode(response.body);

    if(response.statusCode == 200){
      var lst = data['data'];
      return lst;
    }
  }

  Future<dynamic> getFavouriteContent()async{

    print('favo');
    final uri = Uri.parse('${baseurl}content/favourite');

    http.Response response = await http.get(uri,
        headers: {
      'authorization' : 'Bearer $token'
    });

    print(response.statusCode);


    var data = json.decode(response.body);

    print('favoruites $data}');

    if(response.statusCode == 200){
      var lst = data['data'];
      return lst;
    }
  }

  Future<dynamic> getFavouriteWellness()async{
    final uri = Uri.parse('${baseurl}wellness/favourite');

    http.Response response = await http.get(uri,headers: {
      'authorization' : 'Bearer $token'
    });

    var data = json.decode(response.body);

    if(response.statusCode == 200){
      var lst = data['data'];
      return lst;
    }
  }

  Future<dynamic> getWellnessContent()async{
    final uri = Uri.parse('${baseurl}wellness');

    http.Response response = await http.get(uri,headers: {
      'authorization' : 'Bearer ${token}'
    });

    var data = json.decode(response.body);

    if(response.statusCode == 200){
      var lst = data['data'];
      return lst;
    }
  }

  Future<dynamic> getHarmonyMoods()async{
    final uri = Uri.parse('${baseurl}harmony/mood');

    try{
      http.Response response = await http.get(uri,headers: {
        'authorization' : 'Bearer ${token}'
      });

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
      http.Response response = await http.get(uri,headers: {
        'authorization' : 'Bearer $token'
      });

      var data = json.decode(response.body);

      if(response.statusCode == 200){
        var lst = data['data'];
        return lst;
      }
    }catch(e){
      print(e);
    }
  }

  Future<dynamic> getFavouriteHarmony()async{
    final uri = Uri.parse('${baseurl}fvrt_harmony');


      http.Response response = await http.get(
          uri,
          headers: {
        'authorization' : 'Bearer $token'
      }
      );

      var data = json.decode(response.body);

      print(data);

      if(response.statusCode == 200){
        return data;
      }

  }

  Future<dynamic> getFavouriteYoga()async{
    final uri = Uri.parse('${baseurl}yoga/favourite');

      http.Response response = await http.get(
          uri,
          headers: {
        'authorization' : 'Bearer $token'
      }
      );

      var data = json.decode(response.body);

      print(data);

      if(response.statusCode == 200){
        return data;
      }

  }

  Future<dynamic> getBreathingData()async{
    http.Response response = await http.get(Uri.parse('https://brainsoul.s3.ap-south-1.amazonaws.com/breathe/breathingList.json'));

    var data = json.decode(response.body);

    if(response.statusCode == 200){
      return data;
    }
  }

  Future<dynamic> getFavouriteQuotes()async{
    final uri = Uri.parse('${baseurl}quote/favourite');

    http.Response response = await http.get(uri,headers: {
      'authorization' : 'Bearer $token'
    });

    var data = json.decode(response.body);

    if(response.statusCode == 200){
      var lst = data['data'];
      return lst;
    }
  }

  Future<dynamic> getYogaList()async{
    final uri = Uri.parse('${baseurl}yoga');

    http.Response response = await http.get(uri,headers: {
      'authorization' : 'Bearer $token'
    });

    var data = json.decode(response.body);

    if(response.statusCode == 200){
      return data;
    }
  }

  Future<dynamic> getYogaDetail({required String yogaId})async{
    final uri = Uri.parse('${baseurl}yoga/detail');

    try{
      http.Response response = await http.post(uri,headers: {
        'authorization' : 'Bearer $token'
      },
          body: {
            'yogaId' : yogaId
          }
      );

      var data = json.decode(response.body);

      if(response.statusCode == 200){
        return data;
      }
    }
    catch(e){
      log(e.toString());
    }
  }

  Future<dynamic> getUserProfile(String userId)async{
    final uri = Uri.parse('${baseurl}user/detail');

    http.Response response = await http.post(uri,body:{
      'userId' : userId
    },
        headers: {
          'authorization' : 'Bearer $token',

        }
    );

    var data = json.decode(response.body);
    print(data);
    if(response.statusCode == 200){
      return data['data'];
    }
  }

  Future<dynamic> getGames()async{
    final uri = Uri.parse('${baseurl}games');

    http.Response response = await http.get(uri,
        headers: {
          'authorization' : 'Bearer $token',

        }
    );

    var data = json.decode(response.body);
    print(data);
    if(response.statusCode == 200){
      return data['data'];
    }
  }

  Future<dynamic> getCommunities()async{
    final uri = Uri.parse('${baseurl}community');

    http.Response response = await http.get(uri,
        headers: {
          'authorization' : 'Bearer $token',

        }
    );

    var data = json.decode(response.body);
    print(data);
    if(response.statusCode == 200){
      return data['data'];
    }
  }

  Future<dynamic> getKnowYourselfCategory()async{
    final uri = Uri.parse('${baseurl}know/cat');

    http.Response response = await http.get(uri,
        headers: {
          'authorization' : 'Bearer $token',

        }
    );

    var data = json.decode(response.body);
    print(data);
    if(response.statusCode == 200){
      return data;
    }
  }

  Future<dynamic> getTalktomeCategory()async{
    final uri = Uri.parse('${baseurl}talk/cat');

    http.Response response = await http.get(uri,
        headers: {
          'authorization' : 'Bearer $token',

        }
    );

    var data = json.decode(response.body);
    print(data);
    if(response.statusCode == 200){
      return data;
    }
  }

  Future<dynamic> getKnowYourselfResults()async{
    final uri = Uri.parse('${baseurl}know/result');

    http.Response response = await http.get(uri,
        headers: {
          'authorization' : 'Bearer $token',

        }
    );

    var data = json.decode(response.body);
    print(data);
    if(response.statusCode == 200){
      return data['data'];
    }
  }

  Future<dynamic> getTalkToMeSessionsList()async{
    final uri = Uri.parse('${baseurl}talk');

    http.Response response = await http.get(uri,
        headers: {
          'authorization' : 'Bearer $token',

        }
    );

    var data = json.decode(response.body);
    print(data);
    if(response.statusCode == 200){
      return data['data'];
    }
  }

  Future<dynamic> getSubscriptions()async{
    final uri = Uri.parse('${baseurl}plan');

    http.Response response = await http.get(uri,
        headers: {
          'authorization' : 'Bearer $token',

        }
    );

    var data = json.decode(response.body);
    print(data);
    if(response.statusCode == 200){
      return data['data'];
    }
  }


  ///PUT

  Future<dynamic> editProfile(Map<String,dynamic> params) async {
    final uri = Uri.parse('${baseurl}user/update');

    http.Response response = await http.put(
        uri,
        body: json.encode(params),
        headers: {
          'authorization' : 'Bearer $token',
          'Content-Type': 'application/json'
        }
    );
    var data = json.decode(response.body);
    if(response.statusCode == 200){
      return data;
    }
  }

  Future<dynamic> cancelTalktome(Map<String,dynamic> params) async {
    final uri = Uri.parse('${baseurl}talk');

    http.Response response = await http.put(
        uri,
        body: params,
        headers: {
          'authorization' : 'Bearer $token',
        //  'Content-Type': 'application/json'

        }
    );
    var data = json.decode(response.body);
    print(response.statusCode);
    if(response.statusCode == 200){
      return data;
    }
  }

  Future<dynamic> themeCounter(String themeId) async {
    final uri = Uri.parse('${baseurl}theme/counter');

    http.Response response = await http.put(
        uri,
        body: {
          'themeId' : themeId
        },
        headers: {
          'authorization' : 'Bearer $token',
        //  'Content-Type': 'application/json'
        }
    );
    var data = json.decode(response.body);
    print(response.statusCode);
    if(response.statusCode == 200){
      return data;
    }
  }

  ///POST

  Future<dynamic> addFavouriteHarmony({required Map body})async{
    final uri = Uri.parse('${baseurl}fvrt_harmony/add');


    http.Response response = await http.post(
        uri,
        body: json.encode(body),
        headers: {
          'authorization' : 'Bearer $token',
          'Content-Type': 'application/json'
        }
    );

    var data = json.decode(response.body);

    print(data);

    if(response.statusCode == 200){
      return data;
    }

  }

  Future<dynamic> getQuotes(String country)async{

    final uri = Uri.parse('${baseurl}quote');

    http.Response response = await http.post(uri,body: {'country' : country},headers: {
      'authorization' : 'Bearer ${token}'
    });



    var data = json.decode(response.body);
    print(data);

    if(response.statusCode == 200){
      var lst = data['data'];
      return lst;
    }
  }

  Future<dynamic> getWellnessDetails(String wellnessId)async{

    final uri = Uri.parse('${baseurl}wellness/detail');

    http.Response response = await http.post(
        uri,
        body: {
          'wellId' : wellnessId,
          //'likes': [{'id':1, 'title':123}]
        },
        headers: {
          'authorization' : 'Bearer $token'
        }
    );

    var data = json.decode(response.body);
    return(data);


  }

  Future<dynamic> likeQuotes(String id)async{
    final uri = Uri.parse('${baseurl}quote/like');

    http.Response response = await http.post(
        uri,
        headers: {
      'authorization' : 'Bearer $token'
    },
      body: {
          "quoteId" : id
      }
    );

    var data = json.decode(response.body);

    if(response.statusCode == 200){
       return data['data'];
    }
  }

  Future<dynamic> likeContent(String id)async{
    final uri = Uri.parse('${baseurl}content/like');

    http.Response response = await http.post(
        uri,
        headers: {
      'authorization' : 'Bearer $token'
    },
      body: {
          "contentId" : id
      }
    );

    var data = json.decode(response.body);

    if(response.statusCode == 200){
       return data['data'];
    }
  }

  Future<dynamic> likeWellness(String id)async{
    final uri = Uri.parse('${baseurl}wellness/like');

    http.Response response = await http.post(
        uri,
        headers: {
      'authorization' : 'Bearer $token'
    },
      body: {
          "wellnessId" : id
      }
    );

    var data = json.decode(response.body);

    if(response.statusCode == 200){
       return data['data'];
    }
  }

  Future<dynamic> likeYoga(String id)async{
    final uri = Uri.parse('${baseurl}yoga/like');

    http.Response response = await http.post(
        uri,
        headers: {
      'authorization' : 'Bearer $token'
    },
      body: {
          "yogaId" : id
      }
    );

    var data = json.decode(response.body);

    if(response.statusCode == 200){
       return data['data'];
    }
  }

  Future<dynamic> likeCommunity(String id)async{
    final uri = Uri.parse('${baseurl}community/like');

    http.Response response = await http.post(
        uri,
        headers: {
      'authorization' : 'Bearer $token'
    },
      body: {
          "communityId" : id
      }
    );


    var data = json.decode(response.body);

    print(data);
    if(response.statusCode == 200){
       return data['data'];
    }
  }

  Future<dynamic> likeGame(String id)async{
    final uri = Uri.parse('${baseurl}games/like');

    http.Response response = await http.post(
        uri,
        headers: {
      'authorization' : 'Bearer $token'
    },
      body: {
          "gameId" : id
      }
    );


    var data = json.decode(response.body);

    print(data);
    if(response.statusCode == 200){
       return data['data'];
    }
  }

  Future<dynamic> getContentDetails(String categoryId)async{

    final uri = Uri.parse('${baseurl}content/detail');

    http.Response response = await http.post(uri,body: {'contentId' : categoryId},headers: {
      'authorization' : 'Bearer $token'
    });

    var data = json.decode(response.body);
    return(data);


  }

  Future<dynamic> answerKnowYourselfQuestions({required List answers})async{
    final uri = Uri.parse('${baseurl}know/answer');


    try{
      http.Response response = await http.post(
          uri,
          body: json.encode({
            'data' : answers
          }),
          headers: {
            'authorization' : 'Bearer $token',
            'Content-Type': 'application/json'
          }
      );

      var data = json.decode(response.body);

      print(data);

      if(response.statusCode == 200 || response.statusCode == 208){
        return data;
      }
    }
    catch(e){
      return e.toString();
    }

  }

  Future<dynamic> answerTalktomeQuestions({required List answers})async{
    final uri = Uri.parse('${baseurl}talk/answer');


    http.Response response = await http.post(
        uri,
        body: json.encode({
          'data' : answers
        }),
        headers: {
          'authorization' : 'Bearer $token',
          'Content-Type': 'application/json'
        }
    );

    var data = json.decode(response.body);

    print(data);

    if(response.statusCode == 200){
      return data;
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



