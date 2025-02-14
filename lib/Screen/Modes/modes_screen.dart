import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/Screen/Modes/mode_provider.dart';
import 'package:smart_home/Screen/home/homePage.dart';
import 'package:smart_home/Screen/lightScreen/provider/lightProvider.dart';
import 'package:smart_home/constant.dart';
import 'package:smart_home/main.dart';
import 'package:smart_home/models/Global.dart';
import 'package:smart_home/models/Modes.dart';
import 'package:http/http.dart' as http;

class ModesScreen extends StatefulWidget {
  const ModesScreen({super.key});

  @override
  State<ModesScreen> createState() => _ModesScreenState();
}

Future<bool> switchMode(Mode mode) async {
  var url = Uri.http(Global.ipadressnohttp, '/switch_mode/');
  final headers = <String, String>{
    'Content-Type': 'application/json',
  };
  final data = jsonEncode({
    'mode_name': mode.name // Assuming you have the user ID
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

class _ModesScreenState extends State<ModesScreen> {
  @override
  Widget build(BuildContext context) {
    final modeProvider = Provider.of<ModeProvider>(context);

    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          getAppBarUI(context),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: Column(
              children: getModesListUI(),
            ),
          ),
        ]));
  }

  List<Widget> getModesListUI() {
    GlobalKey<State> _dialogKey = GlobalKey<State>();

    final modeProvider = Provider.of<ModeProvider>(context);

    final List<Widget> noList = <Widget>[];
    for (int i = 0; i < modesList.length; i++) {
      final Mode mode = modesList[i];
      noList.add(
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            onTap: () async {
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
                bool result = await switchMode(mode);

                if (_dialogKey.currentContext != null) {
                  Navigator.of(_dialogKey.currentContext!).pop();
                }
                if (result) {
                  modeProvider.changeMode(mode);
                } else {}
              } catch (e) {}
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      mode.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  CupertinoSwitch(
                    activeColor: modeProvider.isModeSelected(mode)
                        ? kSecondaryColor
                        : Colors.grey.withOpacity(0.6),
                    onChanged: (bool value) async {
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
                        bool result = await switchMode(mode);

                        if (_dialogKey.currentContext != null) {
                          Navigator.of(_dialogKey.currentContext!).pop();
                        }
                        if (result) {
                          modeProvider.changeMode(mode);
                        } else {}
                      } catch (e) {}
                    },
                    value: modeProvider.isModeSelected(mode),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      // if (i == 0) {
      //   noList.add(const Divider(
      //     height: 1,
      //   ));
      // }
    }
    return noList;
  }

  // void checkAppPosition(int index) {
  //   if (index == 0) {
  //     if (modesList[0].isSelected) {
  //       modesList.forEach((d) {
  //         d.isSelected = false;
  //       });
  //     } else {
  //       modesList.forEach((d) {
  //         d.isSelected = true;
  //       });
  //     }
  //   } else {
  //     modesList[index].isSelected = !modesList[index].isSelected;

  //     int count = 0;
  //     for (int i = 0; i < modesList.length; i++) {
  //       if (i != 0) {
  //         final Mode data = modesList[i];
  //         if (data.isSelected) {
  //           count += 1;
  //         }
  //       }
  //     }

  //     if (count == modesList.length - 1) {
  //       modesList[0].isSelected = true;
  //     } else {
  //       modesList[0].isSelected = false;
  //     }
  //   }
  // }
}
