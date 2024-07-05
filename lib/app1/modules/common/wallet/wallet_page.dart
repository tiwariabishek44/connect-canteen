import 'dart:developer';

import 'package:connect_canteen/app1/model/transction_model.dart';
import 'package:connect_canteen/app1/modules/common/wallet/utils/balance_card.dart';
import 'package:connect_canteen/app1/modules/common/wallet/utils/transctionItems.dart';
import 'package:connect_canteen/app1/modules/common/wallet/utils/transction_shrimmer.dart';
import 'package:connect_canteen/app1/modules/common/wallet/transcton_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WalletPage extends StatefulWidget {
  final String userId;
  final bool isStudent;
  final String name;
  final String image;
  final String grade;

  WalletPage({
    Key? key,
    required this.grade,
    required this.userId,
    required this.isStudent,
    required this.name,
    required this.image,
  }) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final transctionController = Get.put(TransctionController());
  bool _showAllTransactions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 4.0, // Adjusts the spacing above the title
        title: Text(
          "Wallet",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                widget.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              BalanceCard(
                userid: widget.userId,
              ),
              SizedBox(height: 2.h),
              _buildTransactionSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        StreamBuilder<List<TransactionResponseModel>>(
          stream: transctionController.fetchAllTransction(
            widget.userId,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return TransctionShrimmer();
                },
              );
            } else if (snapshot.hasError) {
              log('Error: ${snapshot.error}');
              return Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Server Error',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: 50,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Sorry, no transaction happened till now.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              List<TransactionResponseModel> transactions = snapshot.data!;
              transactions.sort((a, b) => b.date.compareTo(a.date));
              int itemCount = _showAllTransactions
                  ? transactions.length
                  : (transactions.length > 5 ? 5 : transactions.length);

              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      TransactionResponseModel transaction =
                          transactions[index];
                      return TransactionItem(
                        transctionTime: transaction.date,
                        name: transaction.type,
                        date: transaction.date.toString(),
                        remarks: transaction.status,
                        amount: transaction.amount.toInt().toString(),
                        color:
                            Colors.green, // Assuming all amounts are positive
                      );
                    },
                  ),
                  if (transactions.length > 5)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showAllTransactions = !_showAllTransactions;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _showAllTransactions ? 'Show less' : 'Show more',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(
                              _showAllTransactions
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }
          },
        ),
      ],
    );
  }
}
