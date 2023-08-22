import 'package:http/http.dart' as http;

class WeatherServices{
  static const baseurl = 'api.weatherapi.com';

  static const apiKey = 'dc8f7cdbfd294b5ca9993644232807';


  Future<dynamic> getCurrentWeather(double latitude, double longitude)async{
    final params  = {
      'q' : '${latitude},${longitude}',
      'key' : apiKey,
      'aqi' : 'yes'
    };

    final url = Uri.https(baseurl, '/v1/current.json', params);
    print('my url' + url.toString());
    try{

      http.Response response = await http.get(url);
      return response;
    }
    catch(e){
      print(e.toString());
    }

  }

}