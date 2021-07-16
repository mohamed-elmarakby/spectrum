import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vibration/vibration.dart';
import 'package:http/http.dart' as http;

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async {
  print(message);
  if (await Vibration.hasVibrator()) {
    Vibration.vibrate();
  }
}

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future<String> getToken() async {
    return await _fcm.getToken();
  }

  Future initialise() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.getToken().then((val) {});
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print(message);
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate();
        }
      },
      onBackgroundMessage: backgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print(message);
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate();
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print(message);
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate();
        }
      },
    );
  }

  Future<bool> callOnFcmApiSendPushNotifications(
      {List<String> userToken, String body, String title}) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "registration_ids": userToken,
      "collapse_key": "type_a",
      "notification": {
        "title": '$title',
        "body": '$body',
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          "key=AAAAopCRUnU:APA91bHbW80Rb8XwoE630RUTPjsuQhURAokqjBtGPYztP2yR8cAGYwnfaepn3UUc542n1BL30xPDkwByfgrJS9U9HNaG5dvZRz-57yP55Djnhkpf6XkDzhDAqqMGiLTYrr3dVumtiaAc" // 'key=YOUR_SERVER_KEY'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      log('test ok push CFM');
      return true;
    } else {
      log(' CFM error');
      // on failure do sth
      return false;
    }
  }
}
