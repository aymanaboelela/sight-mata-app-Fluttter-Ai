// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:doctor_app/core/cache_data/App_cach_data.dart'
//     show AppCacheData;
// import 'package:doctor_app/core/cache_data/shared_preferences.dart';
// import 'package:doctor_app/core/utils/router/app_router.dart';
// import 'package:flutter/widgets.dart';
// import 'package:go_router/go_router.dart' show GoRouter;
// import 'package:http/http.dart' as http;
// import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'package:firebase_messaging/firebase_messaging.dart';


// class NotificationsHelper {
//   // creat instance of fbm
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   // initialize notifications for this app or device حطه في المين فايل
//   Future<void> initNotifications() async {
//     await _firebaseMessaging.requestPermission();
//     // get device token
//     String? deviceToken = await _firebaseMessaging.getToken();
//     CacheData.setData(key: AppCacheData.deviceToken, value: deviceToken!);
//     log(
//         "===================Device FirebaseMessaging Token====================");
//     log(deviceToken);
//     log(
//         "===================Device FirebaseMessaging Token====================");
//   }

// // handel notifications in case app is terminated
// void handleBackgroundNotifications(BuildContext context) async {
//   // 1. لو التطبيق كان مقفول وتم فتحه من نوتفكيشن
//   FirebaseMessaging.instance.getInitialMessage().then((message) {
//     if (message != null) {
//       _handleNotificationAction(message, context);
//     }
//   });

//   // 2. لو التطبيق في الخلفية والمستخدم ضغط على النوتفكيشن
//   FirebaseMessaging.onMessageOpenedApp.listen((message) {
//     _handleNotificationAction(message, context);
//   });

//   // 3. لو التطبيق مفتوح واستقبل النوتفكيشن مباشرة
//   FirebaseMessaging.onMessage.listen((message) {
//     _handleNotificationAction(message, context);
//   });
// }

// void _handleNotificationAction(RemoteMessage message, BuildContext context) {
//   final type = message.data['type'];
//   final title = message.notification?.title ?? 'إشعار';
//   final body = message.notification?.body ?? 'لديك إشعار جديد';

//   switch (type) {
//     case 'confirm':
//       log("[Notification] ✅ Confirm received");
//       GoRouter.of(context).pushReplacement(AppRouter.kHomeDoctorView);
//       break;

//     case 'reject':
//       log("[Notification] ❌ Reject received");
//       GoRouter.of(context).pushReplacement(AppRouter.kConfirmationDoctor);
//       break;
//     default:
//       log("[Notification] ⚠️ نوع إشعار غير معروف: $type");
//   }
// }

//   Future<String?> getAccessToken() async {
//     // is Change it with your service account firebase ????????????
//     final serviceAccountJson = {
//       "type": "service_account",
//       "project_id": "doctor-a479b",
//       "private_key_id": "97ac162af5993c73f991cbff2e39ae2bd43506f9",
//       "private_key":
//           "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDCy1wGUTLvE3rj\nykekcUPBNYQBM2f0r/jD6NO8vfR3aoWMSagVaX3n+HSWSjiOJWjwzktChSP0i97s\nXq8C/gZU56Bwipfg/9TA9QJEn82giDfz2/WSb1eIDWXZTN76tB6dsz1oeWXrGHYo\nFtXNpTsmaCS9eTGGY2JEG8PJ2lWtkR1wzItJZHK/U04sHlnbnfmzWsguSglr2FHV\nQWSpenz38uMX4e+bhn+tUyyt6Lb8o3lTRgx84O2lwNRKik9axsQO8uRrGfnMwHxz\nng+QN5rc46Iy2FseF4ymLdfa+vQfFaTQHu/NI/tGObSqSXjf1Odo9gAHC08RxgaW\nTSZlAB23AgMBAAECggEAPgXIKE7EW/Ek6NCoXQifXS5v+H3otLUvDRneCTOmWjt1\niESPmzm6mBi47n11YnUw47ObrPN9jkjW0wYWzWoalAAoSo0mbMKoeEPK1BTZwSp+\nPkwj9dsz0KMLcdQTD1o4gVfnzpMQy3k/beZPbyoUGleAkz+6cCLG0A7TGTtGmnuS\n1UfLq8rl4Y6oiQk5A+i5Zbnd24Wwk85iiw1VrllanlLrGrSlssSXj2ZyJcKEKxnA\nZzs6WWaUwjinop6W6stuqivo/lX2am5oKtLmrIeRcbXv4RqkFtqxbNOlWOO4FSxB\nevz+XZvNzbMxyyTUo4gNVURZVuZekIf8LbTsPiFFOQKBgQDlY+TTboPz35zDjF//\ncLyynicIFc5vkM0guBu39WGITH9hTeSMZ6DnyCscGOtydebvXgf6UjyJTN+DjTsQ\np47Fbl0kq5GhDvD12ihHUf+F09PIuD8Ca0aEbbjLxrhdEw6BAVc6LLOMUaB2x9tw\nlUqqE9oHDLEhU/TTj+EtPCV35QKBgQDZZBZcxNL0nkSbF3WaL5QuQj9l4grOYcLR\nTmrrYq95cJtAKK25rQ3EgJgdlW9jGnI/uTTf/on24XTnPfm0Yksm4k+PjkbDl6in\nIb8UFGGyNjqJGOnV6ec/EK7UAcuzEZ425N6JRRaZzVDgw9Akxf+ZPeCTLG88yJHT\nUyhwBnjtawKBgQCE0E634EAEHo9MZWVbp7GJlaoxszaAQA2UiSR7YVakLO5/rzLJ\n3GI8cRgMv5zq+7rHEuF5nM2yDVFIgKgXH3y5cQn65l9+KgF3x2UUzjQtDxWLHKpW\nwzfkCwc47Qjn0tXN+bHAXAtlDgnjXBoA2F+Pk8jj1gRksJCLQb31i+KBxQKBgFXT\ncAi8JFUzTv60KlfvRN9mhEUjEwUcD6A3B3tbANA/JuwTo1LVAcR8yJGVd952iHik\nFD4C7lEr/c116GnRDL6TRrn0f/ekno8tgZTZ3yBOzJln3pn3uLZrTbqh4twVrpMZ\nlMo5Ho0mRDIY3MpH6XuEtG8mcdxbi0cVY7emtoN1AoGAFawStwMXoERRfYXPPwy1\nuvKELyYyyJFIfTa/IH+0k7z9VBCK4jbJJN4pT/4J1N6v/nh85Uh7WeZAKdsAvEYQ\ntvrvQRDSu5399joivXJl+5r6YTKN2WGf7HDJfxpFRCmDQB/ql/b5oBoKN+jsMOSO\nDorocoDNkNjOE6cNiidfk+A=\n-----END PRIVATE KEY-----\n",
//       "client_email":
//           "firebase-adminsdk-fbsvc@doctor-a479b.iam.gserviceaccount.com",
//       "client_id": "100382234005500318731",
//       "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//       "token_uri": "https://oauth2.googleapis.com/token",
//       "auth_provider_x509_cert_url":
//           "https://www.googleapis.com/oauth2/v1/certs",
//       "client_x509_cert_url":
//           "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40doctor-a479b.iam.gserviceaccount.com",
//       "universe_domain": "googleapis.com"
//     };

