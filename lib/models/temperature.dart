import 'dart:convert';

import 'package:smart_home/models/Global.dart';
import 'package:http/http.dart' as http;

class Temperature {
  final double temperature;
  final double humidity;

  Temperature({required this.temperature, required this.humidity});
  factory Temperature.fromJson(Map<String, dynamic> json) {
    print(json['temp']);
    return Temperature(
      temperature: (json['temp']) as double,
      humidity: (json['humidity']) as double,
    );
  }
}

Future<Temperature> fetchtemperatures() async {
  var url_abon_ultras = Uri.http(Global.ipadressnohttp, 'get_temperature');

  final response = await http.get(url_abon_ultras);

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    return Temperature.fromJson(jsonData);
  } else {
    throw Exception('Failed to load temps');
  }
}
