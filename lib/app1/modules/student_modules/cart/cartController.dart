import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/modules/student_modules/homepage/utils/menue_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxString selectedTimeSlot = ''.obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxBool isGuaranteedOrder = false.obs;
  final RxDouble guaranteeAmount = 0.0.obs;

  // Available time slots for the canteen
  final List<String> timeSlots = [
    '8:30 AM',
    '9:30 AM',
    '11:00 AM',
  ];

  // Method to add MenuItem to cart
  void addToCart(ProductResponseModel item) {
    // Check if item already exists in cart
    final existingItemIndex =
        cartItems.indexWhere((item) => item.id == item.id);

    if (existingItemIndex != -1) {
      // Item exists, increment quantity
      cartItems[existingItemIndex].quantity++;
      // Show success message
      _showSuccessMessage('Added another ${item.name}');
    } else {
      // Create new cart item
      final cartItem = CartItem(
        id: item.productId,
        name: item.name,
        price: item.price,
        imageUrl: item.proudctImage,
        isStandardItem:
            !(item.type == 'Basic Items'), // Convert isBasic to isStandardItem
        quantity: 1,
      );

      cartItems.add(cartItem);
      // Show success message
      _showSuccessMessage('${item.name} added to cart');
    }

    // Update totals
    updateTotalAmount();
  }

  // Helper method to show success message
  void _showSuccessMessage(String message) {
    Get.snackbar(
      'Cart Updated',
      message,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: EdgeInsets.all(10),
      borderRadius: 10,
      icon: Icon(Icons.shopping_cart, color: Colors.white),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  // Method to increment quantity
  void incrementQuantity(String itemId) {
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      cartItems[index].quantity++;
      updateTotalAmount();
    }
  }

  // Method to decrement quantity
  void decrementQuantity(String itemId) {
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      } else {
        // If quantity would become 0, remove item from cart
        cartItems.removeAt(index);
      }
      updateTotalAmount();
    }
  }

  // Method to remove item from cart
  void removeFromCart(String itemId) {
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final removedItem = cartItems[index];
      cartItems.removeAt(index);
      updateTotalAmount();

      // Show removal message
      Get.snackbar(
        'Item Removed',
        '${removedItem.name} removed from cart',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(10),
        borderRadius: 10,
        icon: Icon(Icons.remove_shopping_cart, color: Colors.white),
      );
    }
  }

  void updateTotalAmount() {
    double total = 0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }
    totalAmount.value = total;

    // Calculate guarantee amount based on item types
    double basicItemsTotal = 0;
    double standardItemsTotal = 0;

    for (var item in cartItems) {
      if (item.isStandardItem) {
        standardItemsTotal += item.price * item.quantity;
      } else {
        basicItemsTotal += item.price * item.quantity;
      }
    }

    // Calculate guarantee amount
    double guarantee = standardItemsTotal; // Full amount for standard items
    if (basicItemsTotal > 100) {
      guarantee +=
          (basicItemsTotal - 100); // Amount exceeding Rs. 100 for basic items
    }

    if (guarantee > 0) {
      isGuaranteedOrder.value = true;
      guaranteeAmount.value =
          guarantee < 50 ? 50 : guarantee; // Minimum 50 Rs guarantee
    } else {
      isGuaranteedOrder.value = false;
      guaranteeAmount.value = 0;
    }
  }

  // Get total quantity of items in cart
  int get totalItems {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Get total quantity of a specific item
  int getItemQuantity(String itemId) {
    final item = cartItems.firstWhereOrNull((item) => item.id == itemId);
    return item?.quantity ?? 0;
  }

  // Check if an item is in cart
  bool isItemInCart(String itemId) {
    return cartItems.any((item) => item.id == itemId);
  }

  // Clear cart
  void clearCart() {
    cartItems.clear();
    selectedTimeSlot.value = '';
    updateTotalAmount();
  }
}

// CartItem model updated to include imageUrl
class CartItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final bool isStandardItem;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.isStandardItem,
    this.quantity = 1,
  });
}
