import 'package:flutter/material.dart';

class LightScreen extends StatelessWidget {
  final String predictedClass;
  final String probabilityInactive;
  final String probabilityActive;
  final String executionTime;
  LightScreen(
      {super.key,
      required this.predictedClass,
      required this.probabilityInactive,
      required this.probabilityActive,
      required this.executionTime});

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
            child: Text("probabilityActive : ${probabilityActive}"),
          ),
          Center(
            child: Text("executionTime : ${executionTime}s"),
          ),
        ],
      ),
    );
  }
}
