import 'package:e_commerce_app/ui/orders_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class CartController extends GetxController {
  var carts = <Map<String, dynamic>>[].obs; // List of cart items
  var subtotal = 0.0.obs; // Subtotal of all items
  var discount = 0.0.obs; // Discount on the cart
  var deliveryCharges = 5.0.obs; // Flat delivery charges
  var total = 0.0.obs; // Final total
  var isLoading = false.obs; // Loading state

  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    fetchCart(); // Fetch cart data on initialization
  }

  // Fetch cart data from API
  Future<void> fetchCart() async {
    isLoading.value = true;
    try {
      final response = await _dio.get('http://192.168.107.37:8081/api/cartItem/list');
      if (response.statusCode == 200) {
        carts.value = (response.data as List).cast<Map<String, dynamic>>();
        calculateTotals(); // Recalculate totals
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch cart data");
    } finally {
      isLoading.value = false;
    }
  }

  // Calculate subtotal, discount, and total
  void calculateTotals() {
    subtotal.value = carts.fold(0.0, (sum, cart) {
      return sum +
          (cart['cartDetails'] as List<dynamic>)
              .fold(0.0, (subtotal, product) => subtotal + (product['subtotal'] ?? 0.0));
    });

    discount.value = subtotal.value * 0.1; // Example: 10% discount
    total.value = subtotal.value - discount.value + deliveryCharges.value;
  }

  // Add an item to the cart
  Future<void> addToCart(Map<String, dynamic> product) async {
    isLoading.value = true;

    try {
      // Check if the product already exists in the cart
      final existingCart = carts.firstWhereOrNull((cart) =>
          (cart['cartDetails'] as List<dynamic>).any(
                (item) => item['productId'] == product['productId'],
          ));

      if (existingCart != null) {
        // Increment the quantity of the existing item
        for (var item in existingCart['cartDetails']) {
          if (item['productId'] == product['productId']) {
            item['qty'] += 1;
            item['subtotal'] = item['qty'] * item['price'];
          }
        }
        calculateTotals(); // Update totals
        Get.snackbar("Success", "Product quantity updated in the cart!");
        return;
      }

      // Prepare the new product payload
      final cartRequest = {
        "cartDetails": [
          {
            "title": product['title'],
            "productId": product['productId'],
            "price": product['price'],
            "qty": 1, // Default quantity is 1
            "subtotal": product['price'], // Calculate subtotal
            "description": product['description'],
            "category": product['category'],
            "image": product['image'],
            "rating": product['rating'] ?? 0,
          }
        ],
        "itemCount": 1, // Single item initially
        "totalPrice": product['price'], // Total equals price initially
      };

      // API call to save the new item in the cart
      final response = await _dio.post(
        'http://192.168.107.37:8081/api/cartItem/save',
        data: cartRequest,
      );

      if (response.statusCode == 201) {
        // Add the new cart item locally for immediate feedback
        carts.add({
          "cartId": response.data['cartId'], // Assuming API returns cartId
          ...cartRequest,
        });
        calculateTotals();
        Get.snackbar("Success", "Item added to cart successfully!");
      }
    } on DioException catch (e) {
      String errorMessage = "An error occurred";
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Connection timed out. Please try again.";
      } else if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? "Failed to add item.";
      }
      Get.snackbar("Error", errorMessage, backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Unexpected error: ${e.toString()}",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }


  // Increment item quantity
  void incrementItem(int cartId, int productId) {
    for (var cart in carts) {
      if (cart['cartId'] == cartId) {
        for (var product in cart['cartDetails']) {
          if (product['productId'] == productId) {
            product['qty']++;
            product['subtotal'] = product['qty'] * product['price'];
            calculateTotals();
            return;
          }
        }
      }
    }
  }

  // Decrement item quantity
  void decrementItem(int cartId, int productId) {
    for (var cart in carts) {
      if (cart['cartId'] == cartId) {
        for (var product in cart['cartDetails']) {
          if (product['productId'] == productId && product['qty'] > 1) {
            product['qty']--;
            product['subtotal'] = product['qty'] * product['price'];
            calculateTotals();
            return;
          }
        }
      }
    }
  }

  // Remove an item from the cart
  void removeItem(int cartId, int productId) {
    for (var cart in carts) {
      if (cart['cartId'] == cartId) {
        cart['cartDetails'].removeWhere((product) => product['productId'] == productId);
        calculateTotals();
        return;
      }
    }
  }

  // Place order
  Future<void> placeOrder() async {
    isLoading.value = true;

    final orderDetails = carts.expand((cart) {
      return (cart['cartDetails'] as List).map((product) {
        return {
          "productId": product['productId'],
          "productName": product['title'],
          "quantity": product['qty'],
          "unitPrice": product['price'],
          "subtotal": product['subtotal'],
          "category": product['category'],
          "description": product['description'],
        };
      });
    }).toList();

    final orderData = {
      "customerId": 101,
      "orderDate": DateTime.now().toIso8601String(),
      "status": "PENDING",
      "totalAmount": total.value,
      "paymentInfo": "Paid via Credit Card",
      "deliveryInfo": "Deliver to address X",
      "orderDetails": orderDetails,
    };

    try {
      final response = await _dio.post(
        'http://192.168.107.37:8081/api/order/save',
        data: orderData,
      );

      if (response.statusCode == 201) {
        Get.snackbar("Success", "Order Placed Successfully!");
        Get.offAll(() => OrdersPage());
        carts.clear();
        calculateTotals();
      } else {
        throw Exception("Unexpected server response");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to place order: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}
