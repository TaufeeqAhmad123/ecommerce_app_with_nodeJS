import 'package:ecommerece_app/app/controllers/cart_controller.dart';
import 'package:ecommerece_app/app/controllers/favorite_controller.dart';
import 'package:get/get.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..put<FavoriteController>(FavoriteController())
      ..put<CartController>(CartController());
  }
}
