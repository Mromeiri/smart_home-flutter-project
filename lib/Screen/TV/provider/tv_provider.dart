import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_home/Screen/TV/tv_screen.dart';
import 'package:smart_home/components/custom_dialog.dart';
import 'package:smart_home/main.dart';
import 'package:smart_home/models/Global.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home/models/temperature.dart';

class TvProvider with ChangeNotifier {
  int _channel = 0;

  int get channel => _channel;

  void setTVChannel(int _newTvChannel) {
    _channel = _newTvChannel;
    notifyListeners();
  }

  Future<void> toggleChannel(Channel _newTvChannel) async {
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
    var result = await switchTv(_newTvChannel);
    if (_dialogKey.currentContext != null) {
      Navigator.of(_dialogKey.currentContext!).pop();
    }
    print(result);
    if (result['status'] == "success") {
      _channel = int.parse(_newTvChannel.number);
    } else {
      CustomDialog.showGameOverDialog(navigationKey.currentContext!,
          Color(0XFFC72C41), result['message'], false);
    }

    notifyListeners();
  }
}

Future<Map<String, dynamic>> switchTv(Channel state) async {
  var url = Uri.http(Global.ipadressnohttp, '/switch_tv_channel/');
  final headers = <String, String>{
    'Content-Type': 'application/json',
  };
  final data = jsonEncode({
    'channel': state.number,
    'name': state.name, // Assuming you have the user ID
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
