import 'package:e_commerce_app/ui/order_listView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../application/controller/order_controller.dart';
class OrdersPage extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Orders"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          bottom: const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.purple,
            tabs: [
              Tab(text: "Active"),
              Tab(text: "Completed"),
              Tab(text: "Cancel"),
            ],
          ),
        ),
        body: Obx(() {
          if (orderController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            children: [
              OrderListView(),
              _buildOrderList(orderController.completedOrders),
              _buildOrderList(orderController.cancelledOrders),
            ],
          );
        }),
      ),
    );
  }

  // Builds the list of orders for a specific tab
  Widget _buildOrderList(List<dynamic> orders) {
    return orders.isEmpty
        ? const Center(child: Text("No orders available"))
        : ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  // Builds an individual order card
  Widget _buildOrderCard(dynamic order) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                order['image'],
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order['name'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order['brand'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${order['price']}",
                    style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    // Handle track order
                  },
                  child: const Text("Track Order"),
                ),
                const SizedBox(height: 8),
                if (order['status'] == 'active')
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Handle cancel/delete order
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}