import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DummyOrder {
  final String mealName;
  final double price;
  final String mealTime;
  final String studentName;

  DummyOrder({
    required this.mealName,
    required this.price,
    required this.mealTime,
    required this.studentName,
  });
}

class TimeBasedOrderController extends GetxController {
  // Observable variables
  var currentSystemTime = ''.obs;
  var activeTimeSlot = ''.obs;
  var visibleOrders = <DummyOrder>[].obs;

  // Meal time slots
  final List<String> mealTimeSlots = ['9:30', '10:10', '11:40'];

  Timer? _timer;

  // Dummy orders
  final List<DummyOrder> allOrders = [
    DummyOrder(
        mealName: 'Chicken Momo',
        price: 120.0,
        mealTime: '9:30',
        studentName: 'Ram Sharma'),
    DummyOrder(
        mealName: 'Veg Chowmein',
        price: 90.0,
        mealTime: '9:30',
        studentName: 'Sita Patel'),
    DummyOrder(
        mealName: 'Thukpa',
        price: 110.0,
        mealTime: '10:10',
        studentName: 'Hari Thapa'),
    DummyOrder(
        mealName: 'Chicken Burger',
        price: 150.0,
        mealTime: '10:10',
        studentName: 'Gita Gurung'),
    DummyOrder(
        mealName: 'Fried Rice',
        price: 130.0,
        mealTime: '11:40',
        studentName: 'Shyam Karki'),
  ];

  @override
  void onInit() {
    super.onInit();
    // Update time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => updateTime());
    updateTime(); // Initial update
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void updateTime() {
    final now = DateTime.now();
    // Update current time in HH:mm:ss format
    currentSystemTime.value = DateFormat('HH:mm:ss').format(now);
    updateActiveTimeSlot();
  }

  void updateActiveTimeSlot() {
    final currentTimeStr =
        currentSystemTime.value.substring(0, 5); // Get HH:mm part
    final currentDateTime = _parseTime(currentTimeStr);

    String? activeSlot;

    for (int i = 0; i < mealTimeSlots.length; i++) {
      final slotTime = _parseTime(mealTimeSlots[i]);
      final nextSlotTime = i < mealTimeSlots.length - 1
          ? _parseTime(mealTimeSlots[i + 1])
          : _parseTime('23:59');

      if (currentDateTime.isAfter(slotTime) &&
          currentDateTime.isBefore(nextSlotTime)) {
        activeSlot = mealTimeSlots[i];
        break;
      }
    }

    // Update active time slot if changed
    if (activeSlot != activeTimeSlot.value) {
      activeTimeSlot.value = activeSlot ?? '';
      updateVisibleOrders();
    }
  }

  DateTime _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    final now = DateTime.now();
    return DateTime(
        now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
  }

  void updateVisibleOrders() {
    if (activeTimeSlot.isEmpty) {
      visibleOrders.clear();
      return;
    }

    visibleOrders.value = allOrders
        .where((order) => order.mealTime == activeTimeSlot.value)
        .toList();
  }

  // For testing purposes only
  void setTestTime(String time) {
    currentSystemTime.value = '$time:00';
    updateActiveTimeSlot();
  }
}

class OrdersDisplayPage extends StatelessWidget {
  final controller = Get.put(TimeBasedOrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Orders'),
      ),
      body: Column(
        children: [
          // Current Time and Active Slot Display
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              children: [
                Obx(() => Text(
                      'Current Time: ${controller.currentSystemTime.value}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                Obx(() => Text(
                      'Active Time Slot: ${controller.activeTimeSlot.value}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue.shade700,
                      ),
                    )),
              ],
            ),
          ),

          // Test Time Buttons (for demonstration)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => controller.setTestTime('09:35'),
                  child: const Text('Test 9:35'),
                ),
                ElevatedButton(
                  onPressed: () => controller.setTestTime('10:15'),
                  child: const Text('Test 10:15'),
                ),
                ElevatedButton(
                  onPressed: () => controller.setTestTime('11:45'),
                  child: const Text('Test 11:45'),
                ),
              ],
            ),
          ),

          // Orders List
          Expanded(
            child: Obx(
              () => controller.visibleOrders.isEmpty
                  ? const Center(
                      child: Text(
                        'No orders for current time slot',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: controller.visibleOrders.length,
                      itemBuilder: (context, index) {
                        final order = controller.visibleOrders[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            title: Text(
                              order.mealName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(order.studentName),
                            trailing: Text(
                              'Rs. ${order.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),

          // Summary Card
          Obx(() => Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Total Orders: ${controller.visibleOrders.length}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Total: Rs. ${controller.visibleOrders.fold(0.0, (sum, order) => sum + order.price).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
