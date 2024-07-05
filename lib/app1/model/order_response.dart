class UserOrderResponse {
  final String otp;
  final String userId;
  final String username;
  final String userClass;
  final String date;
  final String mealTime;
  final double totalAmount;
  final String schoolRefrenceId; // Added schoolRefrenceId field
  final List<CartItem> products;
  final String status; // Added status field

  UserOrderResponse({
    required this.otp,
    required this.schoolRefrenceId,
    required this.userId,
    required this.username,
    required this.userClass,
    required this.date,
    required this.mealTime,
    required this.totalAmount,
    required this.products,
    required this.status, // Added status field
  });

  factory UserOrderResponse.fromJson(Map<String, dynamic> json) {
    var productsList = json['products'] as List<dynamic>;
    List<CartItem> parsedProducts =
        productsList.map((item) => CartItem.fromJson(item)).toList();

    return UserOrderResponse(
      otp: json['otp'],
      schoolRefrenceId:
          json['schoolRefrenceId'], // Added schoolRefrenceId field
      userId: json['userId'],
      username: json['username'],
      userClass: json['userClass'],
      date: json['date'],
      mealTime: json['mealTime'],
      totalAmount: json['totalAmount'],
      products: parsedProducts,
      status: json['status'], // Added status field
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> productsJson =
        products.map((product) => product.toJson()).toList();

    return {
      'otp': otp,
      'schoolRefrenceId': schoolRefrenceId, // Added schoolRefrenceId field
      'userId': userId,
      'username': username,
      'userClass': userClass,
      'date': date,
      'mealTime': mealTime,
      'totalAmount': totalAmount,
      'products': productsJson,

      'status': status, // Added status field
    };
  }
}

class CartItem {
  String id;
  String name;
  int quantity;
  double price;

  CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }
}
