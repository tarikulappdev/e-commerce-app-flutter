import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../application/controller/cart_controller.dart';
import 'checkout_screen.dart';

class CartPage extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final carts = cartController.carts;

        if (carts.isEmpty) {
          return const Center(
            child: Text("Your cart is empty!"),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: carts.length,
                itemBuilder: (context, index) {
                  final cart = carts[index];
                  final cartDetails = cart['cartDetails'] as List<dynamic>;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Cart ID: ${cart['cartId']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ...cartDetails.map((product) {
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                // Product Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  // child: Image.network(
                                  //   product['image'] ?? '',
                                  //   height: 40,
                                  //   width: 40,
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                                const SizedBox(width: 10),

                                // Product Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['title'] ?? 'Product Title',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "\$${(product['price'] ?? 0.0).toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Quantity Control
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle,
                                          color: Colors.purple),
                                      onPressed: () => cartController.decrementItem(
                                          cart['cartId'], product['productId']),
                                    ),
                                    Text(
                                      product['qty'].toString(),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle,
                                          color: Colors.purple),
                                      onPressed: () => cartController.incrementItem(
                                          cart['cartId'], product['productId']),
                                    ),
                                  ],
                                ),

                                // Delete Button
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => cartController.removeItem(
                                      cart['cartId'], product['productId']),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
            ),

            // Order Summary
            _buildOrderSummary(cartController),

            // Checkout Button
            _buildCheckoutButton(),
          ],
        );
      }),
    );
  }

  Widget _buildOrderSummary(CartController cartController) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow("Subtotal", '\$${cartController.subtotal.toStringAsFixed(2)}'),
          _buildSummaryRow("Discount", '-\$${cartController.discount.toStringAsFixed(2)}'),
          _buildSummaryRow(
              "Delivery Charges", '\$${cartController.deliveryCharges.toStringAsFixed(2)}'),
          const Divider(),
          _buildSummaryRow(
            "Total",
            '\$${cartController.total.toStringAsFixed(2)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () async {
          await cartController.placeOrder();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text(
          "Check Out",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

}
