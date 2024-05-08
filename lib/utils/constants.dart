import 'package:flutter/material.dart';

showDialogueBox(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(text),
    ),
  );
}

Widget loadingWheel(BuildContext context) {
  return Center(
    child: CircularProgressIndicator(
    backgroundColor: Color.fromARGB(255, 66, 14, 71),
    color: Color.fromARGB(255, 106, 19, 135),
    strokeWidth: 5,
  ));
}