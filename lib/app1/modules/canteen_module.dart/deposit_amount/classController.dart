import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/model/school_model.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:get/get.dart';

class SchoolClassController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;
  var schoolData = Rxn<SchoolModel>();

  // Stream school data to get classes using schoolId as a filter
  Stream<SchoolModel?> getSchoolData(String schoolId) {
    return _firestore
        .collection('proudctionSchool')
        .where('schoolId', isEqualTo: schoolId)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return SchoolModel.fromJson({
          ...doc.data(),
          'schoolId': doc.id,
        });
      }
      return null;
    });
  }

  // Get class list sorted
  List<ClassModel> getSortedClasses(List<ClassModel> classes) {
    classes.sort((a, b) => a.name.compareTo(b.name));
    return classes;
  }
}

class StudentListController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;
  var students = <StudentDataResponse>[].obs;
  var isDepositing = false.obs;

  // Stream students filtered by school and class
  Stream<List<StudentDataResponse>> getStudents(String schoolId) {
    return _firestore
        .collection('productionStudents')
        .where('schoolId', isEqualTo: schoolId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => StudentDataResponse.fromJson({
                ...doc.data(),
                'id': doc.id,
              }))
          .toList();
    });
  }

  // Method to search students
  List<StudentDataResponse> searchStudents(
      List<StudentDataResponse> studentList, String query) {
    if (query.isEmpty) return studentList;

    return studentList.where((student) {
      return student.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Future<bool> processDeposit(
      StudentDataResponse student, double amount) async {
    try {
      isDepositing(true);

      // Create deposit transaction
      final depositRef = _firestore.collection('deposits').doc();

      await _firestore.runTransaction((transaction) async {
        // Create deposit record
        transaction.set(depositRef, {
          'studentId': student.userid,
          'amount': amount,
          'date': Timestamp.now(),
          'studentName': student.name,
          'className': student.classes,
          'schoolId': student.schoolId,
        });

        // Update student wallet balance
        final studentRef =
            _firestore.collection('productionStudents').doc(student.userid);
        transaction.update(studentRef, {
          'depositAmount': FieldValue.increment(amount),
        });
      });

      return true;
    } catch (e) {
      print('Deposit error: $e');
      return false;
    } finally {
      isDepositing(false);
    }
  }
}
