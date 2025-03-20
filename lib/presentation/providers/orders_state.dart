import 'package:flutter/material.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/domain/classes/order.dart';
import 'package:rmsh/domain/commands/orders_usecases.dart';

class OrdersState with ChangeNotifier {
  OrdersState(this._usecases);
  final OrdersUsecases _usecases;

  List<OrderEntity> orders = [];
  bool isLoading = false;
  Failure? getOrdersError;
  void getOrders() async {
    isLoading = true;
    getOrdersError = null;
    notifyListeners();

    final either = await _usecases.getAllOrders();
    either.fold(
      (failure) {
        getOrdersError = failure;
      },
      (success) {
        orders = success;
      },
    );

    isLoading = false;
    notifyListeners();
  }

  Failure? cancelOrderError;
  void cancelOrder(int orderIndex) async {
    isLoading = true;
    notifyListeners();

    final either = await _usecases.cancelOrder(orders[orderIndex].id);
    either.fold(
      (failure) => cancelOrderError = failure,
      (success) => orders.removeAt(orderIndex),
    );

    isLoading = false;
    notifyListeners();
  }

  void resetCancelError() {
    cancelOrderError = null;
    notifyListeners();
  }
}
