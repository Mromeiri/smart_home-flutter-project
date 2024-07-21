import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_home/main.dart';
import 'package:smart_home/models/Global.dart';
import 'package:http/http.dart' as http;

class LightProvider with ChangeNotifier {
  bool _isOn = false;

  bool get ison => _isOn;

  Future<void> toggleLight() async {
    GlobalKey<State> _dialogKey = GlobalKey<State>();

    try {
      showDialog(
        context: navigationKey.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            key: _dialogKey,
            child: CircularProgressIndicator(),
          );
        },
      );
      bool result = await createBuyCourse(!_isOn);

      if (_dialogKey.currentContext != null) {
        Navigator.of(_dialogKey.currentContext!).pop();
      }
      if (result) {
        _isOn = !_isOn;

        notifyListeners();
      } else {}
    } catch (e) {}
  }

  void initLight(bool state) {
    print("sssssssssssssssssss");
    _isOn = state;
    notifyListeners();
  }
}

Future<bool> createBuyCourse(bool state) async {
  var url = Uri.http(Global.ipadressnohttp, '/switch_light/');
  final headers = <String, String>{
    'Content-Type': 'application/json',
  };
  final data = jsonEncode({
    'iss': state // Assuming you have the user ID
  });
  final response = await http.post(
    url,
    headers: headers,
    body: data,
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false; // Print the response body for debugging
  }
}
