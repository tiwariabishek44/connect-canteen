import 'dart:async';
import 'dart:developer';
import 'package:connect_canteen/app1/cons/prefs.dart';
import 'package:connect_canteen/app1/modules/student_modules/homepage/homepage.dart';
import 'package:connect_canteen/app1/modules/student_modules/student_mainscreen/student_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/api_models/login_api_response.dart';
import '../../../services/api_client.dart';
import '../../../widget/snackbar_widget.dart';
import '../../student_modules/splash screen/splash_screen.dart';
import 'view/login_view.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var termsAndConditions = false.obs;
  var isPasswordVisible = false.obs;
  var isGuestLogin = false.obs;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final storage = GetStorage();
  String? token;
  var userId;
  String? formattedTokenExpiryDate;
  Timer? timer;

  @override
  void onClose() {
    // Dispose controllers when the controller is closed
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void userLogin() {
    if (loginFormKey.currentState!.validate()) {
      // dologin();
      Get.offAll(() => StudentMainScreenView());
    }
  }

  var isLoginLoading = false.obs;
  var loginApiResponse = ApiResponse<LoginResponse>.initial().obs;
  void dologin() async {
    isLoginLoading.value = true;
    final reqbody = {
      "email": emailController.text,
      "password": passwordController.text,
    };
    log("req body $reqbody");

    //==============Observe the API Response ===========
    // if (response.status == ApiStatus.SUCCESS) {
    //   log("lOGIN SUCCESSS:::::");
    //   isLoginLoading.value = false;
    //   // Call the article Controller for getting category list and navigation
    //   Get.off(() => SplashScreen());
    //   log(response.response.toString());
    //   token = loginApiResponse.value.response!.token.toString();
    //   userId = loginApiResponse.value.response!.userId;
    //   formattedTokenExpiryDate =
    //       loginApiResponse.value.response!.formattedTokenExpiryDate.toString();
    //   saveUserData(
    //     loginApiResponse.value.response!.token.toString(),
    //     loginApiResponse.value.response!.userId,
    //     loginApiResponse.value.response!.formattedTokenExpiryDate.toString(),
    //   );
    //   checkAutoLogout(); //set the duration value for logout immediately after login
    // } else {
    //   isLoginLoading.value = false;
    //   log("Login Failed: Error:${response.status}");
    //   getSnackBar(message: response.message);
    // }
  }

  void saveUserData(String token, var userId, String formattedTokenExpiryDate) {
    log("user data saved");
    storage.write(Prefs.userId, userId);
    storage.write(Prefs.formattedTokenExpiryDate, formattedTokenExpiryDate);
  }

  // -------------checks whether the access token has expire for autoLogout---------//
  void checkAutoLogout() {
    log('autologout function called');
    if (token == null) {
      log("from checkAutoLogout token is null");
      return; // No authentication data, do nothing
    }
    final currentDateTime = DateTime.now();
    final expiryTime = DateTime.parse(formattedTokenExpiryDate!)
        .difference(currentDateTime)
        .inSeconds;
    log('Expiry Date:::::::$formattedTokenExpiryDate');
    log('Date Time now:::::${DateTime.now()}');
    log('Time Remaining::::::$expiryTime');
    if (currentDateTime.isAfter(DateTime.parse(formattedTokenExpiryDate!))) {
      log('autoLogout1');
      clearUserData();
    } else {
      log('no autoLogout');
      timer = Timer(Duration(seconds: expiryTime), () {
        log("this is logout from timer");
        logout();
      });
    }
  }

  void logout() {
    clearUserData();
    // timer!.cancel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 0), () {
        Get.offAll(() => const LoginView());
        getSnackBar(message: 'You have been Log Out');
      });
    });

    // You can navigate to the login screen using Get's navigation system
    // Get.offAllNamed('/login');
  }

  void clearUserData() async {
    log('--------logout--------');
    token = null;
    userId = null;
    formattedTokenExpiryDate = null;
    // clear stored authentication data, navigate to the login screen
    storage.remove('token');
    storage.remove('userId');
    storage.remove('formattedTokenExpiryDate');
  }
}
