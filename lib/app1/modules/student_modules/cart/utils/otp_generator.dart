import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:get/get.dart';

class OTPGenerator extends GetxController {
  var isotpshow = false.obs;
  Set<String> _generatedOTPs = {};

  String generateUniqueOTP(int length) {
    String otp;
    do {
      otp = generateOTP(length);
    } while (_generatedOTPs.contains(otp));
    _generatedOTPs.add(otp);
    return otp;
  }

  String generateOTP(int length) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(10));
    return values.join();
  }
}
