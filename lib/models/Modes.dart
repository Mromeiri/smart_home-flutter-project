import 'dart:convert';

import 'package:smart_home/models/Global.dart';
import 'package:http/http.dart' as http;

class Mode {
  final String name;

  Mode({
    required this.name,
  });
  factory Mode.fromJson(Map<String, dynamic> json) {
    return Mode(
      name: json['name'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

List<Mode> modesList = [
  Mode(
    name: "Smart Mode",
  ),
  Mode(
    name: "User Mode",
  ),
  Mode(
    name: "Assisted Mode",
  )
];
Future<Mode> fetchMode() async {
  var url_abon_ultras = Uri.http(Global.ipadressnohttp, 'get_mode_state');

  final response = await http.get(url_abon_ultras);

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    return Mode.fromJson(jsonData);
  } else {
    throw Exception('Failed to load temps');
  }
}
