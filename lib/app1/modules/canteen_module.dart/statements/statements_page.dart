import 'dart:developer';

import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app1/model/admin_summary.dart';
import 'package:connect_canteen/app1/model/wallet_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/order%20hold/utils/order_tile_shrimmer.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/statements/statement_controller.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/statements/utils/balance_filed.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/statements/utils/no_data_found.dart';
import 'package:connect_canteen/app1/modules/common/wallet/wallet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class StatementPage extends StatefulWidget {
  @override
  State<StatementPage> createState() => _StatementPageState();
}

class _StatementPageState extends State<StatementPage> {
  final statementController = Get.put(StatementController());
  DateTime _selectedDate = DateTime.now();

  void selectDate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 400,
            width: 300,
            child: SfDateRangePicker(
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                setState(() {
                  _selectedDate = args.value;
                  statementController.selectedDate.value =
                      "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";
                });
                Navigator.of(context).pop(); // Close the date picker dialog
              },
              initialSelectedDate: _selectedDate,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                'Statement',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date : ${statementController.selectedDate.value}',
                  style:
                      TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      selectDate();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8), // Adjust padding as needed
                        child: Row(
                          mainAxisSize: MainAxisSize
                              .min, // Ensure the row takes up minimum space needed
                          children: [
                            Icon(Icons.filter_list),
                            SizedBox(
                                width: 8), // Add space between icon and text
                            Text(
                              "Filter",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight
                                      .w600), // Adjust font size as needed
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder<List<TransctionResponseMode>>(
                  stream: statementController.getStatement(
                      'texasinternationalcollege',
                      statementController.selectedDate.value),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SingleChildScrollView(
                        child: ListView.builder(
                          itemCount: 5,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 50,
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      log('Error: ${snapshot.error}');
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return NodataFound();
                    }

                    var statements = snapshot.data!;

                    return Column(
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        TotalCollection(
                          totalCollection: statementController.grandTotal.value
                              .toStringAsFixed(1),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        SingleChildScrollView(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: statements.length,
                            itemBuilder: (context, index) {
                              var statement = statements[index];

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => WalletPage(
                                          grade: statement.className,
                                          userId: statement.userId,
                                          isStudent: true,
                                          name: statement.userName,
                                          image: '',
                                        ));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                statement.transactionDate
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18.0.sp,
                                                ),
                                              ),
                                              SizedBox(height: 0.6.h),
                                              Row(
                                                children: [
                                                  Icon(Icons.person_outline,
                                                      size: 17.sp),
                                                  SizedBox(width: 1.w),
                                                  Text(
                                                    '${statement.userName}',
                                                    style: TextStyle(
                                                      fontSize: 17.0,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '${statement.className}',
                                                style: TextStyle(
                                                  fontSize: 17.0.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          'Rs.${statement.amount.toStringAsFixed(1)}',
                                          style: TextStyle(
                                            fontSize: 17.0.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
