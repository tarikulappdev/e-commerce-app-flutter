import 'package:e_commerce_app/model/product.dart';

class CartModel {
  int? id;
  int? userId;
  DateTime? date;
  List<Product>? products;

  CartModel({  this.id,   this.userId,   this.date,   this.products});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      products: List<Product>.from(
        json['products'].map((product) => Product.fromJson(product)),
      ),
    );
  }
}


