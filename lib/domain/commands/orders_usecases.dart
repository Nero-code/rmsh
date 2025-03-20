import 'package:dartz/dartz.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/domain/classes/order.dart';
import 'package:rmsh/domain/contracts/orders_repo.dart';

class OrdersUsecases {
  final OrdersRepo _repo;
  const OrdersUsecases(this._repo);

  Future<Either<Failure, Unit>> cancelOrder(String orderId) async {
    return await _repo.cancelOrder(orderId);
  }

  Future<Either<Failure, List<OrderEntity>>> getAllOrders() async {
    return await _repo.getAllOrders();
  }
}
