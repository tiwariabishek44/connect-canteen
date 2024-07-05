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

  // Create a method to convert CartItem to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }

  // Create a method to create CartItem from Firestore map
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }
}
