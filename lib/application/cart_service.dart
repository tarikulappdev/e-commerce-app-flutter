import 'package:dio/dio.dart';
import 'package:e_commerce_app/model/cart_model.dart';





class CartService {
  final Dio _dio = Dio();

  Future<List<CartModel>> fetchCarts() async {
    final response = await _dio.get('https://fakestoreapi.com/carts');
    return (response.data as List).map((json) => CartModel.fromJson(json)).toList();
  }
}
