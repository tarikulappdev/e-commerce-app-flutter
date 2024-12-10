import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_app/ui/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../application/controller/product_controller.dart';
import 'all_products.dart';

class ProductPage extends StatelessWidget {
  ProductPage({super.key});

  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            SizedBox(
              height: 10,
            ),
            // Profile Photo
            CircleAvatar(
              radius: 20, // Adjust the size as needed
              backgroundImage: NetworkImage(
                'https://www.pngall.com/wp-content/uploads/5/Profile-Male-PNG.png', // Replace with the actual profile image URL
              ),
            ),
            SizedBox(width: 10), // Spacing between image and text
            // Greeting Text and Username
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello!",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                Text(
                  "John William",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              // Notification button action here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                        child: TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search here"))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            CarouselSlider(
              items: [
                Image.network(
                    "https://img.freepik.com/free-photo/shopping-concept-close-up-portrait-young-beautiful-attractive-redhair-girl-smiling-looking-camera_1258-132679.jpg?ga=GA1.1.797727058.1731166389&semt=ais_hybrid"),
                Image.network(
                    "https://img.freepik.com/premium-photo/young-woman-sweater-holds-shopping-bags-mobile_164357-5207.jpg?ga=GA1.1.797727058.1731166389&semt=ais_hybrid"),
                Image.network(
                    "https://img.freepik.com/free-vector/flat-cyber-monday-social-media-cover-template_23-2149098788.jpg?ga=GA1.1.797727058.1731166389&semt=ais_hybrid"),
              ],
              options: CarouselOptions(
                height: 140,
                autoPlay: true,
                viewportFraction: 1,
              ),
            ),
            const SizedBox(height: 10),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final groupedProducts = controller.categoryWiseProducts;

              if (groupedProducts.isEmpty) {
                return const Center(child: Text("No products found."));
              }

              return Column(
                children: groupedProducts.entries.map((entry) {
                  final category = entry.key;
                  final products = entry.value;

                  return _buildCategorySection(category, products);
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(String category, List<dynamic> products) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {
                  // Navigate to CategoryPage with the category name
                  Get.to(() => AllProducts(category: category));
                },
                child: const Text("See All",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true, // Allows the GridView to take only as much space as it needs
            physics: const NeverScrollableScrollPhysics(), // Prevents the GridView from scrolling
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              final price = (product["price"] is int)
                  ? product["price"].toDouble()
                  : product["price"];

              return GestureDetector(
                onTap: () {
                  // Navigate to Product Details
                  Get.to(() => ProductDetailsPage(product: product));
                },
                child: Card(
                  elevation: 2,
                  shadowColor: Colors.grey.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10)),
                        child: Image.network(
                          product["image"],
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product["title"],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "\$${price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  }