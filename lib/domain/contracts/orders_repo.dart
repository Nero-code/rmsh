import 'package:dartz/dartz.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/domain/classes/order.dart';

abstract class OrdersRepo {
  Future<Either<Failure, List<OrderEntity>>> getAllOrders();
  Future<Either<Failure, Unit>> cancelOrder(String orderId);
}
