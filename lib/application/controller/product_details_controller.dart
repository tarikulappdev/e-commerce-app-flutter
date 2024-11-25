import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../model/product_details.dart';


class ProductDetailsController extends GetxController {
  var product = ProductDetails().obs;
  var isLoading = false.obs;
  final int productId;

  ProductDetailsController(this.productId);

  @override
  void onInit() {
    super.onInit();
    fetchProduct(productId);
  }

  void fetchProduct(int productId) async {
    try {
      isLoading(true);
      var response = await Dio().get('https://fakestoreapi.com/products/$productId');
      product.value = ProductDetails.fromJson(response.data);
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
