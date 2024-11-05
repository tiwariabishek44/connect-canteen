import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

class QuotaController extends GetxController {
  final loginController = Get.find<LoginController>();

  final RxDouble quotaProgress = 0.0.obs;
  final RxInt currentOrders = 0.obs;
  final RxInt totalStudents = 0.obs;
  final RxInt dailyQuota = 0.obs;
  final RxInt availableQuota = 0.obs; // New variable for available quota
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream controllers
  final _studentCountController = StreamController<int>();
  final _todayOrdersController = StreamController<int>();

  // Stream subscriptions
  StreamSubscription? _studentsSubscription;
  StreamSubscription? _ordersSubscription;

  @override
  void onInit() {
    super.onInit();
    ever(loginController.studentDataResponse, (_) {
      _cancelStreams();
      if (loginController.studentDataResponse.value != null) {
        initializeStreams();
      }
    });
  }

  void _cancelStreams() {
    _studentsSubscription?.cancel();
    _ordersSubscription?.cancel();
    totalStudents.value = 0;
    currentOrders.value = 0;
    dailyQuota.value = 0;
    availableQuota.value = 0;
    quotaProgress.value = 0;
  }

  void initializeStreams() {
    try {
      final schoolId = loginController.studentDataResponse.value?.schoolId;

      if (schoolId == null) {
        print('SchoolId is null, streams not initialized');
        return;
      }

      // Listen to students collection
      _studentsSubscription = _firestore
          .collection('productionStudents')
          .where('schoolId', isEqualTo: schoolId)
          .snapshots()
          .listen(
        (snapshot) {
          totalStudents.value = snapshot.docs.length;
          // Calculate daily quota as 25% of total students
          dailyQuota.value = 7 + (totalStudents.value * 0.3).floor();
          _updateQuotaProgress();
        },
        onError: (error) {
          print('Error in students stream: $error');
        },
      );

      // Listen to today's orders
      _listenToTodayOrders(schoolId);
    } catch (e) {
      print('Error initializing streams: $e');
    }
  }

  void _listenToTodayOrders(String schoolId) {
    final nepalinow = NepaliDateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(nepalinow);

    _ordersSubscription = _firestore
        .collection('orders')
        .where('referenceSchoolId', isEqualTo: schoolId)
        .where('mealDate', isEqualTo: today)
        .snapshots()
        .listen(
      (snapshot) {
        currentOrders.value = snapshot.docs.length;
        _updateQuotaProgress();
      },
      onError: (error) {
        print('Error in orders stream: $error');
      },
    );
  }

  void _updateQuotaProgress() {
    if (dailyQuota.value > 0) {
      // Calculate available quota
      availableQuota.value =
          (dailyQuota.value - currentOrders.value).clamp(0, dailyQuota.value);
      // Update progress
      quotaProgress.value = currentOrders.value / dailyQuota.value;
    } else {
      availableQuota.value = 0;
      quotaProgress.value = 0;
    }
  }

  @override
  void onClose() {
    _cancelStreams();
    _studentCountController.close();
    _todayOrdersController.close();
    super.onClose();
  }
}

