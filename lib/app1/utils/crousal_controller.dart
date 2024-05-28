import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarouselController extends GetxController {
  final List<String> carouselItems = ['Item 1', 'Item 2', 'Item 3'].obs;
  final RxInt currentIndex = 0.obs;
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    startTimer();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (currentIndex.value < carouselItems.length - 1) {
        currentIndex.value++;
      } else {
        currentIndex.value = 0;
      }
      pageController.animateToPage(
        currentIndex.value,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }
}
