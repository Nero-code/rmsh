import 'package:dartz/dartz.dart';
import 'package:rmsh/core/errors/exceptions.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/data/models/order_model.dart';
import 'package:rmsh/data/sources/orders_remote.dart';
import 'package:rmsh/domain/contracts/orders_repo.dart';

class OrdersRepoImple implements OrdersRepo {
  const OrdersRepoImple(this._remoteSource);
  final OrdersRemoteSource _remoteSource;

  @override
  Future<Either<Failure, Unit>> cancelOrder(String orderId) async {
    try {
      await _remoteSource.cancelOrder(orderId);
      return const Right(unit);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderModel>>> getAllOrders() async {
    try {
      final res = await _remoteSource.getAllOrders();
      res.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Right(res);
    } on EmptyResponseException {
      return const Left(EmptyResponseFailure("لا يوجد طلبات"));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
