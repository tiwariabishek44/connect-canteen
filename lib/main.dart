import 'dart:async';
import 'dart:io';

import 'package:connect_canteen/app/local_notificaiton/local_notifications.dart';
import 'package:connect_canteen/app/widget/splash_screen.dart';
import 'package:connect_canteen/app_test/data%20_print_page.dart';
import 'package:connect_canteen/app_test/test_contorller%20.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:timezone/data/latest.dart' as tz;

final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
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
  final printController = Get.put(PrintController());
  final testcontorller = Get.put(TestContorller());
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
              onPressed: () {},
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
// import 'package:nepali_utils/nepali_utils.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'This Week\'s Dates (Nepali)',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ThisWeekNepaliDatesPage(),
//     );
//   }
// }

// class ThisWeekNepaliDatesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('This Week\'s Dates (Nepali)'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(
//             7,
//             (index) {
//               NepaliDateTime currentDate = NepaliDateTime.now();
//               int difference = index - currentDate.weekday + 1;
//               NepaliDateTime date = currentDate.add(Duration(days: difference));
//               String formattedDate =
//                   NepaliDateFormat('yyyy-MM-dd').format(date);
//               String dayOfWeek = DateFormat('EEEE').format(date.toDateTime());
//               return Text(
//                 '$formattedDate ($dayOfWeek)',
//                 style: TextStyle(fontSize: 18.0),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
