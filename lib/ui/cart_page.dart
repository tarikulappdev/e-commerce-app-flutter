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

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.carts.length,
                itemBuilder: (context, index) {
                  final cart = cartController.carts[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.network(
                          "https://via.placeholder.com/80", // Placeholder image
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text("Brand Name"),
                              SizedBox(height: 10,),
                              Text(
                                "\$40",
                                style: TextStyle(color: Colors.purple),
                              ),
                            ],
                          ),
                        ),

                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.purple),
                              onPressed: () {
                                // Handle decrement logic
                              },
                            ),
                            Text(
                              '${cart.products?.first.quantity}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle,
                                  color: Colors.purple),
                              onPressed: () {
                                // Handle increment logic
                              },
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Handle delete logic
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            _buildOrderSummary(cartController),
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
          _buildSummaryRow("Items", '${cartController.carts.length}'),
          _buildSummaryRow("Subtotal", '\$${cartController.subtotal.value}'),
          _buildSummaryRow("Discount", '-\$${cartController.discount.value}'),
          _buildSummaryRow(
              "Delivery Charges", '\$${cartController.deliveryCharges.value}'),
          const Divider(),
          _buildSummaryRow("Total", '\$${cartController.total}',
              isBold: true),
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
          style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          // Handle checkout
          Get.to(CheckoutScreen());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text("Check Out",style: TextStyle(color: Colors.white),),
      ),
    );
  }
}
