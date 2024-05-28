import 'package:connect_canteen/app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'product_controller.dart';
import 'package:uuid/uuid.dart'; // For generating unique product IDs

class ProductUploadPage extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Product Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Create a product with dummy data for the rest
                Product newProduct = Product(
                  productId: Uuid().v4(), // Generate a unique ID
                  name: nameController.text,
                  image:
                      'https://thebigmansworld.com/wp-content/uploads/2023/02/chicken-chow-mein-800x1200.jpg',
                  price: double.parse(priceController.text),
                  active: true,
                );

                // Upload the product using the controller
                productController.uploadProduct(newProduct);
              },
              child: Text('Upload Product'),
            ),
          ],
        ),
      ),
    );
  }
}
