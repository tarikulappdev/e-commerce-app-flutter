class Order {
  final String? title;
  final String? brand;
  final int? price;
  final String? image;

  Order({
     this.title,
     this.brand,
     this.price,
     this.image,
  });

  // Factory method to create an Order object from a map
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      title: json['title'] ?? '',
      brand: json['brand'] ?? '',
      price: json['price'] ?? 0,
      image: json['image'] ?? '',
    );
  }

  // Method to convert an Order object into a map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'brand': brand,
      'price': price,
      'image': image,
    };
  }
}
