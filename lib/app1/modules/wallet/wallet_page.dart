import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/modules/wallet/balance_load.dart';
import 'package:connect_canteen/app1/modules/wallet/utils/balance_card.dart';
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

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(now);
    final timeStamp = DateFormat('HH:mm\'', 'en').format(nepaliDateTime);
    final date = DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);

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
              _buildProfileCard(context, date),
              SizedBox(height: 1.h),
              BalanceCard(),
              SizedBox(height: 2.h),
              _buildTransactionSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, String date) {
    return Container(
      width: 100.w,
      height: 14.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
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
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
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
            if (isStudent)
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
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
            return TransactionItem(
              name: 'load',
              date: "20020200202",
              remarks: 'transaction.remarks',
              amount: '200',
              color: Colors.green,
            );
          },
        ),
      ],
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String name;
  final String date;
  final String remarks;
  final String amount;
  final Color color;

  const TransactionItem({
    required this.name,
    required this.remarks,
    required this.date,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color backgroundColor;
    if (name.toLowerCase() == 'load') {
      iconData = Icons.add_circle_outline;
      backgroundColor = Colors.green.shade100;
    } else if (name.toLowerCase() == 'purchase') {
      iconData = Icons.remove_circle_outline;
      backgroundColor = Colors.red.shade100;
    } else {
      iconData = Icons.account_circle;
      backgroundColor = Colors.grey.shade200;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                barrierColor: Colors.black.withOpacity(0.5),
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    backgroundColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Type:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '${name.toLowerCase() == 'load' ? "Balance Load" : 'Purchase'}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  'Date:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  date,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  name.toLowerCase() == 'load'
                                      ? "Last Time : Rs."
                                      : 'Item:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  remarks,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: CircleAvatar(
              radius: 25,
              backgroundColor: backgroundColor,
              child: Icon(
                iconData,
                color: color,
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "Rs.$amount",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: name.toLowerCase() == 'load' ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
