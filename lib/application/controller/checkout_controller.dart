import 'package:get/get.dart';
class CheckoutController extends GetxController {
  var selectedPaymentMethod = 'Credit Card'.obs;

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }
}