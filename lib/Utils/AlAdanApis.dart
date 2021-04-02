import 'dart:convert';
import 'dart:async';
import 'package:Nimaz_App_Demo/Model/data.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class AlAdanAPI {
// initiize the Longitutude and latittude
  static double pLat = 0.0;
  static double pLong = 0.0;
// calling the model
  Data list = new Data();

  Future getnimazSchedule() async {
    // uuse for get current location
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);

    pLat = position.latitude;
    pLong = position.longitude;

    String date = DateTime.now().toIso8601String();
    // method 4 for fatching the region
    int method = 4; //
    // Api number 1 from the aladhan.com/prayer_time , and I pick 11 uber api
    // bcz its contains the date, Latitude and ongitude that is used for get location
    final url =
        "http://api.aladhan.com/v1/timings/$date?latitude=$pLat&longitude=$pLong&method=$method";

    http.Response res = await http.get(Uri.encodeFull(url), headers: {
      "Accept":
          "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
    });

    final data = json.decode(res.body);

    list = new Data.fromJson(data);

    return list;
  }
}
