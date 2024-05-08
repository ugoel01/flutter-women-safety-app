import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/db/share_pref.dart';
import 'package:flutter_women_safety_app/utils/flutter_background_services.dart';
//import 'package:flutter_women_safety_app/home_screen.dart';
//import 'package:flutter_women_safety_app/login_screen.dart';
//import 'package:flutter_women_safety_app/utils/constants.dart';
import 'package:flutter_women_safety_app/widgets/home%20screen/bottom_page.dart';
//import 'package:workmanager/workmanager.dart';
//import 'package:flutter_women_safety_app/widgets/parentHomeScreen.dart';

// void callbackDispatcher() async {
//   Workmanager().executeTask((taskName, inputData) {
//     initializeService();
//     return Future.value(true);
//   });
// }

Future<void> main () async{
  WidgetsFlutterBinding.ensureInitialized();
  initializeService();
  // await Workmanager().initialize(callbackDispatcher);
  // await Workmanager().registerPeriodicTask("women safety app", "send location");
  Platform.isAndroid
   ? await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyDmZtDDN38qs2g_D_7E3kSsA4Eg9EC6OYo',
      appId: '1:450173741220:android:d44ca530619d96b9209e31',
      messagingSenderId: '450173741220',
      projectId: 'flutter-women-safety-app',
      storageBucket: 'flutter-women-safety-app.appspot.com'
      )) : await Firebase.initializeApp();
  await MySharedPrefference.init();
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Women Safety App',
debugShowCheckedModeBanner: false,
home: BottomPage()
);
}
}
