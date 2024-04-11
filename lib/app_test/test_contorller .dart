import 'dart:math';

import 'package:connect_canteen/app/models/order_response.dart';
import 'package:get/get.dart';

class FoodOrderTime {
  final String mealTime;
  final String orderHoldTime;

  FoodOrderTime({
    required this.mealTime,
    required this.orderHoldTime,
  });
}

class TestContorller extends GetxController {
  final List<double> prices = [
    50, // Samosa
    120, // Veg Momo
    150, // Chicken Momo
    100, // Chowmein
    120, // Chicken Roll
    60, // Fried Rice
    200, // Veg Khana Set
    250, // Non Veg Khana Set
    50, // Bread Chop
  ];

  final List<String> options = [
    'BscCSIT-1st Sem',
    'BscCSIT-2nd Sem',
    'BscCSIT-3rd Sem',
    'BscCSIT-4th Sem',
  ];

  final List<String> groupcodes = [
    '1429',
    '2267',
    '9876',
    '7865',
  ];

  final String customerImage =
      "https://firebasestorage.googleapis.com/v0/b/connect-cant.appspot.com/o/profilePicture%2F2024-04-05%2011%3A16%3A12.572271.png?alt=media&token=6c69170f-9726-40dd-9ed2-000d30370c43";

  final List<FoodOrderTime> foodOrdersTime = [
    FoodOrderTime(mealTime: "09:00", orderHoldTime: "8:00"),
    FoodOrderTime(mealTime: "10:30", orderHoldTime: "9:30"),
    FoodOrderTime(mealTime: "11:00", orderHoldTime: "10:00"),
  ];

  final List<String> imageUrls = [
    'https://www.indianhealthyrecipes.com/wp-content/uploads/2021/12/samosa-recipe.jpg',
    'https://resize.indiatvnews.com/en/resize/oldbucket/1200_-/lifestylelifestyle/IndiaTv94add1_momos-main-pic.jpg',
    'https://www.archanaskitchen.com/images/archanaskitchen/1-Author/shaikh.khalid7-gmail.com/Chicken_Momos_Recipe_Delicious_Steamed_Chicken_Dumplings.jpg',
    'https://thebigmansworld.com/wp-content/uploads/2023/02/chicken-chow-mein-recipe.jpg',
    'https://lh4.googleusercontent.com/proxy/EG-kWc7b5gqVrXOriIpVK4ao-jNHc5WfpDzv2g0PV_yIhzAl4tAXAy_9q69f00QG-3odYcWYf2jb7keCIUv5DCp2xp16tSMiXnpn',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcKQvi_5UjNQhb_O1wYemPdhUJzp8njCWwjuUKULNHuQ&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcKQvi_5UjNQhb_O1wYemPdhUJzp8njCWwjuUKULNHuQ&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcKQvi_5UjNQhb_O1wYemPdhUJzp8njCWwjuUKULNHuQ&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcKQvi_5UjNQhb_O1wYemPdhUJzp8njCWwjuUKULNHuQ&s',
  ];

  final Random random = Random();
  final List<OrderResponse> orders = [];
  List<OrderResponse> generateDummyOrders() {
    final List<String> products = [
      'Samosa',
      'Veg Momo',
      'Chicken Momo',
      'Chowmein',
      'Chicken Roll',
      'Fried Rice',
      'Veg Khana Set',
      'Non Veg Khana Set',
      'Bread Chop',
    ];
    for (int i = 0; i < 10; i++) {
      final int productIndex = random.nextInt(products.length);
      final double price = prices[8];
      final String productName = products[7];
      final String classs = options[random.nextInt(options.length)];
      final String groupcod = groupcodes[random.nextInt(options.length)];
      final FoodOrderTime foodOrderTime =
          foodOrdersTime[random.nextInt(foodOrdersTime.length)];
      final String productImageUrl = imageUrls[productIndex];
      DateTime now = DateTime.now();
      String productId =
          '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}${now.millisecond}';

      orders.add(OrderResponse(
        id: productId,
        mealtime: foodOrderTime.mealTime,
        classs: classs,
        customer: 'Abishek Tiwari',
        groupid: "5O6xYxq3UnOBErm6WPxGK2tQXSR2",
        cid: '5O6xYxq3UnOBErm6WPxGK2tQXSR2',
        productName: productName,
        productImage: productImageUrl,
        price: price,
        quantity: 1,
        groupcod: groupcod,
        checkout: 'false',
        date: '29/12/2080',
        orderType: 'regular',
        holdDate: '',
        orderTime: foodOrderTime.orderHoldTime,
        customerImage: customerImage,
        orderHoldTime: foodOrderTime.orderHoldTime,
      ));
    }

    return orders;
  }
}
