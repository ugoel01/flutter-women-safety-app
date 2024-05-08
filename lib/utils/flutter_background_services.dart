import 'dart:async';
import 'dart:ui';
import 'package:background_sms/background_sms.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_women_safety_app/db/db_services.dart';
import 'package:flutter_women_safety_app/models/contactsm.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shake/shake.dart';
import 'package:vibration/vibration.dart';

Position? _curentPosition;

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

getAndSendSMS(messageBody) async {
    List<TContact> contactList = await DatabaseHelper().getContactList();
      if (contactList.isEmpty) {
        Fluttertoast.showToast(msg: "Emergency contact is empty");
        return;
      }
      
      contactList.forEach((element) =>
       _sendSms(element.number, "I am in trouble. Please reach me at $messageBody"));
  }

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    "women safety app",
    "foreground service",
    importance: Importance.high,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true,
        notificationChannelId: "women safety app",
        initialNotificationTitle: "foreground service",
        initialNotificationContent: "initializing",
        foregroundServiceNotificationId: 888,
      ));
  service.startService();
}

@pragma('vm-entry-point')
void onStart(ServiceInstance service) async {

  DartPluginRegistrant.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
              forceAndroidLocationManager: true)
          .then((Position position) {
        _curentPosition = position;
        print("bg location ${position.latitude}");
      }).catchError((e) {
        Fluttertoast.showToast(msg: e.toString());
      });

      ShakeDetector.autoStart(
          shakeThresholdGravity: 2.7,
          shakeSlopTimeMS: 500,
          shakeCountResetTime: 3000,
          minimumShakeCount: 1,
          onPhoneShake: () async {
            if (await Vibration.hasVibrator() ?? false) {
              if (await Vibration.hasCustomVibrationsSupport() ?? false) {
                Vibration.vibrate(duration: 1000);
              } else {
                Vibration.vibrate();
                await Future.delayed(Duration(milliseconds: 500));
                Vibration.vibrate();
              }
            }
            String messageBody = "https://.google.com/maps/search/?api=1&query=${_curentPosition?.latitude}%2C${_curentPosition?.longitude}";
            getAndSendSMS(messageBody);
          });

      flutterLocalNotificationsPlugin.show(
        888,
        "women safety app",
        "go to app",
        NotificationDetails(
            android: AndroidNotificationDetails(
              "women safety app",
              "foreground service",
              icon: 'ic_bg_service_small',
              ongoing: true,
            )),
      );
    }
  }
}