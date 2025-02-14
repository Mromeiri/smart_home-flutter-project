import 'package:flutter/material.dart';

class FanPredictScreen extends StatelessWidget {
  final String predictedClass;
  final String probabilityInactive;
  final String probabilityActiveOn1;
  final String probabilityActiveOn2;

  final String probabilityActiveOn3;

  final String executionTime;
  FanPredictScreen(
      {super.key,
      required this.predictedClass,
      required this.probabilityInactive,
      required this.executionTime,
      required this.probabilityActiveOn1,
      required this.probabilityActiveOn2,
      required this.probabilityActiveOn3});

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
            child: Text("executionTime : ${executionTime}s"),
          ),
        ],
      ),
    );
  }
}
