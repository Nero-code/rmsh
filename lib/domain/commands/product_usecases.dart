import 'package:dartz/dartz.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/domain/classes/product_info.dart';
import 'package:rmsh/domain/classes/product_item.dart';
import 'package:rmsh/domain/contracts/product_repo.dart';

class ProductUsecases {
  final ProductRepo _repo;
  const ProductUsecases(this._repo);

  Future<Either<Failure, List<ProductInfo>>> getAllProducts(
      [String? filter, String? query]) async {
    return await _repo.getAllProducts(filter, query);
  }

  Future<Either<Failure, List<ProductInfo>>> loadMore(
      [String? filter, String? query]) async {
    return await _repo.loadMore(filter, query);
  }

  Future<Either<Failure, List<String>>> getAllCategories() async {
    return await _repo.getAllCategories();
  }

  Future<Either<Failure, ProductItem>> getProductDetails(String id) async {
    return await _repo.getProductDetails(id);
  }

  Future<Either<Failure, List<ProductInfo>>> getWishList() async {
    return await _repo.getWishList();
  }

  Future<Either<Failure, Unit>> addOrRemoveWishlist(
      String productId, bool add) async {
    if (add) return await _repo.addToWishlist(productId);
    return await _repo.removefromWishlist(productId);
  }

  Future<Either<Failure, Unit>> like(String productId, bool like) async {
    if (like) return await _repo.like(productId);
    return await _repo.unLike(productId);
  }
}
