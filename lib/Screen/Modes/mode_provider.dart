// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home/main.dart';
import 'package:smart_home/models/Global.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home/models/Modes.dart';

class ModeProvider with ChangeNotifier {
  Mode? _mode;

  Mode? get currentMode => _mode;

  void changeMode(Mode mode) {
    print(mode.name);
    _mode = mode;
    notifyListeners();
  }

  bool isModeSelected(Mode mode) {
    if (_mode!.name.toLowerCase() == mode.name.toLowerCase()) return true;
    return false;
  }
}
