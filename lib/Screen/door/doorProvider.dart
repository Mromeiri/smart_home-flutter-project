import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_home/components/custom_dialog.dart';
import 'package:smart_home/main.dart';
import 'package:smart_home/models/Global.dart';
import 'package:http/http.dart' as http;

class DoorProvider with ChangeNotifier {
  bool _isOn = false;

  bool get ison => _isOn;

  Future<void> toggledoor(String pincode) async {
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
    var result = await switchDoor(!ison, pincode);

    if (_dialogKey.currentContext != null) {
      Navigator.of(_dialogKey.currentContext!).pop();
    }
    print(result);
    if (result['status'] == "success") {
      _isOn = !_isOn;
      if (pincode != "close") {
        Navigator.pop(
          navigationKey.currentContext!,
        );
      }
    } else {
      CustomDialog.showGameOverDialog(navigationKey.currentContext!,
          Color(0XFFC72C41), result['message'], false);
    }

    notifyListeners();
  }

  void initdoor(bool state) {
    _isOn = state;
    notifyListeners();
  }
}

Future<Map<String, dynamic>> switchDoor(bool state, String pincode) async {
  var url = Uri.http(Global.ipadressnohttp, '/switch_door/');
  final headers = <String, String>{
    'Content-Type': 'application/json',
  };
  final data = jsonEncode({
    'state': state,
    'pin_code': pincode, // Assuming you have the user ID
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
