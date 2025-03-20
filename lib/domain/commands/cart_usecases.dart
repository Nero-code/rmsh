import 'package:dartz/dartz.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/domain/classes/delivery_office.dart';
import 'package:rmsh/domain/classes/order.dart';
import 'package:rmsh/domain/contracts/cart_repo.dart';

class CartUsecases {
  final CartRepo _repo;
  const CartUsecases(this._repo);

  Future<Either<Failure, Unit>> checkout(OrderEntity order) async {
    return await _repo.checkout(order);
  }

  Future<Either<Failure, List<DeliveryOffice>>> getDeliveryofices() async {
    return await _repo.getDeiveryOffices();
  }
}
