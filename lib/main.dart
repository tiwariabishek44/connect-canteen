import 'dart:async';
import 'dart:io';

import 'package:connect_canteen/app/local_notificaiton/local_notifications.dart';
import 'package:connect_canteen/app/widget/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  // Initialize the Nepali locale data
  initializeDateFormatting('ne_NP');
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();

  tz.initializeTimeZones();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyA5VIVGPVFRcNLohPEako3CA8PUf0w5JNQ",
              appId: "1:999730318693:android:696c321cf43b858593a58c",
              messagingSenderId: "999730318693",
              projectId: "connect-cant",
              storageBucket: "connect-cant.appspot.com"))
      : await Firebase.initializeApp();

  //  // Initialize Firebase
  await GetStorage.init(); // Initialize GetStorage

//  handle in terminated state
  var initialNotification =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (initialNotification?.didNotificationLaunchApp == true) {
    LocalNotifications.onClickNotification.stream.listen((event) {
      Future.delayed(Duration(seconds: 1), () {
        // print(event);

        navigatorKey.currentState!.pushNamed('/another',
            arguments: initialNotification?.notificationResponse?.payload);
      });
    });
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    // Check initial connectivity status
    initConnectivity().then(_updateConnectionStatus);

    // Subscribe to connectivity changes
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<ConnectivityResult> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await Connectivity().checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return ConnectivityResult.none;
    }
    return result;
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        // Use Builder to get context inside the builder
        return Builder(
          builder: (context) {
            return GetMaterialApp(
              title: 'Connect Canteen',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              // Check connectivity status to determine which screen to show
              home: _connectionStatus == ConnectivityResult.none
                  ? OfflineScreen()
                  : SplashScreen(),
            );
          },
        );
      },
    );
  }
}

class OfflineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 3, 79, 117),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_wifi_off,
              size: 72,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'No Internet Connection',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Please check your connection and try again',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement your retry logic here
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// void main() {
//   runApp(MyApp());
// }

// class FoodOrderTime {
//   final String mealTime;
//   final String orderHoldTime;

//   FoodOrderTime({required this.mealTime, required this.orderHoldTime});
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Canteen Food Order Times',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: FoodOrderTimePage(),
//     );
//   }
// }

// class FoodOrderTimePage extends StatelessWidget {
//   final List<FoodOrderTime> foodOrderTimes = [
//     FoodOrderTime(mealTime: "09:00", orderHoldTime: "08:00"),
//     FoodOrderTime(mealTime: "12:30", orderHoldTime: "11:30"),
//     FoodOrderTime(mealTime: "18:00", orderHoldTime: "17:00"),
//   ];

//   // Function to check if the current time falls within the allowed order time range in Nepali time
//   bool isOrderTime() {
//     DateTime currentTime = DateTime.now().toUtc(); // Get current UTC time
//     var nepalTimeZoneOffset =
//         Duration(hours: 5, minutes: 45); // Nepal is UTC+5:45
//     currentTime = currentTime.add(nepalTimeZoneOffset); // Convert to Nepal time

//     // Convert current time to Nepali time
//     final nepaliCurrentTime = DateFormat('HH:mm').format(currentTime);

//     int currentHour = int.parse(nepaliCurrentTime.split(":")[0]);
//     return (currentHour >= 15 ||
//         currentHour < 8); // Order time is from 4 PM to 8 AM
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Canteen Food Order Times'),
//       ),
//       body: isOrderTime()
//           ? ListView.builder(
//               itemCount: foodOrderTimes.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return ListTile(
//                   title: Text('Meal Time: ${foodOrderTimes[index].mealTime}'),
//                   subtitle: Text(
//                       'Order Hold Time: ${foodOrderTimes[index].orderHoldTime}'),
//                 );
//               },
//             )
//           : Center(
//               child: Text(
//                 'Meal orders are accepted from 4 PM to 8 AM Nepali time.',
//                 style: TextStyle(fontSize: 16),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//     );
//   }
// }
