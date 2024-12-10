import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../model/product.dart';

class ProductController extends GetxController {
  var isLoading = true.obs;
  var categoryWiseProducts = <String, List<dynamic>>{}.obs;
  var allProducts = <dynamic>[].obs;


  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  // void fetchProducts() async {
  //   try {
  //     isLoading(true);
  //     final response =
  //         await Dio().get('http://192.168.107.37:8081/api/products/list');
  //     if (response.statusCode == 200) {
  //       var products = response.data as List;
  //
  //       // Group products by category
  //       var groupedProducts = <String, List<dynamic>>{};
  //       for (var product in products) {
  //         String category = product["category"] ?? "Other";
  //         groupedProducts.putIfAbsent(category, () => []).add(product);
  //       }
  //
  //       categoryWiseProducts.value = groupedProducts;
  //     }
  //   } catch (e) {
  //     print("Error fetching products: $e");
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  void fetchProducts() async {
    try {
      isLoading(true);
      final response =
      await Dio().get('http://192.168.107.37:8081/api/products/list');
      if (response.statusCode == 200) {
        var products = response.data as List;

        // Save all products for filtering later
        allProducts.value = products;

        // Group products by category
        var groupedProducts = <String, List<dynamic>>{};
        for (var product in products) {
          String category = product["category"] ?? "Other";
          groupedProducts.putIfAbsent(category, () => []).add(product);
        }

        categoryWiseProducts.value = groupedProducts;
      }
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      isLoading(false);
    }
  }


  Future<void> fetchAllCategoryProducts(String category) async {
    isLoading.value = true;

    try {
      // Log the incoming category and all products
      print("Category to filter: $category");
      print("All Products: $allProducts");

      // Ensure case-insensitive matching
      var categoryProducts = allProducts.where((product) {
        return product['category'].toString().toLowerCase() == category.toLowerCase();
      }).toList();

      // Log the filtered products
      print("Filtered Products: $categoryProducts");

      // Update the categoryWiseProducts map
      categoryWiseProducts[category] = categoryProducts;
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      isLoading.value = false;
    }
  }



}
