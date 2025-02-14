// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sort_child_properties_last, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/Screen/Modes/mode_provider.dart';
import 'package:smart_home/Screen/lightScreen/provider/lightProvider.dart';
import 'package:smart_home/Screen/notification/notification_provider.dart';
import 'package:smart_home/Screen/temperature/fan_predict_screen.dart';
import 'package:smart_home/Screen/temperature/provider/fan_provider.dart';
import 'package:smart_home/Screen/temperature/provider/temperature_provider.dart';
import 'package:smart_home/components/customIconButton.dart';
import 'package:smart_home/main.dart';
import 'package:smart_home/models/Global.dart';
import 'package:smart_home/models/temperature.dart';
import 'package:http/http.dart' as http;

class TemperatureScreen extends StatefulWidget {
  const TemperatureScreen({super.key});

  @override
  State<TemperatureScreen> createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  @override
  void initState() {
    super.initState();
  }

  GlobalKey<State> _dialogKey = GlobalKey<State>();

  String predictedClass = '';
  double probabilityFanOff = 0.0;
  double probabilityActiveOn1 = 0.0;
  double probabilityActiveOn2 = 0.0;
  double probabilityActiveOn3 = 0.0;

  double executionTime = 0.0;
  final modeProvider = Provider.of<ModeProvider>(
    navigationKey.currentContext!,
    listen: false,
  );
  final fanProvider = Provider.of<FanProvider>(
    navigationKey.currentContext!,
    listen: false,
  );
  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('${Global.ipadress}/prediction_fan'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> result = json.decode(response.body);
      print(result['Predicted class']);

      setState(() {
        predictedClass = result['predicted_class'].toString();
        probabilityFanOff = result['probability_class0'];
        probabilityActiveOn1 = result['probability_class1'];
        probabilityActiveOn2 = result['probability_class2'];
        probabilityActiveOn3 = result['probability_class3'];
        executionTime = result['execution_time'];
      });

      if (modeProvider.currentMode!.name == "Smart Mode") {
        fanProvider.setFanLevel(int.parse(predictedClass));
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final temperatureProvider = Provider.of<TemperatureProvider>(context);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IntrinsicHeight(
                child: Stack(
                  children: [
                    Align(
                      child: Text(
                        "Temperature",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      child: CustomIconButton(
                        child: Icon(Icons.arrow_back),
                        height: 35,
                        width: 35,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: CustomIconButton(
                        child: Icon(Icons.auto_awesome),
                        height: 35,
                        width: 35,
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
                                builder: (context) => FanPredictScreen(
                                      executionTime: executionTime.toString(),
                                      probabilityActiveOn1:
                                          probabilityActiveOn1.toString(),
                                      probabilityActiveOn2:
                                          probabilityActiveOn2.toString(),
                                      probabilityActiveOn3:
                                          probabilityActiveOn3.toString(),
                                      predictedClass: predictedClass,
                                      probabilityInactive:
                                          probabilityFanOff.toString(),
                                    )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TemperatureProgress(
                      temperature: temperatureProvider.temp.temperature,
                      text: "Temperature", // Provide the temperature value here
                    ),
                    TemperatureProgress(
                      temperature: temperatureProvider.temp.humidity,
                      text: "Humidity", // Provide the temperature value here
                    ),
                    FanSpeedControl(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FanSpeedControl extends StatefulWidget {
  @override
  _FanSpeedControlState createState() => _FanSpeedControlState();
}

class _FanSpeedControlState extends State<FanSpeedControl> {
  final fanProvider = Provider.of<FanProvider>(
    navigationKey.currentContext!,
  );

  void _increaseSpeed() {
    setState(() {
      if (fanProvider.fanLevel < 3) {
        fanProvider.toggleChannel(fanProvider.fanLevel + 1);
      }
    });
  }

  void _decreaseSpeed() {
    setState(() {
      if (fanProvider.fanLevel > 0) {
        fanProvider.toggleChannel(fanProvider.fanLevel - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.chevron_left, color: Colors.grey),
                  onPressed: _decreaseSpeed,
                ),
                Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      width: 30, // Adjust the width as needed
                      height: 30,
                      "assets/icons/fan.svg",
                      color: Colors.blue,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${fanProvider.fanLevel}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: Colors.grey),
                  onPressed: _increaseSpeed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TemperatureProgress extends StatelessWidget {
  final double temperature;
  final double maxValue;
  final Color coldColor;
  final Color moderateColor;
  final Color hotColor;
  final String text;

  TemperatureProgress({
    required this.text,
    required this.temperature,
    this.maxValue = 100.0,
    this.coldColor = Colors.blue,
    this.moderateColor = Colors.green,
    this.hotColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the percentage of the temperature relative to the maximum value
    var tomporaire;
    if (temperature > 0) {
      tomporaire = temperature;
    } else {
      tomporaire = -temperature;
    }

    double percentage = (tomporaire / maxValue).clamp(0.0, 1.0);

    // Determine the color based on the temperature range
    Color color;
    if (temperature < 0) {
      color = coldColor;
    } else {
      if (percentage < 0.33) {
        color = coldColor;
      } else if (percentage < 0.66) {
        color = moderateColor;
      } else {
        color = hotColor;
      }
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 200.0,
          height: 200.0,
          child: CircularProgressIndicator(
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            value: percentage,
            strokeWidth: 10.0, // Adjust the thickness of the progress indicator
          ),
        ),
        Column(
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal),
            ),
            Text(
              '${temperature.toStringAsFixed(1)}°',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
