import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/repository/grete_repository.dart';
import 'package:connect_canteen/app/service/api_client.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class RemaningController extends GetxController {
  final GreatRepository grandTotalRepo = GreatRepository();

  final Rx<ApiResponse<OrderResponse>> salseOrderResponse =
      ApiResponse<OrderResponse>.initial().obs;

  final RxMap<String, int> totalQuantitySalseOrder = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();

    fetchTotalRemaning();
  }

  var calenderDate = ''.obs;
  var isLoading = false.obs;
//-------------to fetch  the total salse of the day ------------
  Future<void> fetchTotalRemaning() async {
    try {
      isLoading(true);
      final filters = {
        "date": calenderDate.value,
        "checkout": "false",

        'orderType': 'regular',
        // Add more filters as needed
      };
      salseOrderResponse.value = ApiResponse<OrderResponse>.loading();
      final orderResult = await grandTotalRepo.getFromDatabase(
          filters, OrderResponse.fromJson, ApiEndpoints.orderCollection);
      if (orderResult.status == ApiStatus.SUCCESS) {
        salseOrderResponse.value =
            ApiResponse<OrderResponse>.completed(orderResult.response);

        // Calculate total quantity after fetching orders
        calculateTotalQuantityForRemaing(orderResult.response!);
        isLoading(false);
      }
    } catch (e) {
      isLoading(false);
    }
  }

//-----------to retrive the each product with the respective total quantity
  final RxList<ProductWithQuantity> productWithQuantity =
      <ProductWithQuantity>[].obs;

  void calculateTotalQuantityForRemaing(List<OrderResponse> orders) {
    totalQuantitySalseOrder.clear();

    // Create a map to store image URLs by product name
    final Map<String, String> productImages = {};

    orders.forEach((order) {
      totalQuantitySalseOrder.update(
        order.productName,
        (value) => value + order.quantity,
        ifAbsent: () => order.quantity,
      );

      // Populate product images
      if (!productImages.containsKey(order.productName)) {
        productImages[order.productName] = order.productImage;
      }
    });

    // Convert map to list of ProductQuantity objects
    productWithQuantity.value = totalQuantitySalseOrder.entries
        .map((entry) => ProductWithQuantity(
              productName: entry.key,
              image: productImages[entry.key] ?? '', // Get image URL
              totalQuantity: entry.value,
            ))
        .toList();
  }
}

class ProductWithQuantity {
  final String productName;
  final String image; // Add image field
  final int totalQuantity;

  ProductWithQuantity({
    required this.productName,
    required this.image,
    required this.totalQuantity,
  });
}
