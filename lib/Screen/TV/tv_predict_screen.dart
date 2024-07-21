import 'package:flutter/material.dart';

class TvPredictScreen extends StatelessWidget {
  final String predictedClass;
  final String probabilityInactive;
  final String probabilityActiveOn1;
  final String probabilityActiveOn2;

  final String probabilityActiveOn3;
  final String probabilityActiveOn4;
  final String probabilityActiveOn5;

  final String probabilityActiveOn6;

  final String executionTime;
  TvPredictScreen(
      {super.key,
      required this.predictedClass,
      required this.probabilityInactive,
      required this.executionTime,
      required this.probabilityActiveOn1,
      required this.probabilityActiveOn2,
      required this.probabilityActiveOn3,
      required this.probabilityActiveOn4,
      required this.probabilityActiveOn5,
      required this.probabilityActiveOn6});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("predictedClass is : ${predictedClass}"),
          ),
          Center(
            child: Text("probabilityInactive : ${probabilityInactive}"),
          ),
          Center(
            child:
                Text("probability Fan Active on 1 : ${probabilityActiveOn1}"),
          ),
          Center(
            child:
                Text("probability Fan Active on 2 : ${probabilityActiveOn2}"),
          ),
          Center(
            child:
                Text("probability Fan Active on 3 : ${probabilityActiveOn3}"),
          ),
          Center(
            child:
                Text("probability Fan Active on 4 : ${probabilityActiveOn4}"),
          ),
          Center(
            child:
                Text("probability Fan Active on 5 : ${probabilityActiveOn5}"),
          ),
          Center(
            child:
                Text("probability Fan Active on 6 : ${probabilityActiveOn6}"),
          ),
          Center(
            child: Text("executionTime : ${executionTime}s"),
          ),
        ],
      ),
    );
  }
}
