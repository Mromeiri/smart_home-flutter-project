// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/Screen/Modes/mode_provider.dart';
import 'package:smart_home/Screen/TV/provider/tv_provider.dart';
import 'package:smart_home/Screen/door/doorProvider.dart';
import 'package:smart_home/Screen/home/homePage.dart';
import 'package:smart_home/Screen/lightScreen/provider/lightProvider.dart';
import 'package:smart_home/Screen/notification/notification_provider.dart';
import 'package:smart_home/Screen/temperature/provider/fan_provider.dart';
import 'package:smart_home/Screen/temperature/provider/temperature_provider.dart';
import 'package:smart_home/components/bottom_bar.dart';
import 'package:smart_home/firebase_api.dart';
import 'package:smart_home/models/Global.dart';
import 'package:smart_home/models/Modes.dart';
import 'package:smart_home/models/notification.dart';
import 'package:smart_home/models/temperature.dart';
import 'package:smart_home/notificationService.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final navigationKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyCaHh-Jm0kmkNOnWWZcVP7ac_II-4m7WKk',
              appId: '1:478258864520:android:62536b00a212882c879a3d',
              messagingSenderId: '478258864520',
              projectId: 'pushhnoti'))
      : await Firebase.initializeApp();

  await FirebaseApi().initNotification();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> _initfunction;
  bool? lightState;
  Temperature? tempState;
  bool? doorstate;
  Mode? mode;
  int? tv;
  int? fan;
  @override
  void initState() {
    _initfunction = iniit();
    // TODO: implement initState
    super.initState();
  }

  Future<bool> iniit() async {
    try {
      lightState = await getLightState();
      tempState = await fetchtemperatures();
      doorstate = await getDoorState();
      mode = await fetchMode();
      tv = await getTvState();
      fan = await getFanState();
      await get_notification();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> getLightState() async {
    // Define the URL for your Django server's getLightState endpoint
    var url = Uri.http(Global.ipadressnohttp, '/get_light_state/');

    // Send the GET request
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the request is successful, parse the response JSON
      bool responseData = jsonDecode(response.body);
      return responseData;
      // Extract the state from the response

      // Return the state
    } else {
      // If the request fails, throw an error or handle it accordingly
      throw Exception('Failed to load light state');
    }
  }

  Future<int> getTvState() async {
    // Define the URL for your Django server's getLightState endpoint
    var url = Uri.http(Global.ipadressnohttp, '/get_tv_state/');

    // Send the GET request
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the request is successful, parse the response JSON
      int responseData = jsonDecode(response.body);
      print(responseData);
      return responseData;
      // Extract the state from the response

      // Return the state
    } else {
      // If the request fails, throw an error or handle it accordingly
      throw Exception('Failed to load light state');
    }
  }

  Future<int> getFanState() async {
    // Define the URL for your Django server's getLightState endpoint
    var url = Uri.http(Global.ipadressnohttp, '/get_fan_level/');

    // Send the GET request
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the request is successful, parse the response JSON
      int responseData = jsonDecode(response.body);
      print(responseData);
      return responseData;
      // Extract the state from the response

      // Return the state
    } else {
      // If the request fails, throw an error or handle it accordingly
      throw Exception('Failed to load light state');
    }
  }

  Future<bool> getDoorState() async {
    // Define the URL for your Django server's getLightState endpoint
    var url = Uri.http(Global.ipadressnohttp, '/get_door_state/');

    // Send the GET request
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the request is successful, parse the response JSON
      bool responseData = jsonDecode(response.body);
      return responseData;
      // Extract the state from the response

      // Return the state
    } else {
      // If the request fails, throw an error or handle it accordingly
      throw Exception('Failed to load light state');
    }
  }

  List<MyNotification> notifications = [];
  Future<void> get_notification() async {
    try {
      FetchResult<List<MyNotification>> result = await fetechnotification();

      if (result.error != null) {
        // Handle the error if one occurred during fetching data
        print('111111111111111111111111111111111111111111111: ${result.error}');
      } else {
        // Data fetching was successful, use 'result.data'
        setState(() {
          try {
            result.data!.sort((a, b) =>
                DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
            print(result.data);
            notifications = result.data!;
            // notificationProvider.setNotifications(result.data!);
          } catch (e) {
            print(e);
          }
        });

        // Use 'enfants' list here or update the UI with fetched data
      }
    } catch (error) {
      // Handle other exceptions that might occur during the process
      print('Exception occurred: $error');
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ModeProvider()..changeMode(mode ?? modesList[0]),
        ),
        ChangeNotifierProvider(
            create: (context) => LightProvider()..initLight(lightState!)),
        ChangeNotifierProvider(
            create: (context) =>
                TemperatureProvider()..setTemperature(tempState!)),
        ChangeNotifierProvider(
            create: (context) => TvProvider()..setTVChannel(tv!)),
        ChangeNotifierProvider(
            create: (context) => FanProvider()..setFanLevel(fan!)),
        ChangeNotifierProvider(
            create: (context) => DoorProvider()..initdoor(doorstate!)),
        ChangeNotifierProvider(
            create: (context) =>
                NotificationProvider()..setNotifications(notifications)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: MyHomePage(),
        home: FutureBuilder<bool>(
          future: _initfunction,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // Internet connectivity check is complete
              // Access the result using snapshot.data
              print(snapshot.data);
              if (snapshot.data == true) {
                print("light state is ${lightState}");
                return BottomBar(0);
              } else
                return NoInternet();
            } else {
              // Still checking internet connectivity
              return Scaffold(
                body: Center(
                  child: Container(
                    height: 500,
                    width: 500,
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/icons/logo.png',
                              width: 150, height: 150),
                          SizedBox(height: 16),
                          CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),

        navigatorKey: navigationKey,
      ),
    );
  }
}

class NoInternet extends StatelessWidget {
  NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/noInternet.png',
                    height: 250,
                  ),
                  Text(
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                    'Ooops!',
                  ),
                  SizedBox(height: 10),
                  Text(
                    textAlign: TextAlign.center,
                    'it seems there is something wrong with your internet conncection. Please connect to the internet and restart the App',
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight / 9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                            Size(screenWidth / 2.5, 50)),
                        backgroundColor:
                            MaterialStateProperty.all(Color(0XFF576AF6)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'TRY AGAIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
