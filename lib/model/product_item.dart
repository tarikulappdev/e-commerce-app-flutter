class ProductItem {
  final int? productId;
  final int? quantity;

  ProductItem({ this.productId,  this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }
}
