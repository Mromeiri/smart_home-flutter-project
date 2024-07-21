// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/Screen/Modes/mode_provider.dart';
import 'package:smart_home/Screen/TV/provider/tv_provider.dart';
import 'package:smart_home/Screen/TV/tv_screen.dart';
import 'package:smart_home/Screen/door/PINCODE.dart';
import 'package:smart_home/Screen/door/doorProvider.dart';
import 'package:smart_home/Screen/home/components/darkcontainer.dart';
import 'package:smart_home/Screen/lightScreen/LightScreen.dart';
import 'package:smart_home/Screen/lightScreen/provider/lightProvider.dart';
import 'package:smart_home/Screen/notification/notification_provider.dart';
import 'package:smart_home/Screen/notification/notification_screen.dart';
import 'package:smart_home/Screen/temperature/provider/fan_provider.dart';
import 'package:smart_home/Screen/temperature/temperature_screen.dart';
import 'package:smart_home/components/default_button.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home/components/icon_button.dart';
import 'package:smart_home/constant.dart';
import 'dart:convert';
import 'package:page_transition/page_transition.dart';
import 'package:smart_home/main.dart';

import 'package:smart_home/models/Global.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<State> _dialogKey = GlobalKey<State>();
  String predictedClass = '';
  double probabilityInactive = 0.0;
  double probabilityActive = 0.0;
  double executionTime = 0.0;
  final modeProvider = Provider.of<ModeProvider>(
    navigationKey.currentContext!,
    listen: false,
  );
  final lightProvider = Provider.of<LightProvider>(
    navigationKey.currentContext!,
    listen: false,
  );
  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('${Global.ipadress}/prediction_light'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> result = json.decode(response.body);
      print(result['Predicted class']);

      setState(() {
        predictedClass = result['Predicted class'].toString();
        probabilityInactive = result['probability_class0'];
        probabilityActive = result['probability_class1'];
        executionTime = result['execution Time'];
      });

      if (modeProvider.currentMode!.name == "Smart Mode") {
        if (predictedClass == "0") {
          lightProvider.initLight(false);
        } else {
          lightProvider.initLight(true);
        }
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final lightProvider = Provider.of<LightProvider>(context);
    final doorProvider = Provider.of<DoorProvider>(context);
    final tvProvider = Provider.of<TvProvider>(context);
    final fanProvider = Provider.of<FanProvider>(context);

    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          getAppBarUI(context),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: DarkContainer(
                            itsOn: lightProvider.ison,
                            switchButton: () {
                              lightProvider.toggleLight();
                            },
                            onTap: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return Center(
                                    key: _dialogKey,
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                              await fetchData();
                              if (_dialogKey.currentContext != null) {
                                Navigator.of(_dialogKey.currentContext!).pop();
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LightScreen(
                                          executionTime:
                                              executionTime.toString(),
                                          predictedClass:
                                              predictedClass.toString(),
                                          probabilityActive:
                                              probabilityActive.toString(),
                                          probabilityInactive:
                                              probabilityInactive.toString(),
                                        )),
                              );

                              //  Navigator.of(context).pushNamed(SmartLight.routeName);
                            },
                            iconAsset: 'assets/icons/svg/light.svg',
                            device: 'Lightening',
                            deviceCount: '1 lamp',
                            switchFav: () {},
                            isFav: false,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(
                              (5 / 585) * _mediaQueryData.size.height),
                          child: DarkContainer(
                            itsOn: fanProvider.fanLevel == 0 ? false : true,
                            switchButton: () {
                              if (fanProvider.fanLevel != 0) {
                                fanProvider.toggleChannel(0);
                              } else {
                                fanProvider.toggleChannel(1);
                              }
                            },
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TemperatureScreen(),
                                  ));
                            },
                            iconAsset: 'assets/icons/svg/ac.svg',
                            device: 'AC',
                            deviceCount: fanProvider.fanLevel == 0
                                ? "off"
                                : "Fan Level ${fanProvider.fanLevel}",
                            switchFav: () {},
                            isFav: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: DarkContainer(
                            itsOn: doorProvider.ison,
                            switchButton: () {
                              if (!doorProvider.ison) {
                                _showPINCodeDialog(context);
                              } else {
                                doorProvider.toggledoor("close");
                              }

                              // lightProvider.toggleLight();
                            },
                            onTap: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return Center(
                                    key: _dialogKey,
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                              // await fetchData();
                              if (_dialogKey.currentContext != null) {
                                Navigator.of(_dialogKey.currentContext!).pop();
                              }
                            },
                            iconAsset: 'assets/icons/door1.svg',
                            device: 'Safety',
                            deviceCount: 'Password Lock',
                            switchFav: () {},
                            isFav: false,
                            height: 55,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(
                              (5 / 585) * _mediaQueryData.size.height),
                          child: DarkContainer(
                            itsOn: tvProvider.channel == 0 ? false : true,
                            switchButton: () {
                              if (tvProvider.channel == 0) {
                                tvProvider.toggleChannel(channels[1]);
                              } else {
                                tvProvider.toggleChannel(Channel(
                                    background: 'background',
                                    image: 'image',
                                    name: '',
                                    number: '0'));
                              }
                            },
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TVScreen(),
                                  ));
                            },
                            iconAsset: 'assets/icons/tv.svg',
                            device: 'TV',
                            deviceCount: tvProvider == 0
                                ? ''
                                : 'On channel ${tvProvider.channel}',
                            switchFav: () {},
                            isFav: false,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Flexible(
                  //   child: getPopularCourseUI(),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget getAppBarUI(BuildContext context) {
  final notificationProvider = Provider.of<NotificationProvider>(context);

  return Padding(
    padding: const EdgeInsets.only(top: 8.0, left: 10, right: 18),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            width: 150, child: Image.asset('assets/images/smarthome.png')),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            "By Linda & Abdellah",
            style: TextStyle(fontSize: 8),
          ),
        ),
        Expanded(child: SizedBox()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 16),
              IconBtnWithCounter(
                numOfitem: notificationProvider.notificationsItems.length,
                svgSrc: "assets/icons/Bell.svg",
                press: () async {
                  Navigator.push(
                      context,
                      PageTransition(
                          duration: Duration(milliseconds: 100),
                          child: NotificationScreen(),
                          type: PageTransitionType.leftToRight));
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ],
    ),
  );
}

void _showPINCodeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(child: PINCODE()),
      );
    },
  );
}
