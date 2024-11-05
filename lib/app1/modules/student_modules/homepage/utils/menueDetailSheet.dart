import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/model/meal_time.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/modules/student_modules/cart/cartController.dart';
import 'package:connect_canteen/app1/modules/student_modules/homepage/utils/menue_section.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/order_controller.dart';
import 'package:connect_canteen/app1/widget/snackbarHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MenuItemDetailSheet extends StatelessWidget {
  final bool isFreemium;
  final ProductResponseModel item;
  final studentOrderController = Get.put(StudentOrderController());
  final RxString selectedMealTime = ''.obs;

  MenuItemDetailSheet({Key? key, required this.item, required this.isFreemium})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(theme),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _buildImage(),
                  _buildContent(theme),
                  _buildMealTimeSelection(theme), // New meal time section
                ],
              ),
            ),
          ),
          _buildBottomBar(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withOpacity(0.1),
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Get.back(),
              splashRadius: 24,
            ),
          ),
        ],
      ),
    );
  }

  // ... Keep existing _buildHeader and _buildImage methods ...

  Widget _buildMealTimeSelection(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Meal Time',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          StreamBuilder<List<MealTime>>(
            stream: studentOrderController.getMealTimes(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error loading meal times',
                    style: TextStyle(color: Colors.red));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final mealTimes = snapshot.data ?? [];
              if (mealTimes.isEmpty) {
                return Text('No meal times available',
                    style: TextStyle(color: Colors.grey));
              }

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(() => DropdownButton<String>(
                      isExpanded: true,
                      value: selectedMealTime.value.isEmpty
                          ? null
                          : selectedMealTime.value,
                      hint: Text('Choose meal time'),
                      underline: SizedBox(),
                      items: mealTimes.map((MealTime mealTime) {
                        return DropdownMenuItem<String>(
                          value: mealTime.mealTime,
                          child: Text(mealTime.mealTime),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          selectedMealTime.value = newValue;
                        }
                      },
                    )),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Rs ${item.price}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              _buildInfoItem(
                icon: Icons.star_outline,
                text: '4.5',
                theme: theme,
              ),
              SizedBox(width: 24),
              _buildInfoItem(
                icon: Icons.info_outline,
                text: item.type,
                theme: theme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16).copyWith(
        bottom: 16 + MediaQuery.of(Get.context!).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => selectedMealTime.value.isEmpty
              ? Text(
                  'Please select a meal time',
                  style: TextStyle(color: Colors.red),
                )
              : SizedBox()),
          SizedBox(height: 8),
          Obx(() => ElevatedButton(
                onPressed: studentOrderController.isLoading.value
                    ? null // Disable button while loading
                    : () async {
                        if (selectedMealTime.value.isEmpty) {
                          SnackbarHelper.showErrorSnackbar(
                              'Please select a meal time');
                          return;
                        }

                        final result = await studentOrderController.placeOrder(
                          isFreemium,
                          item,
                          selectedMealTime.value,
                          DateTime.now(),
                        );

                        if (!result) {
                          // Error already shown in placeOrder method
                          return;
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: theme.colorScheme.primary,
                ),
                child: studentOrderController.isLoading.value
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.restaurant_menu, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Order Now • ₹${item.price}',
                            style: TextStyle(
                              color: Colors.white,
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

  Widget _buildInfoItem({
    required IconData icon,
    required String text,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
