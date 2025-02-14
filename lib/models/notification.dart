// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_home/models/Global.dart';

class MyNotification {
  final String id;
  final String title;
  final String detail;
  final String thumnail;
  final String date;
  final String type;
  String? predectedClass;
  String? itemControlled;
  MyNotification(
      {required this.id,
      required this.title,
      required this.detail,
      required this.thumnail,
      required this.date,
      required this.type,
      this.predectedClass,
      this.itemControlled});

  factory MyNotification.fromJson(Map<String, dynamic> json) {
    print(json);
    return MyNotification(
      id: json['id'].toString(),
      title: json['title'].toString(),
      detail: json['body'].toString(),
      thumnail: json['image'].toString(),
      date: json['date'].toString(),
      type: json['type'].toString(),
      predectedClass: json['predectedClass'].toString(),
      itemControlled: json['itemControlled'].toString(),
    );
  }
}

// List<MyNotification> notificationss = [
//   MyNotification(
//       id: "1",
//       title: "ML",
//       detail: "Souhaitez-vous augmenter la vitesse de ventilateur a 3 ?",
//       thumnail: "",
//       date: DateTime.now().toIso8601String(),
//       type: "ML"),
//   MyNotification(
//       id: "2",
//       title: "WARNING ⚠️",
//       detail: "La temperature dans la chambre est trop elvee",
//       thumnail: "",
//       date: DateTime.now().toIso8601String(),
//       type: "Notification"),
// ];
// Future<List<MyNotification>> fetechnotification() async {
//   var url_abon_ultras =
//       Uri.http(Global.ipadressnohttp, 'get_annoucement_notification');

//   final response = await http.get(url_abon_ultras);

//   Iterable list = json.decode(response.body);

//   return list.map((model) => MyNotification.fromJson(model)).toList();
// }

class FetchResult<T> {
  final T? data;
  final String? error;

  FetchResult({this.data, this.error});
}

Future<FetchResult<List<MyNotification>>> fetechnotification() async {
  print("the id isss ${Global.id}");
  try {
    var url_abon_ultras = Uri.http(
        Global.ipadressnohttp, 'get_annoucement_notification/' + '1' + '/');

    final response = await http.get(url_abon_ultras);
    print(response.body);
    print(response.statusCode);
    print(response.headers);
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);

      List<MyNotification> enfantsList =
          list.map((model) => MyNotification.fromJson(model)).toList();
      return FetchResult<List<MyNotification>>(data: enfantsList);
    } else {
      print(response.body);
      print(response.statusCode);
      print(response.headers);
      // Return an error message if the response status code is not 200
      return FetchResult<List<MyNotification>>(
          error: 'Failed to load data: ${response.statusCode}');
    }
  } catch (error) {
    // Return an error message if an exception occurs during the HTTP request
    return FetchResult<List<MyNotification>>(
        error: 'Failed to fetch data: $error');
  }
}

List<MyNotification> notifications = [
  MyNotification(
      type: '',
      id: '1',
      date: '2021-02-01 17:51',
      detail: 'Exemple pour Notification',
      thumnail: 'assets/icons/notifications.svg',
      title: 'Notification Test'),
  MyNotification(
      type: '',
      id: '2',
      date: '2021-02-01 17:51',
      detail: 'Second Exemple pour Notification',
      thumnail: 'assets/icons/notifications.svg',
      title: 'Hello Bro 😊😁'),
  // MyNotification(
  //     id: '3',
  //     date: '2021-02-01 17:51',
  //     detail: 'Exemple pour Notification',
  //     thumnail: 'assets/icons/notifications.svg',
  //     title: 'Notification Test'),
  // MyNotification(
  //     id: '4',
  //     date: '2021-02-01 17:51',
  //     detail: 'Exemple pour Notification',
  //     thumnail: 'assets/icons/notifications.svg',
  //     title: 'Notification Test'),
  // MyNotification(
  //     id: '5',
  //     date: '2021-02-01 17:51',
  //     detail: 'Exemple pour Notification',
  //     thumnail: 'assets/icons/notifications.svg',
  //     title: 'Notification Test'),
];
