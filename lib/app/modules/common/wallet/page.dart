import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/models/wallet_model.dart';
import 'package:connect_canteen/app/modules/common/wallet/balance_load.dart';
import 'package:connect_canteen/app/modules/common/wallet/controller.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app/widget/custom_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WalletPage extends StatelessWidget {
  final WalletController walletController = Get.put(WalletController());

  final String userId;
  final bool isStudent;
  final String name;
  final String image;
  WalletPage(
      {Key? key,
      required this.userId,
      required this.isStudent,
      required this.name,
      required this.image})
      : super(key: key);
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
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: Center(
              child: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  size: 26.sp,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ),
        ),
        centerTitle: false,
        scrolledUnderElevation: 0,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'Profile',
          style: AppStyles.appbar,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(66, 178, 176, 176),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$name! 👋', // Use truncated name
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          date, // Replace with current date
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 22.sp,
                        backgroundColor: Colors.white,
                        child: CachedNetworkImage(
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => CircleAvatar(
                            radius: 21.4.sp,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 224, 218, 218),
                          ),
                          imageUrl: image ?? '',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, // Apply circular shape
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          fit: BoxFit.fill,
                          width: double.infinity,
                          errorWidget: (context, url, error) => CircleAvatar(
                            radius: 21.4.sp,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 224, 218, 218),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),

            Container(
              width: 100.w,
              height: 15.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(66, 178, 176, 176),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 2.h, left: 5.w),
                child: StreamBuilder<Wallet?>(
                  stream: walletController.getWallet(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingWidget();
                    } else if (snapshot.hasError) {
                      return SizedBox.shrink();
                    } else if (snapshot.data == null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\Rs.0', // Display total balance
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Wallet BALANCE',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      );
                    } else {
                      Wallet wallet = snapshot.data!;
                      Map<String, double> totals =
                          walletController.calculateTotals(wallet.transactions);
                      double totalBalance = totals['totalBalance'] ?? 0.0;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\Rs.${totalBalance.toInt()}', // Display total balance
                                style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Wallet BALANCE',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                          isStudent
                              ? SizedBox.shrink()
                              : GestureDetector(
                                  onTap: () async {
                                    Get.to(() => BalanceLoadPage(
                                          oldBalance: totalBalance.toString(),
                                          id: userId,
                                          name: name,
                                        ));
                                  },
                                  child: ActionButton(
                                      icon: Icons.add, label: 'Add')),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),

            // Action Buttons

            // : Padding(
            //     padding: const EdgeInsets.all(18.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [

            //         GestureDetector(
            //             onTap: () async {
            //               await walletController.createWallet(userId, name);
            //             },
            //             child: ActionButton(
            //                 icon: Icons.remove_circle, label: 'wallet')),
            //         GestureDetector(
            //             onTap: () async {
            //               DateTime now = DateTime.now();
            //               NepaliDateTime nepaliDateTime =
            //                   NepaliDateTime.fromDateTime(now);
            //               await walletController.addTransaction(
            //                 userId,
            //                 Transactions(
            //                   date: nepaliDateTime,
            //                   name: 'penalty', // or penalty
            //                   amount: 100.0,
            //                   timestamp: DateTime.now(),
            //                 ),
            //               );
            //             },
            //             child: ActionButton(
            //                 icon: Icons.remove_circle, label: 'Penalty')),
            //       ],
            //     ),
            //   ),
            SizedBox(height: 30),

            // Transactions
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transactions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    StreamBuilder<Wallet?>(
                      stream: walletController.getWallet(userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox.shrink();
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
                            transactions
                                .sort((a, b) => b.date.compareTo(a.date));
                            return Expanded(
                              child: ListView.builder(
                                itemCount: transactions.length,
                                itemBuilder: (context, index) {
                                  Transactions transaction =
                                      transactions[index];
                                  return TransactionItem(
                                    name: transaction.name,
                                    date: transaction.date.toString(),
                                    remarks: transaction.remarks,
                                    amount:
                                        transaction.amount.toInt().toString(),
                                    color: Colors
                                        .green, // Assuming all amounts are positive
                                  );
                                },
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  ActionButton({required this.icon, required this.label});
  final walletcontroller = Get.put(WalletController());

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 252, 252, 252),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 227, 224, 224).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.0.w, vertical: 1.h),
            child: walletcontroller.transctionAdd.value
                ? LoadingWidget()
                : Icon(
                    icon,
                    size: 28,
                    color: Colors.blue.shade700,
                  ),
          ),
        ));
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
    // Determine the icon and color based on the transaction name
    IconData iconData;
    Color backgroundColor;
    if (name.toLowerCase() == 'load') {
      iconData = Icons.add_circle_outline; // Icon for load
      backgroundColor = Colors.green.shade100; // Background color for load
    } else if (name.toLowerCase() == 'Purchase') {
      iconData = Icons.remove_circle_outline; // Icon for penalty
      backgroundColor = Colors.red.shade100; // Background color for penalty
    } else {
      iconData = Icons.account_circle; // Default icon
      backgroundColor = Colors.grey.shade200; // Default background color
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                  barrierColor:
                      Color.fromARGB(255, 73, 72, 72).withOpacity(0.5),
                  context: Get.context!,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 34.0.h),
                      child: Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 80.w,
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 32),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      // Wrap keys and values in a Row
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
                                    SizedBox(height: 1.h),
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
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
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
            "Rs." + amount,
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
