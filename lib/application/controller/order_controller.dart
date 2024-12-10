import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class OrderController extends GetxController {
  var isLoading = true.obs;
  var activeOrders = <dynamic>[].obs;
  var completedOrders = <dynamic>[].obs;
  var cancelledOrders = <dynamic>[].obs;

  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void fetchOrders() async {
    try {
      isLoading.value = true;

      final response = await _dio.get('http://192.168.107.37:8081/api/order/list');
      if (response.statusCode == 200) {
        List<dynamic> orders = response.data;

        // Categorize orders
        activeOrders.value = orders.where((o) => o['status'] == 'PENDING').toList();
        completedOrders.value = orders.where((o) => o['status'] == 'COMPLETED').toList();
        cancelledOrders.value = orders.where((o) => o['status'] == 'CANCELLED').toList();
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch orders: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
