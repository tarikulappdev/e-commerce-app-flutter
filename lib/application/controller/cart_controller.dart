// controllers/cart_controller.dart


import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../model/cart.dart';
import '../../model/cart_model.dart';

class CartController extends GetxController {

  final Dio _dio = Dio();

  //cart
  var carts = <CartModel>[].obs;
  var isLoading = false.obs;
  var subtotal = 0.0.obs;
  var discount = 4.0.obs;
  var deliveryCharges = 2.0.obs;

  double get total => subtotal.value - discount.value + deliveryCharges.value;

  Future<void> createCart(Cart cart) async {
    try {
      final response = await _dio.post(
        'https://fakestoreapi.com/carts',
        data: cart.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Cart created successfully.");
        print("Cart created: ${response.data}");
      } else {
        Get.snackbar("Error", "Failed to create cart.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while creating cart.");
      print("Error creating cart: $e");
    }
  }

  @override
  void onInit() {
    fetchCartData();
    super.onInit();
  }

  void fetchCartData() async {
    isLoading.value = true;
    try {
      var response = await Dio().get('https://fakestoreapi.com/carts');
      List data = response.data;
      carts.value = data.map((e) => CartModel.fromJson(e)).toList();
      calculateSubtotal();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void calculateSubtotal() {
    subtotal.value = carts.fold(
        0,
            (sum, cart) => sum +
            cart.products!.fold(
                0,
                    (subtotal, product) =>
                subtotal + product.quantity! * 40)); // Example price.
  }
}
