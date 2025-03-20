import 'package:flutter/material.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/domain/classes/cart_item.dart';
import 'package:rmsh/domain/classes/delivery_office.dart';
import 'package:rmsh/domain/classes/order.dart';
import 'package:rmsh/domain/classes/product_item.dart';
import 'package:rmsh/domain/commands/cart_usecases.dart';
import 'package:rmsh/presentation/vm/cart_vm.dart';

class CartState with ChangeNotifier {
  CartState(this._usecases);

  final CartUsecases _usecases;

  List<CartViewModel> items = [];
  bool isLoading = false;
  int total = 0;
  void computeTotal() {
    if (items.isEmpty) {
      total = 0;
      return;
    }

    total = items
        .map((e) => e.c.price * e.count)
        .reduce((value, element) => value + element)
        .toInt();
  }

  void changeItemCount(int index, int val) {
    if (val < 1) return;
    items[index].count = val;
    computeTotal();
    notifyListeners();
  }

  void addToCart(CartItem item) {
    items.add(CartViewModel(item));
    computeTotal();
    notifyListeners();
  }

  void removeFromCart(int index) {
    items.removeAt(index);
    computeTotal();
    notifyListeners();
  }

  bool contains(String productId, ProductDetails details) {
    return items
        .where(
          (e) => ((e.c.id == productId) && (e.c.details.id == details.id)),
        )
        .isNotEmpty;
  }

  bool containsColor(int value) {
    return items
        .where(
          (e) => (e.c.details.color == value),
        )
        .isNotEmpty;
  }

  Failure? officesError;
  List<DeliveryOffice> offices = [];
  void getDeliveryOffices() async {
    final either = await _usecases.getDeliveryofices();
    either.fold(
      (l) => officesError = l,
      (r) => offices = r,
    );
    notifyListeners();
  }

  Failure? checkoutError;
  void checkout(OrderEntity order) async {
    isLoading = true;
    checkoutError = null;
    notifyListeners();

    final either = await _usecases.checkout(order);
    either.fold(
      (failure) => checkoutError = failure,
      (success) {
        items.clear();
        total = 0;
      },
    );

    isLoading = false;
    notifyListeners();
  }

  void resetCheckoutError() {
    checkoutError = null;
  }
}
