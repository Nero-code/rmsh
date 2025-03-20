import 'package:dartz/dartz.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/domain/classes/delivery_office.dart';
import 'package:rmsh/domain/classes/order.dart';

abstract class CartRepo {
  // Future<Either<Failure, Unit>> addToCart(CartItem p);
  // Future<Either<Failure, Unit>> removeFromCart(CartItem p);
  // Future<Either<Failure, Unit>> changeCount(int count);
  // Future<Either<Failure, Unit>> validateProducts(List<CartItem> list);
  Future<Either<Failure, Unit>> checkout(OrderEntity order);
  Future<Either<Failure, List<DeliveryOffice>>> getDeiveryOffices();
}
