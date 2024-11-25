import 'package:e_commerce_app/ui/orders_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../application/controller/checkout_controller.dart';
class CheckoutScreen extends StatelessWidget {
  final RxInt selectedMethod = 1.obs; // Track selected payment method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('Check Out'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address and Time
            const Row(
              children: [
                Icon(Icons.location_pin, color: Colors.purple),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '325 15th Eighth Avenue, NewYork',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Saep eaque fugiat ea voluptatem veniam.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.access_time, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  '6:00 pm, Wednesday 20',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Order Summary
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _orderSummaryRow('Items', '3'),
                    const SizedBox(height: 8),
                    _orderSummaryRow('Subtotal', '\$423'),
                    const SizedBox(height: 8),
                    _orderSummaryRow('Discount', '-\$4'),
                    const SizedBox(height: 8),
                    _orderSummaryRow('Delivery Charges', '\$2'),
                    const Divider(height: 24, color: Colors.grey),
                    _orderSummaryRow('Total', '\$423', isBold: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Payment Methods
            const Text(
              'Choose payment method',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 16),
            Column(
              children: [
                _buildPaymentOption(
                  index: 1,
                  icon: Icons.paypal,
                  label: "Paypal",
                  isSelected: selectedMethod.value == 1,
                  onTap: () => selectedMethod.value = 1,
                ),
                _buildPaymentOption(
                  index: 2,
                  icon: Icons.credit_card,
                  label: "Credit Card",
                  isSelected: selectedMethod.value == 2,
                  onTap: () => selectedMethod.value = 2,
                ),
                _buildPaymentOption(
                  index: 3,
                  icon: Icons.money,
                  label: "Cash",
                  isSelected: selectedMethod.value == 3,
                  onTap: () => selectedMethod.value = 3,
                ),
              ],
            ),
            // Add Payment Method
            TextButton.icon(
              onPressed: () {
                // Handle adding a new payment method
              },
              icon: const Icon(Icons.add, color: Colors.purple),
              label: const Text('Add new payment method',
                  style: TextStyle(color: Colors.purple)),
            ),
            const Spacer(),

            // Checkout Button
            ElevatedButton(
              onPressed: () {
                // Handle checkout logic
                Get.to(OrdersPage());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Check Out',
                style: TextStyle(fontSize: 16,color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderSummaryRow(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
        Text(
          value,
          style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.purple[50] : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.purple : Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.purple, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.purple),
          ],
        ),
      ),
    );
  }
}