import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.text,
    this.press,
  }) : super(key: key);
  final String? text;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    return SizedBox(
      width: double.infinity,
      height: (56 / 812.0) * _mediaQueryData.size.height,
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: Colors.white,
          backgroundColor: Color(0XFF12B2B8),
        ),
        onPressed: press as VoidCallback,
        child: Text(
          text!,
          style: TextStyle(
            fontSize: (16 / 375.0) * _mediaQueryData.size.width,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
