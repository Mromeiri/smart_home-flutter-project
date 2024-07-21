import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_home/Screen/TV/tv_screen.dart';
import 'package:smart_home/components/custom_dialog.dart';
import 'package:smart_home/main.dart';
import 'package:smart_home/models/Global.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home/models/temperature.dart';

class FanProvider with ChangeNotifier {
  int _fanLevel = 0;

  int get fanLevel => _fanLevel;

  void setFanLevel(int _newFanlevel) {
    _fanLevel = _newFanlevel;
    notifyListeners();
  }

  Future<void> toggleChannel(int _newFanlevel) async {
    GlobalKey<State> _dialogKey = GlobalKey<State>();

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
    var result = await switchFan(_newFanlevel);
    if (_dialogKey.currentContext != null) {
      Navigator.of(_dialogKey.currentContext!).pop();
    }
    print(result);
    if (result['status'] == "success") {
      _fanLevel = _newFanlevel;
    } else {
      CustomDialog.showGameOverDialog(navigationKey.currentContext!,
          Color(0XFFC72C41), result['message'], false);
    }

    notifyListeners();
  }
}

Future<Map<String, dynamic>> switchFan(int state) async {
  var url = Uri.http(Global.ipadressnohttp, '/switch_fan_level/');
  final headers = <String, String>{
    'Content-Type': 'application/json',
  };
  final data = jsonEncode({
    'fanLevel': state,
    // Assuming you have the user ID
  });
  final response = await http.post(
    url,
    headers: headers,
    body: data,
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    return jsonResponse;
  } else {
    return {"status": "error"}; // Print the response body for debugging
  }
}
