import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rmsh/core/errors/exceptions.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/data/models/order_model.dart';
import 'package:rmsh/data/sources/cart_remote.dart';
import 'package:rmsh/domain/classes/delivery_office.dart';
import 'package:rmsh/domain/classes/order.dart';
import 'package:rmsh/domain/contracts/cart_repo.dart';

class CartRepoImple implements CartRepo {
  const CartRepoImple(this._remoteSource, this._internet);
  final InternetConnectionChecker _internet;
  final CartRemoteSource _remoteSource;

  @override
  Future<Either<Failure, Unit>> checkout(OrderEntity order) async {
    if (await _internet.hasConnection) {
      try {
        await _remoteSource.chackout(OrderModel.fromEntity(order));
        return const Right(unit);
      } on BadRequestException {
        return const Left(CouponNotValidFailure());
      } catch (e) {
        print(e.toString());
        return Left(Failure(e.toString()));
      }
    }
    return const Left(OfflineFaliure());
  }

  @override
  Future<Either<Failure, List<DeliveryOffice>>> getDeiveryOffices() async {
    if (await _internet.hasConnection) {
      try {
        final res = await _remoteSource.getDeliveryOffices();
        return Right(res);
      } on EmptyResponseException {
        return const Left(EmptyResponseFailure());
      } catch (e) {
        return Left(Failure(e.toString()));
      }
    }
    return const Left(OfflineFaliure());
  }

  // @override
  // Future<Either<Failure, Unit>> validateProducts(List<CartItem> list) async {
  //   try {
  //     await _remoteSource.validateProducts(list);
  //     return const Right(unit);
  //   } catch (e) {
  //     return Left(Failure(e.toString()));
  //   }
  // }
}
