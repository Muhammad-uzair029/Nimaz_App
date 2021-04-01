import 'package:Nimaz_App_Demo/Screens/BottomNavScreens/More.dart';
import 'package:Nimaz_App_Demo/Screens/BottomNavScreens/Qibla.dart';
import 'package:Nimaz_App_Demo/Screens/BottomNavScreens/Quran.dart';
import 'package:Nimaz_App_Demo/Screens/BottomNavScreens/Today.dart';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:hexcolor/hexcolor.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  final Color navBarColor = HexColor('#2a2b3d');
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: navBarColor, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        // borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style6, // Choose the nav bar style with this property.
    );
  }
}

List<Widget> _buildScreens() {
  return [Today(), Qibla(), QuranSection(), More()];
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: Image.asset(
        'assets/home_screen/today.png',
      ),
      title: ("Today"),
      activeColorPrimary: HexColor('#16a884'),
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: Image.asset(
        'assets/home_screen/kaaba.png',
      ),
      title: ("Qibla"),
      activeColorPrimary: HexColor('#16a884'),
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: Image.asset('assets/home_screen/quran.png'),
      title: ("Quran"),
      activeColorPrimary: HexColor('#16a884'),
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.menu),
      title: ("More"),
      activeColorPrimary: HexColor('#16a884'),
      inactiveColorPrimary: Colors.grey,
    ),
  ];
}
