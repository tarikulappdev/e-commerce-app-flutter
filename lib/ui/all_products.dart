import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../application/controller/product_controller.dart';
import '../application/controller/cart_controller.dart';

class AllProducts extends StatelessWidget {
  final String category;

  AllProducts({super.key, required this.category});
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (productController.allProducts.isNotEmpty) {
        productController.fetchAllCategoryProducts(category);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Obx(() {
        if (productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        List<dynamic> categoryProducts =
            productController.categoryWiseProducts[category] ?? [];

        if (categoryProducts.isEmpty) {
          return const Center(child: Text("No products found."));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.75,
          ),
          itemCount: categoryProducts.length,
          itemBuilder: (context, index) {
            var product = categoryProducts[index];
            return ProductCard(product: product);
          },
        );
      }),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final CartController cartController = Get.find<CartController>();

  ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  product['image'],
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.grey[300],
                  size: 20,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['title'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '\$${product['price']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Obx(() => cartController.isLoading.value
                  ? const CircularProgressIndicator()
                  : Container(
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  onPressed: () {
                    cartController.addToCart(product);
                  },
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}

