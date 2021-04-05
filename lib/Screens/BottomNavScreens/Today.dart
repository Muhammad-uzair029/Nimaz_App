import 'package:Nimaz_App_Demo/Controllers/today_controller.dart';
import 'package:Nimaz_App_Demo/Notifiction/Notification.dart';
import 'package:Nimaz_App_Demo/Notifiction/notificationPlugin.dart';
import 'package:Nimaz_App_Demo/Notifiction/notificationScreens.dart';
import 'package:Nimaz_App_Demo/Screens/BottomNavScreens/Qibla/Qibla.dart';
import 'package:Nimaz_App_Demo/Screens/MainPage/MainScreen.dart';
import 'package:Nimaz_App_Demo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class TodaySection extends StatefulWidget {
  @override
  _TodaySectionState createState() => _TodaySectionState();
}

class _TodaySectionState extends State<TodaySection> {
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload $payload');
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => TodaySection()));

    navigatorKey.currentState
        .push(MaterialPageRoute(builder: (_) => MainPage()));
  }

  final user = User().obs;
  String setstateofdate;

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    final _todayController = Get.put(TodayController());
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: HexColor("#100F17"),
          ),
          FutureBuilder(
            future: _todayController.getnimazSchedule(setstateofdate),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                _todayController.periodictimer(
                    snapshot.data.data.timings.fajr,
                    snapshot.data.data.timings.dhuhr,
                    snapshot.data.data.timings.asr,
                    snapshot.data.data.timings.maghrib,
                    snapshot.data.data.timings.isha);
                return Container(
                    child: Column(
                  children: <Widget>[
                    // Stack of Above Image, Isha text, Adnd location
                    Stack(
                      children: [
                        Container(
                          height: orientation == Orientation.portrait
                              ? MediaQuery.of(context).size.height * 0.3
                              : MediaQuery.of(context).size.height * 0.4,
                          color: Colors.blueAccent,
                          child: Image.asset(
                            'assets/home_screen/main_frame.jpg',
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        Center(
                            child: Column(
                          children: [
                            Padding(
                                padding: orientation == Orientation.portrait
                                    ? EdgeInsets.only(top: 70)
                                    : EdgeInsets.only(top: 5),
                                child: Text('ISHA',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 40))),
                            Padding(
                                padding: orientation == Orientation.portrait
                                    ? EdgeInsets.only(top: 10)
                                    : EdgeInsets.only(top: 0),
                                child: Text(
                                    snapshot.data.data.meta.offset.isha
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30))),
                            SizedBox(
                                width: 200,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.location_on,
                                    color: HexColor('#16a884'),
                                    size: 30,
                                  ),
                                  title: Text(snapshot.data.data.meta.timezone,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)),
                                ))
                          ],
                        )),
                      ],
                    ),
                    // hijrii BAr With Date
                    Container(
                        height: orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.height * 0.1
                            : MediaQuery.of(context).size.height * 0.14,
                        color: HexColor('#2c2b3b'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: HexColor('#16a884'),
                                    size: 30,
                                  )),
                              onTap: () {
                                _todayController.decrementDate();
                                setState(() {
                                  setstateofdate =
                                      _todayController.user.value.currentDate;
                                });
                              },
                            ),
                            Container(
                                alignment: Alignment.topCenter,
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 20, bottom: 10),
                                    child: SizedBox(
                                      width: 200,
                                      child: ListTile(
                                          //  Hijrii
                                          title: Text(
                                              snapshot.data.data.date.hijri
                                                      .month.en +
                                                  ' ' +
                                                  snapshot.data.data.date.hijri
                                                      .year,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20)),
                                          // date
                                          subtitle: Center(
                                              child: Obx(() => Text(
                                                    '${_todayController.user.value.currentDate}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14),
                                                  ))),
                                          trailing: Image.asset(
                                            'assets/home_screen/today.png',
                                            height: 30,
                                            width: 20,
                                            color: HexColor('#16a884'),
                                          )),
                                    ))),
                            GestureDetector(
                                onTap: () {
                                  _todayController.incrmentDate();
                                  setState(() {
                                    setstateofdate =
                                        _todayController.user.value.currentDate;
                                  });
                                },
                                child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: HexColor('#16a884'),
                                      size: 30,
                                    ))),
                          ],
                        )),
                    Container(
                        height: orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.height * 0.46
                            : MediaQuery.of(context).size.height * 0.30,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              nimazTimeTile(
                                'assets/home_screen/sunrise_for_calendar/sunrise.png',
                                'Fajr',
                                snapshot.data.data.timings.fajr,
                                snapshot.data.data.timings.fajr,
                              ),
                              nimazTimeTile(
                                'assets/home_screen/sunrise_for_calendar/sun.png',
                                'Dhuhr',
                                snapshot.data.data.timings.dhuhr,
                                snapshot.data.data.timings.dhuhr,
                              ),
                              nimazTimeTile(
                                'assets/home_screen/sunrise_for_calendar/sun.png',
                                'Asr',
                                snapshot.data.data.timings.asr,
                                snapshot.data.data.timings.asr,
                              ),
                              nimazTimeTile(
                                'assets/home_screen/sunrise_for_calendar/sunset.png',
                                'Maghrib',
                                snapshot.data.data.timings.maghrib,
                                snapshot.data.data.timings.maghrib,
                              ),
                              nimazTimeTile(
                                'assets/home_screen/sunrise_for_calendar/night.png',
                                'Isha',
                                snapshot.data.data.timings.isha,
                                snapshot.data.data.timings.isha,
                              ),
                            ],
                          ),
                        )),
                  ],
                ));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  // NomazTilee for each Nimaz
  Widget nimazTimeTile(
    String leadingicon,
    String nimazName,
    String nimazTime,
    String alaramIconTime,
  ) {
    final _todayController = Get.find<TodayController>();
    // timer = Timer.periodic(Duration(minutes: 1), (Timer t) async {
    //   DateTime now = DateTime.now();

    //   String formattedTime = DateFormat.Hm().format(now);
    //   print("Notification Formatted Dates");
    //   print(formattedTime);
    // });
    print("Today Time baby");
    print(_todayController.user.value.formattedTime);
    return Container(
        padding: EdgeInsets.all(5.0),
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Fetch the nimaz name and Shows Icon
              Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(children: [
                    Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: ImageIcon(
                          AssetImage(leadingicon),
                          size: 25,
                          color: Colors.white,
                          // color: Color(0xFF3A5A98),
                        )),
                    Text(
                      nimazName,
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ])),

              // Alaram bell notification Icons With Time

              Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Row(children: [
                    Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Text(nimazTime,
                            style:
                                TextStyle(color: Colors.white, fontSize: 17))),
                    Obx(() => Container(
                          child: _todayController.user.value.formattedTime ==
                                  alaramIconTime
                              ? ImageIcon(
                                  AssetImage(
                                      'assets/home_screen/notification.png'),
                                  size: 25,
                                  color: HexColor('#16a884'),
                                )
                              : Container(),
                        )),
                  ])),
            ]));
  }
}
