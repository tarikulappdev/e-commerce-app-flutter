import 'package:get/get.dart';
import 'package:dio/dio.dart';

class CategoryProductController extends GetxController {
  var isLoading = false.obs;
  Map<String, List<dynamic>> categoryWiseProducts = {};
  var allProducts = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Automatically fetch products for a default category
    fetchAllCategoryProducts("defaultCategory");
  }

  Future<void> fetchAllCategoryProducts(String category) async {
    isLoading.value = true;
    try {
      var categoryProducts = allProducts
          .where((product) => product['category'] == category)
          .toList();
      categoryWiseProducts[category] = categoryProducts;
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
