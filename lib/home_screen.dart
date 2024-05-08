import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/widgets/home%20screen/aboutUs.dart';
import 'package:flutter_women_safety_app/widgets/home%20screen/emergencyButton.dart';
import 'package:flutter_women_safety_app/widgets/home%20screen/emergencyno.dart';
import 'package:flutter_women_safety_app/widgets/home%20screen/motivationQuotes.dart';
import 'package:flutter_women_safety_app/widgets/home%20screen/myappbar.dart';
import 'package:flutter_women_safety_app/widgets/home%20screen/nearbyLocations.dart';
// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //const HomeScreen({super.key});
  int qIndex=0;

  getRandomQuote(){
    Random random = Random();
    setState(() {
      qIndex=random.nextInt(5);
    });  
  }

  @override
  void initState(){
    getRandomQuote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 66, 14, 71),
        title: Text('Home'),
      ),
      resizeToAvoidBottomInset: true,
      body: Scrollbar(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                MyAppBar(
                quoteIndex: qIndex,
              ),
              MotivationQuotes(),
              EmergencyNo(),
              NearbyLocations(),
              SingleChildScrollView(child: EmergencyButton()),
              AboutUs(),
            ],
            ),
          ),
        ),
      ),
    );
  }
}