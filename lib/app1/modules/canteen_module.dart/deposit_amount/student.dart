import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/deposit_amount/classController.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/deposit_amount/deposit_amound_page.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/deposit_history/deposit_history_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class StudentListdepositPage extends StatelessWidget {
  final studentController = Get.put(StudentListController());
  final String schoolId = 'texasinternationalcollege';
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true, // This adds the back button
        title: Text(
          'Students',
          style: TextStyle(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.receipt_long),
            onPressed: () {
              Get.to(() => DepositHistoryPage());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildStudentList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) => searchQuery.value = value,
        decoration: InputDecoration(
          hintText: 'Search students...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentList() {
    return StreamBuilder<List<StudentDataResponse>>(
      stream: studentController.getStudents(schoolId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerEffect();
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading students'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No Students Found',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          );
        }

        return Obx(() {
          final filteredStudents = studentController.searchStudents(
            snapshot.data!,
            searchQuery.value,
          );

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: filteredStudents.length,
            itemBuilder: (context, index) {
              return _buildStudentCard(filteredStudents[index]);
            },
          );
        });
      },
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 80,
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStudentCard(StudentDataResponse student) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          Get.to(
            () => StudentDepositPage(),
            arguments: student,
          );
        },
        contentPadding: EdgeInsets.all(6),
        leading: CircleAvatar(
          backgroundColor: Colors.black,
          radius: 22,
          child: Text(
            student.name[0].toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 19.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          student.name,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Phone: ${student.phone}',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
