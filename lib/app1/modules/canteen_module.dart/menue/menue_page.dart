import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue/menue_controller.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue/utils/addMenue.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue_edit/menue_edit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class CanteenMenuePage extends StatelessWidget {
  final controller = Get.put(MenueContorller());
  Future<void> showDeleteConfirmation(ProductResponseModel product) async {
    return showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text('Delete ${product.name}?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                // Show loading dialog

                final success =
                    await controller.deleteProduct(product.productId);

                // Close loading dialog
                Get.back();

                if (success) {
                  Get.snackbar(
                    'Success',
                    'Item deleted successfully',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } else {
                  Get.snackbar(
                    'Error',
                    'Failed to delete item',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 4.0.w,
        title: Text(
          'Menu',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                'Manage Your Menu',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildMenuStreamList(theme),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => AddMenuItem());
        },
        label: Text('Add Item'),
        icon: Icon(Icons.add),
      ),
    );
  }

  Widget _buildMenuStreamList(ThemeData theme) {
    return Expanded(
      child: StreamBuilder<List<ProductResponseModel>>(
        stream: controller.getAllMenue("texasinternationalcollege"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerList();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(theme);
          }

          final menuProducts = snapshot.data!;
          return ListView.builder(
            // Removed the nested Expanded
            itemCount: menuProducts.length,
            itemBuilder: (context, index) {
              final item = menuProducts[index];
              return _buildMenuItemCard(item, theme);
            },
          );
        },
      ),
    );
  }

  Widget _buildMenuItemCard(ProductResponseModel item, ThemeData theme) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 60,
            height: 60,
            color: Colors.grey[200],
            child: Icon(Icons.restaurant, color: Colors.grey),
          ),
        ),
        title: Text(item.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rs ${item.price}'),
            Chip(
              label: Text(
                item.type == 'Basic Items' ? 'Basic' : 'Standard',
                style: TextStyle(
                    color: const Color.fromARGB(255, 43, 43, 43), fontSize: 12),
              ),
              backgroundColor: item.type == 'Basic Items'
                  ? Color.fromARGB(255, 245, 137, 130)
                  : Color.fromARGB(255, 117, 155, 118),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Get.to(
                  () => MenueEditPage(
                    productId: item.productId,
                  ),
                  transition: Transition.cupertinoDialog,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => showDeleteConfirmation(item),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      // Removed Expanded
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Container(
                width: 60,
                height: 60,
                color: Colors.white,
              ),
              title: Container(
                height: 20,
                color: Colors.white,
              ),
              subtitle: Container(
                height: 20,
                color: Colors.white,
              ),
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
            'Add new items or change the filter',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
