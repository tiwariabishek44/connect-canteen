import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue/menue_controller.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/homepage/utils/depositAlert.dart';
import 'package:connect_canteen/app1/modules/student_modules/homepage/utils/menueDetailSheet.dart';
import 'package:connect_canteen/app1/modules/student_modules/homepage/utils/orderQuotaCard.dart';
import 'package:connect_canteen/app1/widget/snackbarHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class MenuSection extends StatefulWidget {
  @override
  State<MenuSection> createState() => _MenuSectionState();
}

class _MenuSectionState extends State<MenuSection> {
  final controller = Get.put(MenueContorller());

  final loginController = Get.put(LoginController());

  final quota = Get.put(QuotaController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 3.0.h),
      child: Column(
        children: [
          _buildCategoryTabs(theme),
          SizedBox(height: 16),
          _buildMenuList(theme),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(ThemeData theme) {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCategoryChip(
                'Basic Items',
                controller.selectedCategory.value == 'Basic Items',
                theme,
                () {
                  controller.selectedCategory.value = 'Basic Items';
                  setState(() {});
                },
              ),
              _buildCategoryChip(
                'Standard Items',
                controller.selectedCategory.value == 'Standard Items',
                theme,
                () {
                  controller.selectedCategory.value = 'Standard Items';
                  setState(() {});
                },
              ),
            ],
          ),
        ));
  }

  Widget _buildCategoryChip(
      String label, bool isSelected, ThemeData theme, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withOpacity(0.2),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuList(ThemeData theme) {
    return StreamBuilder<List<ProductResponseModel>>(
      stream: controller.getAllMenue("texasinternationalcollege"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerGrid();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState(theme);
        }

        // Apply filtering based on the selected category
        final menuProducts = snapshot.data!.where((item) {
          final selectedCategory = controller.selectedCategory.value;
          return selectedCategory == 'Basic Items'
              ? item.type == 'Basic Items'
              : item.type == 'Standard Items';
        }).toList();

        if (menuProducts.isEmpty) {
          return _buildEmptyState(theme);
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: menuProducts.length,
          itemBuilder: (context, index) {
            final item = menuProducts[index];
            return _buildMenuItem(item, theme);
          },
        );
      },
    );
  }

  Widget _buildMenuItem(ProductResponseModel item, ThemeData theme) {
    return InkWell(
      onTap: () {
        try {
          // Safely get student data
          final studentData = loginController.studentDataResponse.value;
          if (studentData == null) {
            throw 'Student data not available';
          }

          final depositAmount = studentData.depositAmount;
          final isBasicItem = item.type == "Basic Items";
          final hasQuotaAvailable = quota.quotaProgress.value < 1.0;

          // Required deposit amount based on item type
          final requiredDeposit = isBasicItem ? 50.0 : item.price;
          final hasEnoughDeposit = depositAmount >= requiredDeposit;

          // Helper function to show deposit alert
          void showDepositRequirement() {
            showDialog(
              context: Get.context!,
              builder: (BuildContext context) {
                return DepositAlertDialog(
                  productName: item.name,
                  price: item.price,
                  itemType: item.type,
                );
              },
            );
          }

          // Decision logic
          if (hasQuotaAvailable && isBasicItem) {
            // Case 1: Basic item with available quota
            Get.bottomSheet(
              MenuItemDetailSheet(
                item: item,
                isFreemium: true,
              ),
            );
            // Add your cart addition logic here
          } else if (!hasQuotaAvailable && !hasEnoughDeposit) {
            // Case 2: No quota and insufficient deposit
            showDepositRequirement();
          } else if (hasEnoughDeposit) {
            // Case 3: Has enough deposit regardless of quota
            Get.bottomSheet(
              MenuItemDetailSheet(
                item: item,
                isFreemium: false,
              ),
            );
          } else {
            // Case 4: Standard item without enough deposit
            showDepositRequirement();
          }
        } catch (e) {
          SnackbarHelper.showErrorSnackbar(
              'Unable to process your request. Please try again.');
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: item.proudctImage,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.white,
                        height: 120,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 120,
                      color: Colors.grey[200],
                      child: Icon(Icons.restaurant, color: Colors.grey),
                    ),
                  ),
                  // Item Type Badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.type == 'Basic Items'
                            ? theme.colorScheme.primary.withOpacity(0.9)
                            : theme.colorScheme.secondary.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.type == "Basic Items" ? 'Basic' : 'Standard',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content Section
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${item.price}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: 16),
          Text(
            'No items found',
            style: theme.textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          Text(
            'Try changing the category or check back later',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
