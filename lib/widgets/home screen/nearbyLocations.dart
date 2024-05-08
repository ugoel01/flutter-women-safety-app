//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:flutter/widgets.dart';

class NearbyLocations extends StatelessWidget {
  const NearbyLocations({super.key});

Future<void> _openMap(location) async {
    String googleUrl = 'https://www.google.com/maps/search/$location';

    final Uri _url = Uri.parse(googleUrl);
    try {
      await launchUrl(_url);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'something went wrong! call emergency number');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2.0,1.0,2.0,6.0),
                child: Text("Important Locations Nearby",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  ),)
              )),
              SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                _openMap('Police station near me');
                              },
                              child: Card(
                                color: Color.fromARGB(255, 117, 128, 84),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: Center(
                                    child: Image.asset('assets/police.png',height: 32,),
                                  ),
                                ),
                              ),
                            ),
                            Text("Police stations")
                          ],
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                _openMap('Bus stop near me');
                              },
                              child: Card(
                                color: Color.fromARGB(255, 7, 137, 244),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: Center(
                                    child: Image.asset('assets/bus.png',height: 32,),
                                  ),
                                ),
                              ),
                            ),
                            Text("Bus stations")
                          ],
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                _openMap('Metro station near me');
                              },
                              child: Card(
                                color: Color.fromARGB(255, 242, 84, 21),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: Center(
                                    child: Image.asset('assets/metro.png',height: 32,),
                                  ),
                                ),
                              ),
                            ),
                            Text("Metro stations")
                          ],
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                _openMap('Hospitals near me');
                              },
                              child: Card(
                                color: Color.fromARGB(255, 211, 16, 16),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: Center(
                                    child: Image.asset('assets/hospital.png',height: 32,),
                                  ),
                                ),
                              ),
                            ),
                            Text("Hospitals")
                          ],
                        ),
                    ),
                  ],
                )),
        ]),
    );
  }
}