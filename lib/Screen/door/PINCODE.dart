// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/Screen/door/doorProvider.dart';
import 'package:smart_home/components/custom_dialog.dart';
import 'package:smart_home/components/default_button.dart';
import 'package:smart_home/constant.dart';
import 'package:smart_home/main.dart';
import 'package:smart_home/models/Global.dart';
import 'package:http/http.dart' as http;

class PINCODE extends StatefulWidget {
  const PINCODE({super.key});

  @override
  State<PINCODE> createState() => _PINCODEState();
}

class _PINCODEState extends State<PINCODE> {
  GlobalKey<State> _dialogKey = GlobalKey<State>();
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  final List<String?> errors = [];
  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
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

  String pin1Controller = '';
  String pin2Controller = '';
  String pin3Controller = '';
  String pin4Controller = '';
  @override
  Widget build(BuildContext context) {
    final doorProvider = Provider.of<DoorProvider>(context);

    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    return Container(
      decoration: BoxDecoration(
          color: Color(0XFF0E202E), borderRadius: BorderRadius.circular(20)),
      height: _mediaQueryData.size.height * 0.5,
      width: _mediaQueryData.size.width * 0.5,
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
                width: 150,
                height: 50,
                child: Image.asset('assets/images/pin.jpg')),
            SizedBox(
              height: 10,
            ),
            Text(
              "ENTER YOUR PINCODE",
              style: TextStyle(
                  color: Color(0XFF12B2B8), fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: (50 / 270) * _mediaQueryData.size.width,
                  height: (50 / 540) * _mediaQueryData.size.height,
                  child: TextFormField(
                    autofocus: true,
                    obscureText: false,
                    style: TextStyle(fontSize: 24, color: Color(0XFF12B2B8)),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {
                      removeError(error: kotp);
                      pin1Controller = value;
                      nextField(value, pin2FocusNode);
                    },
                  ),
                ),
                SizedBox(
                  width: (50 / 270) * _mediaQueryData.size.width,
                  height: (50 / 540) * _mediaQueryData.size.height,
                  child: TextFormField(
                      focusNode: pin2FocusNode,
                      obscureText: false,
                      style: TextStyle(fontSize: 24, color: Color(0XFF12B2B8)),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        removeError(error: kotp);
                        pin2Controller = value;
                        nextField(value, pin3FocusNode);
                      }),
                ),
                SizedBox(
                  width: (50 / 270) * _mediaQueryData.size.width,
                  height: (50 / 540) * _mediaQueryData.size.height,
                  child: TextFormField(
                      focusNode: pin3FocusNode,
                      obscureText: false,
                      style: TextStyle(fontSize: 24, color: Color(0XFF12B2B8)),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        removeError(error: kotp);
                        pin3Controller = value;
                        nextField(value, pin4FocusNode);
                      }),
                ),
                SizedBox(
                  width: (50 / 270) * _mediaQueryData.size.width,
                  height: (50 / 540) * _mediaQueryData.size.height,
                  child: Center(
                    child: TextFormField(
                      focusNode: pin4FocusNode,
                      obscureText: false,
                      style: TextStyle(fontSize: 24, color: Color(0XFF12B2B8)),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        removeError(error: kotp);
                        pin4Controller = value;
                        if (value.length == 1) {
                          pin4FocusNode!.unfocus();
                          // Then you need to check is the code is correct or not
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            // FormError(errors: errors),
            SizedBox(
              width: _mediaQueryData.size.width * 0.5,
              child: DefaultButton(
                text: "Continue",
                press: () async {
                  doorProvider.toggledoor(pin1Controller +
                      pin2Controller +
                      pin3Controller +
                      pin4Controller);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
