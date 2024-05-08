import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmergencyNo extends StatefulWidget {
  @override
  State<EmergencyNo> createState() => _EmergencyNoState();
}

class _EmergencyNoState extends State<EmergencyNo> {
  bool showTable = false;
_callNumber(number) async{
  await FlutterPhoneDirectCaller.callNumber(number);
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2.0,10.0,2.0,15.0),
                child: Column(
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () => setState(() => showTable = !showTable),
                      child: Text(showTable ? 'Emergency Numbers' : 'Emergency Numbers'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: showTable ? Colors.white.withOpacity(1.0) : Color.fromARGB(255, 13, 145, 221), // Change color based on state
                        foregroundColor: showTable ? Color.fromARGB(255, 13, 145, 221) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                        textStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),]),
              ),),
        Visibility(
          visible: showTable,
          child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: FixedColumnWidth(180),
                1: FixedColumnWidth(70),
                2: FixedColumnWidth(70)
              },
              children: [TableRow(
                children: [
                  Center(child: Text("National Emergency",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(130, 66, 53, 1),
                  ),),),
                  Padding(padding: EdgeInsets.all(6.0)),
                  InkWell(
                    onTap: () => _callNumber('112'),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Center(child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(50, 148, 239, 1),
                          borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(22.0, 4.0, 22.0, 4.0),
                          child: Column(
                            children: [
                              Icon(FontAwesomeIcons.phone,
                              color: Color.fromRGBO(255, 255, 255, 1)),
                              Text("112",
                              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontWeight: FontWeight.bold),)
                            ]
                          ),
                        ),
                      ),),
                    ),
                  )
                ]
              ),
              TableRow(
                children: [
                  Center(child: Text("Police",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(130, 66, 53, 1),
                  ),),),
                  Padding(padding: EdgeInsets.all(6.0)),
                  InkWell(
                    onTap: () => _callNumber('100'),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Center(child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(50, 148, 239, 1),
                          borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(22.0, 4.0, 22.0, 4.0),
                          child: Column(
                            children: [
                              Icon(FontAwesomeIcons.phone,
                              color: Color.fromRGBO(255, 255, 255, 1)),
                              Text("100",
                              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontWeight: FontWeight.bold),)
                            ]
                          ),
                        ),
                      ),),
                    ),
                  )
                ]
              ),
              TableRow(
                children: [
                  Center(child: Text("Ambulance",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(130, 66, 53, 1),
                  ),),),
                  Padding(padding: EdgeInsets.all(6.0)),
                  InkWell(
                    onTap: () => _callNumber('102'),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Center(child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(50, 148, 239, 1),
                          borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(22.0, 4.0, 22.0, 4.0),
                          child: Column(
                            children: [
                              Icon(FontAwesomeIcons.phone,
                              color: Color.fromRGBO(255, 255, 255, 1)),
                              Text("102",
                              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontWeight: FontWeight.bold),)
                            ]
                          ),
                        ),
                      ),),
                    ),
                  )
                ]
              ),
              TableRow(
                children: [
                  Center(child: Text("Women Helpline",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(130, 66, 53, 1),
                  ),),),
                  Padding(padding: EdgeInsets.all(6.0)),
                  InkWell(
                    onTap: () => _callNumber('1091'),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Center(child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(50, 148, 239, 1),
                          borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18.0, 4.0, 18.0, 4.0),
                          child: Column(
                            children: [
                              Icon(FontAwesomeIcons.phone,
                              color: Color.fromRGBO(255, 255, 255, 1)),
                              Text("1091",
                              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontWeight: FontWeight.bold),)
                            ]
                          ),
                        ),
                      ),),
                    ),
                  )
                ]
              ),
              ],
          ),
        ),
          ],
        )
        
      ),
    );
  }
}