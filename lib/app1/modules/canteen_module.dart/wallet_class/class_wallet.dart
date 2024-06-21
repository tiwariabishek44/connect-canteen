import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/model/school_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/student_list/studetn_list.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/wallet_class/class_wallet_controller.dart';
import 'package:connect_canteen/app1/modules/common/wallet/utils/transction_shrimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ClassWalletPage extends StatelessWidget {
  ClassWalletPage({super.key});
  final classlistController = Get.put(ClassListController());
  @override
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 4.0, // Adjusts the spacing above the title
        title: Text(
          'Wallet',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                'Class List',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: StreamBuilder<SchoolModel?>(
          stream:
              classlistController.getSchoolData("texasinternationalcollege"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: ((context, index) {
                    return TransctionShrimmer();
                  }));
            } else if (snapshot.hasError) {
              return Text('Error loading transactions');
            } else if (snapshot.data == null) {
              return SizedBox.shrink();
            } else {
              SchoolModel school = snapshot.data!;
              List<ClassModel> classes = school.classes;

              if (classes.isEmpty) {
                // Show "No transactions" message here
                return Center(child: Text('No transactions found'));
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: classes.length,
                  itemBuilder: (context, index) {
                    ClassModel grade = classes[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 3.h),
                      child: Container(
                        padding: EdgeInsets.all(2.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8.0,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap: () {
                            Get.to(() => StudentListPage(grade: grade.name),
                                transition: Transition.cupertinoDialog);
                          },
                          title: Text(
                            "${grade.name}" ?? '',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.sp),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: Color.fromARGB(255, 36, 37, 36)),
                        ),
                      ),
                    );
                    ;
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}
