import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../application/controller/order_controller.dart';
import '../model/order.dart';


class OrderListView extends StatelessWidget {
  final OrderController controller = Get.put(OrderController());

   OrderListView({super.key}); // Dependency injection

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
              () => ListView.builder(
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              final order = controller.orders[index];
              return _buildOrderCard(
                order: order,
                onTrackOrder: () {
                  Get.snackbar(
                    "Track Order",
                    "${order.title} tracking started!",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                onDelete: () {
                  //controller.removeOrder(index); // Remove the order
                  Get.snackbar(
                    "Order Removed",
                    "${order.title} has been removed!",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard({
    required Order order,
    required VoidCallback onTrackOrder,
    VoidCallback? onDelete,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                order.image!.isNotEmpty ? order.image! : 'https://via.placeholder.com/150',
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.title!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.brand!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${order.price}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            // Actions
            Column(
              children: [
                ElevatedButton(
                  onPressed: onTrackOrder,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text(
                    "Track Order",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                if (onDelete != null)
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
