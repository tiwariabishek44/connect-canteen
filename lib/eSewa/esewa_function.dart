import 'dart:convert';
import 'dart:developer';

import 'package:connect_canteen/eSewa.dart';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Esewa {
  pay() {
    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: Environment.test,
          clientId: kEsewaClientId,
          secretId: kEsewaSecretKey,
        ),
        esewaPayment: EsewaPayment(
          productId: "1d71jd81",
          productName: 'productName',
          productPrice: "22",
        ),
        onPaymentSuccess: (EsewaPaymentSuccessResult result) {
          log(result.toString());
        },
        onPaymentFailure: () {
          debugPrint('FAILURE');
        },
        onPaymentCancellation: () {
          debugPrint('CANCEL');
        },
      );
    } catch (e) {
      debugPrint('EXCEPTION');
    }
  }

  Future<void> verify(
    EsewaPaymentSuccessResult result, {
    required BuildContext context,
    required String classs,
    required String customer,
    required String groupid,
    required String cid,
    required String productName,
    required String productImage,
    required double price,
    required int quantity,
    required String groupcod,
    required String checkout,
    required String mealtime,
    required String date,
    required String customerimage,
  }) async {
    try {
      String basicAuth =
          'Basic ${base64.encode(utf8.encode('JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R:BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ=='))}';

      Map<String, String> headers = {
        'Authorization': basicAuth,
        'merchantId': kEsewaClientId,
        'merchantSecret': kEsewaSecretKey,
      };

      Uri uri = Uri.parse('https://rc.esewa.com.np/mobile/transaction');
      Uri finalUri = uri.replace(queryParameters: {'txnRefId': result.refId});

      http.Response response = await http.get(finalUri, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(customerimage);

        log("--------------${response.body}");
      } else {
        // Handle other status codes if needed
      }

      log(response.statusCode.toString());
    } catch (e) {
      print(e);
    }
  }
}
