import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../model/product.dart';



class ProductController extends GetxController {
  var featuredProducts = [].obs;
  var popularProducts = [].obs;
  var products = <Product>[].obs;
  var isLoading = true.obs;
  final Dio _dio = Dio();

  @override
  void onInit() {
    fetchProducts();
    fetchAllProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      var response = await Dio().get('https://fakestoreapi.com/products');
      if (response.statusCode == 200) {
        var products = response.data;
        featuredProducts.assignAll(products.sublist(0, 3));
        popularProducts.assignAll(products.sublist(3, 6));
      }
    } catch (e) {
      print("Failed to fetch data: $e");
    }
  }

  void fetchAllProducts() async {
    try {
      isLoading(true);
      var response = await Dio().get('https://fakestoreapi.com/products');
      if (response.statusCode == 200) {
        var productData = response.data as List;
        products.value = productData.map((p) => Product.fromJson(p)).toList();
      }
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      isLoading(false);
    }
  }
}
