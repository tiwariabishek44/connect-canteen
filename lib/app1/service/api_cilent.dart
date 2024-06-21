import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ApiClient {
  Future<ApiResponse<T>> postFirebaseData<T>({
    required String collection,
    required Map<String, dynamic> requestBody,
    required T Function(dynamic json) responseType,
  }) async {
    try {
      // Convert the request body to JSON
      String jsonBody = jsonEncode(requestBody);

      // Make the POST request to Firebase
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection(collection)
          .add(jsonDecode(jsonBody));

      // If the request is successful, construct the response with the document ID
      final data = responseType != null
          ? responseType({'id': docRef.id, ...requestBody})
          : {'id': docRef.id, ...requestBody} as T;
      return ApiResponse.completed([data]);
    } catch (e, stackTrace) {
      log("Error occurred: $e\n$stackTrace",
          error: e); // Log the error along with the stack trace
      return ApiResponse.error("Failed to post data to Firebase");
    }
  }

  Future<SingleApiResponse<void>> update<T>({
    required T Function(QuerySnapshot) responseType,
    required Map<String, dynamic> filters,
    required Map<String, dynamic> updateField,
    required String collection,
  }) async {
    try {
      Query collectionRef = FirebaseFirestore.instance.collection(collection);
      filters.forEach((field, value) {
        collectionRef = collectionRef.where(field, isEqualTo: value);
      });

      QuerySnapshot documentsSnapshot = await collectionRef.get();

      // Update documents
      WriteBatch batch = FirebaseFirestore.instance.batch();
      documentsSnapshot.docs.forEach((doc) {
        batch.update(doc.reference, updateField);
      });
      await batch.commit();

      // Return a successful response with completion message
      return SingleApiResponse.completed("Update successful");
    } catch (e, stackTrace) {
      log("Error occurred: $e\n$stackTrace", error: e);
      return SingleApiResponse.error("Failed to update documents");
    }
  }
}

class SingleApiResponse<T> {
  ApiStatus status;
  T? response;
  String? message;

  SingleApiResponse.initial([this.message])
      : status = ApiStatus.INITIAL,
        response = null;

  SingleApiResponse.loading([this.message])
      : status = ApiStatus.LOADING,
        response = null;

  SingleApiResponse.completed(this.response)
      : status = ApiStatus.SUCCESS,
        message = null;

  SingleApiResponse.error([this.message])
      : status = ApiStatus.ERROR,
        response = null;

  @override
  String toString() {
    return "Status : $status \nData : $response \nMessage : $message";
  }
}

class ApiResponse<T> {
  ApiStatus status;
  List<T>? response;
  String? message;

  ApiResponse.initial([this.message])
      : status = ApiStatus.INITIAL,
        response = null;

  ApiResponse.loading([this.message])
      : status = ApiStatus.LOADING,
        response = null;
  ApiResponse.completed(this.response)
      : status = ApiStatus.SUCCESS,
        message = null;
  ApiResponse.error([this.message])
      : status = ApiStatus.ERROR,
        response = null;

  @override
  String toString() {
    return "Status : $status \nData : $response \nMessage : $message";
  }
}

enum ApiStatus { INITIAL, LOADING, SUCCESS, ERROR }
