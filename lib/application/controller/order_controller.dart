
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../model/order.dart';
class OrderController extends GetxController {
  var activeOrders = [].obs;
  var completedOrders = [].obs;
  var cancelledOrders = [].obs;
  var isLoading = true.obs;


  var orders = <Order>[
    Order(
      title: "Watch",
      brand: "Rolex",
      price: 40,
      image: "https://images.pexels.com/photos/280250/pexels-photo-280250.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2", // Replace with actual image URL
    ),
    Order(
      title: "Airpods",
      brand: "Apple",
      price: 333,
      image: "https://images.pexels.com/photos/788946/pexels-photo-788946.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2", // Replace with actual image URL
    ),
    Order(
      title: "Hoodie",
      brand: "Puma",
      price: 50,
      image: "https://images.pexels.com/photos/29481918/pexels-photo-29481918/free-photo-of-mysterious-figure-overlooks-malibu-mountains-at-dusk.jpeg?auto=compress&cs=tinysrgb&w=600", // Replace with actual image URL
    ),
  ].obs;


  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void fetchOrders() async {
    isLoading(true);
    try {
      var response = await Dio().get('https://example.com/api/orders');
      // Example: Filter orders based on their status
      var orders = response.data;
      activeOrders.assignAll(orders.where((o) => o['status'] == 'active'));
      completedOrders.assignAll(orders.where((o) => o['status'] == 'completed'));
      cancelledOrders.assignAll(orders.where((o) => o['status'] == 'cancelled'));
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      isLoading(false);
    }
  }



}