import 'package:flutter/material.dart';

class SecondButton extends StatelessWidget {
  final String title;
  final Function onPressed;

  const SecondButton(
      {Key? key, required this.title, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
          onPressed: () {
            onPressed();
          },
          child: Text(
            title,
            style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 66, 14, 71),),
          )),
    );
  }
}