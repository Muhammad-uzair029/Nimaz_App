import 'package:Nimaz_App_Demo/Model/data.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';
import 'package:Nimaz_App_Demo/Utils/AlAdanApis.dart';
import 'package:geolocator/geolocator.dart';

class QuranSection extends StatefulWidget {
  @override
  _QuranSectionState createState() => _QuranSectionState();
}

class _QuranSectionState extends State<QuranSection> {
  AlAdanAPI _alAAdanapi = new AlAdanAPI();

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: HexColor("#100F17"),
          ),
          FutureBuilder(
            future: _alAAdanapi.getnimazSchedule(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Container(
                    child: Column(
                  children: <Widget>[
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
                    Container(
                        height: orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.height * 0.1
                            : MediaQuery.of(context).size.height * 0.14,
                        color: HexColor('#2c2b3b'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: HexColor('#16a884'),
                                  size: 30,
                                )),
                            Container(
                                alignment: Alignment.topCenter,
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 20, bottom: 10),
                                    child: SizedBox(
                                      width: 200,
                                      child: ListTile(
                                          title: Text(
                                              snapshot.data.data.date.hijri
                                                      .month.en +
                                                  ' ' +
                                                  snapshot.data.data.date.hijri
                                                      .year,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20)),
                                          subtitle: Center(
                                              child: Text(
                                            snapshot
                                                .data.data.date.gregorian.date,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
                                          )),
                                          trailing: Image.asset(
                                            'assets/home_screen/today.png',
                                            height: 30,
                                            width: 20,
                                            color: HexColor('#16a884'),
                                          )),
                                    ))),
                            Container(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: HexColor('#16a884'),
                                  size: 30,
                                )),
                          ],
                        )),
                    Container(
                        height: orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.height * 0.46
                            : MediaQuery.of(context).size.height * 0.30,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              NimazTimeTile(
                                'assets/home_screen/sunrise_for_calendar/sunrise.png',
                                'Fajr',
                                snapshot.data.data.timings.fajr,
                              ),
                              NimazTimeTile(
                                'assets/home_screen/sunrise_for_calendar/sun.png',
                                'Dhuhr',
                                snapshot.data.data.timings.dhuhr,
                              ),
                              NimazTimeTile(
                                'assets/home_screen/sunrise_for_calendar/sun.png',
                                'Asr',
                                snapshot.data.data.timings.asr,
                              ),
                              NimazTimeTile(
                                'assets/home_screen/sunrise_for_calendar/sunset.png',
                                'Maghrib',
                                snapshot.data.data.timings.maghrib,
                              ),
                              NimazTimeTile(
                                'assets/home_screen/sunrise_for_calendar/night.png',
                                'Isha',
                                snapshot.data.data.timings.isha,
                              ),
                            ],
                          ),
                        )),
                  ],
                ));
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget NimazTimeTile(
    String leadingicon,
    String nimazName,
    String nimazTime,
  ) {
    return Container(
        padding: EdgeInsets.all(5.0),
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
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
              Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Row(children: [
                    Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Text(nimazTime,
                            style:
                                TextStyle(color: Colors.white, fontSize: 17))),
                    ImageIcon(
                      AssetImage('assets/home_screen/notification.png'),
                      size: 25,
                      color: HexColor('#16a884'),
                    ),
                  ])),
            ]));
  }
}
