import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/counter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('this is the group of counter class', () {
    final Counter counter = Counter();

    test('when we open the counter we get the value as 0', () {
      //Arrange
      //Act
      final value = counter.count;
      //Assert
      expect(value, 0);
    });
    test('this is the counter test as it increment it value increase to 1', () {
      //Arrange
      //Act
      counter.increment();
      final value = counter.count;
      //Assert
      expect(value, 1);
    });

    test('when we call this method the value is decrement to -1', () {
      //Act
      counter.decrement();
      final value = counter.count;
      //Assert
      expect(value, -1);
    });
  });
}