class QuotaProgressCard extends StatelessWidget {
  final quotaController = Get.put(QuotaController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.1),
                Theme.of(context).primaryColor.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Quick Order Slots Today',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${quotaController.currentOrders.value}/${quotaController.dailyQuota.value}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        'Quick Slots Left: ${quotaController.availableQuota.value}',
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0,
                  end: quotaController.quotaProgress.value,
                ),
                duration: Duration(milliseconds: 1500),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: value,
                          backgroundColor: Colors.grey.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            value >= 0.8
                                ? Colors.red
                                : Theme.of(context).primaryColor,
                          ),
                          minHeight: 8,
                        ),
                      ),
                      SizedBox(height: 8),
                      _buildQuotaMessage(quotaController, context),
                    ],
                  );
                },
              ),
              SizedBox(height: 8),
              _buildExplanationCard(context, quotaController),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _showQuotaDetails(context),
                    style: TextButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.help_outline,
                          size: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'How it works?',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildQuotaMessage(QuotaController controller, BuildContext context) {
    double progress = controller.quotaProgress.value;
    int availableQuota = controller.availableQuota.value;
    int totalStudents = controller.totalStudents.value;
    int dailyQuota = controller.dailyQuota.value;

    String message;
    String subMessage;
    Color messageColor;
    IconData messageIcon;

    if (availableQuota <= 0) {
      message = '😊 You can still order!';
      subMessage = 'Just need to add deposit amount';
      messageColor = Colors.red;
      messageIcon = Icons.account_balance_wallet;
    } else if (availableQuota <= (controller.dailyQuota.value * 0.2).floor()) {
      message = '🏃‍♂️ Quick! Almost full!';
      subMessage = 'Only $availableQuota quick slots left';
      messageColor = Colors.orange;
      messageIcon = Icons.timer;
    } else {
      message = '✨ Good news! Quick ordering available';
      subMessage = 'Order now without deposit';
      messageColor = Colors.green;
      messageIcon = Icons.check_circle;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              messageIcon,
              size: 20,
              color: messageColor,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: messageColor,
                    ),
                  ),
                  Text(
                    subMessage,
                    style: TextStyle(
                      fontSize: 13,
                      color: messageColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExplanationCard(
      BuildContext context, QuotaController controller) {
    bool isQuotaAvailable = controller.availableQuota.value > 0;

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isQuotaAvailable ? "How it works:" : "What to do now:",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 8),
          if (isQuotaAvailable) ...[
            _buildExplanationRow(context, "🎯",
                "First ${controller.dailyQuota.value} students can order instantly"),
            _buildExplanationRow(
                context, "💰", "No deposit needed for quick slots"),
            _buildExplanationRow(
                context, "🔄", "Slots refresh daily at midnight"),
          ] else ...[
            _buildExplanationRow(
                context, "💫", "Don't worry! You can still order"),
            _buildExplanationRow(context, "🔒", "Just add deposit amount"),
          ],
        ],
      ),
    );
  }

  Widget _buildExplanationRow(BuildContext context, String emoji, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emoji,
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).primaryColor.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuotaDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuotaDetailsSheet(),
    );
  }
}

class QuotaDetailsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuotaOverview(context),
                  SizedBox(height: 24),
                  _buildQuotaRules(context),
                  SizedBox(height: 24),
                  _buildOrderTypes(context),
                  SizedBox(height: 24),
                  _buildFAQs(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quota System Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Everything you need to know about ordering',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotaOverview(BuildContext context) {
    final quotaController = Get.find<QuotaController>();

    return Card(
      elevation: 0,
      color: Theme.of(context).primaryColor.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Quota Overview',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Total Quota',
                  '${quotaController.dailyQuota}',
                  Icons.people_outline,
                ),
                _buildStatItem(
                  context,
                  'Used',
                  '${quotaController.currentOrders}',
                  Icons.check_circle_outline,
                ),
                _buildStatItem(
                  context,
                  'Remaining',
                  '${quotaController.dailyQuota - quotaController.currentOrders.value}',
                  Icons.timer_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildQuotaRules(BuildContext context) {
    final rules = [
      {
        'icon': Icons.access_time,
        'title': 'Daily Reset',
        'description': 'Quota resets every day at midnight',
      },
      {
        'icon': Icons.group,
        'title': '25% Rule',
        'description':
            'First 25% of registered students can order without deposit',
      },
      {
        'icon': Icons.speed,
        'title': 'First Come First Serve',
        'description': 'Quota is allocated on first come first serve basis',
      },
      {
        'icon': Icons.calendar_today,
        'title': 'Order Timing',
        'description': 'Orders can be placed between 8 AM to 2 PM',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quota Rules',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        ...rules.map((rule) => _buildRuleItem(context, rule)),
      ],
    );
  }

  Widget _buildRuleItem(BuildContext context, Map<String, dynamic> rule) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              rule['icon'] as IconData,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule['title'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  rule['description'] as String,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTypes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Types',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        _buildOrderTypeCard(
          context,
          'Freemium Order',
          'No deposit required',
          'Available for first 25% of students',
          Colors.green,
        ),
        SizedBox(height: 12),
        _buildOrderTypeCard(
          context,
          'Guaranteed Order',
          'Requires deposit',
          'Available for all students',
          Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  Widget _buildOrderTypeCard(
    BuildContext context,
    String title,
    String subtitle,
    String description,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQs(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequently Asked Questions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        ExpansionTile(
          title: Text('What happens if I miss the quota?'),
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'You can still place orders in system by providing a deposit.',
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('How is the 25% calculated?'),
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'It\'s calculated based on the total number of registered students in the system.',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
