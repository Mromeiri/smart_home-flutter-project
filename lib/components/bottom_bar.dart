// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smart_home/Screen/Modes/modes_screen.dart';
import 'package:smart_home/Screen/home/homePage.dart';
import 'package:smart_home/constant.dart';

// import '/pages/profile/profile_screen.dart';
// import '../screens/home/home_page.dart';

class BottomBar extends StatefulWidget {
  int _selectedIndex;
  static String routeName = "/../components/bottom_bar";
  BottomBar(this._selectedIndex);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  // int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    MyHomePage(),

    ModesScreen(),

    // Text('Index 3: School'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget._selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(widget._selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Ionicons.home_outline),
            activeIcon: Icon(Ionicons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.settings_outline),
            activeIcon: Icon(Ionicons.settings),
            label: "Modes",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Ionicons.chatbubble_ellipses_outline),
          //   label: "Home",
          //   activeIcon: Icon(Ionicons.chatbubble_ellipses),
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Ionicons.person_outline),
          //   activeIcon: Icon(Ionicons.person),
          //   label: "Home",
          // ),
        ],
        currentIndex: widget._selectedIndex,
        selectedItemColor: kSecondaryColor,
        unselectedItemColor: kSecondaryColor,
        onTap: _onItemTapped,
      ),
      /*
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              AppStyle.homeIcon,
              colorFilter: const ColorFilter.mode(
                AppStyle.primarySwatch,
                BlendMode.srcIn,
              ),
            ),
            icon: SvgPicture.asset(AppStyle.homeIcon),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              AppStyle.eventIcon,
              colorFilter: const ColorFilter.mode(
                AppStyle.primarySwatch,
                BlendMode.srcIn,
              ),
            ),
            icon: SvgPicture.asset(AppStyle.eventIcon),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              AppStyle.reportIcon,
              colorFilter: const ColorFilter.mode(
                AppStyle.primarySwatch,
                BlendMode.srcIn,
              ),
            ),
            icon: SvgPicture.asset(AppStyle.reportIcon),
            label: 'Account',
          ),
          // BottomNavigationBarItem(
          //   activeIcon: SvgPicture.asset(
          //     AppStyle.notificationsIcon,
          //     colorFilter: const ColorFilter.mode(
          //       AppStyle.primarySwatch,
          //       BlendMode.srcIn,
          //     ),
          //   ),
          //   icon: SvgPicture.asset(AppStyle.notificationsIcon),
          //   label: 'Notifications',
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppStyle.primarySwatch,
        onTap: _onItemTapped,
      ),
   */
    );
  }
}
