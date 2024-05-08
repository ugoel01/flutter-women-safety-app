import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/db/db_services.dart';
import 'package:flutter_women_safety_app/models/contactsm.dart';
import 'package:flutter_women_safety_app/widgets/login%20screen/secondButton.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
class EmergencyButton extends StatefulWidget {
  @override
  State<EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<EmergencyButton> {
  Position? _curentPosition;
  String? _curentAddress;
  LocationPermission? permission;

  Future<bool> _requestSmsPermission() async {
    final status = await Permission.sms.request();
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('SMS permission is required to send emergency messages'),
      ));
      return false;
    }
  }


  _sendSms(String phoneNumber, String message) async {
    SmsStatus result = await BackgroundSms.sendMessage(
      phoneNumber: phoneNumber,
      message: message,
      simSlot: 1,
    );
    if (result == SmsStatus.sent) {
      print("Sent");
      Fluttertoast.showToast(msg: "SMS sent");
    } else {
      Fluttertoast.showToast(msg: "Failed to send SMS");
    }
  }


  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      if(mounted){
        setState(() {
          _curentPosition = position;
          print(_curentPosition!.latitude);
          _getAddressFromLatLon();
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  _getAddressFromLatLon() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _curentPosition!.latitude, _curentPosition!.longitude);

      Placemark place = placemarks[0];
      setState(() {
        _curentAddress =
            "${place.locality},${place.postalCode},${place.street},";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  getAndSendSMS() async {
    List<TContact> contactList = await DatabaseHelper().getContactList();
      if (contactList.isEmpty) {
        Fluttertoast.showToast(msg: "Emergency contact is empty");
        return;
      }
      String messageBody = "https://.google.com/maps/search/?api=1&query=${_curentPosition?.latitude}%2C${_curentPosition?.longitude}. $_curentAddress";
      contactList.forEach((element) => _sendSms(element.number, "I am in trouble. Please reach me at $messageBody"));
      Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Container(
        child: ClipOval(
          child: Material(
            color: Color.fromARGB(255, 184, 16, 10), // Customize button color
            child: InkWell(
              onTap: () {
                _showConfirmationDialog(); 
              },
              child: SizedBox(
                width: 150,
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Wrap Text in a Row
                  children: [
                    Text(
                      'Emergency',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _showConfirmationDialog() async {
    if (await _requestSmsPermission()) { // Request SMS permission first
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Do you wish to send SMS to your contacts?'),
            actions: [
              SecondButton(
                title: 'cancel',
                onPressed: () => Navigator.of(context).pop(),
              ),
              SecondButton(
                title: 'send',
                onPressed: () {
                  getAndSendSMS();
                },
              ),
            ],
          );
        },
      );
    }
  }
}