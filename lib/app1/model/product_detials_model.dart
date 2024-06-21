class ProductDetail {
  final String productName;
  final String productImage;
  int totalQuantity;

  ProductDetail({
    required this.productName,
    required this.productImage,
    required this.totalQuantity,
  });
}


class GruoupedProductDetail {
  final String groupName;
  int totalQuantity;
  final String groupCod;

  GruoupedProductDetail({
    required this.groupName,
    required this.groupCod,
    required this.totalQuantity,
  });
}
