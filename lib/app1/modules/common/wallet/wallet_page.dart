import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/model/wallet_model.dart';
import 'package:connect_canteen/app1/modules/common/wallet/balance_load.dart';
import 'package:connect_canteen/app1/modules/common/wallet/utils/balance_card.dart';
import 'package:connect_canteen/app1/modules/common/wallet/utils/transctionItems.dart';
import 'package:connect_canteen/app1/modules/common/wallet/utils/transction_shrimmer.dart';
import 'package:connect_canteen/app1/modules/common/wallet/wallet_controller.dart';
import 'package:connect_canteen/app1/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WalletPage extends StatelessWidget {
  final String userId;
  final bool isStudent;
  final String name;
  final String image;

  WalletPage({
    Key? key,
    required this.userId,
    required this.isStudent,
    required this.name,
    required this.image,
  }) : super(key: key);

  String truncateName(String name, {int maxLength = 10}) {
    if (name.length <= maxLength) return name;
    return '${name.substring(0, maxLength)}...';
  }

  final walletController = Get.put(WalletController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        isLeadingBack: false,
        title: 'Profile',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !isStudent ? SizedBox.shrink() : _buildProfileCard(context),
              SizedBox(height: 1.h),
              Text(
                "Wallet",
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 1.h),
              BalanceCard(
                userid: userId,
              ),
              SizedBox(height: 2.h),
              _buildTransactionSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext) {
    return Container(
      width: 100.w,
      height: 14.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 237, 240, 240),
            Color.fromARGB(255, 218, 218, 218)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(66, 0, 0, 0),
            blurRadius: 2,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start, // Added this line
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name ! 👋',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 33, 33, 33),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Class',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(179, 69, 67, 67),
                    ),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 23.sp,
              backgroundColor: Colors.white,
              child: CachedNetworkImage(
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                imageUrl: image,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
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
            if (!isStudent)
              GestureDetector(
                onTap: () async {
                  Get.to(() => BalanceLoadPage(
                        oldBalance: '100',
                        id: userId,
                        name: name,
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryColor,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Add Balance",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 20),
        StreamBuilder<Wallet?>(
          stream: walletController.getWallet(userId),
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
              Wallet wallet = snapshot.data!;
              List<Transactions> transactions = wallet.transactions;

              if (transactions.isEmpty) {
                // Show "No transactions" message here
                return Center(child: Text('No transactions found'));
              } else {
                // Existing logic to sort and display transactions
                transactions.sort((a, b) => b.date.compareTo(a.date));
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    Transactions transaction = transactions[index];
                    log(transaction.date.toString());
                    return TransactionItem(
                      name: transaction.name,
                      date: transaction.date.toString(),
                      remarks: transaction.remarks,
                      amount: transaction.amount.toInt().toString(),
                      color: Colors.green, // Assuming all amounts are positive
                    );
                  },
                );
              }
            }
          },
        ),
      ],
    );
  }
}
