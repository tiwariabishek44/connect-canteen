import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  var isLoading = false.obs;

  final http.Client httpClient;

  LoginController({required this.httpClient});

  var loginSuccess = true.obs;

  Future<void> login() async {
    try {
      isLoading.value = false;

      // Your API endpoint for login
      const apiUrl = 'http://192.168.1.69:8080/api/open/student/login';

      // Parameters for the login request
      final data = {
        'email': emailcontroller.text.trim(),
        'password': passwordcontroller.text.trim(),
      };

      // Send a POST request to the API
      final response = await httpClient.post(
        Uri.parse(apiUrl),
        body: data,
      );

      // Check the status code of the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successful login
        loginSuccess.value = true;
      } else {
        loginSuccess.value = false;
      }
    } catch (e) {
      loginSuccess.value = false;
    }
  }

// to fetch news

  var newsLoded = false.obs;
  Future<void> newsFetch() async {
    try {
      newsLoded(false);
      final response = await httpClient
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      // Send a POST request to the API

      if (response.statusCode == 200 || response.statusCode == 201) {
        newsLoded(true);
      } else {
        newsLoded(false);
      }
    } catch (e) {
      newsLoded(false);
    }
  }
}
