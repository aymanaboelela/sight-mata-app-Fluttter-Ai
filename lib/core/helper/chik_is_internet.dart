// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'dart:io'; // لاستخدام HttpClient للتحقق من الوصول إلى الإنترنت
// import 'package:flutter_bloc/flutter_bloc.dart';

// /// Define the states for internet connection.
// abstract class NetworkState {}

// class NetworkInitial extends NetworkState {}

// class NetworkConnected extends NetworkState {
//   final bool isConnected;
//   NetworkConnected(this.isConnected);
// }

// class NetworkDisconnected extends NetworkState {}

// /// Define the BLoC class.
// class NetworkBloc extends Cubit<NetworkState> {
//   final Connectivity _connectivity = Connectivity();

//   NetworkBloc() : super(NetworkInitial()) {
//     _monitorConnection();
//   }

//   // مراقبة التغييرات في الاتصال
//   Future<void> _monitorConnection() async {
//     _connectivity.onConnectivityChanged.listen((ConnectivityResult result) async {
//       bool isWorking = await _checkInternetConnection(result);
//       if (isWorking) {
//         emit(NetworkConnected(true)); // الإنترنت يعمل بشكل جيد
//       } else {
//         emit(NetworkDisconnected()); // الإنترنت ضعيف أو غير متاح
//       }
//     });
//   }

//   // دالة لفحص الاتصال بالإنترنت
//   Future<bool> _checkInternetConnection(ConnectivityResult result) async {
//     if (result == ConnectivityResult.none) {
//       return false; // لا يوجد اتصال بالشبكة
//     }

//     try {
//       final url = Uri.parse('https://www.google.com');
//       final response = await HttpClient().getUrl(url);
//       final res = await response.close();

//       if (res.statusCode == 200) {
//         return true; // الإنترنت يعمل بشكل جيد
//       } else {
//         return false; // الإنترنت ضعيف أو غير متاح
//       }
//     } catch (e) {
//       return false; // إذا حدث خطأ
//     }
//   }
// }
