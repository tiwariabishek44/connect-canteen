import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TransactionItem extends StatelessWidget {
  final String name;
  final String date;
  final String remarks;
  final String amount;
  final Color color;
  final String transctionTime;

  const TransactionItem({
    required this.transctionTime,
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
    } else if (name.toLowerCase() == 'penalty') {
      iconData = Icons.remove_circle_outline;
      backgroundColor = Colors.red.shade100;
    } else {
      iconData = Icons.account_circle;
      backgroundColor = Colors.grey.shade200;
    }

 

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8),
      child: GestureDetector(
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
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 10.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
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
                              '${name.toLowerCase() == 'load' ? "Balance Load" : name.toLowerCase() == 'penalty' ? 'Penalty' : 'Purchase'}',
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
                              date + " : " + transctionTime,
                                      style: TextStyle(
                                        fontSize: 16.sp,
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
                                  ? "" : '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                name.toLowerCase() == 'load'
                                    ? ''
                                    : name.toLowerCase() == 'penalty'
                                        ? 'Penalty :Rs${remarks.split(' ')[0]}'
                                        : 'Last Time :Rs ${remarks.split(' ')[0]}',
                                maxLines: 2,
                                overflow: TextOverflow
                                    .clip, // or TextOverflow.ellipsis
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        name.toLowerCase() == 'load'
                            ? SizedBox.shrink()
                            : Row(
                                children: [
                                  Text(
                                    name.toLowerCase() == 'load'
                                        ? "Last Time Rs."
                                        : '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      name.toLowerCase() == 'load'
                                          ? remarks
                                          : 'Item: ${remarks.split(' ').skip(1).join(' ')}',
                                      maxLines: 2,
                                      overflow: TextOverflow
                                          .clip, // or TextOverflow.ellipsis
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.black,
                                      ),
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
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 244, 244, 244),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: backgroundColor,
                  child: Icon(
                    iconData,
                    color: color,
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
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          date.toString().split(' ')[0],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Rs.$amount",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: name.toLowerCase() == 'load'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