//     List<String> scopes = [
//       "https://www.googleapis.com/auth/userinfo.email",
//       "https://www.googleapis.com/auth/firebase.database",
//       "https://www.googleapis.com/auth/firebase.messaging"
//     ];

//     try {
//       http.Client client = await auth.clientViaServiceAccount(
//           auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

//       auth.AccessCredentials credentials =
//           await auth.obtainAccessCredentialsViaServiceAccount(
//               auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//               scopes,
//               client);

//       client.close();
//       log("Access Token/////: ${credentials.accessToken.data}"); // Print Access Token
//       return credentials.accessToken.data;
//     } catch (e) {
//       print("Error getting access token: $e");
//       return null;
//     }
//   }

//   Map<String, dynamic> getBody({
//     required String fcmToken,
//     required String title,
//     required String body,
//     required String userId,
//     String? type,
//   }) {
//     return {
//       "message": {
//         "token": fcmToken,
//         "notification": {"title": title, "body": body},
//         "android": {
//           "notification": {
//             "notification_priority": "PRIORITY_MAX",
//             "sound": "default"
//           }
//         },
//         "apns": {
//           "payload": {
//             "aps": {"content_available": true}
//           }
//         },
//         "data": {
//           "type": type,
//           "id": userId,
//           "click_action": "FLUTTER_NOTIFICATION_CLICK"
//         }
//       }
//     };
//   }

//   // الميثود المستخمه في ارسال النوتفكيشن

//   Future<void> sendNotifications({
//     required String fcmTokenResever,
//     required String title,
//     required String notificationBody,
//     required String userId,
//     String? type,
//   }) async {
//     try {
//       var serverKeyAuthorization = await getAccessToken();

//       // change your project id
//       const String urlEndPoint =
//           "https://fcm.googleapis.com/v1/projects/doctor-a479b/messages:send";
//       //   // change your project id
//       //   "https://fcm.googleapis.com/v1/projects/(YourProjectId)/messages:send";

//       Dio dio = Dio();
//       dio.options.headers['Content-Type'] = 'application/json';
//       dio.options.headers['Authorization'] = 'Bearer $serverKeyAuthorization';

//       var response = await dio.post(
//         urlEndPoint,
//         data: getBody(
//           userId: userId,
//           fcmToken: fcmTokenResever,
//           title: title,
//           body: notificationBody,
//           type: type ?? "message",
//         ),
//       );

//       // Print response status code and body for debugging
//       log('Response Status Code: ${response.statusCode}');
//       log('Response Data: ${response.data}');
//       log('token device resver: $fcmTokenResever');
//     } catch (e) {
//       log("Error sending notification: $e");
//     }
//   }
// }

// // testing the notification with postman 
// // {
// //   "message": {
// //     "token": "device token ?????????????????",
// //     "notification": {
// //       "title": "Notification Title",
// //       "body": "Notification Body"
// //     },
// //     "android": {
// //       "notification": {
// //         "notification_priority": "PRIORITY_MAX",
// //         "sound": "default"
// //       }
// //     },
// //     "apns": {
// //       "payload": {
// //         "aps": {
// //           "content_available": true
// //         }
// //       }
// //     },
// //     "data": {
// //       "type": "type",
// //       "id": "userId",
// //       "click_action": "FLUTTER_NOTIFICATION_CLICK"
// //     }
// //   }
// // }
// ////// in headers 
// ///Authorization : Bearer access token
// // Content-Type : application/json

// // POST https://fcm.googleapis.com/v1/projects/(myproject-b5ae1)/messages:send