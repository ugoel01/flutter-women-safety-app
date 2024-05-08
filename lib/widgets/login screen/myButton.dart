import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  bool loading;
  MyButton(
      {required this.title, required this.onPressed, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            onPressed();
          },
          child: Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 66, 14, 71),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
        ),
      ),
    );
  }
}