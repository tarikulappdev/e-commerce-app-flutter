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
            _buildSection("Featured", controller.featuredProducts),
            _buildSection("Most Popular", controller.popularProducts),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, var productList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {
                  // Navigate to CategoryPage with the category name
                  Get.to(() => AllProducts());
                },
                child: const Text("See All"),
              ),
            ],
          ),
          Obx(() => SizedBox(
            height: 200, // Adjust the height as needed
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                var product = productList[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to Product Details Page with product ID
                    Get.to(() => ProductDetailsPage(productId: product["id"]));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    shadowColor: Colors.grey.withOpacity(0.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Image.network(
                                product["image"],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 100, // Adjust height as needed
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: CircleAvatar(
                                backgroundColor:
                                Colors.white.withOpacity(0.8),
                                radius: 15,
                                child: const Icon(
                                  Icons.favorite_border,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "\$${product["price"]}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
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
          )),
        ],
      ),
    );
  }

}
