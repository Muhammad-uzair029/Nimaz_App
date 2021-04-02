import 'package:Nimaz_App_Demo/Screens/BottomNavScreens/Qibla/qibla_compass.dart';
import 'package:flutter/material.dart';

import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:hexcolor/hexcolor.dart';

class QiblaSection extends StatelessWidget {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qiblah',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      themeMode: ThemeMode.system,
      home: Scaffold(
        backgroundColor: HexColor('#2a2b3d'),
        body: FutureBuilder(
          future: _deviceSupport,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );

            if (snapshot.hasError)
              return Center(
                child: Text('Error: ${snapshot.error.toString()}'),
              );
            // call the Compass Class
            if (snapshot.hasData)
              return QiblaCompass();
            else
              return Container(
                child: Text('Error'),
              );
          },
        ),
      ),
    );
  }
}
