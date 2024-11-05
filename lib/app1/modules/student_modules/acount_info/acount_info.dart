import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/acount_info/account_info_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/acount_info/class_update.dart';
import 'package:connect_canteen/app1/modules/student_modules/acount_info/name_update.dart';
import 'package:connect_canteen/app1/modules/student_modules/acount_info/utils/photo_permission.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class AccountInfo extends StatelessWidget {
  AccountInfo({super.key});
  final accountInfoController = Get.put(AccountInfoController());
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder<StudentDataResponse?>(
        stream: loginController.getStudetnData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerLoading();
          } else if (snapshot.hasError || snapshot.data == null) {
            return _buildErrorState();
          }

          StudentDataResponse studentData = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(studentData),
                SizedBox(height: 2.h),
                _buildQuickStats(studentData),
                SizedBox(height: 3.h),
                _buildSectionTitle("Account Information"),
                _buildInfoSection(studentData, theme),
                SizedBox(height: 3.h),
                _buildSectionTitle("Preferences"),
                _buildPreferencesSection(theme),
                SizedBox(height: 3.h),
                _buildLogoutButton(),
                SizedBox(height: 2.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(StudentDataResponse studentData) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 5.h),
          Container(
            width: 100.sp,
            child: Text(
              studentData.name,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            studentData.classes,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(StudentDataResponse studentData) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildStatItem(
            icon: Icons.food_bank_outlined,
            label: "Orders",
            value: "12",
          ),
          _buildStatDivider(),
          _buildStatItem(
            icon: Icons.star_outline,
            label: "Credits",
            value: " 0",
          ),
          _buildStatDivider(),
          _buildStatItem(
            icon: Icons.account_balance_wallet_outlined,
            label: "Deposit",
            value: "Rs 0",
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 24.sp),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[300],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInfoSection(StudentDataResponse studentData, ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoTile(
            theme,
            icon: Icons.person_outline,
            title: "Name",
            subtitle: studentData.name,
            onTap: () => _navigateToNameUpdate(studentData),
            showEdit: true,
          ),
          _buildDivider(),
          _buildInfoTile(
            theme,
            icon: Icons.school_outlined,
            title: "Class",
            subtitle: studentData.classes,
            onTap: () => _navigateToClassUpdate(studentData),
            showEdit: true,
          ),
          _buildDivider(),
          _buildInfoTile(
            theme,
            icon: Icons.phone_outlined,
            title: "Phone",
            subtitle: studentData.phone,
            isVerified: true,
          ),
          _buildDivider(),
          _buildInfoTile(
            theme,
            icon: Icons.email_outlined,
            title: "Email",
            subtitle: studentData.email,
            isVerified: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoTile(
            theme,
            icon: Icons.notifications_outlined,
            title: "Notifications",
            subtitle: "Order updates & offers",
            onTap: () {},
            showChevron: true,
          ),
          _buildDivider(),
          _buildInfoTile(
            theme,
            icon: Icons.security_outlined,
            title: "Privacy",
            subtitle: "Data usage & sharing",
            onTap: () {},
            showChevron: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool showEdit = false,
    bool showChevron = false,
    bool isVerified = false,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.primary,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
          if (isVerified)
            Icon(
              Icons.verified,
              color: Colors.green,
              size: 16.sp,
            ),
        ],
      ),
      trailing: showEdit
          ? Icon(Icons.edit, color: AppColors.primaryColor)
          : showChevron
              ? Icon(Icons.chevron_right, color: Colors.grey)
              : null,
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey[200]);
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[50],
          foregroundColor: Colors.red,
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout),
            SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(fontSize: 16.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            height: 20,
            margin: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
            color: Colors.white,
          ),
          // Add more shimmer placeholders as needed
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          SizedBox(height: 16),
          Text(
            "Error loading profile",
            style: TextStyle(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }

  void _showPhotoOptions(String userId) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return PhotoPermission(studentId: userId);
      },
    );
  }

  void _navigateToNameUpdate(StudentDataResponse studentData) {
    Get.to(
      () => NameUpdate(
        userId: studentData.userid,
        initialName: studentData.name,
      ),
      transition: Transition.cupertino,
    );
  }

  void _navigateToClassUpdate(StudentDataResponse studentData) {
    Get.to(
      () => ClassUpdate(
        userId: studentData.userid,
        initialName: studentData.classes,
        classOptions: [], // Pass your class options here
      ),
      transition: Transition.cupertino,
    );
  }
}
