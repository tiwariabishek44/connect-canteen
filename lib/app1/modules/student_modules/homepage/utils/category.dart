import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/model/category_model.dart';
import 'package:connect_canteen/app1/modules/student_modules/filter_product/filter_product_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class HorizontalGridView extends StatelessWidget {
  final categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250, // Adjust the height according to your requirement
      child: StreamBuilder<List<CategoryModel>>(
        stream: categoryController.getAllMenue("texasinternationalcollege"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //shrimmer
            return GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1.0,
              ),
              itemCount: 4, // Number of shimmer items
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child:
                  Text('No data available'), // Handle case where data is empty
            );
          } else {
            final menueProducts = snapshot.data!;

            return GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1.0,
              ),
              itemCount: menueProducts.length, // Number of items in the grid
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(
                                () => FilterProductPage(
                                      title: menueProducts[index].name!,
                                    ),
                                transition: Transition.cupertinoDialog);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              image: DecorationImage(
                                image:
                                    NetworkImage(menueProducts[index].image!),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          menueProducts[index].name!,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CategoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<CategoryModel>> getAllMenue(
    String schoolrefrence,
  ) {
    return _firestore
        .collection("categories")
        .where('school', isEqualTo: schoolrefrence)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CategoryModel.fromMap(doc.data()))
              .toList(),
        );
  }
}
