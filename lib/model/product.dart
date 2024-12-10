import 'dart:convert';
List<Product> productsFromJson(String str) => List<Product>.from(
    json.decode(str).map((x) => Product.fromJson(x)));



class Product {
  final int? productId;
  final String? title;
  final double? price;
  final String? description;
  final String? category;
  final String? image;
  final double? rating;

  Product({
      this.productId,
      this.title,
      this.price,
      this.description,
      this.category,
      this.image,
      this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: json['rating'].toDouble(),
    );
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      title: map['title'],
      image: map['image'],
      price: map['price'].toDouble(),
      productId: map['id'],
    );
  }
}
