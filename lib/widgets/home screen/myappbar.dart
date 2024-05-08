// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/utils/quotes.dart';

class MyAppBar extends StatelessWidget {
  final int? quoteIndex;

  MyAppBar({this.quoteIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, bottom: 8.0),
      child: GestureDetector(
        child: Container(
          child: Text(
            quoteIndex != null
                ? (quoteIndex! < welcomeQuotes.length // Check if index is valid
                    ? welcomeQuotes[quoteIndex!]
                    : 'We are always available to help you') // Handle invalid index
                : 'No quote available',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
