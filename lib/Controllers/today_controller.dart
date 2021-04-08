import 'package:Nimaz_App_Demo/Notifiction/notificationPlugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';
import 'package:Nimaz_App_Demo/Model/data.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class User {
  String currentDate;
  String formattedTime;
  String nimazName;
  String getminutes;

  String showNimazTime;
  String pickDate;
  User(
      {this.currentDate,
      this.formattedTime,
      this.nimazName,
      this.getminutes,
      this.showNimazTime,
      this.pickDate});
}

class TodayController extends GetxController {
  static double pLat = 0.0;
  static double pLong = 0.0;

  String showNimaz;
  String nameofNimaz;
  static final DateTime nowDate = DateTime.now();
  final user =
      User(getminutes: '23', nimazName: 'wer', showNimazTime: '', pickDate: '')
          .obs;

// calling the model
  Data list = new Data();

  Future getnimazSchedule(String datetime) async {
    // uuse for get current location
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);

    pLat = position.latitude;
    pLong = position.longitude;

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

// Nimaz time controller
//
  Timer timer;
  void notificationPeriodicTimer(String fajar, zohar, asr, maghrib, isha) {
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) async {
      DateTime now = DateTime.now();
      // print(DateFormat.Hm().format(now));
      user(User(formattedTime: DateFormat.Hm().format(now)));
      if (user().formattedTime == fajar) {
        await notificationPlugin.showNotification('Fajar', 'Fajar');
        user(User(nimazName: 'Dhuhr'));
      }
      if (user().formattedTime == zohar) {
        await notificationPlugin.showNotification('Dhuhr', 'Dhuhr');
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

// getnimazName and Time When USe Start the application

  void getNimaz(String fjr, zohar, asar, mag, ish) {
    DateTime now = DateTime.now();
    String nowTime = DateFormat.H().format(now);
    var format = DateFormat.H();
    // Fajar Section
    DateTime fjrtime = DateFormat('HH').parse(fjr);
    String fjrtime2 = DateFormat.H().format(fjrtime);
    var fjrtime3 = format.parse(fjrtime2);
    // zohar Section
    DateTime zohartime = DateFormat('HH').parse(zohar);
    String zohartime2 = DateFormat.H().format(zohartime);
    var zohartime3 = format.parse(zohartime2);
    // Asar Section
    DateTime asrtime = DateFormat('HH').parse(asar);
    String asrtime2 = DateFormat.H().format(asrtime);
    var asrtime3 = format.parse(asrtime2);
    // Maghrib Section
    DateTime magtime = DateFormat('HH').parse(mag);
    String magtime2 = DateFormat.H().format(magtime);
    var magtime3 = format.parse(magtime2);
    // Ishahrib Section
    DateTime ishatime = DateFormat('HH').parse(ish);
    String ishatime2 = DateFormat.H().format(ishatime);
    var ishatime3 = format.parse(ishatime2);

    var nimazlist = new List(5);
    nimazlist[0] = fjrtime3;
    nimazlist[1] = zohartime3;
    nimazlist[2] = asrtime3;
    nimazlist[3] = magtime3;
    nimazlist[4] = ishatime3;
    var nimaz_Diff = new List(5);

    for (int i = 0; i < 5; i++) {
      var timeNow = format.parse(nowTime);

      String diff = "${nimazlist[i].difference(timeNow)}".substring(0, 2);
      if (diff != null) {
        if (diff.contains(':')) {
          diff = diff.substring(0, 1);
        }
        print(int.parse(diff));
        if ((int.parse(diff)) <= 0) {
          diff = '12';
        }
        nimaz_Diff[i] = diff;
      } else {
        nimaz_Diff[i] = diff;
      }
    }

    int smallest_value = int.parse(nimaz_Diff[0]);
    // incex number for finding the name of nimaz
    int index_number = 0;
    // //Loop through the array
    for (int i = 0; i < nimaz_Diff.length; i++) {
      //Compare elements of array with min and less then 2 bcz between  we want to elemniate the smaller value bcz its will not chnage the name of nimaz

      if (int.parse(nimaz_Diff[i]) < smallest_value) {
        smallest_value = int.parse(nimaz_Diff[i]);
        index_number = i;
      }
    }

    print("Smallest value in the list : ${smallest_value}");

    print(index_number);
    index_number == 0
        ? user(User(nimazName: 'Fajar'))
        : index_number == 1
            ? user(User(nimazName: 'Dhuhr'))
            : index_number == 2
                ? user(User(nimazName: 'Asr'))
                : index_number == 3
                    ? user(User(nimazName: 'Maghrib'))
                    : index_number == 4
                        ? user(User(nimazName: 'Isha'))
                        : user(User(nimazName: 'Null'));

    print("Nimaz");
    print(nimazlist);
    print("Difference::::");
    print(nimaz_Diff);

    // user(User(showNimazName: user().nimazName));
    showNimaz = user().nimazName;
    print("Assigned nimaz");
    print(showNimaz);
    // print(user().nimazName);
  }
}

//  delay time settingss by Difference Rough Code
//

// String getminutesfortext = 'asd';
// String gethoursfortext;
// String nn;
// String delayNimazTime(String delayNimazTime) {
//   DateTime now = DateTime.now();
//   String todayDate1 = DateFormat.Hm().format(now);
//   var format = DateFormat.Hm();
//   // Fajar Section
//   DateTime todayDate = DateFormat('HH:mm').parse(delayNimazTime);
//   String todayDate2 = DateFormat.Hm().format(todayDate);
//   var one = format.parse(todayDate1);
//   var two = format.parse(todayDate2);
//   // String ss = (two.difference(one).toString()).substring(0, 1);
//   String time = "${two.difference(one)}".substring(0, 6);

//   if (time[1] == ':') {
//     time = "${two.difference(one)}".substring(0, 4);
//   } else {
//     time = "${two.difference(one)}".substring(0, 5);
//   }

//   return time;
// }

// Show Time and Nimaz At Start
//

// // variables of Days Controller

//   int incount = 0;

//   var daysFromNow;
//   var preDaysFrom;

// // Days Controller Funtions;;;;
//   String datetimeFormatter(DateTime now) {
//     final DateFormat formatter = DateFormat('yyyy-MM-dd');
//     final String formatted = formatter.format(now);
//     return formatted;
//   }

//   void incrmentDate() {
//     incount++;
//     var daysFromNow = DateTime.now().add(new Duration(days: incount));

//     user(User(currentDate: datetimeFormatter(daysFromNow)));
//   }

//   void decrementDate() {
//     preDaysFrom = DateTime.now().add(new Duration(days: incount--));
//     user(User(currentDate: datetimeFormatter(preDaysFrom)));
//   }
