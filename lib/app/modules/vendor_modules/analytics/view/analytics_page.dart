import 'package:flutter/material.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:intl/intl.dart';
import 'package:connect_canteen/app/modules/vendor_modules/analytics/view/total_orders_tab.dart';
import 'package:connect_canteen/app/modules/vendor_modules/analytics/view/total_remaning_orders_tab.dart';
import 'package:nepali_utils/nepali_utils.dart';

class AnalyticsPage extends StatefulWidget {
  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();

    // ignore: deprecated_member_use
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

    String formattedDate =
        DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: Color(0xff06C167),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Analytics",
                  style: AppStyles.appbar,
                ),
                Text(
                  formattedDate,
                  style: AppStyles.listTilesubTitle,
                ),
              ],
            ),
          ),
          bottom: const TabBar(
            indicatorColor: AppColors.iconColors,
            labelColor: AppColors.iconColors,
            indicatorWeight: 1,
            automaticIndicatorColorAdjustment: true,
            tabs: [
              Tab(text: 'Total Order'),
              Tab(text: 'Remaning Orders'),
            ],
          ),
        ),
        body: TabBarView(
          children: [TotalOrdersTab(), TotalRemaningOrdersTab()],
        ),
      ),
    );
  }
}
