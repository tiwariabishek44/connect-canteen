import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/utils/all_order_tab.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/utils/order_history_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  final loignController = Get.put(LoginController());
  late TabController _tabController;
  bool _isAllOrdersTabActive = true;
  bool _isHistoryTabActive = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          if (_tabController.index == 0) {
            _isAllOrdersTabActive = true;
            _isHistoryTabActive = false;
          } else {
            _isAllOrdersTabActive = false;
            _isHistoryTabActive = true;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleSpacing: 24.0,
          title: Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Text(
              'Orders',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt, size: 24.sp, color: Colors.black),
                      SizedBox(width: 8),
                      Text('All orders',
                          style:
                              TextStyle(color: Colors.black, fontSize: 18.sp)),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 24.sp, color: Colors.black),
                      SizedBox(width: 8),
                      Text('History',
                          style:
                              TextStyle(color: Colors.black, fontSize: 18.sp)),
                    ],
                  ),
                ),
              ],
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                    width: 4.0,
                  ),
                ),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 4.0,
              labelColor: Colors.black,
              splashFactory: NoSplash.splashFactory,
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed) ||
                      states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.hovered)) {
                    return Colors.grey.withOpacity(0.2);
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) => true,
          child: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _isAllOrdersTabActive
                  ? AllOrdersTab(
                      groupcod:
                          '${loignController.studentDataResponse.value!.groupcod}',
                      schoolrefrenceId:
                          '${loignController.studentDataResponse.value!.schoolId}',
                    )
                  : SizedBox.shrink(),
              _isHistoryTabActive
                  ? HistoryTab(
                      groupcod:
                          '${loignController.studentDataResponse.value!.groupcod}',
                      schoolrefrenceId:
                          '${loignController.studentDataResponse.value!.schoolId}',
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
