import 'package:cloud_firestore/cloud_firestore.dart';

class APIClient {
  static Stream<List<T>> createStream<T>({
    required String collectionName,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? filters,
  }) {
    Query collectionRef = FirebaseFirestore.instance.collection(collectionName);

    // Apply filters if provided
    if (filters != null && filters.isNotEmpty) {
      filters.forEach((field, value) {
        collectionRef = collectionRef.where(field, isEqualTo: value);
      });
    }

    return collectionRef.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
