import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuItemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProduct(ProductResponseModel product) async {
    try {
      final docRef = _firestore.collection('productionProduct').doc();

      await docRef.set({
        'productId': docRef.id,
        'adminId': product.adminId,
        'name': product.name,
        'image': product.proudctImage,
        'price': product.price,
        'active': product.active,
        'referenceSchool': product.referenceSchool,
        'type': product.type,
      });
    } catch (e) {
      throw 'Failed to add product: $e';
    }
  }
}
