import 'product_item.dart';

class Cart {
  final int userId;
  final String date;
  final List<ProductItem> products;

  Cart({required this.userId, required this.date, required this.products});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': date,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}
