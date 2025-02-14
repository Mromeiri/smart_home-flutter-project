// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/Screen/Modes/mode_provider.dart';
import 'package:smart_home/Screen/TV/tv_predict_screen.dart';
import 'package:smart_home/components/customIconButton.dart';
import 'package:smart_home/main.dart';
import 'package:smart_home/models/Global.dart';
import 'package:http/http.dart' as http;
import 'provider/tv_provider.dart';

class Channel {
  final String background;
  final String image;
  final String name;
  final String number;

  Channel(
      {required this.background,
      required this.image,
      required this.name,
      required this.number});
}

class TVScreen extends StatefulWidget {
  @override
  _TVScreenState createState() => _TVScreenState();
}

final List<Channel> channels = [
  Channel(background: '', image: "", name: "", number: "0"),
  Channel(
      background: 'assets/images/green.jpg',
      image: "assets/images/mbc3.png",
      name: "MBC3",
      number: "1"),
  Channel(
      background: 'assets/images/orange.png',
      image: "assets/images/nickelodeon.png",
      name: "nickelodeon",
      number: "2"),
  Channel(
      background: 'assets/images/blue.png',
      image: "assets/images/spacetoon.png",
      name: "spacetoon",
      number: "3"),
  Channel(
      background: 'assets/images/gray.jpg',
      image: "assets/images/boomerang.png",
      name: "boomerang",
      number: "4"),
  Channel(
      background: 'assets/images/gray.jpg',
      image: "assets/images/Cartoon_Network.png",
      name: "Cartoon Network",
      number: "5"),
  Channel(
      background: 'assets/images/green.jpg',
      image: "assets/images/jeem.png",
      name: "JEEM",
      number: "6"),
  // 'assets/images/pink.png',
  // 'assets/images/purple.png',
  // 'assets/images/sky_blue.png',
  // 'assets/images/green.jpg',
  // 'assets/images/blue.png',
];

class _TVScreenState extends State<TVScreen> {
  GlobalKey<State> _dialogKey = GlobalKey<State>();

  String predictedClass = '';
  double probabilityFanOff = 0.0;
  double probabilityActiveOn1 = 0.0;
  double probabilityActiveOn2 = 0.0;
  double probabilityActiveOn3 = 0.0;
  double probabilityActiveOn4 = 0.0;
  double probabilityActiveOn5 = 0.0;
  double probabilityActiveOn6 = 0.0;

  double executionTime = 0.0;
  final tvProvider = Provider.of<TvProvider>(
       navigationKey.currentContext!,
      listen: false,
    );
    final modeProvider = Provider.of<ModeProvider>(
    navigationKey.currentContext!,
    listen: false,
  );
  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('${Global.ipadress}/prediction_tv'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> result = json.decode(response.body);
      print(result['Predicted class']);

      setState(() {
        predictedClass = result['Predicted class'].toString();
        probabilityFanOff = result['probability_class0'];
        probabilityActiveOn1 = result['probability_class1'];
        probabilityActiveOn2 = result['probability_class2'];
        probabilityActiveOn3 = result['probability_class3'];
        probabilityActiveOn4 = result['probability_class4'];
        probabilityActiveOn5 = result['probability_class5'];
        probabilityActiveOn6 = result['probability_class6'];
        executionTime = result['execution Time'];
      });
       if (modeProvider.currentMode!.name == "Smart Mode") {
        tvProvider.setTVChannel(int.parse(predictedClass));
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tvProvider = Provider.of<TvProvider>(context);
    int? _selectedChannel = tvProvider.channel;
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
                        "TV",
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
                                builder: (context) => TvPredictScreen(
                                      executionTime: executionTime.toString(),
                                      probabilityActiveOn1:
                                          probabilityActiveOn1.toString(),
                                      probabilityActiveOn2:
                                          probabilityActiveOn2.toString(),
                                      probabilityActiveOn3:
                                          probabilityActiveOn3.toString(),
                                      probabilityActiveOn4:
                                          probabilityActiveOn4.toString(),
                                      probabilityActiveOn5:
                                          probabilityActiveOn5.toString(),
                                      probabilityActiveOn6:
                                          probabilityActiveOn6.toString(),
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
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: channels.length -
                      1, // Reduce the count by 1 to accommodate the shift
                  itemBuilder: (context, index) {
                    int shiftedIndex = index + 1;
                    return GestureDetector(
                      onTap: () {
                        tvProvider.toggleChannel(channels[shiftedIndex]);
                        setState(() {
                          _selectedChannel = shiftedIndex;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedChannel == shiftedIndex
                                ? Colors.blue
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  10), // Apply borderRadius to the background image
                              child: Image.asset(
                                channels[shiftedIndex].background,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(),
                                    Center(
                                      child: Image.asset(
                                        channels[shiftedIndex].image,
                                        fit: BoxFit.contain,
                                        width:
                                            100, // Adjust the width of the image
                                        height:
                                            100, // Adjust the height of the image
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        channels[shiftedIndex].number,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
