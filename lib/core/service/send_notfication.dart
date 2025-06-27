import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class NotificationSender {
  NotificationSender._();
  static final NotificationSender instance = NotificationSender._();

  Future<String?> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "singmet-2e7f8",
      "private_key_id": "11c04756e4874076a37bf45b8f1e10cff225ab1f",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCPGinGOlhA8Jkn\nb3t+hBt85WfXf4gF3JLhmkLhWwlDqErAnDJRac1UBS+bosKHSCaYcnD5/996p1jt\n5tZPIXBEORzJsYA+JmL4JeiRsA5xO97Fw/watRKwcWmsXrtnALz8qDHsWnBMw84S\nt5RXLy1JNZsgMyaFUn/w52CtqFFSJTLjqYqV79MLjlNlXf4ZAONxKO4AClIgGFcO\nEIkEP7H3ocNxNW0ldvb8AOnhaL4xEKHmAfUcYUqCai9u0Jh6ZvGwSOyPoOciXwTe\nZyExHrYcRzXjVRTVzLV7Q0xu2MUOK+Rovyhny3+BVsbK3AFa9mkp9T6h88Sm8ISh\n3KZKhpG3AgMBAAECggEALnPVv61M3Le9X5nGwsjri12EmeWiKBTz8Rv8Pd8pYLcO\nnPuXMepgZrfQPntVHkkDjlUH639t8gjEy2U1iDZYlSzc9XQTJxma4uabWj+GUKeY\npyX5fkntKS2HmhaeSs9oibOnkQvCjIi7KkRBeROtZahrFMbF6F1hfrf9ICIVU86X\nCtNFT2ZpbBzeNUSEpsITI+Dq9N//h2TezcrCe/1Ma85muwWfL03l47bGS4QVzfiH\ny4nkeNmTt0BDNcq8KrJvQprnNY8LoZee7HzdFFlikHfDO2R6Sf1b+8Y9bObqkAiZ\nvX/LEzWjXUqDH0kCFq3oe1ZjfKleWf9li37NXQBIEQKBgQDJhDH6g4ZUAdsun06H\n1x5QV4uoddHJRA4D+Sc/EJI6AuZkATWC4Of1/qJiXh1EhQHGJ/ykkiiP2r0ENme3\nI5S5gxsMRi3+WdeVBffJan6OvZ1cil3lVEv52JQqa4t3TYCGk+YyBB4a1fPR38Mg\nsdbjgHKG8eYRBm8q39mHcIIriwKBgQC1yt+/NgKsIg1Rj4QXXsGzTVuI5+C7yuA0\nfBFCvzCzXSwrBtKqsiV65Ld7Cu52+dad47B0V7RaqoQ/3n8L30wqyGKJbHy9BZ60\nEuuOuuxpMdKlZa0o1W2yQoKL5MfuY1LmMYju2CcXw7IVdZOmivF31S5/VZmEtD5B\n67114UooBQKBgAz50i4LYg7uv6pU372ngHAz8u46B/Qpya0/0eMhsgjCPwuZeFSh\nHs6cQuCKpt/OoLqdwIroTmxU7W7kAfGs/NqlMoyryDJknpkd9UKm9NdEJmnbDwjB\nUNMZuxCwNB7OgsQnqd72nOmldTnCatIkIW4syzMdSG84NthP6bXq7LbZAoGBAK0/\nt3Zpyag0F49H/7Gp+12edoKFwVYW5Q7/wg9jV81IGUS0DubgOfnhqL6ZT2ORfCgi\nitKFlvrlEH4x09ADsXoAWG/xNPuLNJEWiukOWSlzcvVvbdPBevZsji82DBezDpkU\nUhSVaMQsGzZ6RAlu1urF/rcZY+HlSIPYX0nNN7flAoGAQZQcb7cHV9/fl45HxsRR\nX9+0Kesy+EvL2sPKOTNYeuzk3W0lV/RolRvQEbktePkMVi5KpDfUvQtbQ99KRFmd\nrposS+MqoiZdJdPeMVZVUahGff3LuKU/OV7JaKU10z+WuamKp6FV/KwGxi/xyFEF\nvYA/20Ih5FwiLvdAm4VfZ08=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-fbsvc@singmet-2e7f8.iam.gserviceaccount.com",
      "client_id": "111226237675371437913",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40singmet-2e7f8.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    try {
      http.Client client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

      auth.AccessCredentials credentials =
          await auth.obtainAccessCredentialsViaServiceAccount(
              auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
              scopes,
              client);

      client.close();
      log("Access Token: ${credentials.accessToken.data}");
      return credentials.accessToken.data;
    } catch (e) {
      log("Error getting access token: $e");
      return null;
    }
  }

  Map<String, dynamic> getBody({
    required String fcmToken,
    required String title,
    required String body,
    required String userId,
    String? type,
  }) {
    return {
      "message": {
        "token": fcmToken,
        "notification": {"title": title, "body": body},
        "android": {
          "notification": {
            "notification_priority": "PRIORITY_MAX",
            "sound": "default"
          }
        },
        "apns": {
          "payload": {
            "aps": {"content_available": true}
          }
        },
        "data": {
          "type": type,
          "id": userId,
          "click_action": "FLUTTER_NOTIFICATION_CLICK"
        }
      }
    };
  }

  Future<void> sendNotification({
    required String fcmToken,
    required String title,
    required String body,
    required String userId,
    String? type,
  }) async {
    try {
      final serverKeyAuthorization = await getAccessToken();
      if (serverKeyAuthorization == null) {
        throw Exception('Failed to obtain access token');
      }

      const String urlEndPoint =
          "https://fcm.googleapis.com/v1/projects/singmet-2e7f8/messages:send"; // بيتغير حسب Project ID

      final dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $serverKeyAuthorization';

      final response = await dio.post(
        urlEndPoint,
        data: getBody(
          fcmToken: fcmToken,
          title: title,
          body: body,
          userId: userId,
          type: type ?? "message",
        ),
      );

      log('Notification sent - Status: ${response.statusCode}');
      log('Response Data: ${response.data}');
      log('Recipient FCM Token: $fcmToken');
    } catch (e) {
      log("Error sending notification: $e");
    }
  }
}
// عشان تجيب الحجات اللي عاوزه تتغير 
// step  1 اختار ااعدادات التطبيق + cloud messaging
// step  2 اختار 	Manage Service Accounts
// step  3 اختار 	 اضغط علي اللينك الي قدامك 
// step  4 اختار keys 
// step  5 اضغط علي add key
 // step  6 اختار create new key
// step  7 اختار json
// step  8 هيظهرلك ملف json افتحه هتلاقي فيه كل الحجات اللي انت عاوزها