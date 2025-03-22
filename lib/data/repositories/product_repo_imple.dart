import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rmsh/core/errors/exceptions.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/data/sources/products_remote.dart';
import 'package:rmsh/domain/classes/product_info.dart';
import 'package:rmsh/domain/classes/product_item.dart';
import 'package:rmsh/domain/contracts/product_repo.dart';

class ProductRepoImple implements ProductRepo {
  ProductRepoImple(this._remoteSource, this._internet);
  final ProductsRemoteSource _remoteSource;
  final InternetConnectionChecker _internet;

  int currentPage = 1;

  @override
  Future<Either<Failure, List<String>>> getAllCategories() async {
    if (kDebugMode) {
      print("getAllCategories in repo");
    }
    try {
      final res = (await _remoteSource.getAllCategories())
          .map<String>((e) => e.name)
          .toList();
      if (kDebugMode) {
        print("finished parsing data models");
      }
      return Right(res);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductInfo>>> getAllProducts(
      [String? filter, String? query]) async {
    if (kDebugMode) {
      print("getAllProducts: repo");
    }
    if (await _internet.hasConnection) {
      try {
        currentPage = 1;
        final res =
            await _remoteSource.getAllProducts(filter ?? '', query ?? '');

        if (kDebugMode) {
          print("\n\n\n\n\n");
          print("products: ${res.length}");
        }
        // if (res.isNotEmpty) {
        return Right(res);
        // }
        // return const Left(EmptyResponseFailure());
      } on EmptyResponseException {
        return const Left(EmptyResponseFailure("لا يوجد منتجات"));
      } catch (e) {
        return Left(Failure(e.toString()));
      }
    }
    return const Left(OfflineFaliure());
  }

  @override
  Future<Either<Failure, List<ProductInfo>>> loadMore(
      [String? filter, String? query]) async {
    if (await _internet.hasConnection) {
      try {
        print("loadMore: currentPage = $currentPage");
        final res = await _remoteSource.loadMore(
            ++currentPage, filter ?? '', query ?? '');
        print("loadMore: currentPage = $currentPage");
        return Right(res);
      } on EmptyResponseException {
        return const Left(EmptyResponseFailure());
      } catch (e) {
        print(e.toString());
        return Left(Failure(e.toString()));
      }
    }
    return const Left(OfflineFaliure());
  }

  @override
  Future<Either<Failure, ProductItem>> getProductDetails(String id) async {
    print("Repo: getProductDetails");
    if (await _internet.hasConnection) {
      try {
        final res = await _remoteSource.getProductDetails(id);
        return Right(res);
      } on EmptyResponseException {
        return const Left(ItemNotFoundFailure("المنتج غير متوفر"));
      } catch (e) {
        return Left(Failure(e.toString()));
      }
    }
    return const Left(OfflineFaliure());
  }

  @override
  Future<Either<Failure, Unit>> like(String productId) async {
    if (await _internet.hasConnection) {
      try {
        await _remoteSource.like(productId);
        return const Right(unit);
      } catch (e) {
        return Left(Failure(e.toString()));
      }
    }
    return const Left(OfflineFaliure());
  }

  @override
  Future<Either<Failure, Unit>> unLike(String productId) async {
    if (await _internet.hasConnection) {
      try {
        await _remoteSource.unLike(productId);
        return const Right(unit);
      } catch (e) {
        return Left(Failure(e.toString()));
      }
    }
    return const Left(OfflineFaliure());
  }

  @override
  Future<Either<Failure, Unit>> addToWishlist(String productId) async {
    if (await _internet.hasConnection) {
      try {
        await _remoteSource.addToWishlist(productId);
        return const Right(unit);
      } catch (e) {
        return Left(Failure(e.toString()));
      }
    }
    return const Left(OfflineFaliure());
  }

  @override
  Future<Either<Failure, Unit>> removefromWishlist(String productId) async {
    if (await _internet.hasConnection) {
      try {
        await _remoteSource.removefromWishlist(productId);
        return const Right(unit);
      } catch (e) {
        return Left(Failure(e.toString()));
      }
    }
    return const Left(OfflineFaliure());
  }

  @override
  Future<Either<Failure, List<ProductInfo>>> getWishList() async {
    if (await _internet.hasConnection) {
      try {
        final res = await _remoteSource.getWishList();
        return Right(res);
      } on EmptyResponseException {
        return const Left(EmptyResponseFailure("لا يوجد منتجات محفوظة"));
      } catch (e) {
        return Left(Failure(e.toString()));
      }
    }
    return const Left(OfflineFaliure());
  }
}
