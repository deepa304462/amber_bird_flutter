import 'package:amber_bird/data/profile/ref.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//https://firebase.google.com/docs/cloud-messaging/flutter/client
class FCMSyncService {
  FCMSyncService._();

  static init() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    setupInteractedMessage();
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  static tokenSync(
    Ref profile,
  ) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    ClientService.post(path: 'notificationToken/add', payload: {
      'profile': profile.toMap(),
      'uniqueDeviceKey': profile.id,
      'deviceType': 'ANDROID',
      'token': fcmToken
    });
  }

  static Future<Map<String, dynamic>> getFCMData() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    return initialMessage!.data;
  }

  static subcribeTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  static unSubcribeTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }
}

// data from notification
void _handleMessage(RemoteMessage message) {
  if (message.data['type'] == 'chat') {}
}

// handle message on background state
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}
