import 'package:Nimaz_App_Demo/Notifiction/notificationPlugin.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';
import 'package:Nimaz_App_Demo/Model/data.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class User {
  String currentDate;
  String formattedTime;
  String nimazName;
  String getminutes;
  String getTheTime;
  // String gethours;

  User({
    this.currentDate,
    this.formattedTime,
    this.nimazName,
    this.getminutes,
    this.getTheTime,
  });
}

class TodayController extends GetxController {
  static double pLat = 0.0;
  static double pLong = 0.0;

// variables of Days Controller
  int incount = 0;

  var daysFromNow;
  var preDaysFrom;
  static final DateTime nowDate = DateTime.now();
  // String currentDate = nowDate.toIso8601String();
  // var user = User(currentDate: nowDate.toIso8601String()).obs;
  // var user1 =
  //     User(nimazName: "Aachman").obs; // declare just like any other variable
// on the controller file
  final user = User(getminutes: '23', getTheTime: '12:45').obs;

// calling the model
  Data list = new Data();

  Future getnimazSchedule(String datetime) async {
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
        "http://api.aladhan.com/v1/timings/$datetime?latitude=$pLat&longitude=$pLong&method=$method";

    http.Response res = await http.get(Uri.encodeFull(url), headers: {
      "Accept":
          "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
    });

    final data = json.decode(res.body);

    list = new Data.fromJson(data);

    return list;
  }

// Days Controller Funtions;;;;
  String datetimeFormatter(DateTime now) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    return formatted;
  }

  String incrmentDate() {
    String date = DateTime.now().toIso8601String();
    incount++;
    var daysFromNow = DateTime.now().add(new Duration(days: incount));

    print("Current Date");
    print(date);
    print("PreDay is ::::");

    print(daysFromNow);
    user(User(currentDate: datetimeFormatter(daysFromNow)));

    return datetimeFormatter(daysFromNow);
  }

  String decrementDate() {
    preDaysFrom = DateTime.now().add(new Duration(days: incount--));
    print("Counter Value:::");
    print(incount);
    print("PreDay::::");
    print(preDaysFrom);
    user(User(currentDate: datetimeFormatter(preDaysFrom)));

    return datetimeFormatter(preDaysFrom);
  }

// Nimaz time controller
//
  Timer timer;
  void notificationPeriodicTimer(String fajar, zohar, asr, maghrib, isha) {
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) async {
      DateTime now = DateTime.now();
      print(DateFormat.Hm().format(now));
      user(User(formattedTime: DateFormat.Hm().format(now)));
      if (user().formattedTime == fajar) {
        await notificationPlugin.showNotification('Fajar', 'Fajar');
        user(User(nimazName: 'Dhuhr'));
      }
      if (user().formattedTime == zohar) {
        await notificationPlugin.showNotification('Zohar', 'Zohar');
        user(User(nimazName: 'Asr'));
      }
      if (user().formattedTime == asr) {
        await notificationPlugin.showNotification('asr', 'asr');

        user(User(nimazName: 'Maghrib'));
      }
      if (user().formattedTime == maghrib) {
        await notificationPlugin.showNotification('maghrib', 'maghrib');
        user(User(nimazName: 'Isha'));
      }
      if (user().formattedTime == isha) {
        await notificationPlugin.showNotification('isha', 'Isha');
        user(User(nimazName: 'Fajar'));
      }
    });
  }

//  delay time settingss
//

  String getminutesfortext = 'asd';
  String gethoursfortext;
  String nn;
  String delayNimazTime(String delayNimazTime) {
    DateTime now = DateTime.now();
    String todayDate1 = DateFormat.Hm().format(now);
    var format = DateFormat.Hm();
    // Fajar Section
    DateTime todayDate = DateFormat('HH:mm').parse(delayNimazTime);
    String todayDate2 = DateFormat.Hm().format(todayDate);
    var one = format.parse(todayDate1);
    var two = format.parse(todayDate2);
    // String ss = (two.difference(one).toString()).substring(0, 1);
    String time = "${two.difference(one)}".substring(0, 6);

    if (time[1] == ':') {
      time = "${two.difference(one)}".substring(0, 4);
    } else {
      time = "${two.difference(one)}".substring(0, 5);
    }
    user(User(getTheTime: time));

    return time;
  }
}
